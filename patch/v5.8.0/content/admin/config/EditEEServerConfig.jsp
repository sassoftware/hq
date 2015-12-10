<%@ page language="java" %>
<%@ page errorPage="/common/Error.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html:form action="/admin/config/EditConfig">

<!--  ORG FORM -->
<tiles:insert page="/admin/config/EditServerConfigForm.jsp" />

<!-- HIERARCHICAL ALERTING PROPERTIES SHOULD BE THE FIRST SECTION IN THE EE FORM -->
<tiles:insert page="/admin/config/HierarchicalAlertingForm.jsp"/>

<tiles:insert page="/admin/config/AlertThrottleForm.jsp"/>

<tiles:insert page="/admin/config/AutoBaselineForm.jsp"/>

<tiles:insert page="/admin/config/SNMPForm.jsp"/>

<!-- FORM BUTTONS -->
<tiles:insert definition=".form.buttons"/>

</html:form>