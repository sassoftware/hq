import java.text.DateFormat
import org.apache.commons.lang.StringEscapeUtils
import org.hyperic.hq.appdef.shared.AppdefEntityID;
import org.hyperic.hq.appdef.shared.AppdefUtil;
import org.hyperic.hq.hqu.rendit.BaseController
import org.hyperic.hq.hqu.rendit.html.DojoUtil
import org.hyperic.hq.events.shared.AlertManager;
import org.hyperic.hq.escalation.shared.EscalationManager;
import org.hyperic.hibernate.PageInfo
import org.hyperic.util.StringUtil
import org.hyperic.hq.authz.server.session.Resource
import org.hyperic.hq.authz.shared.AuthzConstants
import org.hyperic.hq.authz.shared.ResourceManager
import org.hyperic.hq.events.server.session.Alert
import org.hyperic.hq.events.server.session.AlertSortField
import org.hyperic.hq.galerts.server.session.GalertLog
import org.hyperic.hq.events.AlertPermissionManager;
import org.hyperic.hq.events.EventConstants
import org.hyperic.hq.appdef.server.session.DownResSortField
import org.hyperic.hq.authz.shared.PermissionException
import org.hyperic.hq.context.Bootstrap;
import org.hyperic.hq.events.AlertSeverity
import org.hyperic.hq.galerts.server.session.GalertLogSortField
import org.hyperic.hq.events.AlertFiredEvent
import org.hyperic.hq.escalation.EscalationEvent
import org.hyperic.util.timer.StopWatch
import org.json.JSONObject
import org.json.JSONArray
import org.hibernate.Hibernate

import org.hyperic.hibernate.SortField
import org.hyperic.hq.hqu.rendit.i18n.BundleMapFacade
import org.apache.commons.lang.StringEscapeUtils
import org.slf4j.Logger
import org.slf4j.LoggerFactory

import com.sas.hyperic.security.servlet.LocaleSetId

class DashboardController extends BaseController
{
    private alertMan = Bootstrap.getBean(AlertManager.class)
    private escMan   = Bootstrap.getBean(EscalationManager.class)
    private alertPermissionMan = Bootstrap.getBean(AlertPermissionManager.class)
    
    private PRIORITIES = ["", "!", "!!", "!!!"]
    private DateFormat DF = DateFormat.getDateTimeInstance(DateFormat.SHORT,
                                                           DateFormat.SHORT, LocaleSetId.getLocale())

    private static int TYPEFILTER_ALL         = 0
    private static int TYPEFILTER_DOWN        = 1
    private static int TYPEFILTER_ALERTSALL   = 2
    private static int TYPEFILTER_ALERTSESC   = 3
    private static int TYPEFILTER_ALERTSNOESC = 4

    private static _resToPlatformMap = [:]
    private static _platformMap = [:]
    
	  private _summaryData = [:]
	  
	  private BundleMapFacade bundle
    private Logger logger = LoggerFactory.getLogger(this.class)
	  private TableColumn platformCol,resourceCol,alertCol,priorityCol,statusTypeCol,lastCheckCol,lastEscalation,durationCol,stateCol,statusInfoCol

      /**
     * Set the property bundle.  Extend the superclass method to also initialize values
     * that couldn't be initialized earlier since the bundle isn't available in the constructor.
     */
    @Override
    void setLocaleBundle(newBundle) {
        super.setLocaleBundle(newBundle)       
        bundle = newBundle       
        platformCol    = new TableColumn('Platform', bundle['opcenterTabPlatform'], true)
				resourceCol    = new TableColumn('Resource', bundle['opcenterTabResource'], true)
				alertCol       = new TableColumn('Alert', bundle['opcenterTabAlertName'], true)
				priorityCol    = new TableColumn('Priority', bundle['opcenterTabAlertPriority'], true)
				statusTypeCol  = new TableColumn("StatusType", bundle['opcenterTabStatus'], true)
				lastCheckCol   = new TableColumn('LastCheck', bundle['opcenterTabLaskCheck'], false)
				lastEscalation = new TableColumn('LastEscalation', bundle['opcenterTabLastEsca'], true)
				durationCol    = new TableColumn('Duration', bundle['opcenterTabDuration'], true)
				stateCol       = new TableColumn('State', bundle['opcenterTabState'], false)
				statusInfoCol  = new TableColumn('StatusInfo', bundle['opcenterTabStatusInf'], false)
       
    }
    protected void init() {
        setJSONMethods(['updateDashboard']) 
    }

