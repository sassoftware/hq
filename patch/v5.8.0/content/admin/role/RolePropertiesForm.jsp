<%@ page language="java" %>
<%@ page errorPage="/common/Error.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/tld/hq.tld" prefix="hq" %>
<%@ taglib tagdir="/WEB-INF/tags/jsUtils" prefix="jsu" %>

<jsu:script>
    function updateDashboardName(name){
        var node = document.getElementById("dashboardString");   
        if(name.length < 1){
            node.innerHTML = '';
        }else{
        	name = name.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
            node.innerHTML = name;
        }
    }
</jsu:script>
<tiles:importAttribute name="mode" ignore="true"/>
<tiles:importAttribute name="role" ignore="true"/>

<c:choose>
  <c:when test="${not empty role}">
    <hq:owner var="ownerStr" owner="${role.owner}"/>
  </c:when>
  <c:otherwise>
    <hq:owner var="ownerStr" owner="${sessionScope.webUser}"/>
  </c:otherwise>
</c:choose>

<tiles:insert definition=".header.tab">
  <tiles:put name="tabKey" value="admin.role.props.PropertiesTab"/>
</tiles:insert>

<!--  GENERAL PROPERTIES -->
<table width="100%" cellpadding="0" cellspacing="0" border="0" class="BlockBg">
  <tr valign="top">
    <td width="20%" class="BlockLabel"><html:img page="/images/icon_required.gif" height="9" width="9" border="0"/><fmt:message key="common.label.Name"/></td>
<c:choose>
  <c:when test="${mode eq 'view'}">
    <td width="30%" class="BlockContent">
      <c:out value="${role.name}"/>
    </td>
  </c:when>
  <c:otherwise>
    <logic:messagesPresent property="name">
    <td width="30%" class="ErrorField">
      <html:text size="30" maxlength="40" property="name" onblur="updateDashboardName(this.value);" onkeyup="updateDashboardName(this.value);"/><br>
      <span class="ErrorFieldContent">- <html:errors property="name"/></span>
    </td>
    </logic:messagesPresent>
    <logic:messagesNotPresent property="name">
    <td width="30%" class="BlockContent">
      <html:text size="30" maxlength="40" property="name" onblur="updateDashboardName(this.value);" onkeyup="updateDashboardName(this.value);"/><br>
    </td>
    </logic:messagesNotPresent>
  </c:otherwise>
</c:choose>
    <td width="20%" class="BlockLabel"><fmt:message key="admin.role.props.OwnerLabel"/></td>
    <td width="30%" class="BlockContent">
      <c:out value="${ownerStr}" escapeXml="false"/>
<c:if test="${mode eq 'edit'}">
      <html:link action="/admin/role/RoleAdmin" paramId="r" paramName="role" paramProperty="id">
      	<html:param name="mode" value="changeOwner"/>
      	<fmt:message key="admin.role.props.ChangeButton"/>
      </html:link>
</c:if>
    </td>
  </tr>
  <tr valign="top">
    <td width="20%" class="BlockLabel"><fmt:message key="common.label.Description"/></td>
<c:choose>
  <c:when test="${mode eq 'view'}">
    <td width="30%" class="BlockContent">
      <c:out value="${role.description}"/>
    </td>
  </c:when>
  <c:otherwise>
    <logic:messagesPresent property="description">
    <td width="30%" class="ErrorField">
      <html:textarea cols="35" rows="3" property="description"/><br>
      <span class="ErrorFieldContent">- <html:errors property="description"/></span>
    </td>
    </logic:messagesPresent>
    <logic:messagesNotPresent property="description">
    <td width="30%" class="BlockContent">
      <html:textarea cols="35" rows="3" property="description"/><br>
      <span class="CaptionText"><fmt:message key="admin.role.props.100"/></span>
    </td>
    </logic:messagesNotPresent>
  </c:otherwise>
</c:choose>
    <td width="20%" class="BlockLabel">&nbsp;
      <c:if test="${mode eq 'view'}">
        <fmt:message key="admin.role.props.AdministerCAMLabel"/>
      </c:if>
    </td>
    <td width="30%" class="BlockContent">
      <c:if test="${mode eq 'view'}">
       <c:choose>
        <c:when test="${adminCam eq 'true'}">
         <fmt:message key="admin.role.props.administer.yes"/>
        </c:when>
        <c:otherwise>
         <fmt:message key="admin.role.props.administer.no"/>
        </c:otherwise>
       </c:choose>
      </c:if><!-- END VIEW MODE -->
      &nbsp;
    </td>
  </tr>
  <tr valign="top">
    <td width="20%" class="BlockLabel"><fmt:message key="admin.role.DashboardName"/></td>
    <td width="30%" class="BlockContent">
    	<span id="dashboardString"><c:out value="${role.name}"/>&nbsp;</span>
    </td>
    <td width="20%" class="BlockLabel"></td>
    <td width="30%" class="BlockContent"></td>
   </tr>
</table>
<!--  /  -->
