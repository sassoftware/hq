/* **********************************************************************
/*
 * NOTE: This copyright does *not* cover user programs that use Hyperic
 * program services by normal system calls through the application
 * program interfaces provided as part of the Hyperic Plug-in Development
 * Kit or the Hyperic Client Development Kit - this is merely considered
 * normal use of the program, and does *not* fall under the heading of
 * "derived work".
 *
 * Copyright (C) [2004-2012], VMware, Inc.
 * This file is part of Hyperic.
 *
 * Hyperic is free software; you can redistribute it and/or modify
 * it under the terms version 2 of the GNU General Public License as
 * published by the Free Software Foundation. This program is distributed
 * in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
 * even the implied warranty of MERCHANTABILITY or FITNESS FOR A
 * PARTICULAR PURPOSE. See the GNU General Public License for more
 * details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
 * USA.
 */ 
package com.hyperic.hq.plugin.system ; 

import java.io.File;
import java.io.FileFilter;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.net.URL;
import java.nio.ByteBuffer;
import java.nio.channels.Channels;
import java.nio.channels.ReadableByteChannel;
import java.nio.channels.WritableByteChannel;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicBoolean;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hyperic.hq.agent.AgentConfig;
import org.hyperic.hq.appdef.shared.AppdefEntityConstants;
import org.hyperic.hq.bizapp.shared.lather.ControlSendCommandResult_args;
import org.hyperic.hq.context.Bootstrap;
import org.hyperic.hq.product.ControlPlugin;
import org.hyperic.hq.product.GenericPlugin;
import org.hyperic.hq.product.PluginException;
import org.hyperic.hq.product.PluginManager;
import org.hyperic.hq.product.ProductPlugin;
import org.hyperic.hq.product.TypeInfo;
import org.hyperic.util.config.ConfigResponse;
import org.hyperic.util.file.FileUtil;
/**
 * Platform Product plugin suporting infra HA actions such as an immediate VM reset.<br>  
 *<p>
 * The class must handle different behaviours in server and agent contexts as well as<br> 
 * Dynamic enablement of the control actions in accordance with a given platform's support.
 *</p>  
 *<p> 
 *The class is responsible for the extraction and loading of infra HA related native libraries <br>
 *which are originally packaged in the same jar as itself. 
 </p>  
 *<p> 
 *Additionally, the class supports runtime plugin plugin reload (context of a different classloader)  
 *</p>
 */
public class SystemPlugin extends org.hyperic.hq.plugin.system.SystemPlugin{
    
    private static final String VM_HA_CLIENT_BIN_RELATIVE_PATH = "/vm-ha-client-bin" ; 
    private static final String LIBRARIES_LOADED_FLAG_KEY = "vm.hq.client.lib.loaded" ; 
    
    private static VMGuestAppMonitor haClient ; 
    private static boolean supportsHAClientActions ; 
    private static final String RESTART_PLATFORM = "restart_platform";
    private static final String RESET_VM = "reset_VM";
    
    // set of supported actions
    private static final List<String> actions = Arrays.asList(new String[] { RESTART_PLATFORM, RESET_VM });

    /**
     * Initializes and returns a new {@link VMLifecycleControlPlugin} IFF:<br/> 
     * - No other corresponding plugin was found in super class logic<br/>
     * - The given platform supports infra HA actions (i.e. > ESX 6 + vmtools + infra HA module are installed) or<br/> 
     * - Server context (required for the ControlManager.isSupported to return a positive response which would in turn<br/>
     *   enable the UI control tab.<br/> 
     * 
     * @param type 
     * @param info 
     * @return the plugin corresponding to the sub plugin and resource type (e.g. control plugin 
     * for the platform resource).
     */
    @Override
    public GenericPlugin getPlugin(String type, TypeInfo info) {
        GenericPlugin plugin = super.getPlugin(type,info) ; 
        
        if ((plugin == null) && supportsHAClientActions && type.equals(ProductPlugin.TYPE_CONTROL)
                && (info.getType() == AppdefEntityConstants.APPDEF_TYPE_PLATFORM)) {
            plugin =  new VMLifecycleControlPlugin() ;
        }//EO if control type plugin

        else if ((plugin == null) && type.equals(ProductPlugin.TYPE_CONTROL)
                && (info.getType() == AppdefEntityConstants.APPDEF_TYPE_PLATFORM)) {
            plugin = new SystemControlPlugin();
        }
        
        return plugin ; 
    }//EOM 
    
