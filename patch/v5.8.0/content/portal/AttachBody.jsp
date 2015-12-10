<%@ page language="java" %>
<%@ page errorPage="/common/Error.jsp" %>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr class="PageTitleBar"> 
    <td><html:img page="/images/spacer.gif" width="5" height="1" alt="" border="0"/></td>
    <td><html:img page="/images/spacer.gif" width="15" height="1" alt="" border="0"/></td>
    <td width="34%"><c:out value="${attachment.description}"/></td>
    <td width="33%"><html:img page="/images/spacer.gif" width="1" height="1" alt="" border="0"/></td>
    <td width="32%"><html:img page="/images/spacer.gif" width="202" height="26" alt="" border="0"/></td>
  </tr>
  <tr>
  	<td rowspan="99" class="PageTitle">&nbsp;</td>
    <td valign="top" align="left" rowspan="99"></td>
    <td colspan="3"><html:img page="/images/spacer.gif" width="1" height="1" alt="" border="0"/></td>
  </tr>
  <tr valign="top">
    <td width="100%" colspan="4">
    <c:url var="attachUrl" context="/hqu/${attachment.plugin.name}" value="${attachment.path}"/>
    <c:import charEncoding="utf-8" url="${attachUrl}"/>
    </td>
  </tr>
</table>