    private getIconUrl(String img, String title) {
        def imgUrl = urlFor(asset:'images') + "/" + img

        """<img src="/${imgUrl}" title="${title}">"""
    }

	/**
	 * Method to batch load the platform resource map
	 */
	private initPlatformMap() {
		StopWatch watch = new StopWatch()
		
        watch.markTimeBegin("getAllPlatformDescendentEdges")
		def edges = OpCenterDAO.getAllPlatformDescendentEdges()
		watch.markTimeEnd("getAllPlatformDescendentEdges")
		
		watch.markTimeBegin("populateMap")
		edges.each { child ->
			def parentId = child.from.id
			if (!_platformMap[parentId]) {
				_resToPlatformMap[parentId] = parentId
        		_platformMap[parentId] = child.from					
			}
			_resToPlatformMap[child.to.id] = parentId				
		}
		watch.markTimeEnd("populateMap")
		
		log.info("initPlatformMap[edges=" + edges.size() 
					+ ", _resToPlatformMap=" + _resToPlatformMap.size() 
					+ ", _platformMap=" + _platformMap.size()
					+ "]: " + watch)
	}
	
    /**
     * Method to get the platform Resource for the given Resource, pulling it
     * from the cache if found.
     */
    private getPlatform(resource) {
    	if (_resToPlatformMap.isEmpty()) {
            initPlatformMap()		
    	}
 
        def platId = _resToPlatformMap[resource.id]
        if (!platId) {
         	StopWatch watch = new StopWatch()
         	
            def platResource = resource.platform
            platId = platResource.id
            _resToPlatformMap[resource.id] = platId
            _platformMap[platId] = platResource           
            
            watch.markTimeBegin("findResourceEdges")
       		def children = resourceHelper.findResourceEdges(AuthzConstants.ResourceEdgeContainmentRelation, platResource)
       		watch.markTimeEnd("findResourceEdges")
			
			children.each { child ->
				_resToPlatformMap[child.to.id] = platId
			}
			
			log.info("getPlatform[fromResourceId=" + platId 
						+ ", resourceEdges=" + children.size()
						+ "]: " + watch)
        }

        return _platformMap[platId]
    }
    
    // TODO: Should try to migrate this to the OpCenterDAO
    private canTakeAction(resource) {
        def appdefRes
        
        if (resource.isInAsyncDeleteState()) {
            return false
        }
        
        try {
            alertPermissionMan.canFixAcknowledgeAlerts(user, AppdefUtil.newAppdefEntityId(resource))
			
			return true
        } catch(PermissionException e) {
            return false
        }
    }
    
    private getUnfixedAlerts(params, typefilter, start, summaryData) {
        def res = getUnfixedClassicAlerts(params, typefilter, start, summaryData)
        res.addAll(getUnfixedGroupAlerts(params, typefilter, start, summaryData))
    
    	return res    
	}
    
