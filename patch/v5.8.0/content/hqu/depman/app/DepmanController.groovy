import org.hyperic.hq.hqu.rendit.BaseController
import org.hyperic.hq.authz.server.session.Resource
import org.hyperic.hq.authz.server.session.ResourceManagerImpl
import org.hyperic.hq.authz.shared.ResourceEdgeCreateException
import org.hyperic.hq.context.Bootstrap;
import org.hyperic.hq.authz.shared.AuthzConstants
import org.hyperic.hq.authz.shared.ResourceManager;
import org.hyperic.hq.product.PlatformDetector
import org.hyperic.hq.appdef.shared.PlatformManager;
import org.hyperic.hq.appdef.server.session.PlatformManagerImpl
import org.hyperic.hq.appdef.server.session.Platform
import org.hyperic.hq.appdef.shared.AppdefEntityConstants
import org.hyperic.hq.appdef.shared.AppdefEntityID
import org.hyperic.hq.authz.shared.PermissionException
import org.json.JSONObject
import org.json.JSONArray
import java.util.Random


class DepmanController extends BaseController
{
	public static final String SHOW_PARAM_NAME = "show"
	public static final String TYPE_PARAM_NAME = "typeId"
	public static final String NAME_PARAM_NAME = "name"
	public static final String PARENT_PARAM_NAME = "parentId"
	public static final String PLATFORM_PARAM_NAME = "platformId"
	public static final String SHOW_FILTER_ALL = ""
	public static final String SHOW_FILTER_WITH_DEPENDENCIES = "withdeps"
	public static final String SHOW_FILTER_WITHOUT_DEPENDENCIES = "wodeps"
	public static final Boolean ALL_PLATFORMS = null
	public static final Boolean PLATFORMS_WITH_DEPENDENCIES = Boolean.TRUE
	public static final Boolean PLATFORMS_WITHOUT_DEPENDENCIES = Boolean.FALSE
	
    protected void init() {
        onlyAllowSuperUsers()
    }
    
    def index(params) {
        // By default, this sends views/depman/index.gsp to
        // the browser, providing 'plugin' and 'userName' locals to it
        //
        // The name of the currently-executed action dictates which .gsp file 
        // to render (in this case, index.gsp).
        //
        // If you want to render AJAX, read RenderFrame.groovy for parameters
        // or return a Map from this method and in init(), call:
        //     setJSONMethods(['myJSONMethod', 'anotherJSONMethod'])
    	render(locals:[ plugin :  getPlugin(),
    	                userName: user.name,
    	                availablePlatformTypes: getAvailablePlatformTypes(),
    	                topLevelPlatformTypes: getTopLevelPlatformTypes()])  
    }

    def getAvailablePlatformTypes() {
    	def platformTypes = Bootstrap.getBean(PlatformManager.class).findSupportedPlatformTypes()
    	
    	platformTypes.sort {a, b -> a.name <=> b.name}
    }
    
    def getTopLevelPlatformTypes() {
    	def platformTypes = Bootstrap.getBean(PlatformManager.class).findUnsupportedPlatformTypes()
    	
    	platformTypes.sort {a, b -> a.name <=> b.name}
    }
    
    def getTopLevelPlatformsData(params) {
    	def showParam = params.getOne(SHOW_PARAM_NAME, SHOW_FILTER_ALL)
    	def typeParam = params.getOne(TYPE_PARAM_NAME, "")
    	def nameParam = params.getOne(NAME_PARAM_NAME, "")
    	
    	// Setup "show" filter
    	def showFilter = ALL_PLATFORMS
    	
    	if (showParam == SHOW_FILTER_WITH_DEPENDENCIES) {
    		showFilter = PLATFORMS_WITH_DEPENDENCIES
    	} else if (showParam == SHOW_FILTER_WITHOUT_DEPENDENCIES) {
    		showFilter = PLATFORMS_WITHOUT_DEPENDENCIES
    	}
    	
    	// Setup platform type filter
    	def typeFilter = []
    	
    	getTopLevelPlatformTypes().each { pType ->
    		if (typeParam == "" || typeParam == (pType.id + "")) {
    			typeFilter << pType
    		}
    	}
    	
    	// Setup partial name filter
    	def nameFilter = ""
    	
    	if (nameParam != "") {
    		nameFilter = nameParam
    	}
    	
    	resourceHelper.findParentPlatformsByNetworkRelation(typeFilter.collect { pType -> pType.id }, nameFilter, showFilter)
    }
   
    def getAllAvailablePlatformsData(params) {
    	def typeParam = params.getOne(TYPE_PARAM_NAME, "")
    	def nameParam = params.getOne(NAME_PARAM_NAME, "")
  	
    	// Setup platform type filter
    	def typeFilter = []
    	
    	getAvailablePlatformTypes().each { pType ->
    		if (typeParam == "" || typeParam == (pType.id + "")) {
    			typeFilter << pType
    		}
    	}
    	
    	// Setup partial name filter
    	def nameFilter = ""
    	
    	if (nameParam != "") {
    		nameFilter = nameParam
    	}
    	
    	resourceHelper.findPlatformsByNoNetworkRelation(typeFilter.collect { pType -> pType.id }, nameFilter)
    }
    