    /**
     * @returns true if the given platform supports infra HA actions (i.e. > ESX 6 + vmtools + infra HA module are installed) and \
     * false if otherwise
     */
    @Override 
    protected final boolean hasPlatformControlActions() { return true; }//EOM
    
    @Override
    public final void init(final PluginManager manager) throws PluginException {
        try{
            //only init the vm-ha-client resources if in agent context and not already initalized
            if(! Bootstrap.isServer()  && (haClient == null)) { 
            
                PlatformType.initVMActions(this.getClass());
                
                haClient = new VMGuestAppMonitor() ; 
                
                if(! (supportsHAClientActions = haClient.isClientSupported()) ) { 
                    PlatformType.disposeVMActions();
                    this.getLog().warn("Platform Does not support VM actions") ;
                }//EO if unsupported
                else {
                    this.getLog().warn("Platform supports VM actions") ;
                }
                
              //TODO: FOR DEBUG: REMOVE BELOW CODE LINE 
              //supportsHAClientActions = true ; 
                
            }//EO if agent context 
            
            super.init(manager);
             
        }catch(Throwable t) { 
            //Silence the Exception as the agent should be started even if the HA is disabled 
            this.getLog().error(t) ;  
        }//EO catch block 
    }//EOM 
    
    /**
     * OS & cpu architecture based Native libraries loading strategies.  
     */
    private static enum PlatformType { 
        
        Win32 { 
            @Override
            public final boolean is64x() { return false; }//EOM 
            @Override
            public final boolean isUnix() { return false; }//EOM 
        },//EO Win32 
        Win64 {  
            @Override
            public final boolean is64x() { return true; }//EOM 
            @Override
            public final boolean isUnix() { return false; }//EOM
        },//EO Win64  
        Unix32 { 
            @Override
            public final boolean is64x() { return false; }//EOM 
            @Override
            public final boolean isUnix() { return true; }//EOM
        },//EO Unix64 
        Unix64 { 
            @Override
            public final boolean is64x() { return true; }//EOM 
            @Override
            public final boolean isUnix() { return true; }//EOM
        };//EO Unix64
        
        private static final Map<String,PlatformType> reverseMapping = new HashMap<String,PlatformType>(4) ; 
        
        static{ 
            for(PlatformType enumPlatformType : values()) { 
                reverseMapping.put("" + enumPlatformType.isUnix() + enumPlatformType.is64x(), enumPlatformType) ;
            }//EO while there are more platforms 
        }//EO static block 
        
        /**
         * @return the strategy corresponding to the given os and chip architecture. 
         */
        private static final PlatformType currentPlatform() { 
             final String osName = System.getProperty("os.name") ; 
             final String osArch = System.getProperty("os.arch") ; 
             return reverseMapping.get(""+ !osName.toLowerCase().startsWith("win") + osArch.endsWith("64")) ; 
        }//EOM
        
        /**
         * @return true if not on windows (including mac and solaris) 
         */
        public abstract boolean isUnix() ;
        public abstract boolean is64x() ; 
        
