import java.text.DateFormat
import java.util.Locale
import java.io.*
import java.beans.*
import java.util.*
import java.util.regex.*
import java.text.*

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import org.hyperic.hq.hqu.rendit.metaclass.ResourceCategory
import org.hyperic.hq.authz.server.session.AuthzSubject
import org.hyperic.hq.authz.shared.AuthzSubjectManager
import org.hyperic.hq.context.Bootstrap;
import org.hyperic.hq.appdef.shared.ServiceManager
import org.hyperic.hq.appdef.shared.ServerManager
import org.hyperic.hq.appdef.shared.ConfigManager

import org.hyperic.hq.livedata.server.session.LiveDataManagerImpl as ldmi
import org.hyperic.hq.livedata.shared.LiveDataCommand
import org.hyperic.hq.livedata.FormatType
import org.hyperic.util.config.ConfigResponse 
import org.hyperic.hq.product.ProductPlugin
import org.hyperic.hq.hqu.rendit.html.DojoUtil
import org.hyperic.hq.hqu.rendit.BaseController
import org.hyperic.hq.appdef.server.session.DownResSortField
import org.hyperic.hq.hqu.rendit.util.HQUtil
import org.hyperic.hq.hqu.rendit.helpers.ResourceHelper
import org.hyperic.hq.hqu.rendit.metaclass.ResourceCategory
import org.hyperic.util.pager.PageControl
import org.hyperic.hq.appdef.shared.ServiceValue

import org.hyperic.hq.plugin.wsmq.services.*

import org.hyperic.hq.authz.shared.ResourceManager

class MqController extends BaseController {
    private static final Log log = LogFactory.getLog("MqController");
	
    private static final REMOTEQ="remote.queue";
    private static final REMOTEQM="remote.qmanager";
    private static final TRANSMITQ="transmit.queue";

    private authzMan = Bootstrap.getBean(AuthzSubjectManager.class)

    def MqController() {
        onlyAllowSuperUsers() 
        setTemplate('standard')  // in views/templates/standard.gsp
    } 

    private getViewedMembers() {
        def r = viewedResource
        def members
        
        if (r.isGroup()) {
            members = r.getGroupMembers(user).toArray()
        } else { 
            members = [r] 
        }
        members
    } 
    
    def List findChannels(type,channelName){
    	log.debug("findChannels("+type+","+channelName+")");
    	def channels
        ServiceManager ServicesMan=Bootstrap.getBean(ServiceManager.class)
    	channels=ServicesMan.getServicesByType(user, type.name, true).grep{
            (it.name.contains(channelName))
        }
    	log.debug("findChannels - channels => "+channels)
    	channels
    }

    def createChannelPair(type,channel){
        def pairCH=new ChannelPair();
        pairCH.source=channel
        findChannels(type,Utils.getConfigValue(channel,Common.CHANNEL)).each(){ it ->
            pairCH.target.add(it)
        }
        pairCH
    }

    private AuthzSubject getOverlord() {
        authzMan.overlordPojo
    }

    def index(params) {
    	render(locals:[eid: viewedResource.entityId]) 
    }