    def getDependentPlatformsData(params) {
    	def parentPlatformId = params.getOne(PARENT_PARAM_NAME)?.toInteger()
    	   	    	
    	def resource = Bootstrap.getBean(ResourceManager.class).findResource(new AppdefEntityID(AppdefEntityConstants.APPDEF_TYPE_PLATFORM + ":" + parentPlatformId))
    	def children = resourceHelper.findResourceEdges(AuthzConstants.ResourceEdgeNetworkRelation, resource)
    	
    	children.collect { resourceEdge ->
    		resourceEdge.to
    	}
    }
    
    def getAllDependentPlatformsData(params) {
    	def typeParam = params.getOne(TYPE_PARAM_NAME, "")
    	def nameParam = params.getOne(NAME_PARAM_NAME, "")
  	
    	// Setup platform type filter
    	def typeFilter = []
    	
    	getAvailablePlatformTypes().each { pType ->
    		if (typeParam == "" || typeParam == (pType.id + "")) {
    			typeFilter << pType
    		}
    	}
    	
    	// Setup partial name filter
    	def nameFilter = ""
    	
    	if (nameParam != "") {
    		nameFilter = nameParam
    	}
    	
    	resourceHelper.findResourceEdges(AuthzConstants.ResourceEdgeNetworkRelation, 
    									 typeFilter.collect { pType -> new Integer(pType.id) }, 
    									 nameFilter)
    }
    
    def serializePlatform(platform) {
    	[ name : platform.name, 
          description: platform.description, 
          id : platform.id,
          type : platform.platformType.name]
    }
    
    def serializeResource(resource) {
    	[ name : resource.name, 
          id : resource.instanceId,
          type : resource.prototype.name]
    }

    def serializePlatformWithDependencies(platform, dependencies) {
    	[ name : platform.name, 
          description: platform.description, 
          id : platform.id,
          type : platform.platformType.name,
          deps : dependencies]
    }

    def loadTopLevelPlatforms(params) {
    	// Get All Filtered Platforms
       	def items = new JSONArray()
       	def state = "SUCCESS"
        def userMsg = ""
        	
        try {
        	getTopLevelPlatformsData(params).each { platform ->
	        	items.put(new JSONObject(serializePlatform(platform)))
	        }
	    	
	    	if (items.length() == 0) {
	    		userMsg = localeBundle.noPlatformsFound
	    	}
        } catch(Exception e) {
        	state = "ERR"
        	userMsg = localeBundle.errorRetrievingPlatforms
        }
    	
    	def json = new JSONObject([ code : state, msg : userMsg, items : items])

    	render(inline : "${json}", contentType : "text/json")
    }

    def loadAvailablePlatforms(params) {
    	def items = new JSONArray()
    	def state = "SUCCESS"
        def userMsg = ""
        	
        try {
        	getAllAvailablePlatformsData(params).each { platform ->
	        	items.put(new JSONObject(serializePlatform(platform)))
	        }
	    	
	    	if (items.length() == 0) {
	    		userMsg = localeBundle.noPlatformsFound
	    	}
        } catch(Exception e) {
        	state = "ERR"
            userMsg = localeBundle.errorRetrievingPlatforms
        }
        
    	def json = new JSONObject([ code : state, msg : userMsg, items : items])
    	
    	render(inline : "${json}", contentType : "text/json")
    }

    def loadDependentPlatforms(params) {
    	def items = new JSONArray()
    	def state = "SUCCESS"
    	def userMsg = ""
    	
    	try {
    		getDependentPlatformsData(params).each { platform ->
	    		items.put(new JSONObject(serializeResource(platform)))
	        }
	    	
	    	
	    	if (items.length() == 0) {
	    		userMsg = localeBundle.noDependentPlatformsFound
	    	}
    	} catch(Exception e) {
        	state = "ERR"
            userMsg = localeBundle.errorRetrievingPlatforms
    	}
    	
    	def json = new JSONObject([ code : state, msg : userMsg, items : items])
    	
    	render(inline : "${json}", contentType : "text/json")
    }
    
    def loadAllDependentPlatforms(params) {
    	def items = new JSONArray()
    	def state = "SUCCESS"
    	def userMsg = ""
    	
    	try {
    		getAllDependentPlatformsData(params).each { resourceEdge ->
	    		def parent = new JSONObject([name : resourceEdge.from.name, id : resourceEdge.from.id])
	    		def child = new JSONObject([name : resourceEdge.to.name, id : resourceEdge.to.id])
	    		
	    		items.put(new JSONObject([ "parent" : parent, "child" : child]))
	    	}
	    	
	    	if (items.length() == 0) {
	    		userMsg = localeBundle.noPlatformsFound
	    	}
    	} catch(Exception e) {
        	state = "ERR"
            userMsg = localeBundle.errorRetrievingPlatforms
    	}
    	
    	def json = new JSONObject([ code : state, msg : userMsg, items : items])
    		
    	render(inline : "${json}", contentType : "text/json")
    }
    