        /**
         * Loads the native libraries corresponding to the platform on which the agent resides.<br/> 
         * Libraries shall not be loaded if in server context or it was determined that the libraries were already loaded 
         * (LIBRARIES_LOADED_FLAG_KEY system property.<br/>  
         * <br/>
         * The native library artifacts for all platforms are packaged within the system-plugin.jar uunder the vm-ha-client/lib directory.<br/>
         * <br/> 
         * On first load, all artifacts residing under the /vm-ha-client/lib/<PlatformType.name()> would be extracted from the jar into the  
         * <AGENT_HOME>/bundles/agent-<VERSION>/lib/vm-ha-client-bin dir and loaded into the vm using the sequence defined in the 
         * /vm-ha-client/lib/<PlatformType.name()>/loadSequence.txt file.<br/> 
         * <br/> 
         * If however the artifacts were already extracted, no extraction would be performed. 
         * 
         * @throws Throwable
         */
        public static final void initVMActions(Class<?> pluginClass) throws Throwable { 
            
            //if the libraries were already loaded abort 
            if(System.getProperty(LIBRARIES_LOADED_FLAG_KEY) != null) {
                return ;
            } 
                    
            URL pluginsDir = SystemPlugin.class.getClassLoader().getResource(".") ; 
            if(pluginsDir == null) {
                pluginsDir = SystemPlugin.class.getClassLoader().getResource("") ;
            }
            final File destParent = new java.io.File(pluginsDir.getFile(), VM_HA_CLIENT_BIN_RELATIVE_PATH) ; 
             
            final Log pluginLog = LogFactory.getLog(pluginClass);
            pluginLog.info("vm ha client bin directory is -->" + destParent);
            
            final String LIB_DIR_NAME = "/vm-ha-client/lib/" + PlatformType.currentPlatform() + "/" ;
            
            final InputStream loadSequenceFileIS = SystemPlugin.class.getResourceAsStream(LIB_DIR_NAME + "load-sequence.txt") ; 
            
            final StringBuilder loadSequence = new StringBuilder() ; 
            try{ 
                
                while(loadSequenceFileIS.available() > 0) { 
                    loadSequence.append((char)loadSequenceFileIS.read()) ;
                }//EO while there are more chars 
            }finally{ 
                loadSequenceFileIS.close() ; 
            }//EO catch block 
            
            final String[] libraryNames = loadSequence.toString().trim().split(",") ;
            final File[] existingLibraries = destParent.listFiles() ;  
            if(!destParent.exists() || ((existingLibraries == null) || (existingLibraries.length != libraryNames.length))) { 
                
                if(existingLibraries != null) {
                     for(File existingLibrary : existingLibraries) { 
                         existingLibrary.delete() ; 
                     }//EO while there are more existing libraries 
                }//EO if there was a partial extraction 
                 
                destParent.mkdirs() ;
                loadLibrariesFromJar(libraryNames, destParent, LIB_DIR_NAME) ;
            }else {
                 loadLibrariesFromFS(libraryNames, destParent) ; 
            }//EO else if files were already extracted 
                
            
          //flag that the libraries had been loaded 
          System.setProperty(LIBRARIES_LOADED_FLAG_KEY, "1") ;
             
        }//EOM 
        
        /**
         * @param libraryLoadSequence simple file names sorted in load order 
         * @param destParent 
         * @param LIB_DIR_NAME relative path in the jar under which the artifacts should reside
         * @throws Throwable
         */
        private static final void loadLibrariesFromJar(final String[] libraryLoadSequence, final File destParent, final String LIB_DIR_NAME) throws Throwable{ 
            URL fileURL = null ; 
            File destFile = null ;
            ReadableByteChannel rbc = null;
            WritableByteChannel wbc = null; 
         
            for(String libraryName : libraryLoadSequence) {  
                fileURL = SystemPlugin.class.getResource(LIB_DIR_NAME + libraryName) ;
                destFile = new File(destParent, libraryName) ;
                
                try{ 
                    rbc = Channels.newChannel(fileURL.openStream()) ;
                    wbc = Channels.newChannel(new FileOutputStream(destFile)) ;
                    fastChannelCopy(rbc, wbc) ; 
                }finally{ 
                    if(rbc != null) {
                        rbc.close() ;
                    }
                    if(wbc != null) {
                        wbc.close() ;
                    } 
                }//EO catch block 
                
                
                System.load(destFile.getAbsolutePath()) ;
            }//EO while there are more libraries to load 
        }//EOM 
        
