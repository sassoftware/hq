<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="/WEB-INF/tld/hq.tld" prefix="hq" %>

<link rel="stylesheet" href="<html:rewrite page="/static/js/dojo/1.5/dojo/resources/dojo.css"/>" type="text/css"/>
<link rel="stylesheet" href="<html:rewrite page="/static/js/dojo/1.5/dijit/themes/tundra/tundra.css"/>" type="text/css"/>
<link rel="shortcut icon" href="<html:rewrite page="/images/4.0/icons/favicon.ico"/>"/>
<link rel="stylesheet" href="<html:rewrite page="/css/win.css"/>" type="text/css"/>
<link rel="stylesheet" href="<html:rewrite page="/css/HQ_40.css"/>" type="text/css"/>
<hq:Timeout />
<DIV id="headerLogoZ" class="headerLogoZ">
        <TABLE cellSpacing=0 cellPadding=0 width="100%">
        <TBODY>
        <TR>
        	<TD id=bantitle noWrap></TD><TD id=banBlank></TD></TR>
        <TR>
          <TD id=bantitle noWrap><fmt:message key="header.product.name"/></TD>
          <TD id=banBlank></TD></TR></TBODY></TABLE>
</DIV>

<div id="headerLinks">
	<sec:authorize access="hasRole('ROLE_HQ_USER')">
 		<c:if test="${not empty HQUpdateReport}">
 	 		<div id="update" class="dialog" style="display: none;">
 	 			<c:out value="${HQUpdateReport}" escapeXml="false"/>
 	 
 	 			<form name="updateForm" action="">
 	 				<div style="text-align:right;">
 	 					<input id="updateAcknowledgementButton" type="button" class="button42" value="<fmt:message key="header.Acknowledge"/>" />
 	 				</div>
 	 			</form>
 			</div>
			<a id="updateLink">
 				<img src="<spring:url value="/static/images/transmit2.gif" />" align="absMiddle" border="0" />                        
 			</a>
		</c:if>	
	</sec:authorize>
	<ul>
		<sec:authorize access="hasRole('ROLE_HQ_USER')">
			<li>
				<span><fmt:message key="header.Welcome"/></span>
				<a href="<spring:url value="/admin/user/UserAdmin.do?mode=view&u=${sessionScope.webUser.id}"/>">
	            	${sessionScope.webUser.firstName}
				</a>
			</li>
			<li>
				<a id="signOutLink" href="<spring:url value="/j_spring_security_logout" />" title="<fmt:message key="header.SignOut" />">
					<fmt:message key="header.SignOut" />
				</a>
			</li>
		</sec:authorize>
		<li>
            <a id="helpLink" href="<hq:help/>" onclick="helpWin=window.open((typeof help != 'undefined' ? help : this.href),'SASDoc','width=800,height=650,scrollbars=yes,toolbar=yes,left=80,top=80,resizable=yes');helpWin.focus();return false;" >
				<fmt:message key="header.Help" />
			</a>
		</li>
	</ul>
