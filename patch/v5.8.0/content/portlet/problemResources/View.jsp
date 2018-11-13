 <%@ page language="java" %>
<%@ page errorPage="/common/Error.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/tld/display.tld" prefix="display" %>
<%@ taglib tagdir="/WEB-INF/tags/jsUtils" prefix="jsu" %>

<tiles:importAttribute name="adminUrl" ignore="true"/>
<c:set var="rssUrl" value="/rss/ViewProblemResources.rss"/>
<script>
  curAM = ' <fmt:message key='common.label.time.am'/>';
  curPM = ' <fmt:message key='common.label.time.pm'/>';
  updatedStr= ' <fmt:message key='dash.home.UpdatedTime'/>';
</script>	
<script type="text/javascript">
    function requestProblemResponse() {
        hqDojo.xhrGet({
            url: "<html:rewrite action="/dashboard/ViewProblemResources" />",
            handleAs: "json",
            load: function(response, args) {
                showProblemResponse(response, args);
                setTimeout("requestProblemResponse()", portlets_reload_time);
            },
            error: function(response, args) {
                reportError(response, args);
                setTimeout("requestProblemResponse()", portlets_reload_time);
            }
        });		
    }

    hqDojo.addOnLoad(function() {
		requestProblemResponse();
    });
</script>
<div class="effectsPortlet">
	<tiles:insert definition=".header.tab">
  		<tiles:put name="tabKey" value="dash.home.ProblemResources"/>
  		<tiles:put name="adminUrl" beanName="adminUrl" />
  		<tiles:put name="portletName" beanName="portletName" />
  		<tiles:put name="rssBase" beanName="rssUrl" />
	</tiles:insert>

   	<!-- Content Block  -->
    <table class="table" width="100%" border="0" cellspacing="0" cellpadding="0" id="problemResourcesTable">
      	<tbody>
        	<tr class="tableRowHeader" id="problemResourcesTableHeader">
          		<th width="50%" style="text-align:left!important;" class="tableRowInactive"><fmt:message key="dash.home.TableHeader.ResourceName"/></th>
          		<th width="10%" style="text-align:center!important;" class="tableRowInactive" nowrap><fmt:message key="resource.common.monitor.visibility.AvailabilityTH"/></th>
          		<th width="10%" style="text-align:center!important;" class="tableRowInactive" nowrap><fmt:message key="dash.home.TableHeader.Alerts"/></th>
          		<th width="10%" style="text-align:center!important;" class="tableRowInactive"><fmt:message key="dash.home.TableHeader.OOB"/></th>
          		<th width="20%" style="text-align:center!important;" class="tableRowInactive"><fmt:message key="dash.settings.criticalAlerts.last"/></th>
        	</tr>
        	<!-- table rows are inserted here dynamically -->
      	</tbody>
    </table>
    <table width="100%" cellpadding="0" cellspacing="0" border="0" id="noProblemResources" style="display:none;" class="portletLRBorder">
        <tbody>
	        <tr class="ListRow">
	            <td class="ListCell">
	                <c:url var="path" value="/images/4.0/icons/properties.gif"/>
	                <fmt:message key="dash.home.add.resources.to.display">
	                  	<fmt:param value="${path}"/>
	                </fmt:message>
	            </td>
	        </tr>
        </tbody>
  	</table>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
       	<tr>
        	<td colspan="4" id="modifiedProblemTime" class="modifiedDate"></td>
        </tr>
    </table>
</div>