    private getUnfixedClassicAlerts(params, typefilter, start, summaryData) {
        StopWatch watch = new StopWatch()
        def groupId = params.getOne('groupFilter')?.toInteger()
        def groupFilter = (groupId != -1) ? groupId : null
        def platformFilter = params.getOne('platformFilter')
        def inEscLow = 0, inEscMed = 0, inEscHigh = 0;
        def unfixedLow = 0, unfixedMed = 0, unfixedHigh = 0;
 
		def res = []
		def unfixed = null
        def unfixedInEsc = []
        Map groupedUnfixed = [:]
        Map groupedUnfixedInEsc = [:]
        
        if (!platformFilter || platformFilter.size() == 0) {
        	platformFilter = null
        }

        if (typefilter == TYPEFILTER_ALERTSESC) {
        	watch.markTimeBegin("findAlertsInEsc")
        	unfixed = alertHelper.findAlerts(AlertSeverity.LOW, start, start, 
                   							 true, true, groupFilter,
                   							 PageInfo.getAll(AlertSortField.DATE, false))
            watch.markTimeEnd("findAlertsInEsc")
        	
        	groupedUnfixed = unfixed.groupBy { it.definition.id }
        	groupedUnfixedInEsc = groupedUnfixed
        } else {
        	watch.markTimeBegin("findAlertsAll")
        	unfixed = alertHelper.findAlerts(AlertSeverity.LOW, start, start, 
                   							 false, true, groupFilter,
                   							 PageInfo.getAll(AlertSortField.DATE, false))
            watch.markTimeEnd("findAlertsAll")
                        
            // need to get alerts in escalation in batch for quick lookup later
        	watch.markTimeBegin("findAlertsInEsc")
            unfixedInEsc = alertHelper.findAlerts(AlertSeverity.LOW, start, start, 
                   								  true, true, groupFilter,
                   								  PageInfo.getAll(AlertSortField.DATE, false))
            watch.markTimeEnd("findAlertsInEsc")
                        
            if (typefilter == TYPEFILTER_ALERTSNOESC) {
            	// TODO: there is no api to get alerts with no escalation, so we
            	// will need to get all alerts and subtract alerts in escalation
        		unfixed.removeAll(unfixedInEsc)
        	} else {
        		groupedUnfixedInEsc = unfixedInEsc.groupBy { it.definition.id }
        	}
        	
        	groupedUnfixed = unfixed.groupBy { it.definition.id }
        }
                        
		watch.markTimeBegin("populateResult")
        for (alerts in groupedUnfixed.values()) {
            def alert = alerts.get(0)
            def result = [:]
            def definition = alert.definition
            def resource = definition?.resource

            // [HQ-3740] Force initialization to avoid stale session exceptions
            if (!Hibernate.isInitialized(resource)) {
                Hibernate.initialize(resource)
            }

            // Check if alert definition has been removed
            if (resource) {
            	def plat = getPlatform(resource)
                
               	// Filter by platform, if given.
               	if (platformFilter) {
            		if (!plat?.name?.contains(platformFilter)) {
            			continue
            		}
        		}
        
                result["Platform"] = plat
                result["Resource"] = resource
                result["Alert"] = alert
                result["Priority"] = definition.priority
                result["StatusType"] = "Alert"
                result["Duration"]   = System.currentTimeMillis() - alert.getCtime()
                result["StatusInfo"] = new StringBuffer()
                result["StatusInfo"] << alerts.size() + " occurrences. "
                result["LastCheck"] = alert.ctime

                // States
                result["State"] = new StringBuffer()

                // Counts
                if (groupedUnfixedInEsc.containsKey(definition.id)) {
                    if (definition.priority == EventConstants.PRIORITY_LOW) {
                        inEscLow++
                    } else if (definition.priority == EventConstants.PRIORITY_MEDIUM) {
                        inEscMed++
                    } else if (definition.priority == EventConstants.PRIORITY_HIGH) {
                        inEscHigh++
                    }
                }

                if (definition.priority == EventConstants.PRIORITY_LOW) {
                    unfixedLow++
                } else if (definition.priority == EventConstants.PRIORITY_MEDIUM) {
                    unfixedMed++
                } else if (definition.priority == EventConstants.PRIORITY_HIGH) {
                    unfixedHigh++
                }

                res << result
            }
        }
        watch.markTimeEnd("populateResult")

        summaryData["AlertsUnfixedLow"] = unfixedLow
        summaryData["AlertsUnfixedMed"] = unfixedMed
        summaryData["AlertsUnfixedHigh"] = unfixedHigh
        summaryData["AlertsUnfixed"] = unfixedLow + unfixedMed + unfixedHigh
        summaryData["AlertsInEscLow"] = inEscLow
        summaryData["AlertsInEscMed"] = inEscMed
        summaryData["AlertsInEscHigh"] = inEscHigh
        summaryData["AlertsInEsc"] = inEscLow + inEscMed + inEscHigh

        log.info("getUnfixedClassicAlerts[unfixedAlerts=" + unfixed.size()
        			+ ", unfixedAlertsInEsc=" + unfixedInEsc.size()
            		+ ", unfixedAlertDefinitions=" + groupedUnfixed.size()
            		+ ", unfixedAlertDefinitionsInEsc=" + groupedUnfixedInEsc.size()
            		+ ", filteredResult=" + res.size()
            		+ "]: " + watch)	
        	    
	    return res
    }

