<%@ page language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/tld/hq.tld" prefix="hq" %>
<%@ taglib tagdir="/WEB-INF/tags/jsUtils" prefix="jsu" %>
<tiles:importAttribute name="hideLogs" ignore="true"/>
<jsu:script>
    hqDojo.require("dijit.dijit");
    hqDojo.require("dijit.Dialog");
    var topNDia = new hqDijit.Dialog({
        id: 'TopN_popup',
        refocus: true,
        autofocus: false,
        opacity: 0,
        title: "TopN"
    });
</jsu:script>
<jsu:script>
  	var semiIndex = imagePath.indexOf(";");
  	if (semiIndex != -1)
    	imagePath = imagePath.substring(0, semiIndex);

        function requestTopN(timestamp) {
        hqDojo.xhrGet({
        url: "<html:rewrite action="/resource/platform/TopN?eid=${eid}" />",
        content: {
        time: timestamp
        },
        handleAs: "json",
        load: function(response, args) {
        displayTopN(response, args);
        },
        error: function(response, args) {
        reportError(response, args);
        }
        });
    }

    function displayTopN(response, args){
        topNDia.set("content",response.topn);
        topNDia.show();
    }
  	<c:forEach var="timeTick" items="${timeIntervals}">
    	overlay.times.push('<hq:dateFormatter value="${timeTick.time}"/>');
  	</c:forEach>
</jsu:script>
<div id="overlay" class="overlay"></div>

<table cellpadding="0" cellspacing="0" border="0" width="100%">
  <%--
  <tr>
    <td class="ListHeaderInactive">Events</td>
  </tr>
  <tr>
    <td>

  --%>
  <c:if test="${not hideLogs}">
    <tiles:insert page="/resource/common/monitor/visibility/EventLogs.jsp"/>
  </c:if>
  <tr>
    <td width="10">
      <div id="timetop"></div>
      <html:img page="/images/timeline_ll.gif" height="10"/> 
    </td>
    <c:forEach var="timeTick" items="${timeIntervals}" varStatus="status">
      <c:set var="count" value="${status.count}"/>
    <td width="9">
     <div id="timePopup_<c:out value="${count - 1}"/>"
 	 	onmouseover="this.className = 'timelineOn'; overlay.moveOverlay(this);overlay.delayTimePopup(<c:out
                value="${count - 1}"/>)"
 	 	onmousedown="this.className = 'timelineDown'; overlay.showTopN(<c:out value="${count - 1}"/>);"
 	 	onmouseout="this.className = 'timelineOff'; overlay.curTime = null"
 	 	class="timelineOff">
     </div>
    </td>
    </c:forEach>
      <td width="10" align="left">
      <html:img page="/images/timeline_lr.gif" height="10"/>
    </td>
    <td class="BoldText" style="padding-left: 4px;">
      <fmt:message key="resource.common.monitor.visibility.topn.value"/>
    </td>
  </tr>
  <tr>
    <td></td>
    <td colspan="<c:out value="${count / 2}"/>" valign="top">
      <hq:dateFormatter value="${timeIntervals[0].time}"/>
      <div id="timePopup" class="timepopup" onmousedown="overlay.hideTimePopup()"></div>
    </td>
    <td colspan="<c:out value="${count / 2}"/>" align="right" valign="top">
      <hq:dateFormatter value="${timeIntervals[count - 1].time}"/>
    </td>
    <td></td>
  </tr>
  <tr>
    <td colspan="<c:out value="${count + 2}"/>" valign="top">
      <a name="eventDetail"></a>
      <div id="eventDetailTable"
           style="position: relative; height: 230px; display: none;">
      <div class="eventDetails">
	<jsu:script>
	  	var statusArr =
	    new Array ("ALL", "ERR", "WRN", "INF", "DBG", "ALR", "CTL");
	
	  	function filterEventsDetails(status) {
	    	for (i = 0; i < statusArr.length; i++) {
	      		hqDojo.attr(statusArr[i] + "EventsTab", "class", "eventsTab"); 
	    	}
	    
	    	hqDojo.attr(status + "EventsTab", "class", "eventsTabOn");
	
	    	if (status != statusArr[0])
	      		showEventsDetails(eventsTime, status);
	    	else
	      		showEventsDetails(eventsTime);
	  	}
	</jsu:script>
      <table cellspacing="0" width="100%">
        <tr>
          <td id="ALLEventsTab" width="10%" class="eventsTabOn" nowrap="true">
            <a href="#eventDetail" onclick="filterEventsDetails('ALL')" class="black"><fmt:message key="resource.common.monitor.label.events.All"/></a>
          </td>
          <td id="ERREventsTab" width="10%" class="eventsTab" nowrap="true">
            <a href="#eventDetail" onclick="filterEventsDetails('ERR')" class="red"><fmt:message key="resource.common.monitor.label.events.Error"/></a>
          </td>
          <td id="WRNEventsTab" width="10%" class="eventsTab" nowrap="true">
            <a href="#eventDetail" onclick="filterEventsDetails('WRN')" class="yellow"><fmt:message key="resource.common.monitor.label.events.Warn"/></a>
          </td>
          <td id="INFEventsTab" width="10%" class="eventsTab" nowrap="true">
            <a href="#eventDetail" onclick="filterEventsDetails('INF')" class="green"><fmt:message key="resource.common.monitor.label.events.Info"/></a>
          </td>
          <td id="DBGEventsTab" width="10%" class="eventsTab" nowrap="true">
            <a href="#eventDetail" onclick="filterEventsDetails('DBG')" class="green"><fmt:message key="resource.common.monitor.label.events.Debug"/></a>
          </td>
          <td id="ALREventsTab" width="10%" class="eventsTab" nowrap="true">
            <a href="#eventDetail" onclick="filterEventsDetails('ALR')" class="red"><fmt:message key="resource.common.monitor.label.events.Alert"/></a>
          </td>
          <td id="CTLEventsTab" width="10%" class="eventsTab" nowrap="true">
            <a href="#eventDetail" onclick="filterEventsDetails('CTL')" class="navy"><fmt:message key="resource.common.monitor.label.events.Control"/></a>
          </td>
          <td valign="top" style="text-align: right; border-bottom: solid; border-width: 1px; border-color: #000000;">
            <html:img page="/images/dash-icon_delete.gif"
                      onclick="hqDojo.fadeOut({ node: 'eventDetailTable' }).play()"/>
          </td>
        </tr>
        <tr>
          <td colspan="8"> 
            <div id="eventsSummary" class="eventsSummary"></div>
          </td>
        </tr>
      </table>
      </div>
      </div>
    </td>
  </tr>
</table>

