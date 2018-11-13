<%@ page language="java" %>
<%@ page errorPage="/common/Error.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<fmt:setBundle basename="controlAction" var="cap"/>

<c:if test="${controlEnabled}">
<table width="100%" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td colspan="2" class="BlockContent"><html:img page="/images/spacer.gif" width="1" height="1" border="0"/></td>
  </tr>
  <c:choose>
  <c:when test="${! empty controlAction}">
  <c:if test="${! empty controlResource}">
  <tr valign="top">
    <td width="20%" class="BlockLabel"><fmt:message key="resource.common.inventory.security.ResourceNameLabel"/></td>
    <td width="80%" class="BlockContent"><c:out value="${controlResource.name}"/></td>
  </tr>
  </c:if>
  <tr valign="top">
    <td width="20%" class="BlockLabel"><fmt:message key="alert.config.props.ControlType"/></td>
    
      <c:set var="theLowerKey" value="${fn:toLowerCase(controlAction)}" />
      <fmt:message key="ca-${theLowerKey}" var="matchedKey" bundle="${cap}" />
      <c:choose>
                 <c:when test="${fn:startsWith(matchedKey,'???')}">
                          <td width="80%" class="BlockContent"><c:out value="${controlAction}"/></td>
                 </c:when>
                 <c:otherwise>
                          <td width="80%" class="BlockContent"><fmt:message key="${matchedKey}" /></td>
                 </c:otherwise>
      </c:choose>
    
  </tr>
  </c:when>
  <c:otherwise>
  <tr valign="top">
    <td width="20%" class="BlockLabel"><fmt:message key="alert.config.props.ControlType"/></td>
    <td width="80%" class="BlockContent"><fmt:message key="alert.config.props.ControlType.none"/></td>
  </tr>
  </c:otherwise>
  </c:choose>
  <tr>
    <td colspan="2" class="BlockContent"><html:img page="/images/spacer.gif" width="1" height="1" border="0"/></td>
  </tr>
  <tr>
    <td colspan="2" class="BlockBottomLine"><html:img page="/images/spacer.gif" width="1" height="1" border="0"/></td>
  </tr>
</table>
</c:if>