        /**
         * @param libraryLoadSequence simple file names sorted in load order 
         * @param destParent
         * @throws Throwable
         */
        private static final void loadLibrariesFromFS(final String[] libraryLoadSequence, final File destParent) throws Throwable{
            File destFile = null ; 
            for(String libraryName : libraryLoadSequence) { 
                destFile = new File(destParent, libraryName) ;
                System.load(destFile.getAbsolutePath()) ;
            }//EO while there are more libraries to load 
        }//EOM 
        
        
        
        public static final void disposeVMActions() throws Throwable { 
            //NYI
        }//EOM 
        
        /**
         * Copies the one stream into another 
         * @param source
         * @param dest
         * @throws IOException
         */
        private static final void fastChannelCopy(final ReadableByteChannel source, final WritableByteChannel dest) throws IOException { 
            final ByteBuffer buffer = ByteBuffer.allocateDirect(16*1024) ;
            while(source.read(buffer) != -1) { 
                buffer.flip(); 
                dest.write(buffer) ; 
                buffer.compact() ; 
            }//EO while there are source
            
            buffer.flip() ; 
            while(buffer.hasRemaining()) { 
                dest.write(buffer) ; 
            }//EO while there are more remaining bytes 
        }//EOM 

    }//EO enum PlatformInitializerType 
    
    
    /**
     * ControlPlugin handling infra-ha inteactions.</br>  
     */
    public static final class SystemControlPlugin extends ControlPlugin{ 
        
        //indicator that another reset_vm is in progress 
        private static AtomicBoolean isActionInProgress = new AtomicBoolean() ;
        
       
        @Override
        public final List<String> getActions() {
            return actions ; 
        }//EOM 
        
        /**
         * @param actionName control action being executed 
         * @param persistedControlResponsesDir directory in which control actions exepected to outlive agent/vm restarts are stored  
         * @return true if the isActionInProgress was true or the persistedControlResponsesDir exists and contains at list one file 
         * whose name has the actionName prefix 
         */
        private final boolean concurrentActionInProgress(final String actionName, final File persistedControlResponsesDir) { 
            if(isActionInProgress.get()) {
                return true ;
            } 
            
            File[] controlResponses = null ; 
            
            return (persistedControlResponsesDir.exists() && ((controlResponses = persistedControlResponsesDir.listFiles(new FileFilter() { 
                    public final boolean accept(final File pathname) {
                        return (pathname.getName().startsWith(actionName + '_')) ; 
                    }//EOM 
                 })) == null)) ;  
            
        }//EOM 
        
        @Override
        public void doAction(String action, final ControlSendCommandResult_args resultsMetadata) throws PluginException {
            doAction(action, null/*String[]*/, resultsMetadata);
        }//EOM 
        

        @Override
        public void doAction(final String action, final String[] args, final ControlSendCommandResult_args resultsMetadata) throws PluginException {
            final Log log = this.getLog() ; 
            final File persistedControlResponsesDir = new File(AgentConfig.PERSISTED_CONTROL_RESPONSES_DIR) ;persistedControlResponsesDir.mkdir() ;
            final File persistedControlActionFile = new File(persistedControlResponsesDir, action + '_' +  resultsMetadata.getId() + ".ser") ;
          
            try{ 
                if(concurrentActionInProgress(action, persistedControlResponsesDir)) {
                    throw new PluginException("Multiple " + action + " exeutions is unsupported") ;
                }
                isActionInProgress.set(true) ; 
                
                
                log.info("About to persist a successful control response for action " + action +  " to file " + persistedControlActionFile) ;

                resultsMetadata.setResult(RESULT_SUCCESS)  ;
                FileUtil.persistObject(resultsMetadata, persistedControlActionFile); 

                if (action.equalsIgnoreCase(RESTART_PLATFORM) || action.equalsIgnoreCase(RESET_VM)) {
                    if ((PlatformType.currentPlatform() == PlatformType.Win32)
                            || (PlatformType.currentPlatform() == PlatformType.Win64)) {
                        log.info("Restarting machine");
                        String[] cmd = { "shutdown", "-r" };
                        Runtime.getRuntime().exec(cmd);

                    } else if ((PlatformType.currentPlatform() == PlatformType.Unix32)
                            || (PlatformType.currentPlatform() == PlatformType.Unix64)) {
                        log.info("Restarting machine");
                        Runtime.getRuntime().exec("reboot");
                    }
                }
                             
                this.setResult(RESULT_SUCCESS) ;
            }catch(Throwable t) { 
                log.error("An Error Had occured during the execution of platform action " + action + ", removing persited control action response file " + persistedControlActionFile, t) ;
                persistedControlActionFile.delete() ; 
                
                if(t instanceof InvocationTargetException) {
                    t = ((InvocationTargetException)t).getTargetException() ;
                } 
                this.setExceptionMessage(t) ; 
                throw (t instanceof PluginException ? ((PluginException)t) : new PluginException(t)) ;
                
            }finally{ 
                isActionInProgress.set(false) ; 
            }//EO catch block  
            
        }//EOM 
        
