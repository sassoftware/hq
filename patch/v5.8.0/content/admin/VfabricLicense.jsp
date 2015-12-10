<%@ page language="java"%>
<%@ page errorPage="/common/Error.jsp"%>
<%@ page import="com.hyperic.hq.license.LicenseManager"%>
<%@ page import="org.hyperic.hq.context.Bootstrap"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.lang.System"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html"%>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="/WEB-INF/tld/sas.tld" prefix="sas" %>
<%
	Map info = ((LicenseManager)Bootstrap.getBean(LicenseManager.class)).getLicenseInfo();

	for (Iterator it=info.entrySet().iterator(); it.hasNext();) {
    	Map.Entry entry = (Map.Entry)it.next();
	    request.setAttribute((String)entry.getKey(), entry.getValue());
	}
	if (null == request.getAttribute("vFabricLicenseType")) {
		return;
	}
	if (null != request.getAttribute("vFabricLicenseExpire")) {
		Date date = (Date)request.getAttribute("vFabricLicenseExpire");
		long now = System.currentTimeMillis();
		long expire = date.getTime();
		if (now > expire) {
			request.setAttribute("vFabricLicenseExpired", "true");
		}
	}
%>

<fmt:setBundle basename="EEApplicationResources" var="EE"/>
<tiles:insert definition=".header.tab">
	<tiles:put name="tabName">
    	<fmt:message bundle="${EE}" key="admin.home.LicenseInfoTab" />
  	</tiles:put>
	<tiles:put name="tabKey" value="" />
	<tiles:put name="icon">
		<html:img page="/images/key.gif" alt="" />
	</tiles:put>
</tiles:insert>

<table width="100%" cellpadding="0" cellspacing="0" border="0"
	class="TableBottomLine " bgcolor="white">
	<tr>
		<td class="BlockLabel" width="20%"><fmt:message bundle="${EE}"
				key="admin.home.LicenseExpiration" /></td>
		<td class="BlockContent"><c:choose>
				<c:when test="${not empty vFabricLicenseExpire}">
					<sas:evmMapDefaultDateTimeTag value="${vFabricLicenseExpire}" />
				</c:when>
				<c:otherwise>
					<fmt:message key="common.label.Never" />
				</c:otherwise>
			</c:choose></td>
		<td class="BlockContent"><c:choose>
				<c:when test="${not empty vFabricLicenseExpired}">
					<b><font color="red"><fmt:message bundle="${EE}" key="admin.home.LicenseExpiredNotes" /></font></b>
				</c:when>
				<c:otherwise>
				</c:otherwise>
			</c:choose></td>
		<td class="BlockLabel">&nbsp;</td>
	</tr>
	<tr>
		<td class="BlockLabel"><fmt:message bundle="${EE}"
				key="admin.home.LicensePlatformLimit" /></td>
		<td class="BlockContent"><c:choose>
				<c:when test="${not empty vFabricLicensePlatforms}">
					<c:out value="${vFabricLicensePlatforms}" />
				</c:when>
				<c:otherwise>
					<fmt:message key="common.label.None" />
				</c:otherwise>
			</c:choose></td>
		<td class="BlockLabel">&nbsp;</td>
	</tr>
</table>