    private getUnfixedGroupAlerts(params, typefilter, start, summaryData) {
		def res = []
        def platformFilter = params.getOne('platformFilter')

		if (platformFilter && platformFilter.size() > 0) {
        	// groups have no platforms so no need to process further
        	return res
        }
        
        StopWatch watch = new StopWatch()
        def groupId = params.getOne('groupFilter')?.toInteger()
        def groupFilter = (groupId != -1) ? groupId : null
        def inEscLow = 0, inEscMed = 0, inEscHigh = 0;
        def unfixedLow = 0, unfixedMed = 0, unfixedHigh = 0;
 
		def unfixed = null
        def unfixedInEsc = []
        Map groupedUnfixed = [:]
        Map groupedUnfixedInEsc = [:]

        if (typefilter == TYPEFILTER_ALERTSESC) {
            watch.markTimeBegin("findGroupAlertsInEsc")
        	unfixed = alertHelper.findGroupAlerts(AlertSeverity.LOW, start, start, true,
                                        		  true, groupFilter,
                                        		  PageInfo.getAll(GalertLogSortField.SEVERITY, false))
            watch.markTimeEnd("findGroupAlertsInEsc")
        	
        	groupedUnfixed = unfixed.groupBy { it.alertDef.id }
        	groupedUnfixedInEsc = groupedUnfixed
        } else {
            watch.markTimeBegin("findGroupAlertsAll")	        
            unfixed = alertHelper.findGroupAlerts(AlertSeverity.LOW, start, start, false,
                                        		  true, groupFilter,
                                        		  PageInfo.getAll(GalertLogSortField.SEVERITY, false))
            watch.markTimeEnd("findGroupAlertsAll")
            
            // need to get group alerts in escalation in batch for quick lookup later
        	watch.markTimeBegin("findGroupAlertsInEsc")            
            unfixedInEsc = alertHelper.findGroupAlerts(AlertSeverity.LOW, start, start, true,
                                        true, groupFilter,
                                        PageInfo.getAll(GalertLogSortField.SEVERITY, false))
            watch.markTimeEnd("findGroupAlertsInEsc")
           	            
            if (typefilter == TYPEFILTER_ALERTSNOESC) {
            	// TODO: there is no api to get alerts with no escalation, so we
            	// will need to get all alerts and subtract alerts in escalation
        		unfixed.removeAll(unfixedInEsc)
        	} else {
        		groupedUnfixedInEsc = unfixedInEsc.groupBy { it.alertDef.id }
        	}
        	
        	groupedUnfixed = unfixed.groupBy { it.alertDef.id }
        }
                
		watch.markTimeBegin("populateResult")
        for (galerts in groupedUnfixed.values()) {
            def galert = galerts.get(0)

            def result = [:]
            def definition = galert.alertDef
            result["Group"] = definition.group
            result["GroupAlert"] = galert
            result["Priority"] = definition.severityEnum
            result["StatusType"] = "Alert"
            result["Duration"]   = System.currentTimeMillis() - galert.timestamp
            result["StatusInfo"] = new StringBuffer()
            result["StatusInfo"] << galerts.size() + " occurrences. "
            result["StatusInfo"] << galert.longReason + ". "
            result["State"] = new StringBuffer()
            result["LastCheck"] = galert.timestamp

            switch (definition.severityEnum) {
                case 1:
                    unfixedLow++
                    if (groupedUnfixedInEsc.containsKey(definition.id)) {
                        inEscLow++
                    }
                    break;
                case 2:
                    unfixedMed++
                    if (groupedUnfixedInEsc.containsKey(definition.id)) {
                        inEscMed++
                    }
                    break;
                case 3:
                    unfixedHigh++
                    if (groupedUnfixedInEsc.containsKey(definition.id)) {
                        inEscHigh++
                    }
                    break;
            }

            res << result
        }
        watch.markTimeEnd("populateResult")
        
        summaryData["AlertsUnfixedLow"] += unfixedLow
        summaryData["AlertsUnfixedMed"] += unfixedMed
        summaryData["AlertsUnfixedHigh"] += unfixedHigh
        summaryData["AlertsUnfixed"] += unfixedLow + unfixedMed + unfixedHigh
        summaryData["AlertsInEscLow"] += inEscLow
        summaryData["AlertsInEscMed"] += inEscMed
        summaryData["AlertsInEscHigh"] += inEscHigh
        summaryData["AlertsInEsc"] += inEscLow + inEscMed + inEscHigh

        log.info("getUnfixedGroupAlerts[unfixedAlerts=" + unfixed.size()
        			+ ", unfixedAlertsInEsc=" + unfixedInEsc.size()
            		+ ", unfixedAlertDefinitions=" + groupedUnfixed.size()
            		+ ", unfixedAlertDefinitionsInEsc=" + groupedUnfixedInEsc.size()
            		+ ", filteredResult=" + res.size()
            		+ "]: " + watch)	

        return res
    }

