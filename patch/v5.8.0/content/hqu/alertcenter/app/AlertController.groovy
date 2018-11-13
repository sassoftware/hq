/**
 * NOTE: This copyright does *not* cover user programs that use HQ
 * program services by normal system calls through the application
 * program interfaces provided as part of the Hyperic Plug-in Development
 * Kit or the Hyperic Client Development Kit - this is merely considered
 * normal use of the program, and does *not* fall under the heading of
 *  "derived work".
 *
 *  Copyright (C) [2009-2010], VMware, Inc.
 *  This file is part of HQ.
 *
 *  HQ is free software; you can redistribute it and/or modify
 *  it under the terms version 2 of the GNU General Public License as
 *  published by the Free Software Foundation. This program is distributed
 *  in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
 *  even the implied warranty of MERCHANTABILITY or FITNESS FOR A
 *  PARTICULAR PURPOSE. See the GNU General Public License for more
 *  details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
 *  USA.
 *
 */

import org.hyperic.hq.authz.shared.PermissionException

import org.hyperic.hq.hqu.rendit.BaseController

import java.text.DateFormat
import org.hyperic.hq.common.YesOrNo
import org.hyperic.hq.context.Bootstrap;
import org.hyperic.hq.events.AlertPermissionManager;
import org.hyperic.hq.events.AlertSeverity
import org.hyperic.hq.events.EventConstants
import org.hyperic.hq.events.server.session.AlertDefSortField
import org.hyperic.hq.events.server.session.AlertSortField
import org.hyperic.hq.galerts.server.session.GalertDefSortField
import org.hyperic.hq.galerts.server.session.GalertLogSortField
import org.hyperic.hq.hqu.rendit.html.DojoUtil
import org.hyperic.hq.hqu.rendit.util.HQUtil
import com.sas.hyperic.security.servlet.LocaleSetId
import org.hyperic.hq.ui.util.trans.YesOrNoMap