        protected final boolean useConfigSchema(TypeInfo info) {
            return true;
        }//EOM 
        
    }// EO inner class
    
    /**
     * ControlPlugin handling infra-ha inteactions.</br>  
     */
    public static final class VMLifecycleControlPlugin extends ControlPlugin{ 
        
        //indicator that another reset_vm is in progress 
        private static AtomicBoolean isActionInProgress = new AtomicBoolean() ;
        //set of supported actions 
        private static final Map<String,Method> methodsCache = new ConcurrentHashMap<String,Method>() ; 
        
        /**
         * OS & cpu architecture based Native libraries loading strategies.  
         */
       
        @Override
        public final List<String> getActions() {
            return actions ; 
        }//EOM 
        
        /**
         * @param actionName control action being executed 
         * @param persistedControlResponsesDir directory in which control actions exepected to outlive agent/vm restarts are stored  
         * @return true if the isActionInProgress was true or the persistedControlResponsesDir exists and contains at list one file 
         * whose name has the actionName prefix 
         */
        private final boolean concurrentActionInProgress(final String actionName, final File persistedControlResponsesDir) { 
            if(isActionInProgress.get()) {
                return true ;
            } 
            
            File[] controlResponses = null ; 
            
            return (persistedControlResponsesDir.exists() && ((controlResponses = persistedControlResponsesDir.listFiles(new FileFilter() { 
                    public final boolean accept(final File pathname) {
                        return (pathname.getName().startsWith(actionName + '_')) ; 
                    }//EOM 
                 })) == null)) ;  
            
        }//EOM 
        
        @Override
        public void doAction(String action, final ControlSendCommandResult_args resultsMetadata) throws PluginException {
            doAction(action, null/*String[]*/, resultsMetadata);
        }//EOM 
        