    private getDownResources(params, summaryData) {
        StopWatch watch = new StopWatch()
        def platformFilter = params.getOne('platformFilter')
        def groupId = params.getOne('groupFilter')?.toInteger()

        def groupMemberIds = null
        if (groupId != null && groupId > 0) {
            def group = resourceHelper.findGroup(groupId)
            if (group) {
                groupMemberIds = group.resources*.id
            }
        }

        if (!platformFilter || platformFilter.size() == 0) {
        	platformFilter = null
        }
        
        def res = []
        def downPlatforms = 0
        def downRes = 0
        long start = System.currentTimeMillis()
        
        watch.markTimeBegin("getDownResources")
        def downResources = resourceHelper.
                getDownResources(null, PageInfo.getAll(DownResSortField.DOWNTIME, true))
        watch.markTimeEnd("getDownResources")
        
        watch.markTimeBegin("populateResult")
        for (it in downResources) {
            def resource = it.resource.resource

            if (groupMemberIds && !groupMemberIds.contains(resource.id)) {
                log.debug("Skipping resource " + resource.id +
                          ", not in group " + groupId)
            } else {
            	def plat = getPlatform(resource)
                
               	// Filter by platform, if given.
               	if (platformFilter) {
            		if (!plat?.name?.contains(platformFilter)) {
            			continue
            		}
        		}

                downRes++
                if (resource.isPlatform()) {
                    downPlatforms++
                }

                def result = [:]
                result["Platform"] = plat
                result["Resource"] = resource
                result["Priority"] = 3
                result["StatusType"] = "Resource Down"
                result["Duration"] = it?.duration
                result["StatusInfo"] = new StringBuffer()                
                res << result
            }
        }
        watch.markTimeEnd("populateResult")

        summaryData.put("DownResources", downRes)
        summaryData.put("DownPlatforms", downPlatforms)

        log.info("getDownResources[downResources=" + downResources.size()
            		+ ", filteredResult=" + res.size()
            		+ "]: " + watch)

        res
    }

    protected sortAndPage(res, PageInfo pInfo) {
        if (res.size() == 0) {
            return res
        }

        def d = pInfo.sort.description
		
		if (!Hibernate.isInitialized(res)) {
			Hibernate.initialize(res)
		}
        
        def rman = Bootstrap.getBean(ResourceManager.class)
        res = res.sort {a, b ->
            def col1 = a."${d}"
            def col2 = b."${d}"
			
            if (col1 instanceof Resource && col1.id != null) {
                col1= rman.getResourceById(col1.id)
            } else if(col1 != null) {
                col1= rman.getResourceById(col1.resource.id)
            }

            if (col2 instanceof Resource && col2.id != null) {
                col2 = rman.getResourceById(col2.id)
            } else if(col2 != null) {
                col2 = rman.getResourceById(col2.resource.id)
            }

            if (!Hibernate.isInitialized(col1)) {
                Hibernate.initialize(col1)
            }
            if (!Hibernate.isInitialized(col2)) {
                Hibernate.initialize(col2)
            }

            // Alerts are a special case bc we also need to compare Group Alerts
            if (d.equals("Alert")) {
                if (col1 == null) {
                    col1 = a.GroupAlert
                }
                
                if (col2 == null) {
                    col2 = b.GroupAlert
                }
            }
            
            if (col1 instanceof Resource) {
                return col1?.name <=> col2?.name
            } else if (col1 instanceof Alert) {
                if (col2 instanceof Alert) {
                    return col1.definition.name <=> col2.definition.name
                } else if (col2 instanceof GalertLog) {
                    return col1.definition.name <=> col2.alertDef.name
                }
            } else if (col1 instanceof GalertLog) {
                if (col2 instanceof Alert) {
                    return col1.alertDef.name <=> col2.definition.name
                } else if (col2 instanceof GalertLog) {
                    return col1.alertDef.name <=> col2.alertDef.name
                }
            } 
            return col1 <=> col2
        }

        // Now sort
        if (!pInfo.ascending)
            res = res.reverse()

        def startIdx = pInfo.startRow
        def endIdx   = startIdx + pInfo.pageSize
        if (endIdx >= res.size)
            endIdx = -1

        return res[startIdx..endIdx]
    }