class AlertController 
	extends BaseController
{
    private final DateFormat df = 
        DateFormat.getDateTimeInstance(DateFormat.SHORT, DateFormat.SHORT, LocaleSetId.getLocale())
    private final SEVERITY_MAP = [(AlertSeverity.LOW)    : 'Low',
                                  (AlertSeverity.MEDIUM) : 'Med',
                                  (AlertSeverity.HIGH)   : 'High']
    private getSeverityImg(s) {
        def imgUrl = urlFor(asset:'images') + 
            "/${SEVERITY_MAP[s]}-severity.gif"
		def imgLabel=localeBundle.AlertPriorityMed 	
		if (SEVERITY_MAP[s].equals('Low')) {
            imgLabel=localeBundle.AlertPriorityLow
		}
		else if(SEVERITY_MAP[s].equals('High')) {
            imgLabel=localeBundle.AlertPriorityHigh
		}
		else {
            imgLabel=localeBundle.AlertPriorityMed
		}
        """<img src="${imgUrl}" width="16" height="16" border="0" 
                class="severityIcon">  ${imgLabel}"""
    }
    
	private getFixed(fixed) {
		if(fixed == null){
		 return ""	
		}
		
		if(fixed.equals("Yes")){
			return localeBundle.YES
		}else if(fixed.equals("No")){
			return localeBundle.NO
		}else{
			return fixed
		}
	  
	}    
	
	private getActive(act) {
		
	 if(act == null){
			return ""
     }
   
		
	 if(act.equals("Yes")){
	  return localeBundle.YES
	 }else if(act.equals("No")){
	  return localeBundle.NO
	 }else{
	  return act
	 }
    }

    private getPriority(params) {
        def minPriority = params.getOne('minPriority', '1')
        def severity = AlertSeverity.findByCode(minPriority.toInteger())
    }        

    boolean logRequests() {
        false
    }    

    private getNow() {
        System.currentTimeMillis()
    }
    
    private final ALERT_TABLE_SCHEMA = [
        getData: {pageInfo, params -> 
            def alertTime = params.getOne('alertTime', "86400000").toLong()
            def show      = params.getOne('show', "all")
            def group     = params.getOne('group', "0")
            alertHelper.findAlerts(getPriority(params), alertTime, now,
                                   show == "inescalation", show == "notfixed",
                                   group != "0" ? group.toInteger() : null,
                                   pageInfo)
        },
        defaultSort: AlertSortField.DATE,
        defaultSortOrder: 0,  // descending
        styleClass: {it.fixed ? null : "alertHighlight"},
        columns: [
            [field:AlertSortField.ACTION_TYPE, width:'20px',
             label:{
				 def canTakeAction
				
				 try {
					Bootstrap.getBean(AlertPermissionManager.class).canFixAcknowledgeAlerts(user, it.alertDefinition.appdefEntityId)
					
					canTakeAction = true
				 } catch (PermissionException e) {
				    canTakeAction = false
				 }
				
			 	 def esc = it.definition.escalation
             	 def pause = (esc == null ? "0" : (esc.pauseAllowed ? esc.maxPauseTime : "0"))
             	 // checkbox id is in the format: {portalName}|{appdefKey}|{alertId}|{maxPauseTime}
             	 def id = "Alerts|" + it.alertDefinition.appdefEntityId.appdefKey + "|" + it.id + "|" + pause
				 def member = (it.ackable ? "ackableAlert" : "fixableAlert")
             	 def box = ((it.fixed || !canTakeAction) ? "" : "<input type='checkbox' name='ealerts' id='" + id + "' class='" + member + "' value='-559038737:" + it.id +"' onclick='MyAlertCenter.toggleAlertButtons(this)' />")}],
            [field:[getValue: {localeBundle.AlertDate},
                 description:'AlertDate', sortable:true], width:'100px',
             label:{df.format(it.timestamp)}],
            [field:[getValue: {localeBundle.AlertDefinition},
                 description:'AlertDefinition', sortable:false], width:'15%',
             label:{linkTo(it.alertDefinition.name, [resource:it]) }],
            [field:[getValue: {localeBundle.AlertResource},
                 description:'AlertResource', sortable:false], width:'28%',
             label:{linkTo(it.alertDefinition.resource.name,
                           [resource:it.alertDefinition.resource])}],
            [field:[getValue: {localeBundle.AlertPlatform},
                 description:'AlertPlatform', sortable:false], width:'28%',
             label:{linkTo(it.alertDefinition.resource.platform.name,
                           [resource:it.alertDefinition.resource.platform])}],
            [field:[getValue: {localeBundle.AlertFixed},
                 description:'AlertFixed', sortable:false], width:'40px',
             label:{getFixed(YesOrNoMap.valueFor(it.fixed, LocaleSetId.getLocale()))}],
            [field:[getValue: {localeBundle.AlertAck},
                 description:'AlertAck', sortable:false], width:'75px',
             label:{
				 def canTakeAction
				
				 try {
				     Bootstrap.getBean(AlertPermissionManager.class).canFixAcknowledgeAlerts(user, it.alertDefinition.appdefEntityId)
					
					canTakeAction = true
				 } catch (PermissionException e) {
					canTakeAction = false
				 }
			
			     def esc = it.definition.escalation
             	 def pause = (esc == null ? "0" : (esc.pauseAllowed ? esc.maxPauseTime : "0"))
             	 // checkbox id is in the format: {portalName}|{appdefKey}|{alertId}|{maxPauseTime}
             	 def id = "Alerts|" + it.alertDefinition.appdefEntityId.appdefKey + "|" + it.id + "|" + pause
                 def by = it.acknowledgedBy
                 by == null ? ((it.ackable && canTakeAction) ? "<a href='javascript:MyAlertCenter.acknowledgeAlert(\"" + id + "\")'><img src='/images/icon_ack.gif'></a>" : "") : by.fullName
            }],
            [field:[getValue: {localeBundle.AlertPriority},
                 description:'AlertPriority', sortable:true], width:'70px',
             label:{getSeverityImg(it.alertDefinition.severity)}
            ],
        ]
    ]
    
    private final GALERT_TABLE_SCHEMA = [
        getData: {pageInfo, params -> 
            def alertTime = params.getOne('alertTime', "86400000").toLong()
            def show      = params.getOne('show', "all")
            def group     = params.getOne('group', "0")
            alertHelper.findGroupAlerts(getPriority(params), alertTime,
                                        now, show == "inescalation",
                                        show == "notfixed",
                                        group != "0" ? group.toInteger() : null,
                                        pageInfo)
        },
        defaultSort: GalertLogSortField.DATE,
        defaultSortOrder: 0,  // descending
        styleClass: {it.fixed ? null : "alertHighlight"},
        columns: [
            [field:GalertLogSortField.ACTION_TYPE, width:'20px',
             label:{
				 def canTakeAction
				
				 try {
				     Bootstrap.getBean(AlertPermissionManager.class).canFixAcknowledgeAlerts(user, it.alertDef.appdefID)
					
					canTakeAction = true
				 } catch (PermissionException e) {
					canTakeAction = false
				 }
			
			     def esc = it.definition.escalation
             	 def pause = (esc == null ? "0" : (esc.pauseAllowed ? esc.maxPauseTime : "0"))
             	 // checkbox id is in the format: {portalName}|{appdefKey}|{alertId}|{maxPauseTime}
             	 def id = "GroupAlerts|" + it.alertDef.appdefID.appdefKey + "|" + it.id + "|" + pause
             	 def member = (it.acknowledgeable ? "ackableAlert" : "fixableAlert")
             	 def box = ((it.fixed || !canTakeAction) ? "" : "<input type='checkbox' name='ealerts' id='" + id + "' class='" + member + "' value='195934910:" + it.id +"' onclick='MyAlertCenter.toggleAlertButtons(this)' />")}],
            [field:[getValue: {localeBundle.AlertDate},
                 description:'AlertDate', sortable:true], width:'100px',
             label:{df.format(it.timestamp)}],
            [field:[getValue: {localeBundle.AlertDefinition},
                 description:'AlertDefinition', sortable:false], width:'25%',
             label:{linkTo(it.alertDef.name, [resource:it]) }],
            [field:[getValue: {localeBundle.AlertGroup},
                 description:'AlertGroup', sortable:true], width:'35%',
             label:{linkTo(it.alertDef.group.name,
                    [resource:it.alertDef.group])}],
            [field:[getValue: {localeBundle.AlertFixed},
                 description:'AlertFixed', sortable:false], width:'40px',
             label:{getFixed(YesOrNo.valueFor(it.fixed).value.capitalize())}],
            [field:[getValue: {localeBundle.AlertAck},
                 description:'AlertAck', sortable:false], width:'75px',
             label:{
				 def canTakeAction
				
				 try {
				     Bootstrap.getBean(AlertPermissionManager.class).canFixAcknowledgeAlerts(user, it.alertDef.appdefID)
					
					canTakeAction = true
				 } catch (PermissionException e) {
					canTakeAction = false
				 }
				
				 def esc = it.definition.escalation
             	 def pause = (esc == null ? "0" : (esc.pauseAllowed ? esc.maxPauseTime : "0"))
             	 // checkbox id is in the format: {portalName}|{appdefKey}|{alertId}|{maxPauseTime}
             	 def id = "GroupAlerts|" + it.alertDef.appdefID.appdefKey + "|" + it.id + "|" + pause
                 def by = it.acknowledgedBy
                 by == null ? ((it.acknowledgeable && canTakeAction) ? "<a href='javascript:MyAlertCenter.acknowledgeAlert(\"" + id + "\")'><img src='/images/icon_ack.gif'></a>" : "") : by.fullName }],
            [field:[getValue: {localeBundle.AlertPriority},
                 description:'AlertPriority', sortable:true], width:'70px',
             label:{getSeverityImg(it.alertDef.severity)}                
             ],
         ]
    ]
    
    private final DEF_TABLE_SCHEMA = [
        getData: {pageInfo, params -> 
            def excludeTypes = params.getOne('excludeTypes', 'true').toBoolean()
            alertHelper.findDefinitions(AlertSeverity.LOW, 
                                        getOnlyShowDisabled(params),
                                        excludeTypes, pageInfo) 
        },
        defaultSort: AlertDefSortField.CTIME,
        defaultSortOrder: 0,  // descending
        columns: [
            [field:[getValue: {localeBundle.AlertDefName},
                 description:'AlertDefName', sortable:false], width:'13%',
             label:{linkTo(it.name, [resource:it]) }],
            [field:[getValue: {localeBundle.AlertDefCreate},
                 description:'AlertDefCreate', sortable:true], width:'100px',
             label:{df.format(it.ctime)}],
            [field:[getValue: {localeBundle.AlertDefModified},
                 description:'AlertDefModified', sortable:true], width:'100px',
             label:{df.format(it.mtime)}],
            [field:[getValue: {localeBundle.AlertDefActive},
                 description:'AlertDefActive', sortable:false], width:'40px',
             label:{
             	def markUp = "<span style='whitespace:nowrap:'>"
             	 
            	if (it.active && !it.enabled) {
	             	def imgUrl = urlFor(asset:'images') + "/flag_yellow.gif"
	             	
        			markUp += getActive(YesOrNo.valueFor(it.active).value.capitalize()) + "&nbsp;<img align='absmiddle' src='${imgUrl}' width='16' height='16' border='0' class='severityIcon' title='$localeBundle.ActiveButDisabled'/>"
             	} else {
             		markUp += getActive(YesOrNo.valueFor(it.active).value.capitalize())
             	} 
             	
             	return markUp + "</span>"
			}],
            [field:[getValue: {localeBundle.AlertDefLastAlert},
                 description:'AlertDefLastAlert', sortable:false], width:'100px',
             label:{
                if (it.lastFired)
                    return linkTo(df.format(it.lastFired),
                                  [resource:it, resourceContext:'listAlerts'])
                else
                    return ''
            }],
            [field:[getValue: {localeBundle.AlertDefResource},
                 description:'AlertDefResource', sortable:false], width:'23%',
             label:{linkTo(it.resource.name,
                           [resource:it.resource])}],
            [field:[getValue: {localeBundle.AlertDefEscalation},
                 description:'AlertDefEscalation', sortable:false], width:'13%',
             label:{
                if (it.escalation == null)
                    return ""
                else if(it.escalation.id==100 && it.escalation.name=="Default Escalation")
				    return linkTo(localeBundle.DefaultEscalation, [resource:it.escalation])
				else
                    return linkTo(it.escalation.name, [resource:it.escalation])
            }],
            [field:[getValue: {localeBundle.AlertDefPriority},
                 description:'AlertDefPriority', sortable:true], width:'70px',
             label:{getSeverityImg(it.severity)}],
        ]
    ]
    
    private final TYPE_DEF_TABLE_SCHEMA = [
        getData: {pageInfo, params -> 
            alertHelper.findTypeBasedDefinitions(getOnlyShowDisabled(params),
                                                 pageInfo)
        },
        defaultSort: AlertDefSortField.NAME,
        defaultSortOrder: 0,  // descending
        columns: [
            [field:[getValue: {localeBundle.AlertDefName},
                 description:'AlertDefName', sortable:false], width:'20%',
             label:{linkTo(it.name, [resource:it]) }],
            [field:[getValue: {localeBundle.AlertDefCreate},
                 description:'AlertDefCreate', sortable:true], width:'100px',
             label:{df.format(it.ctime)}], 
            [field:[getValue: {localeBundle.AlertDefModified},
                 description:'AlertDefModified', sortable:false], width:'100px',
             label:{df.format(it.mtime)}], 
            [field:[getValue: {localeBundle.AlertDefActive},
                 description:'AlertDefActive', sortable:false], width:'40px',
             label:{
            	def markUp = "<span style='whitespace:nowrap:'>"
                	 
                markUp += getActive(YesOrNo.valueFor(it.active).value.capitalize())

                return markUp + "</span>"
             }],
            [field:[getValue: {localeBundle.ResourceType },
                    description:'resourceType', sortable:false], width:'19%',
             label:{it.resourceType.name}],
            [field:[getValue: {localeBundle.AlertDefEscalation},
                 description:'AlertDefEscalation', sortable:false], width:'18%',
              label:{
                 if (it.escalation == null)
                     return ""
                 else if(it.escalation.id==100 && it.escalation.name=="Default Escalation")
				    return linkTo(localeBundle.DefaultEscalation, [resource:it.escalation])
                 else
                     return linkTo(it.escalation.name, [resource:it.escalation])
             }],
            [field:[getValue: {localeBundle.AlertDefPriority},
                 description:'AlertDefPriority', sortable:true], width:'70px',
             label:{getSeverityImg(it.severity)}], 
        ]
    ]
            
    private final GALERT_DEF_TABLE_SCHEMA = [
        getData: {pageInfo, params -> 
            alertHelper.findGroupDefinitions(AlertSeverity.LOW, 
                                             getOnlyShowDisabled(params),
                                             pageInfo)
        },
        defaultSort: GalertDefSortField.NAME,
        defaultSortOrder: 0,  // descending
        columns: [
            [field:[getValue: {localeBundle.AlertDefName},
                 description:'AlertDefName', sortable:false], width:'17%',
             label:{linkTo(it.name, [resource:it]) }],
            [field:[getValue: {localeBundle.AlertDefCreate},
                 description:'AlertDefCreate', sortable:true], width:'100px',
             label:{df.format(it.ctime)}],
            [field:[getValue: {localeBundle.AlertDefModified},
                 description:'AlertDefModified', sortable:true], width:'100px',
             label:{df.format(it.mtime)}],
            [field:[getValue: {localeBundle.AlertDefActive},
                 description:'AlertDefActive', sortable:false], width:'40px',
             label:{getActive(YesOrNo.valueFor(it.enabled).value.capitalize())}],
            [field:[getValue: {localeBundle.AlertDefLastAlert},
                 description:'AlertDefLastAlert', sortable:false], width:'100px',
             label:{
                 if (it.lastFired)
                     return linkTo(df.format(it.lastFired),
                                   [resource:it, resourceContext:'listAlerts'])
                 else
                     return ''
             }],
            [field:[getValue: {localeBundle.AlertGroup},
                 description:'AlertGroup', sortable:true], width:'16%',
             label:{linkTo(it.group.name, [resource:it.group])}],
            [field:[getValue: {localeBundle.AlertDefEscalation},
                 description:'AlertDefEscalation', sortable:false], width:'14%',
             label:{                 
				 if (it.escalation == null)
                     return ""
                 else if(it.escalation.id==100 && it.escalation.name=="Default Escalation")
				    return linkTo(localeBundle.DefaultEscalation, [resource:it.escalation])
                 else
                     return linkTo(it.escalation.name, [resource:it.escalation])}],
            [field:[getValue: {localeBundle.AlertDefPriority},
                 description:'AlertDefPriority', sortable:true], width:'70px',
             label:{getSeverityImg(it.severity)}], 
        ]
    ]

    private getLastDays() {
        def res = []

        for (i in 1..7) {
            def val
            if (i == 1) {
                val = "$localeBundle.Day"
            } else if (i == 7) {
                val = "$localeBundle.Week"
            } else {
                val = "$i $localeBundle.Days"
            }
            res << [code:i * 24 * 60 * 60 * 1000, value:val]    
        }
        res << [code:System.currentTimeMillis(), value:localeBundle.AllTime]
        res
    }

    private getGroups() {
        def res = [
            [code:0, value:localeBundle.AllGroups]
        ]
        def groups = resourceHelper.findViewableGroups().sort { p1, p2 -> p1.name.compareToIgnoreCase(p2.name) }.each { group ->
            res << [code: group.id, value: group.name]
        }
        res
    }

    def AlertController() {
    }
    
    def index(params) {
    	render(locals:[alertSchema     : ALERT_TABLE_SCHEMA, 
    	               galertSchema    : GALERT_TABLE_SCHEMA,
    	               defSchema       : DEF_TABLE_SCHEMA,
    	               typeDefSchema   : TYPE_DEF_TABLE_SCHEMA,
    	               galertDefSchema : GALERT_DEF_TABLE_SCHEMA,
    	               severities      : AlertSeverity.all,
    	               lastDays        : lastDays,
    	               superUser       : user.isSuperUser(), 
    	               isEE            : HQUtil.isEnterpriseEdition(),
                       groups          : groups])
    }
    
    private getOnlyShowDisabled(params) { 
        def disabledOnly = params.getOne('onlyShowDisabled', 'false').toBoolean()
    
        if (disabledOnly == false) {
            return null
        } else {
            return !disabledOnly
        }
    }
    
    def data(params) {
        def json = DojoUtil.processTableRequest(ALERT_TABLE_SCHEMA, params)
		render(inline:"/* ${json} */", contentType:'text/json-comment-filtered')
    }
    
    def groupData(params) {
        def json = DojoUtil.processTableRequest(GALERT_TABLE_SCHEMA, params)
		render(inline:"/* ${json} */", contentType:'text/json-comment-filtered')
    }
    
    def defData(params) {
        def json = DojoUtil.processTableRequest(DEF_TABLE_SCHEMA, params)
		render(inline:"/* ${json} */", contentType:'text/json-comment-filtered')
    }

    def typeDefData(params) {
        def json = DojoUtil.processTableRequest(TYPE_DEF_TABLE_SCHEMA, params)
		render(inline:"/* ${json} */", contentType:'text/json-comment-filtered')
    }
    
    def galertDefData(params) {
        def json = DojoUtil.processTableRequest(GALERT_DEF_TABLE_SCHEMA, params)
		render(inline:"/* ${json} */", contentType:'text/json-comment-filtered')
    }
    
}
