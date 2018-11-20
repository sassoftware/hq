/*
 * NOTE: This copyright does *not* cover user programs that use HQ
 * program services by normal system calls through the application
 * program interfaces provided as part of the Hyperic Plug-in Development
 * Kit or the Hyperic Client Development Kit - this is merely considered
 * normal use of the program, and does *not* fall under the heading of
 * "derived work".
 * 
 * Copyright (C) [2004, 2005, 2006], Hyperic, Inc.
 * This file is part of HQ.
 * 
 * HQ is free software; you can redistribute it and/or modify
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

package org.hyperic.hq.ui.action.resource.common.control;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.tiles.ComponentContext;
import org.apache.struts.tiles.actions.TilesAction;
import org.hyperic.hq.appdef.server.session.Service;
import org.hyperic.hq.appdef.shared.AppdefEntityID;
import org.hyperic.hq.appdef.shared.ServiceManager;
import org.hyperic.hq.bizapp.shared.ControlBoss;
import org.hyperic.hq.product.PluginNotFoundException;
import org.hyperic.hq.ui.beans.OptionItem;
import org.hyperic.hq.ui.util.RequestUtils;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * This populates the server control list. "Start," "Stop," etc.
 */
public class QuickControlPrepareAction
    extends TilesAction {

    private final Log log = LogFactory.getLog(QuickControlPrepareAction.class.getName());
    private ControlBoss controlBoss;
    private ServiceManager serviceManager;

    @Autowired
    public QuickControlPrepareAction(ControlBoss controlBoss,ServiceManager serviceManager) {
        super();
        this.controlBoss = controlBoss;
        this.serviceManager = serviceManager ;
    }

    public ActionForward execute(ComponentContext context, ActionMapping mapping, ActionForm form,
                                 HttpServletRequest request, HttpServletResponse response) throws Exception {

        log.trace("Preparing quick control options.");

        QuickControlForm qForm = (QuickControlForm) form;

        try {
            int sessionId = RequestUtils.getSessionIdInt(request);

            AppdefEntityID appdefId = RequestUtils.getEntityId(request);

            List<String> actions = controlBoss.getActions(sessionId, appdefId);
            List<OptionItem> options = OptionItem.createOptionsList(actions);

            String databaseName = getHypericDatabaseName(request,appdefId);
            if("service".equals(appdefId.getTypeName())){
                Service service = serviceManager.getServiceById(appdefId.getId());
                log.info("service type is "+service.getServiceType().getName());
                String serviceTypeName = service.getServiceType().getName();
                if(serviceTypeName!=null){
               	serviceTypeName = serviceTypeName.trim();
               	if(serviceTypeName.startsWith("PostgreSQL")&&serviceTypeName.endsWith("DataBase")){
               		String autoinventoryIdentifier = service.getAutoinventoryIdentifier();
               		log.info("autoinventoryIdentifier is "+autoinventoryIdentifier);
               		if(autoinventoryIdentifier!=null){
               			if(autoinventoryIdentifier.endsWith(" "+databaseName)){
               				log.info("now we are in the control page of the database which is used by Hyperic");
               				List<OptionItem> newOptions = new java.util.ArrayList<OptionItem>();
               				for(OptionItem oi: options){
               					log.info(oi.getLabel()+"---"+oi.getValue());
               					if("Vacuum".equals(oi.getValue())||"VacuumAnalyze".equals(oi.getValue())||"Reindex".equals(oi.getValue())){
               						log.info("For database "+databaseName+", "+oi.getValue()+" is not allowed during runtime.");
               					}else{
               						newOptions.add(oi);
               					}
               				}
               				options = newOptions;
               			}
               		}
               	  }
                }
            	
            }
            qForm.setControlActions(options);
            qForm.setNumControlActions(new Integer(options.size()));

            return null;
        } catch (PluginNotFoundException cpe) {
            log.trace("No control plugin available");
            qForm.setNumControlActions(new Integer(0));
            RequestUtils.setError(request, "resource.common.control.error.NoPlugin");

            return null;
        }
    }
    
    private String getHypericDatabaseName(HttpServletRequest request,AppdefEntityID appdefId) throws FileNotFoundException, IOException{
        log.info("Path info is "+request.getPathInfo());
        log.info("Real path is "+request.getSession().getServletContext().getRealPath("/"));
        //log.info("args is "+args);
        //log.info("action is "+action);
        java.util.Properties p = new java.util.Properties();
        String path = request.getSession().getServletContext().getRealPath("/");
        if(path==null){
        	throw new RuntimeException("can't get the path for /");
        }
        else{
           path = path.trim();
           if(path.endsWith("/")||path.endsWith("\\")){
        	   path = path.substring(0,path.length()-1);
           }
           path = path + "/../../../../conf/hq-server.conf";
        }
        p.load(new java.io.FileInputStream(path));
        String databaseUrl = p.getProperty("server.database-url");
        if(databaseUrl==null){
        	throw new RuntimeException("There is no entry server.database-url in hq-server.conf");
        }
        int index1 = databaseUrl.lastIndexOf("/");
        int index2 = databaseUrl.lastIndexOf("?protocolVersion=3");
        if(index1>=index2){
        	throw new RuntimeException("The format of server.database-url is not right.");
        }
        String databaseName = databaseUrl.substring(index1+1,index2);
   	    return databaseName ;
    }


}