    private getSuiteData(PageInfo pInfo, params) {
        double pageSize = params.getOne('pageSize')?.toDouble()
        def typeFilter = params.getOne('typeFilter')?.toInteger()

        def res = []
       	def summaryData = [:]
        def start = System.currentTimeMillis()
        if (typeFilter == TYPEFILTER_ALL || typeFilter == TYPEFILTER_DOWN) {
            res.addAll(getDownResources(params, summaryData))
        }

        if (typeFilter != TYPEFILTER_DOWN) {
            res.addAll(getUnfixedAlerts(params, typeFilter, start, summaryData))
        }

        if (res.size() == 0) {
            return res
        }
        // We'll always have at least 1 page.
        def numPages = Math.max(1, (Integer)Math.ceil(res.size() / pageSize))

        summaryData["FetchTime"] = System.currentTimeMillis() - start
        summaryData["LastUpdated"] = System.currentTimeMillis()
        summaryData["TotalRows"] = res.size()
        summaryData["NumPages"] = numPages
        def sortedAndPaged = sortAndPage(res, pInfo)
        // After sort/page, add info that is more expensive to gather and is
        // not sortable.
        sortedAndPaged.each {
            def resource = it["Resource"]
            if (resource) {
                def lastLog = OpCenterDAO.getLastLog(resource)
                if (lastLog) {
                    it["StatusInfo"] << "Last event: " + lastLog.detail
                }

                def availMetric = it.Resource.getAvailabilityMeasurement()
                if (availMetric == null) {
                    log.error("No availability metric found for: " + it.Resource.name)
                } else {
                    def last = getLastDataPoint(availMetric)
                    it["LastCheck"] = last.timestamp
                }
            }          
            def alert = it["Alert"]
            if (alert) {
                def reason = alertMan.getLongReason(alert)
                it["StatusInfo"] << reason + ". "
                it["EscalationState"] = escMan.findEscalationState(alert.definition)
                
                if (canTakeAction(it["Resource"])) {
                    it["canTakeAction"] = true;
                } else {
                    it["canTakeAction"] = false;
                }

                def lastCheck = 0
                for (condition in alert.definition.conditions) {
                    int condType = condition.type
                    // Search conditions that have measurement ids.
                    if (condType == 1 || condType == 2 || condType == 4) {
                        def condMetric = metricHelper.findMeasurementById(condition.measurementId)
                        def last = getLastDataPoint(condMetric)
                        if (last && last.timestamp > lastCheck) {
                            lastCheck = last.timestamp
                            it["StatusInfo"] << " Current value = " +
                                condMetric.template.renderWithUnits(last.value) + ". "
                        }
                    }
                }

                // Fall back to last alert evaluation if no metric check is
                // available.
                if (lastCheck == 0) {
                    lastCheck = alert.ctime
                }
                it["LastCheck"] = lastCheck

            } else if (it["GroupAlert"]) {
                alert = it["GroupAlert"]
                it["EscalationState"] = escMan.findEscalationState(alert.alertDef)
                
                if (canTakeAction(alert.alertDef.resource)) {
            		it["canTakeAction"] = true;
            	} else {
            		it["canTakeAction"] = false;
            	}
            }

            def escState = it["EscalationState"]
            if (escState != null) {
                def esc = escState.escalation

                it["State"] << getIconUrl("notify.gif", bundle['opcenterInEscalation']+": " + esc.name)

                // TODO: There must be a better way to get this..
                def actionLogs = alert.getActionLog().asList()
                def lastLog = actionLogs.get(actionLogs.size() - 1)
                it["LastEscalation"] = lastLog.timeStamp
                it["StatusInfo"] << "Last action: " + lastLog.detail + ". "

                long next = escState.nextActionTime
                if (next != Long.MAX_VALUE) {
                    it["StatusInfo"] << "Next escalation at " +
                        DF.format(new Date(escState.nextActionTime)) + ". "
                }

                def acked = escState.getAcknowledgedBy()
                if (acked) {
					def theDetail = lastLog.detail
					
					if(theDetail.endsWith("acknowledged the alert")){
						def ackLocale=bundle['acknowledgedTheAlert']
						theDetail = theDetail.replaceAll("acknowledged the alert",ackLocale);
					}
                    def ackedBy = DF.format(lastLog.timeStamp) +
                                  ": " + theDetail + ". "
                    it["State"] << getIconUrl("ack.gif", ackedBy)
                }
            }                    
        }
        
        // TODO: this should not be a global variable. for now, set it
        // at the very last moment to minimize threading issues
        _summaryData.putAll(summaryData)
        
        def startIdx = pInfo.startRow
        def endIdx   = startIdx + pInfo.pageSize
        if (endIdx >= res.size())
            endIdx = -1
        else
            endIdx -= 1

        return res[startIdx..endIdx]
    }

