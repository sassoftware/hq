import org.hyperic.hq.hqu.rendit.HQUPlugin
import org.hyperic.hq.appdef.shared.ServiceValue
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hyperic.hq.hqu.rendit.util.HQUtil
import org.hyperic.hq.product.ProductPlugin
import org.hyperic.util.units.FormatSpecifics
import org.hyperic.util.units.UnitsConstants
import org.hyperic.util.units.UnitsFormat
import org.hyperic.util.units.UnitNumber
import org.hyperic.hq.measurement.server.session.MeasurementManagerImpl as MeasurementMan
import org.hyperic.hq.appdef.shared.ServiceManager
import org.hyperic.hq.appdef.shared.ServerManager;
import org.hyperic.hq.appdef.shared.ConfigManager
import org.hyperic.hq.measurement.shared.MeasurementManager
import org.hyperic.hq.context.Bootstrap;

class Plugin extends HQUPlugin {
    def static final mqControllerLog = LogFactory.getLog("MqController.Plugin");

    static final QMANAGER="queue.manager.name";
    static final CHANNEL="channel.name";
    static final QUEUE="queue.name";
    static final CLUSTER="cluster.name";
    static final QUEUE_CLUSTER = "queue.cluster";

    def static ServiceManager ServicesMan=Bootstrap.getBean(ServiceManager.class)
    def static ServerManager ServerMan=Bootstrap.getBean(ServerManager.class)
    def static ConfigManager ConfigMan=Bootstrap.getBean(ConfigManager.class)
    def static MeasurementManager MeasurementMan=Bootstrap.getBean(MeasurementManager.class)

    void initialize(File pluginDir) {
        super.initialize(pluginDir)
        ServiceValue.metaClass.getQueueManagerName = { ->
            def qm=getQManager(delegate)
            getServerConfigValue(qm,QMANAGER)
        }
	
        ServiceValue.metaClass.getQueueManagerId = { ->
            getQManager(delegate).entityId
        }
	    
        ServiceValue.metaClass.getChannelName = { ->
            getConfigValue(delegate,CHANNEL)
        }

        ServiceValue.metaClass.getChannelID = { ->
            delegate.entityId
        }

        ServiceValue.metaClass.getQueueName = { ->
            getConfigValue(delegate,QUEUE)
        }

        ServiceValue.metaClass.getMsgs = {->
            getMetric(delegate,"Msgs1m")
        }
	    
        ServiceValue.metaClass.getDepth = { ->
            getMetric(delegate,"CurrentDepth")
        }

        /*        def props=ServiceValue.metaClass.properties
        props.each(){ q ->
        if(q.getter instanceof org.codehaus.groovy.runtime.metaclass.ClosureMetaMethod)
        println("--> ${q.getter}")
        }*/
	    
        /*    	["queueManagerName","queueManagerId","channelName","channelID","queueName","msgs","depth"].each(){ q ->
        println("${q} --> "+(ServiceValue.metaClass.hasMetaProperty(q)==true))
    	}*/
    	
        /* addView(description:  'WebSphere HQ Complete Status',
        attachType:   'resource',
        byPlugin:     'websphere_mq',
        controller:   MqController,
        action:       'index')    */

        addView(description:  'WebSphere HQ Complete Status',
            attachType:   'resource',
            resourceType: ['WebSphere MQ QManager 7','WebSphere MQ QManager 6'],
            controller:   MqController,
            action:       'index')
	            
    }

    def _getMetric(r,String metric){
        format(_getMetric(r,metric))
    }
	
    def getMetric(r,String metric){
    	mqControllerLog.debug("getMsgs --> "+r.entityId)
    	def em=MeasurementMan.findEnabledMeasurements(null,r.entityId,null).grep{
            (it.template.alias.contains(metric))
    	}

        if((em==null) || (em.size==0)){
            mqControllerLog.error("getMsgs --> meritc '${metric}' for '${r.entityId}' not found")
            return "N/A"
        }

        if(mqControllerLog.isDebugEnabled()){
            em.each(){ m ->
                if(m.lastDataPoint!=null){
                    mqControllerLog.debug("getMsgs --> m => "+m.lastDataPoint.value+" ("+m.template.alias+")")
                }else{
                    mqControllerLog.debug("getMsgs --> m => null ("+m.template.alias+")")
                }
            }
        }

        if(em[0].lastDataPoint!=null){
            return format(em[0].lastDataPoint.value)
        }
        else{
            return "N/A";
        }
    }
	
    def format(d) {
        return UnitsFormat.format(new UnitNumber(d, UnitsConstants.UNIT_NONE,  UnitsConstants.SCALE_NONE),  Locale.getDefault(), null).toString() 
    }

    def getServerConfigValue(server, prop){
        def config=ConfigMan.getMergedConfigResponse(HQUtil.getOverlord(),ProductPlugin.TYPE_PRODUCT,ServerMan.getServerById(server.id).entityId,true)
        config.getValue(prop)
    }
    
    def getConfigValue(service, prop){
        def config=ConfigMan.getMergedConfigResponse(HQUtil.getOverlord(),ProductPlugin.TYPE_PRODUCT,ServicesMan.getServiceById(service.id).entityId,true)
        def res=config.getValue(prop)
        mqControllerLog.debug("getConfigValue(${service.name},${prop}) => ${res}")
        res
    }
    	
    def getQManager(ServiceValue service){
        def server=ServerMan.getServerByService(HQUtil.getOverlord(),service.id)
        mqControllerLog.debug("getQManager -> "+server)
        server
    }
}      