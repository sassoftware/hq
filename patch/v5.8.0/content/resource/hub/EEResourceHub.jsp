<%@ page language="java"%>
<%@ page errorPage="/common/Error.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html"%>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="/WEB-INF/tld/hq.tld" prefix="hq"%>
<%@ taglib uri="/WEB-INF/tld/display.tld" prefix="display"%>
<%@ taglib uri="/WEB-INF/tld/display-ee.tld" prefix="display-ee"%>
<%@ taglib uri="/WEB-INF/tld/ee.tld" prefix="ee"%>
<%@ taglib tagdir="/WEB-INF/tags/jsUtils" prefix="jsu" %>
<%@ taglib uri="https://www.owasp.org/index.php/OWASP_Java_Encoder_Project" prefix="owasp" %>

<jsu:importScript path="/js/functions.js" />
<jsu:importScript path="/js/listWidget.js" />
<c:set var="widgetInstanceName" value="listResources" />
<jsu:script>
	var pageData = new Array();
	var FOO = "chart";
	var LIST  = "list"; 
	var imagePath = "/images/";
	
	initializeWidgetProperties('<c:out value="${widgetInstanceName}"/>');
	widgetProperties = getWidgetProperties('<c:out value="${widgetInstanceName}"/>');
</jsu:script>
<hq:constant var="PLATFORM" classname="org.hyperic.hq.appdef.shared.AppdefEntityConstants" symbol="APPDEF_TYPE_PLATFORM" />
<hq:constant var="SERVER" classname="org.hyperic.hq.appdef.shared.AppdefEntityConstants" symbol="APPDEF_TYPE_SERVER" />
<hq:constant var="SERVICE" classname="org.hyperic.hq.appdef.shared.AppdefEntityConstants" symbol="APPDEF_TYPE_SERVICE" />
<hq:constant var="APPLICATION" classname="org.hyperic.hq.appdef.shared.AppdefEntityConstants" symbol="APPDEF_TYPE_APPLICATION" />
<hq:constant var="GROUP" classname="org.hyperic.hq.appdef.shared.AppdefEntityConstants" symbol="APPDEF_TYPE_GROUP" />
<hq:constant var="GROUP_COMPAT" classname="org.hyperic.hq.ui.action.resource.hub.ResourceHubPortalAction" symbol="SELECTOR_GROUP_COMPAT" />
<hq:constant var="GROUP_ADHOC" classname="org.hyperic.hq.ui.action.resource.hub.ResourceHubPortalAction" symbol="SELECTOR_GROUP_ADHOC" />
<hq:constant var="CHART" classname="org.hyperic.hq.ui.action.resource.hub.ResourceHubForm" symbol="CHART_VIEW" />
<hq:constant var="LIST" classname="org.hyperic.hq.ui.action.resource.hub.ResourceHubForm" symbol="LIST_VIEW" />

<c:choose>
	<c:when test="${ResourceHubForm.ff == PLATFORM}">
		<fmt:message var="entityTypeTH" key="resource.type.Platform" />
		<fmt:message var="resourceTypeTH" key="resource.hub.PlatformTypeTH" />
		<fmt:message var="resourceTitle" key="resource.common.nav.Platforms.AllPlatforms" />
	</c:when>
	<c:when test="${ResourceHubForm.ff == SERVER}">
		<fmt:message var="entityTypeTH" key="resource.type.Server" />
		<fmt:message var="resourceTypeTH" key="resource.hub.ServerTypeTH" />
		<fmt:message var="resourceTitle" key="resource.common.nav.Servers.AllServers" />
	</c:when>
	<c:when test="${ResourceHubForm.ff == SERVICE}">
		<fmt:message var="entityTypeTH" key="resource.type.Service" />
		<fmt:message var="resourceTypeTH" key="resource.hub.ServiceTypeTH" />
		<fmt:message var="resourceTitle" key="resource.common.nav.Services.AllServices" />
	</c:when>
	<c:when test="${ResourceHubForm.ff == APPLICATION}">
		<fmt:message var="entityTypeTH" key="resource.type.Application" />
		<fmt:message var="resourceTitle" key="resource.common.nav.Applications.AllApplications" />
	</c:when>
	<c:when test="${ResourceHubForm.ff == GROUP}">
		<fmt:message var="entityTypeTH" key="resource.type.Group" />
		<fmt:message var="resourceTypeTH" key="resource.hub.GroupTypeTH" />
		<fmt:message var="resourceTitle" key="resource.common.nav.Groups.AllGroups" />
	</c:when>