    def addDependentPlatforms(params) {
    	def state = "SUCCESS"
        def userMsg = ""
        	
    	try {
	    	def parentId = params.getOne(PARENT_PARAM_NAME)
	    	def platformIds = params.get(PLATFORM_PARAM_NAME)
	    	def parentResourceId = new Integer(parentId)
	    	def childResourceIds = platformIds.collect { id ->
	    		new Integer(id)
	    	}
	    	
	    	def parentAppdef = new AppdefEntityID(AppdefEntityConstants.APPDEF_TYPE_PLATFORM + ":" + parentResourceId)
	    	def childAppdefs = []
	    		
	    	childResourceIds.each { id ->
	    		def appdef = new AppdefEntityID(AppdefEntityConstants.APPDEF_TYPE_PLATFORM + ":" + id)
	    		
	    		if (parentAppdef != appdef) {
	    			childAppdefs << appdef
	    		}    		
	    	}
	    	
	    	resourceHelper.createResourceEdges(AuthzConstants.ResourceEdgeNetworkRelation,
	    									   parentAppdef, 
	    									   (AppdefEntityID[]) childAppdefs.toArray(), 
	    									   false)
	    	userMsg = localeBundle.dependencyUpdateConfirmationMessage
    	} catch(ResourceEdgeCreateException e) {
    		state = "ERR"
            userMsg = localeBundle.errorCreatingAssociation
    	} catch(PermissionException pe){
    		log.error(pe)
    		state = "ERR"
    	    userMsg = localeBundle.noPermissionModifyingAssociation
    	} catch(Exception e) {
    		log.error(e)
    		state = "ERR"
            userMsg = localeBundle.errorModifyingAssociation
    	}
    	
    	def json = new JSONObject([ code : state, msg : userMsg ])
    	
    	render(inline : "${json}", contentType : "text/json")
    }
    
    def removeDependentPlatforms(params) {
    	def state = "SUCCESS"
        def userMsg = ""
           	
        try {
        	def parentId = params.getOne(PARENT_PARAM_NAME)
	    	def platformIds = params.get(PLATFORM_PARAM_NAME)
	    	def parentResourceId = new Integer(parentId)
	    	def childResourceIds = platformIds.collect { id ->
	    		new Integer(id)
	    	}
	    	    	
	    	def parentAppdef = new AppdefEntityID(AppdefEntityConstants.APPDEF_TYPE_PLATFORM + ":" + parentResourceId)
	    	def childAppdefs = []
			
	    	childResourceIds.each { id ->
	    		def appdef = new AppdefEntityID(AppdefEntityConstants.APPDEF_TYPE_PLATFORM + ":" + id)
	    		
	    		if (parentAppdef != appdef) {
	    			childAppdefs << appdef
	    		}    		
	    	}
	
	    	resourceHelper.removeResourceEdges(AuthzConstants.ResourceEdgeNetworkRelation,
	    									   parentAppdef,
	    									   (AppdefEntityID[]) childAppdefs.toArray())
	    	userMsg = localeBundle.dependencyUpdateConfirmationMessage
        } catch(PermissionException pe){
    		log.error(pe)
    		state = "ERR"
    	    userMsg = localeBundle.noPermissionModifyingAssociation
    	} catch(Exception e) {
    		log.error(e)
        	state = "ERR"
            userMsg = localeBundle.errorModifyingAssociation
        }
        
    	def json = new JSONObject([ code : state, msg : userMsg ])
    	
    	render(inline : "${json}", contentType : "text/json")
    }
    
    def removeAllDependentPlatforms(params) {
    	def state = "SUCCESS"
        def userMsg = ""
               	
        try {
        	def parentPlatformId = params.getOne(PARENT_PARAM_NAME)?.toInteger()
	    	def resource = Bootstrap.getBean(ResourceManager.class).findResource(new AppdefEntityID(AppdefEntityConstants.APPDEF_TYPE_PLATFORM + ":" + parentPlatformId))
	    	
	    	resourceHelper.removeResourceEdges(AuthzConstants.ResourceEdgeNetworkRelation, resource)
	    	
	    	userMsg = localeBundle.dependencyUpdateConfirmationMessage
        } catch(PermissionException pe){
    		log.error(pe)
    		state = "ERR"
    	    userMsg = localeBundle.noPermissionModifyingAssociation
    	} catch(Exception e) {
        	state = "ERR"
            userMsg = localeBundle.errorModifyingAssociation
        }
        
    	def json = new JSONObject([ code : state, msg : userMsg ])
    	
    	render(inline : "${json}", contentType : "text/json")
    }
}