    def getstatus(params) {
    	def pairChannels=new ArrayList();
    	def clusterPairChannels=new ArrayList();
    	def channels=new ArrayList();

        ServiceManager ServicesMan=Bootstrap.getBean(ServiceManager.class)
        ServerManager ServerMan=Bootstrap.getBean(ServerManager.class)

    	def server=ServerMan.getServerById((Integer)viewedResource.instanceId)

        def clusterSenderChannelID=ServicesMan.findServiceTypeByName("WEBSPHERE MQ QMANAGER 7 CLUSTER SENDER CHANNEL")
        def clusterReceiverChannelID=ServicesMan.findServiceTypeByName("WEBSPHERE MQ QMANAGER 7 CLUSTER RECEIVER CHANNEL")
        def senderChannelID=ServicesMan.findServiceTypeByName("WEBSPHERE MQ QMANAGER 7 Sender Channel")
        def receiverChannelID=ServicesMan.findServiceTypeByName("WEBSPHERE MQ QMANAGER 7 Receiver Channel")
        def remoteQueueID=ServicesMan.findServiceTypeByName("WEBSPHERE MQ QMANAGER 7 Remote Queue")
        def localQueueID=ServicesMan.findServiceTypeByName("WEBSPHERE MQ QMANAGER 7 Local Queue")
        def clusterID=ServicesMan.findServiceTypeByName("WEBSPHERE MQ QMANAGER 7 Cluster")
        log.debug("clusterSenderChannelID --> "+clusterSenderChannelID)
    	
    	// CHANNELS sender
    	channels=ServicesMan.getServicesByServer(user,server.id,senderChannelID.id,PageControl.PAGE_ALL)
    	channels.each(){ channel ->
            pairChannels.add(createChannelPair(receiverChannelID,channel))
    	}
    	
    	// CHANNELS receiver
    	channels=ServicesMan.getServicesByServer(user,server.id,receiverChannelID.id,PageControl.PAGE_ALL)
    	channels.each(){ channel ->
            def ch=createChannelPair(senderChannelID,channel)
            ch.reverse=true
            pairChannels.add(ch)
    	}
	
    	// CLUSTER CHANNELS sender
    	channels=ServicesMan.getServicesByServer(user,server.id,clusterSenderChannelID.id,PageControl.PAGE_ALL)
    	channels.each(){ channel ->
            clusterPairChannels.add(createChannelPair(clusterReceiverChannelID,channel))
    	}
    	
    	// CLUSTER CHANNELS receiver
    	channels=ServicesMan.getServicesByServer(user,server.id,clusterReceiverChannelID.id,PageControl.PAGE_ALL)
    	channels.each(){ channel ->
            def ch=createChannelPair(clusterSenderChannelID,channel)
            ch.reverse=true
            clusterPairChannels.add(ch)
    	}
    	
    	// REMOTE QUEUES
    	def rquelist=new ArrayList()
    	def rqueues=ServicesMan.getServicesByServer(user,server.id,remoteQueueID.id,PageControl.PAGE_ALL)
    	rqueues.each(){ q ->
            def rq_name=Utils.getConfigValue(q,REMOTEQ)
            def rqm_name=Utils.getConfigValue(q,REMOTEQM)
            def tq_name=Utils.getConfigValue(q,TRANSMITQ)
            if(!rq_name.equals("")){
                def queues=ServicesMan.getServicesByType(user, localQueueID.name, true).grep{
                    (it.name.contains(rq_name) && it.name.contains(rqm_name))
                }
            	def tqueue=ServicesMan.getServicesByServer(user,server.id,localQueueID.id,PageControl.PAGE_ALL).grep{
                    (it.name.contains(tq_name))
            	}

                def rqueue=new RemoteQueue()
                rqueue.remote=q
                rqueue.local=queues[0]
                rqueue.transmit=tqueue[0]
                rquelist.add(rqueue)
            }
    	}
    	
    	// CLUSTER QUEUES
        def cqsList=new ArrayList()
        def clusters=ServicesMan.getServicesByServer(user,server.id,clusterID.id,PageControl.PAGE_ALL)

        clusters.each(){ cls -> 
            def cqs=new ClusterQueues()
            cqs.clusterName=Utils.getConfigValue(cls,Common.CLUSTER)
            cqs.clusterId=cls.entityId
            log.debug("cluster = "+cqs.clusterName)
            cqs.queues=ServicesMan.getServicesByType(user, localQueueID.name, true).grep{
                (Utils.getConfigValue(it,Common.QUEUE_CLUSTER).equals(cqs.clusterName))
            }
            cqsList.add(cqs)
        }


    	
    	//    	def platf = PlatMan.getPlatformByServer(user.valueObject,viewedResource.instanceId)
        //    	def servs = ServMan.getServersByPlatform(user.valueObject,platf.id,true,PageControl.PAGE_ALL).grep {
        //    		(it.installPath.startsWith(viewedResource.config.installPath.value) && !it.name.equals(viewedResource.name))
        //    	}
    	render(locals:[eid: viewedResource.entityId, channels:pairChannels, clusterChannels:clusterPairChannels, rqueues:rquelist, clusterQueuesList:cqsList, debug:clusters ]) 
    } 
}

class ClusterQueues{
    def clusterName
    def clusterId
    def queues
}

class RemoteQueue{
    def remote,transmit,local
}

class ChannelPair{
    def ServiceValue source
    def target=new ArrayList()
    def reverse=false
}

class Common{
    static final QMANAGER="queue.manager.name";
    static final CHANNEL="channel.name";
    static final CLUSTER="cluster.name";
    static final QUEUE_CLUSTER = "queue.cluster";
}

class Utils{
    def static log = LogFactory.getLog("MqController.Utils");
    def static ServiceManager ServicesMan=Bootstrap.getBean(ServiceManager.class)
    def static ServerManager ServerMan=Bootstrap.getBean(ServerManager.class)
    def static ConfigManager ConfigMan=Bootstrap.getBean(ConfigManager.class)

    def static getConfigValue(service, prop){
        def config=ConfigMan.getMergedConfigResponse(HQUtil.getOverlord(),ProductPlugin.TYPE_PRODUCT,ServicesMan.getServiceById(service.id).entityId,true)
        def res=config.getValue(prop)
        log.debug("getConfigValue(${service.name},${prop}) => ${res}")
        res
    }
    
    def static getConfigValueByID(id, prop){
        def config=ConfigMan.getMergedConfigResponse(HQUtil.getOverlord(),ProductPlugin.TYPE_PRODUCT,ServicesMan.getServiceById(id).entityId,true)
        config.getValue(prop)
    }
    
    //XXX ojo... esto se puede mejorar pasando el ID envez del server
    def static getServerConfigValue(server, prop){
        def config=ConfigMan.getMergedConfigResponse(HQUtil.getOverlord(),ProductPlugin.TYPE_PRODUCT,ServerMan.getServerById(server.id).entityId,true)
        config.getValue(prop)
    }
}
  