</c:choose>

<html:form action="/resource/hub/RemoveResource">
	<tiles:insert definition=".page.title.resource.hub">
		<tiles:put name="titleName">
			<span id="browseFilters"><c:out value="${resourceTitle}"escapeXml="false" />
			</span>
		</tiles:put>
	</tiles:insert>

	<c:if test="${not empty ResourceSummary}">
		<div class="hubContainer">
			<table width="100%" cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td class="ResourceHubBlockTitle" width="100%">
						<c:choose>
							<c:when test="${ResourceHubForm.ff == PLATFORM}">
								<fmt:message key="resource.hub.filter.platform" /> 
								(<c:out value="${ResourceSummary.platformCount}" />)
  							</c:when>
							<c:otherwise>
								<c:url var="platformUrl" value="/ResourceHub.do">
									<c:param name="ff" value="${PLATFORM}" />
									<c:param name="view" value="${ResourceHubForm.view}" />
									<c:if test="${not empty param.keywords}">
										<c:param name="keywords" value="${owasp:forUriComponent(param.keywords)}" />
									</c:if>
								</c:url>
								<html:link href="${platformUrl}">
									<fmt:message key="resource.hub.filter.platform" /> 
									(<c:out value="${ResourceSummary.platformCount}" />)
								</html:link>
							</c:otherwise>
						</c:choose> 
						<fmt:message key="common.label.Pipe" /> 
						<c:choose>
							<c:when test="${ResourceHubForm.ff == SERVER}">
								<fmt:message key="resource.hub.filter.server" /> 
								(<c:out value="${ResourceSummary.serverCount}" />)
  							</c:when>
							<c:otherwise>
								<c:url var="serverUrl" value="/ResourceHub.do">
									<c:param name="ff" value="${SERVER}" />
									<c:param name="view" value="${ResourceHubForm.view}" />
									<c:if test="${not empty param.keywords}">
										<c:param name="keywords" value="${owasp:forUriComponent(param.keywords)}" />
									</c:if>
								</c:url>
								<html:link href="${serverUrl}">
									<fmt:message key="resource.hub.filter.server" /> 
									(<c:out value="${ResourceSummary.serverCount}" />)
								</html:link>
							</c:otherwise>
						</c:choose> 
						<fmt:message key="common.label.Pipe" /> 
						<c:choose>
							<c:when test="${ResourceHubForm.ff == SERVICE}">
								<fmt:message key="resource.hub.filter.service" /> 
								(<c:out value="${ResourceSummary.serviceCount}" />)
							</c:when>
							<c:otherwise>
								<c:url var="serviceUrl" value="/ResourceHub.do">
									<c:param name="ff" value="${SERVICE}" />
									<c:param name="view" value="${ResourceHubForm.view}" />
									<c:if test="${not empty param.keywords}">
										<c:param name="keywords" value="${owasp:forUriComponent(param.keywords)}" />
									</c:if>
								</c:url>
								<html:link href="${serviceUrl}">
									<fmt:message key="resource.hub.filter.service" /> 
									(<c:out value="${ResourceSummary.serviceCount}" />)
								</html:link>
							</c:otherwise>
						</c:choose> 
						<fmt:message key="common.label.Pipe" /> 
						<c:choose>
							<c:when test="${ResourceHubForm.ff == GROUP && ResourceHubForm.g == GROUP_COMPAT}">
								<fmt:message key="resource.hub.filter.compatibleGroups" /> 
								(<c:out value="${ResourceSummary.compatGroupCount}" />)
		  					</c:when>
							<c:otherwise>
								<c:url var="groupUrl" value="/ResourceHub.do">
									<c:param name="ff" value="${GROUP}" />
									<c:param name="g" value="${GROUP_COMPAT}" />
									<c:param name="view" value="${ResourceHubForm.view}" />
									<c:if test="${not empty param.keywords}">
										<c:param name="keywords" value="${owasp:forUriComponent(param.keywords)}" />
									</c:if>
								</c:url>
								<html:link href="${groupUrl}">
									<fmt:message key="resource.hub.filter.compatibleGroups" /> 
									(<c:out value="${ResourceSummary.compatGroupCount}" />)
								</html:link>
							</c:otherwise>
						</c:choose> 
						<fmt:message key="common.label.Pipe" /> 
						<c:choose>
							<c:when test="${ResourceHubForm.ff == GROUP && ResourceHubForm.g == GROUP_ADHOC}">
								<fmt:message key="resource.hub.filter.mixedGroups" /> 
								(<c:out value="${ResourceSummary.groupCountAdhocGroup + ResourceSummary.groupCountAdhocPSS + ResourceSummary.groupCountAdhocApp}" />)
  							</c:when>
							<c:otherwise>
								<c:url var="groupUrl" value="/ResourceHub.do">
									<c:param name="ff" value="${GROUP}" />
									<c:param name="g" value="${GROUP_ADHOC}" />
									<c:param name="view" value="${ResourceHubForm.view}" />
									<c:if test="${not empty param.keywords}">
										<c:param name="keywords" value="${owasp:forUriComponent(param.keywords)}" />
									</c:if>
								</c:url>
								<html:link href="${groupUrl}">
									<fmt:message key="resource.hub.filter.mixedGroups" /> 
									(<c:out value="${ResourceSummary.groupCountAdhocGroup + ResourceSummary.groupCountAdhocPSS + ResourceSummary.groupCountAdhocApp}" />)
								</html:link>
							</c:otherwise>
						</c:choose>
                        <fmt:message key="common.label.Pipe" />
						<c:choose>
							<c:when test="${ResourceHubForm.ff == APPLICATION}">
								<fmt:message key="resource.hub.filter.application" /> 
								(<c:out value="${ResourceSummary.applicationCount}" />)
  							</c:when>
							<c:otherwise>
								<c:url var="appUrl" value="/ResourceHub.do">
									<c:param name="ff" value="${APPLICATION}" />
									<c:param name="view" value="${ResourceHubForm.view}" />
									<c:if test="${not empty param.keywords}">
										<c:param name="keywords" value="${owasp:forUriComponent(param.keywords)}" />
									</c:if>
								</c:url>
								<html:link href="${appUrl}">
									<fmt:message key="resource.hub.filter.application" /> 
									(<c:out value="${ResourceSummary.applicationCount}" />)
								</html:link>
							</c:otherwise>
						</c:choose>
					</td>
				</tr>
			</table>
		</c:if>

		<tiles:insert definition=".portlet.confirm" />
		<tiles:insert definition=".portlet.error" />

		<!--  FILTER TOOLBAR CONTENTS -->
		<html:hidden property="view" />

		<c:url var="ftAction" value="/ResourceHub.do">
			<c:if test="${not empty param.keywords}">
				<c:param name="keywords" value="${param.keywords}" />
			</c:if>
			<c:if test="${not empty param.ps}">
				<c:param name="ps" value="${param.ps}" />
			</c:if>
			<c:if test="${not empty param.so}">
				<c:param name="so" value="${param.so}" />
			</c:if>
			<c:if test="${not empty param.sc}">
				<c:param name="sc" value="${param.sc}" />
			</c:if>
			<c:if test="${not empty param.g}">
				<c:param name="g" value="${param.g}" />
			</c:if>
			<c:param name="ff" value="${ResourceHubForm.ff}" />
			<c:param name="view" value="${ResourceHubForm.view}" />
		</c:url>

		<c:url var="fgAction" value="/ResourceHub.do">
			<c:if test="${not empty param.keywords}">
				<c:param name="keywords" value="${param.keywords}" />
			</c:if>
			<c:if test="${not empty param.ps}">
				<c:param name="ps" value="${param.ps}" />
			</c:if>
			<c:if test="${not empty param.so}">
				<c:param name="so" value="${param.so}" />
			</c:if>
			<c:if test="${not empty param.sc}">
				<c:param name="sc" value="${param.sc}" />
			</c:if>
			<c:if test="${not empty param.g}">
				<c:param name="g" value="${param.g}" />
			</c:if>
			<c:if test="${not empty param.ft}">
				<c:param name="ft" value="${param.ft}" />
			</c:if>
			<c:param name="ff" value="${ResourceHubForm.ff}" />
			<c:param name="view" value="${ResourceHubForm.view}" />
		</c:url>
	
		<div class="FilterImage" style="padding: 4px; text-align: right;">
			<c:choose>
				<c:when test="${ResourceHubForm.view == LIST}">
					<input type="button" id="showChartBtn" class="button42" value="<fmt:message key='resource.view.chart' />"
					       onclick="ResourceHubForm.view.value = 'chart'; ResourceHubForm.submit(); return false;" />
				</c:when>
				<c:when test="${ResourceHubForm.view == CHART}">
					<input type="button" id="showChartBtn" class="button42" value="<fmt:message key='resource.view.list' />" 
					       onclick="ResourceHubForm.view.value = 'list'; ResourceHubForm.submit(); return false;" />
				</c:when>
			</c:choose>
		</div>

		<!--  RESOURCE HUB CONTENTS -->
		<c:url var="sAction" value="/ResourceHub.do">
			<c:if test="${not empty param.keywords}">
				<c:param name="keywords" value="${owasp:forUriComponent(param.keywords)}" />
			</c:if>
			<c:if test="${not empty param.ps}">
				<c:param name="ps" value="${param.ps}" />
			</c:if>
			<c:if test="${not empty param.pn}">
				<c:param name="pn" value="${param.pn}" />
			</c:if>
			<c:if test="${not empty param.ft}">
				<c:param name="ft" value="${param.ft}" />
			</c:if>
			<c:if test="${not empty param.g}">
				<c:param name="g" value="${owasp:forUriComponent(param.g)}" />
			</c:if>
			<c:param name="ff" value="${ResourceHubForm.ff}" />
			<c:param name="view" value="${ResourceHubForm.view}" />
		</c:url>

		<c:choose>
			<c:when test="${ResourceHubForm.view == LIST}">
				<jsu:script>
					function refreshAvail() {
        				var now = new Date()

						<c:forEach var="resource" items="${AllResources}">
							<c:url var="availabilityUrl" value="/resource/Availability">
								<c:param name="timeout" value="30000"/>
								<c:param name="eid" value="${resource.entityId.appdefKey}"/>
							</c:url>
        					document.avail${resource.entityId.id}.src = '${availabilityUrl}#' + now.valueOf();
    					</c:forEach>

    			        setAvailRefresh();
      				}
      
      				function setAvailRefresh() {
        				setTimeout( "refreshAvail()", 60*1000 );
      				}
				</jsu:script>
				<jsu:script onLoad="true">
   					setAvailRefresh();
      			</jsu:script>
				<c:choose>
					<c:when test="${empty Indicators || empty AllResources}">
						<display:table items="${AllResources}" var="resource" action="${sAction}" width="100%" cellspacing="0" cellpadding="0" border="0">
							    <display:column width="1%" property="entityId.appdefKey" title="<input type=\"checkbox\" onclick=\"ToggleAll(this, widgetProperties)\" name=\"listToggleAll\">"  isLocalizedTitle="false" styleClass="ListCellCheckbox" headerStyleClass="ListHeaderCheckbox">
        						    <display:checkboxdecorator name="resources" onclick="ToggleSelection(this, widgetProperties)" styleClass="listMember" />
							    </display:column>
							<display:column width="5%" property="id" title="nbsp" nowrap="true">
								<display-ee:quicknavdecorator resource="${resource}" />
							</display:column>
							<display:column width="30%" property="name" title="${entityTypeTH}" isLocalizedTitle="false" href="/Resource.do?eid=${resource.entityId.appdefKey}" sort="true" sortAttr="5" defaultSort="true" />
							<c:if test="${not empty resourceTypeTH}">
								<display:column width="24%" property="id" title="${resourceTypeTH}" isLocalizedTitle="false">
									<display:resourcedecorator resource="${resource}" type="true" />
								</display:column>
							</c:if>
							<display:column width="24%" property="description" title="common.header.Description" />
							<c:if test="${ResourceHubForm.ff == GROUP}">
								<display:column width="6%" property="totalSize" title="common.header.Members" sortAttr="1" align="center" nowrap="true"/>
							</c:if>
							    <display:column width="8%" property="id" title="resource.common.monitor.visibility.AvailabilityTH" styleClass="ListCellCheckbox" headerStyleClass="ListHeaderCheckbox" valign="middle" sortAttr="1">
								    <display:availabilitydecorator resource="${resource}" />
							    </display:column>
						</display:table>
					</c:when>
					<c:otherwise>
						<table class="table" width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr class="tableRowHeader">
								<th width="1%" class="ListHeaderCheckbox">
									<input type="checkbox" onclick="ToggleAll(this, widgetProperties)" name="listToggleAll">
								</th>
								<th width="5%" class="tableRowInactive">&nbsp;</th>
								<th width="30%" class="tableRowSorted">
									<c:choose>
										<c:when test="${param.so == 'dec'}">
											<c:url var="sAction" value="${sAction}">
												<c:param name="so" value="asc"/>
											</c:url>
											<a href="${sAction}">
												<c:out value="${entityTypeTH}" />
												<html:img border="0" page="/images/tb_sortdown.gif" />
											</a>
										</c:when>
										<c:otherwise>
											<c:url var="sAction" value="${sAction}">
												<c:param name="so" value="dec"/>
											</c:url>
											<a href="${sAction}">
												<c:out value="${entityTypeTH}" />
												<html:img border="0" page="/images/tb_sortup.gif" />
											</a>
										</c:otherwise>
									</c:choose>
								</th>
								<c:forEach items="${Indicators}" var="indicator">
									<th class="ListHeaderCheckbox">
										<c:out value="${indicator.name}" />
									</th>
								</c:forEach>
								<th class="ListHeaderCheckbox" nowrap="nowrap">
									<fmt:message key="resource.common.monitor.visibility.AvailabilityTH" />
								</th>
							</tr>
							<c:forEach items="${AllResources}" var="resource">
								<tr class="tableRowOdd">
									<td class="ListCellCheckbox" align="left" valign="top">
										<input type="checkbox" onclick="ToggleSelection(this, widgetProperties)" class="listMember" name="resources" value="<c:out value="${resource.entityId}"/>">
									</td>
									<td class="tableCell" align="left" nowrap valign="top">
										<ee:quicknav resource="${resource}" />
									</td>
									<td class="tableCell" align="left" valign="top">
										<span class="SpanPopup1">
											<html:link action="/Resource" paramId="eid" paramName="resource" paramProperty="entityId">
												<c:out value="${resource.name}" />
											</html:link>
											<c:if test="${not empty resource.description}">
												<span>
													<c:out value="${resource.description}"/>
												</span>
											</c:if>
										</span>
									</td>
									<!-- Insert metrics tile here -->
									<c:forEach items="${indicatorsMap[resource.entityId]}" var="metric">
										<td class="tableCell" align="middle" valign="top">
											<c:choose>
												<c:when test="${not empty metric}">
													<c:out value="${metric}" />
												</c:when>
												<c:otherwise>&nbsp;</c:otherwise>
											</c:choose>
										</td>
									</c:forEach>
									<td class="tableCell" align="middle" valign="top">
										<c:url var="sAction" value="${sAction}">
											<c:param name="so" value="asc"/>
										</c:url>
										<html:img imageName="avail${resource.id}" page="/resource/Availability?timeout=30000" paramId="eid" paramName="resource" paramProperty="entityId" />
									</td>
								</tr>
							</c:forEach>
						</table>
					</c:otherwise>
				</c:choose>
			</c:when>
			<c:otherwise>
				<tiles:insert definition=".resource.common.monitor.visibility.minicharts">
					<tiles:put name="Resources" beanName="AllResources" />
				</tiles:insert>
			</c:otherwise>
		</c:choose>

		<c:url var="psAction" value="/ResourceHub.do">
			<c:if test="${not empty param.keywords}">
				<c:param name="keywords" value="${owasp:forUriComponent(param.keywords)}" />
			</c:if>
			<c:if test="${not empty param.so}">
				<c:param name="so" value="${param.so}" />
			</c:if>
			<c:if test="${not empty param.sc}">
				<c:param name="sc" value="${param.sc}" />
			</c:if>
			<c:if test="${not empty param.ft}">
				<c:param name="ft" value="${param.ft}" />
			</c:if>
			<c:if test="${not empty param.g}">
				<c:param name="g" value="${owasp:forUriComponent(param.g)}" />
			</c:if>
			<c:if test="${not empty param.fg}">
				<c:param name="fg" value="${param.fg}" />
			</c:if>
			<c:if test="${not empty param.unavail}">
				<c:param name="unavail" value="${param.unavail}" />
			</c:if>
			<c:if test="${not empty param.own}">
				<c:param name="own" value="${owasp:forUriComponent(param.own)}" />
			</c:if>
			<c:if test="${not empty param.any}">
				<c:param name="any" value="${owasp:forUriComponent(param.any)}" />
			</c:if>
			<c:param name="ff" value="${ResourceHubForm.ff}" />
			<c:param name="view" value="${ResourceHubForm.view}" />
		</c:url>
	
		<c:url var="pnAction" value="/ResourceHub.do">
			<c:if test="${not empty param.keywords}">
				<c:param name="keywords" value="${owasp:forUriComponent(param.keywords)}" />
			</c:if>
			<c:if test="${not empty param.so}">
				<c:param name="so" value="${param.so}" />
			</c:if>
			<c:if test="${not empty param.sc}">
				<c:param name="sc" value="${param.sc}" />
			</c:if>
			<c:if test="${not empty param.ft}">
				<c:param name="ft" value="${param.ft}" />
			</c:if>
			<c:if test="${not empty param.g}">
				<c:param name="g" value="${owasp:forUriComponent(param.g)}" />
			</c:if>
			<c:if test="${not empty param.fg}">
				<c:param name="fg" value="${param.fg}" />
			</c:if>
			<c:if test="${not empty param.unavail}">
				<c:param name="unavail" value="${param.unavail}" />
			</c:if>
			<c:if test="${not empty param.own}">
				<c:param name="own" value="${owasp:forUriComponent(param.own)}" />
			</c:if>
			<c:if test="${not empty param.any}">
				<c:param name="any" value="${owasp:forUriComponent(param.any)}" />
			</c:if>
			<c:param name="ff" value="${ResourceHubForm.ff}" />
			<c:param name="view" value="${ResourceHubForm.view}" />
		</c:url>
		<c:url var="listNewUrl" value="/resource/platform/Inventory.do">
			<c:param name="mode" value="new"/>
		</c:url>
            <tiles:insert definition=".toolbar.list">
                <tiles:put name="listNewUrl" beanName="listNewUrl" />
                <tiles:put name="deleteOnly" value="true" />
                <tiles:put name="includeGroup" value="true" />
                <tiles:put name="listItems" beanName="AllResources" />
                <tiles:put name="listSize" beanName="AllResources" beanProperty="totalSize" />
                <tiles:put name="widgetInstanceName" beanName="widgetInstanceName" />
                <tiles:put name="pageSizeAction" beanName="psAction" />
                <tiles:put name="pageNumAction" beanName="pnAction" />
                <tiles:put name="defaultSortColumn" value="5" />
                <c:if test="${not canModify}">
                    <tiles:put name="hideAlertDefinitionActions" value="true" />
                 </c:if>
            </tiles:insert>
	</div>
	
	<html:hidden property="ff" />
	<html:hidden property="g" />
	<html:hidden property="pn" />
</html:form>

<tiles:insert definition=".resource.common.addToGroup" />
<tiles:insert definition=".page.footer" />

<script type="text/javascript" src="/static/js/jquery.min.js" />"></script>
<script type="text/javascript">  
    jQuery=$;  
</script> 

<jsu:script>		
	var images = jQuery('form td a img');
	var addLinkTitle = function(imgName, titleMessage){
		images.each(function(){
			if($(this).src.indexOf(imgName)>-1){
				$(this).parentNode.setAttribute('title',titleMessage);
				$(this).setAttribute('alt',titleMessage);
			}
		});
	}
	
	var imagesArray = new Array('/images/icon_hub_m.gif','/images/icon_hub_i.gif','/images/icon_hub_a.gif');
	var titlesArray = new Array('<fmt:message key="resource.hub.image.title.monitor"/>','<fmt:message key="resource.hub.image.title.inventory"/>','<fmt:message key="resource.hub.image.title.alerts"/>');
	for(var i=0; i < imagesArray.length; i++){
		addLinkTitle(imagesArray[i], titlesArray[i]);
	}
</jsu:script>