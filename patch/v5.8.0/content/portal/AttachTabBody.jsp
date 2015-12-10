<%@ page language="java" %>
<%@ page errorPage="/common/Error.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib tagdir="/WEB-INF/tags/jsUtils" prefix="jsu" %>
<!-- get the eid and mode here for the parent portal action and use that action instead of mastheadattach -->
<div style="display:none;">
<c:out value="${resourceViewTabAttachments}"></c:out> ---
<c:out value="${resourceViewTabAttachment.plugin.name}"></c:out>
<div style="padding:2px" id="SubTabSource">
<c:set var="isEmpty" value="true" />
<c:forEach var="attachment" items="${resourceViewTabAttachments}">
	<c:url var="attachmentUrl" value="/TabBodyAttach.do">
		<c:param name="id" value="${attachment.attachment.id}"/>
		<c:param name="mode" value="${param.mode}"/>
		<c:param name="eid" value="${param.eid}"/>
	</c:url>
	<c:choose>
    	<c:when test="${param.id eq attachment.attachment.id}">
    		<div>
    			<a href="${attachmentUrl}"><c:out value="${attachment.HTML}"/></a>
    		</div>
    	</c:when>
    	<c:otherwise>			
			<c:choose>
				<c:when test="${attachment.attachment.view.description ne \"Metric Data Extrapolation\"}">		
					<c:set var="isEmpty" value="false" />
					<div>
						<a href="${attachmentUrl}"><c:out value="${attachment.HTML}"/></a>
					</div>
				</c:when>
				<c:otherwise>
					<c:set var="resourceViewTabAttachments" value="" />					
				</c:otherwise>
			</c:choose>
			
			
    	</c:otherwise>
    </c:choose>
</c:forEach>
</div>
</div>
<c:choose>
<c:when test="${resourceViewTabAttachment ne null}">
	<div id="attachPointContainer" style="padding:4px;">
		<c:url var="attachUrl" context="/hqu/${resourceViewTabAttachment.plugin.name}" value="${resourceViewTabAttachment.path}">
			<c:param name="attachId" value="${param.id}" />
		</c:url>
		<c:import charEncoding="utf-8" url="${attachUrl}"/>
	</div>
</c:when>
<c:when test="${empty resourceViewTabAttachments && isEmpty eq \"true\"}">
	<div>
	  <fmt:message key="resource.common.tabs.Views.TabAttachments"/>
	</div>
</c:when>
<c:otherwise>
	<div class="viewSelectionNote">
	<img src="<html:rewrite page="/images/arrow_up_transparent.gif"/>"/><span><fmt:message key="resource.common.tabs.Views.SelectionNote"/></span>
	</div>
</c:otherwise>
</c:choose>
<jsu:script onLoad="true">
   	hqDojo.byId("SubTabTarget").innerHTML = hqDojo.byId("SubTabSource").innerHTML;
</jsu:script>