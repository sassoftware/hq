<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/tld/hq.tld" prefix="hq" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<hq:constant classname="org.hyperic.hq.ui.Constants"
                symbol="CONTROL_ACTION_NONE"
                   var="CONTROL_ACTION_NONE"/>

<% response.setHeader("Pragma","no-cache");%>
<% response.setHeader("Cache-Control","no-store");%>
<% response.setDateHeader("Expires",-1);%>

<fmt:setBundle basename="controlAction" var="cap"/>

<select id="controlAction" name="controlAction"> 
  <option value="<c:out value="${CONTROL_ACTION_NONE}"/>" class="boldText"><fmt:message key="alert.config.props.ControlType.none"/></option>
  <c:forEach var="action" items="${actions}">
      <c:set var="theLowerKey" value="${fn:toLowerCase(action)}" />
      <fmt:message key="ca-${theLowerKey}" var="matchedKey" bundle="${cap}" />
  
    <c:choose>
      <c:when test="${action == param.action}">
        <option value="<c:out value="${action}"/>" selected="selected">
      </c:when>
      <c:otherwise>
        <option value="<c:out value="${action}"/>">
      </c:otherwise>
    </c:choose>
    
    
    
      <c:choose>
         <c:when test="${fn:startsWith(matchedKey,'???')}">
          <c:out value="${action}"/></option>
         </c:when>
      
         <c:otherwise>
          <fmt:message key="${matchedKey}" /></option>
         </c:otherwise>
    
    
    </c:choose>
    
  </c:forEach>
</select>