    private getLastDataPoint(metric) {
        // We use this method, because because MetricCategory.getlastDataPoint() defaulted
        // to using the entire time range (from time t=0) instead of using the sentinal
        // value of -1.  This has been fixed in MetricCategory.groovy, and eventually this
        // method should be removed.
        metric.getLastDataPoint(-1)
    }


    public getDashboardSchema() {
        def selectCol      = new TableColumn('Select', '<input type="checkbox" id="dashboardTable_CheckAllBox" onclick="MyAlertCenter.toggleAll(this)" />', false)
        

        def globalId = 0
        [
            getData: {pageInfo, params ->
                getSuiteData(pageInfo, params)
            },
            defaultSort: platformCol,
            defaultSortOrder: 1,
            styleClass: {
                if (!it.Priority) {
                    return "OpStyleGreen"
                } else if (it.Priority.equals(1)) {
                    return "OpStyleYellow"
                } else if (it.Priority.equals(2)) {
                    return "OpStyleOrange"
                } else if (it.Priority.equals(3)) {
                    if (it.StatusType == "Resource Down") {
                        return "OpStyleGray"
                    } else {
                        return "OpStyleRed"
                    }
                } else {
                    return ""
                }
            },
            rowId: {globalId++},
            columns: [
                [field: selectCol,
                 width:'3%',
                 label: {
                     if (it.canTakeAction) {
                         if (it.Alert) {
                            def esc = it.Alert.definition.escalation
                            def pause = (esc == null ? "0" : (esc.pauseAllowed ? esc.maxPauseTime : "0"))
                            // checkbox id is in the format: {portalName}|{appdefKey}|{alertId}|{maxPauseTime}
                            def id = "dashboardTable|" + it.Alert.alertDefinition.appdefEntityId.appdefKey + "|" + it.Alert.id + "|" + pause
                            def member = (it.Alert.ackable ? "ackableAlert" : "fixableAlert")
                            return "<input type='checkbox' name='ealerts' id='" + id + "' class='" + member + "' value='-559038737:" + it.Alert.id +"' onclick='MyAlertCenter.toggleAlertButtons(this)' />"
                         } else if (it.GroupAlert) {
                            def esc = it.GroupAlert.definition.escalation
                            def pause = (esc == null ? "0" : (esc.pauseAllowed ? esc.maxPauseTime : "0"))
                            // checkbox id is in the format: {portalName}|{appdefKey}|{alertId}|{maxPauseTime}
                            def id = "dashboardTable|" + it.GroupAlert.alertDef.appdefID.appdefKey + "|" + it.GroupAlert.id + "|" + pause
                            def member = (it.GroupAlert.acknowledgeable ? "ackableAlert" : "fixableAlert")
                            return it.fixed ? "" : "<input type='checkbox' name='ealerts' id='" + id + "' class='" + member + "' value='195934910:" + it.GroupAlert.id +"' onclick='MyAlertCenter.toggleAlertButtons(this)' />"
                         }  
                     } else {
                         return ""
                     }
                 }],  
                [field:  platformCol,
                 width:  '15%',
                 nowrap: false,
                 label:  {
                     if (it.Platform) {
                        return "<a href=\"${it.Platform.urlFor(null)}\" target=\"_blank\">${StringEscapeUtils.escapeHtml(it.Platform.name)}</a>"
                     } else {
                        return ""
                     }
                 }],
                [field:  resourceCol,
                 width:  '15%',
                 nowrap: false,
                 label:  {
                     if (it.Resource) {
                         return "<a href=\"${it.Resource.urlFor(null)}\" target=\"_blank\">${StringEscapeUtils.escapeHtml(it.Resource.name)}</a>"
                     } else if (it.Group) {
                         return "<a href=\"${it.Group.urlFor(null)}\" target=\"_blank\">${StringEscapeUtils.escapeHtml(it.Group.resource.name)}</a>"
                     } else {
                         return ""
                     }
                 }],
                [field:  alertCol,
                 width:  '10%',
                 nowrap: false,
                 label:  {
                     if (it.Alert) {
                         return "<div style=\"display:none;\">${StringEscapeUtils.escapeHtml(it.Alert.alertDefinition.name)}</div><a href=\"${it.Alert.urlFor(null)}\" target=\"_blank\">${StringEscapeUtils.escapeHtml(it.Alert.alertDefinition.name)}</a>"
                     } else if (it.GroupAlert) {
                         return "<div style=\"display:none;\">${StringEscapeUtils.escapeHtml(it.GroupAlert.alertDef.name)}</div><a href=\"${it.GroupAlert.urlFor(null)}\" target=\"_blank\">${StringEscapeUtils.escapeHtml(it.GroupAlert.alertDef.name)}</a>" 
                     } else {
                         return ""
                     }
                 }],
                [field:  priorityCol,
                 width:  '3%',
                 nowrap: false,
                 label:  {
                     if (it.Priority) {
                         return "<div style=\"text-align:center\">${PRIORITIES[it.Priority]}</div>"
                     } else {
                         return ""
                     }
                 }],
                [field:  statusTypeCol,
                 width:  '5%',
                 nowrap: false,
                 label:  { it.StatusType }],                
                [field:  lastEscalation,
                 width:  '6%',
                 nowrap: false,
                 label:  { it.LastEscalation ? DF.format(new Date(it.LastEscalation)) : ""}],
                [field:  lastCheckCol,
                 width:  '6%',
                 nowrap: false,
                 label:  { it.LastCheck ? DF.format(new Date(it.LastCheck)) : ""}],
                [field:  durationCol,
                 width:  '5%',
                 nowrap: false,
                 label:  { it.Duration ? "<div style=\"display:none;\">"+String.format("%014d", it.Duration)+"</div>"+StringUtil.formatDuration(it.Duration) : ""}],
                [field:  stateCol,
                 width:  '5%',
                 nowrap: false,
                 label:  { it.State }],
                [field:  statusInfoCol,
                 width:  '30%',
                 nowrap: false,
                 label:  { it.StatusInfo }]
            ],
        ]
    }

    def index(params) {
        def groups = resourceHelper.findViewableGroups().sort { p1, p2 -> p1.name.compareToIgnoreCase(p2.name) }

        render(locals:[ groups: groups,
                        DASHBOARD_SCHEMA : getDashboardSchema() ])
    }

    def updateDashboard(params) {
        log.info("Updating dashboard data " + params)
        def start = System.currentTimeMillis();
        try {
            JSONObject json = DojoUtil.processTableRequest(getDashboardSchema(), params)
            log.info("Gathered dashboard data in " + (System.currentTimeMillis() - start) + " ms")
            log.info("Summary Data=" + _summaryData)
            JSONObject summary = new JSONObject(_summaryData)
            json.append("summaryinfo", summary)
            json
        } catch (Exception e) {  
            // [HQ-3795] We need to catch any exceptions to avoid user seeing a blank screen
            // Present a fake table with a message in the Status column
            // This isn't the prettiest in the world but succeeds in providing user with feedback.
            log.error("Error Updating Dashboard: " + e);
            JSONArray jsonData = new JSONArray()
            jsonData.put([StatusInfo : "An exception occured while processing this page"])
            [data : jsonData] as JSONObject
        }
    }
}
