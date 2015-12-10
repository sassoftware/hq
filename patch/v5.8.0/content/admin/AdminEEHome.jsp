<%@ page language="java"%>
<%@ page errorPage="/common/Error.jsp"%>
<%@ page import="com.hyperic.hq.license.LicenseManager"%>
<%@ page import="org.hyperic.hq.context.Bootstrap"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.lang.Integer"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html"%>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<tiles:insert definition=".admin.auth.functions" />

<tiles:insert page="/admin/Settings.jsp">
	<tiles:put name="defaultMsg" value="inform.config.admin.PolicyDefaults" />
</tiles:insert>

<c:if test="${useroperations['administerCAM']}">
	<tiles:insert definition=".admin.Plugins" />
	<tiles:insert page="/admin/VfabricLicense.jsp" />
	<tiles:insert page="/admin/VcopsLicense.jsp" />
	<tiles:insert page="/admin/VcloudLicense.jsp" />
	<tiles:insert page="/admin/VsphereLicense.jsp" />

	<%Integer used = ((LicenseManager)Bootstrap.getBean(LicenseManager.class)).getTotalUsed(); 
  	Integer available = ((LicenseManager)Bootstrap.getBean(LicenseManager.class)).getTotalAvailable();
  	request.setAttribute("used", used);
  	request.setAttribute("available", available); 
  	if (-1 == available.intValue()) {
  		request.setAttribute("available", "0"); 
  		request.setAttribute("statusIcon", "/images/icon_available_red.gif");
  	}
  	if (0 == available.intValue()) {
  		request.setAttribute("available", "UNLIMITED"); 
  	}
  	if ((-1 != available.intValue()) && ((0 == available.intValue()) || (used.intValue() < available.intValue()))) {
  		request.setAttribute("statusIcon", "/images/icon_available_green.gif");
  	}
  	else {
  		request.setAttribute("statusIcon", "/images/icon_available_red.gif");
  	}
  %>

	<!--  Licenses status -->
	<tiles:insert definition=".header.tab">
		<tiles:put name="tabName">
    	<fmt:message key="admin.license.usage.satatus" />
  	</tiles:put>
		<tiles:put name="tabKey" value="" />
		<tiles:put name="icon">
			<html:img page="/images/key.gif" titleKey="admin.home.License" altKey="admin.home.License" />
		</tiles:put>
	</tiles:insert>

	<table width="100%" cellpadding="0" cellspacing="0" border="0"
		class="TableBottomLine ">
		<tr>
			<td class="BlockLabel" width="20%"><fmt:message key="admin.license.usage.platform" />:</td>
			<td class="BlockContent"><c:out value="${used}" /> / <c:out
					value="${available}" /> &nbsp; &nbsp; &nbsp; <img
				src="${statusIcon}" /></td>

		</tr>
	</table>
</c:if>