</div>
<sec:authorize access="hasRole('ROLE_HQ_USER')">
	<div id="loading" class="ajaxLoading" style="">
       	<img src="<spring:url value="/static/images/ajax-loader.gif" />" border="0" width="16" height="16" />
    </div>
    <div id="headerAlerts" style="display: none;">
    	<div id="recentText"><fmt:message key="header.RecentAlerts"/></div>
       	<div id="recentAlerts"></div>
    </div>
    <div id="navTabContainer">
			<div id="dashTab" class="tab" style="padding-top: 0px;">
				<a href="<spring:url value="/Dashboard.do" />">
					<fmt:message key="header.dashboard"/>
				</a>
			</div>
	        <div id="resTab" class="tab" style="padding-top: 0px;">
	        	<a href="<spring:url value="/ResourceHub.do" />">
	        		<fmt:message key="header.resources"/>
	        	</a>
	           	<ul class="root" id="resourceSubMenu">
	               	<li>
               		<a href="<spring:url value="/ResourceHub.do" />"><fmt:message key="header.Browse"/></a>
	               	</li>
	                <c:forEach var="attachment" items="${mastheadResourceAttachments}">
									<li>
				 						<a href="<spring:url value="/mastheadAttach.do?typeId=${attachment.attachment.id}"/>">${attachment.HTML}</a>
				 					</li>
									</c:forEach>
	               	<li class="subMenu">
	               		<a><fmt:message key=".dashContent.recentResources"/></a>
	               		<ul>
	               			<c:choose>
  								<c:when test="${not empty resources}">
  									<c:forEach var="resource" items="${resources}">
    									<li>
    										<a href="<spring:url value="/Resource.do?eid=${resource.key}"/>"><c:out value="${resource.value.name}"/></a>
    									</li>
  									</c:forEach>
  								</c:when>
  								<c:otherwise>
    								<li><a href=""><fmt:message key="common.label.None"/></a></li>
  								</c:otherwise>
							</c:choose>
	               		</ul>
			        </li>
				     </ul>
			    </div>		    
	       <div id="analyzeTab" class="tab" style="padding-top: 0px;">
				   <a><fmt:message key="header.analyze"/></a>
				   <ul class="root" id="analyzeSubMenu">
					  <c:if test="${not empty eeItems}">
						<c:forEach var="eeItem" items="${eeItems}">
						     <c:if test="${eeItem.messageKey != 'header.reporting'}">
						     <li><a href="<spring:url value="${eeItem.pagePath}"/>"><fmt:message key="${eeItem.messageKey}"/></a></li>
						     </c:if>
						</c:forEach>
					</c:if>
					<c:forEach var="attachment" items="${mastheadTrackerAttachments}">
					<li>
 						<a href="<spring:url value="/mastheadAttach.do?typeId=${attachment.attachment.id}"/>">${attachment.HTML}</a>
 					</li>
					</c:forEach>
				   </ul>
	        </div>	   	
		   	<%@page import="java.io.InputStream" %> 
		        <%@page import="java.util.Properties" %> 
		        <%@page import="java.util.HashMap" %> 
		        <%@page import="java.util.Map" %> 
		        <% 
				InputStream stream = application.getResourceAsStream("/sas/sas.properties"); 
				Properties props = new Properties(); 
				props.load(stream); 
				Map<String, String> sasMap = new HashMap<String, String>((Map) props);
				if (sasMap.size() > 0) {
		        %>
			   <div id="evTab" class="tab" style="padding-top: 0px;">
			    <a href="<spring:url value="<%=sasMap.entrySet().iterator().next().getValue()%>" />"><fmt:message key="header.ev"/></a>
			    <!-- 
				<a><fmt:message key="header.ev"/></a>
				<ul class="root">
					<c:if test="${empty sasMap}">					 
					    <c:set var="sasMap" scope="session" value="<%=sasMap%>"/>
					</c:if>
					<c:forEach var="item" items="${sasMap}">
					     <li><a href="<spring:url value="${item.value}"/>"><fmt:message key="${item.key}"/></a></li>
					</c:forEach>                    
				</ul>
				-->
			</div>
                        <%
	                    }
	                %>
	             
	      <div id="adminTab" class="tab" style="padding-top: 0px;">
		    	<a href="<spring:url value="/Admin.do" />">
		    		<fmt:message key="header.admin"/>
		    	</a>
		   	</div>
	</div>
	<div id="headerSearch">
		<input type="text" id="searchBox" value=""/>
  </div>
	<div id="headerSearchResults" style="display:none;">
       	<div id="searchClose" class="cancelButton right"></div>
	        <div class="resultsGroup">
       		    <div class="category"><fmt:message key="header.Resources"/> (<span id="resourceResultsCount"></span>)</div>
	           	<ul id="resourceResults">
           		    <li></li>
		        </ul>
		    </div>
		    <div class="resultsGroup">
           		<div class="category"><fmt:message key="header.users"/> (<span id="usersResultsCount"></span>)</div>
		        <ul id="usersResults">
               		<li></li>
           		</ul>
       		</div>
    	</div>
    </div>
    <script src="<spring:url value="/js/lib/lib.js" />" type="text/javascript"></script>
    <script>
	    hqDojo.require("dijit.dijit");
    	hqDojo.require("dijit.Dialog");
    	
		// update the SAS timeout after XHR calls complete
		hqDojo.config.ioPublish = true;
	    hqDojo.subscribe("/dojo/io/done", function() {
			sas_framework_updateTimeout();
   		});  
     	
    	var resourceURL = '<spring:url value="/Resource.do" />';
		var userURL = '<spring:url value="/admin/user/UserAdmin.do" />';
    	var searchWidget = new hyperic.widget.search(hqDojo, { search: '<spring:url value="/app/search" />' }, 3, { keyCode: 83, ctrl: true });
    	var refreshCount = 0;
    	var refreshAlerts = function() {
      		hqDojo.xhrGet({
	    	  	url: "<spring:url value="/common/RecentAlerts.jsp"/>",
	    	  	load: function(response, args) {
	    	        hqDojo.style("headerAlerts", {
	    	        	"display": "",
	    	        	"top": 0,
	    	        	"left": "310px",
	    	        	"paddingLeft": "72px"
	    	        });
	    	        hqDojo.byId("recentAlerts").innerHTML = response;
	    	  	} 
	      	});
	    };
   	 	
	    hqDojo.ready(function() { 
	    	refreshAlerts();
        	activateHeaderTab(hqDojo);
        	searchWidget.create();
        
        	hqDojo.subscribe("refreshAlerts", function(data) {
        		refreshCount++;
        		refreshAlerts();
        	});
        	
        	setInterval(function() {
        		if (refreshCount < 30 || window.autoLogout === undefined) {
    	            hqDojo.publish("refreshAlerts");
    	        } else {
    	        	top.location.href = "<spring:url value="/j_spring_security_logout" />";
    	        }
        		
        		if (refreshCount > 30) refreshCount = 0;
        	}, 60*1000);
        	
        	//Connect the events for the box, cancel and search buttons
        	hqDojo.connect(searchWidget.searchBox, "onkeypress", searchWidget, "search");
        	
        	// What should the hot-keys do?
        	hqDojo.subscribe('enter', searchWidget, "search");
        	
        	// Render Search Tooltip
        	hqDojo.byId('headerSearch').title = "<fmt:message key="header.searchTip.mac" />";
        	
        	hqDojo.query(".tab", hqDojo.byId("headerTabs")).onmouseenter(function(e) {
        		hqDojo.addClass(e.currentTarget, "hover");
        	}).onmouseleave(function(e) {
        		hqDojo.removeClass(e.currentTarget, "hover");
        	});
        	hqDojo.query(".subMenu", hqDojo.byId("headerTabs")).onmouseenter(function(e) {
        		hqDojo.addClass(e.currentTarget, "hover");
        	}).onmouseleave(function(e) {
        		hqDojo.removeClass(e.currentTarget, "hover");
        	});
    		if (hqDojo.byId("updateLink")) {
    			new hqDijit.Dialog({
        	 	 		id: 'update_popup',
        	 			refocus: true,
        	 			autofocus: false,
        	 			opacity: 0,
        	 			title: "<fmt:message key="header.dialog.title.update" />"
        			}, 
        			hqDojo.byId('update')
        		);
        	 	
    			hqDojo.connect(hqDojo.byId("updateAcknowledgementButton"), "onclick", function(e) {
        			if (this.value == "<fmt:message key="header.Acknowledge"/>") {
            	        hqDojo.xhrPost({
                	 	 	url: "<spring:url value="/Dashboard.do" />",
                 		 	content: { 
                 		 		update: true 
                 		 	},
                 	 		load: function(data) {
                 	 			hqDojo.style("updateLink", "display", "none");
                 	 			hqDijit.byId("update_popup").hide();
                			}
               			});
                	}
        		});
        		hqDojo.connect(hqDojo.byId("updateLink"), "onclick", function(e) {
        			 hqDijit.byId("update_popup").show();
        		});
    		}
    	});
    </script>
</sec:authorize>