        /**
         * Resets the VM.
         * <p> 
         * <b>Notes:</b>
         *  <ul>
         *    <li>An exception would be thrown if another action is in progress.</li>
         *    <li>actionName must correspond to a public method in the {@link VMGuestAppMonitor} class.</li>
         *    <li>Successful action snapshot would persited itno the {@link AgentConfig#PERSISTED_CONTROL_RESPONSES_DIR} prior to executing the aciton.<br/>
         *        This is required as a successful reset operation would kill the agent along with the vm before a response could be sent to the server.<br/> 
         *    </li>
         *    <li>If the operation had failed, the persited successful response would be deleted from the filesystem and a failed response
         *        would be sent in its stead. 
         *    </li>
         *  </ul>
         * </>   
         */
        @Override
        public void doAction(final String action, final String[] args, final ControlSendCommandResult_args resultsMetadata) throws PluginException {
            final Log log = this.getLog() ; 
            final File persistedControlResponsesDir = new File(AgentConfig.PERSISTED_CONTROL_RESPONSES_DIR) ;persistedControlResponsesDir.mkdir() ;
            final File persistedControlActionFile = new File(persistedControlResponsesDir, action + '_' +  resultsMetadata.getId() + ".ser") ;
          
            try{ 
                if(concurrentActionInProgress(action, persistedControlResponsesDir)) {
                    throw new PluginException("Multiple " + action + " exeutions is unsupported") ;
                }
                isActionInProgress.set(true) ; 
                
                Method actionMethod = methodsCache.get(action) ; 
                if(actionMethod == null) { 
                    actionMethod = VMGuestAppMonitor.class.getDeclaredMethod(action, (Class[]) ((args == null) || (args.length == 0) ? new Class[]{} : String[].class)) ; 
                    methodsCache.put(action, actionMethod) ; 
                }//EO if not yet cached 
                
                //first persist a success version of the resultsMetadata to the AgentConfig.PERSISTED_CONTROL_RESPONSES_DIR directory 
                //this action is required as a ssuccessful restart request would kill the agent prior to sending the response to the server 
                //which would leave the action's status in 'in progress' indifinitely. 
                //the persisted response would be sent to the server during agent start
                //If the reset request fails then the persited version would be deleted and an error would be sent 
                //to the server by the client invoker (ActionThread) 
                log.info("About to persist a successful control response for action " + action +  " to file " + persistedControlActionFile) ;

                resultsMetadata.setResult(RESULT_SUCCESS)  ;
                FileUtil.persistObject(resultsMetadata, persistedControlActionFile); 
                if("restart_platform".equals(action)){
                  if ((PlatformType.currentPlatform() == PlatformType.Win32)
                        || (PlatformType.currentPlatform() == PlatformType.Win64)) {
                    log.info("Restarting machine");
                    String[] cmd = { "shutdown", "-r" };
                    try{
                     Runtime.getRuntime().exec(cmd);
                    }catch(Exception e){
                     actionMethod.invoke(haClient, (Object[])args) ;	
                    }

                  } else if ((PlatformType.currentPlatform() == PlatformType.Unix32)
                        || (PlatformType.currentPlatform() == PlatformType.Unix64)) {
                    log.info("Restarting machine");
                    try{
                     Runtime.getRuntime().exec("reboot");
                    }catch(Exception e){
                     actionMethod.invoke(haClient, (Object[])args) ;	
                    }
                  }
                }else{
                  actionMethod.invoke(haClient, (Object[])args) ;
                }
                             
                this.setResult(RESULT_SUCCESS) ;
            }catch(Throwable t) { 
                log.error("An Error Had occured during the execution of platform action " + action + ", removing persited control action response file " + persistedControlActionFile, t) ;
                persistedControlActionFile.delete() ; 
                
                if(t instanceof InvocationTargetException) {
                    t = ((InvocationTargetException)t).getTargetException() ;
                } 
                this.setExceptionMessage(t) ; 
                throw (t instanceof PluginException ? ((PluginException)t) : new PluginException(t)) ;
                
            }finally{ 
                isActionInProgress.set(false) ; 
            }//EO catch block  
            
        }//EOM 
        
        protected final boolean useConfigSchema(TypeInfo info) {
            return true;
        }//EOM 
        
    }//EO inner class ResetVMControlPlugin
    
    @Override
    public final void configure(final ConfigResponse config) throws PluginException {
        //if there is no control response disable the controls
        super.configure(config);
    }//EOM 
    
    public static void main(String[] args) throws Throwable {
        //final String parent = "/work/temp/servers/server-5.0.0-EE/hq-engine/hq-server/webapps/ROOT/WEB-INF/classes/vm-ha-client-bin" ;
        final String parent = "/work/workspaces/master-complete/Tests/RestartVM/src" ;
        final String[] arr = new String[] {"libvmGuestLib.so","libappmonitorlib.so","libVMGuestAppMonitorNative.so"} ;
        for(String l : arr) { 
            System.load(new File(parent, l).getAbsolutePath()) ; 
        }//EO while 
        new VMGuestAppMonitor().postState("sdf") ;  
    }//EOM 

}//EOC