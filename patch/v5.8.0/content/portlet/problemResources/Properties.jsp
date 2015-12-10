<%@ page language="java" %>
<%@ page errorPage="/common/Error.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/tld/hq.tld" prefix="hq" %>
<%@ taglib uri="/WEB-INF/tld/display.tld" prefix="display" %>
<%@ taglib tagdir="/WEB-INF/tags/jsUtils" prefix="jsu" %>

<hq:pageSize var="pageSize"/>
<c:set var="widgetInstanceName" value="resources"/>
<c:url var="selfAction" value="/dashboard/Admin.do">
	<c:param name="mode" value="resourceHealth"/>
</c:url>
<jsu:importScript path="/js/listWidget.js" />
<jsu:script>
	var pageData = new Array();
	initializeWidgetProperties('<c:out value="${widgetInstanceName}"/>');
	widgetProperties = getWidgetProperties('<c:out value="${widgetInstanceName}"/>');  
	var help = '<hq:help/>';
</jsu:script>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr class="PageTitle"> 
    <td rowspan="99"><html:img page="/images/spacer.gif" width="5" height="1" alt="" border="0"/></td>
    <td><html:img page="/images/spacer.gif" width="15" height="1" alt="" border="0"/></td>
    <td width="67%" class="PortletTitle"><fmt:message key="dash.home.ProblemResources.Settings.Title"/></td>
    <td width="32%"><html:img page="/images/spacer.gif" width="202" height="32" alt="" border="0"/></td>
    <td width="1%"><html:img page="/images/spacer.gif" width="1" height="1" alt="" border="0"/></td>
  </tr>
  <tr> 
    <td valign="top" align="left" rowspan="99"></td>
    <td colspan="3"><html:img page="/images/spacer.gif" width="1" height="10" alt="" border="0"/></td>
  </tr>
  <tr valign="top"> 
    <td colspan="2">
      <html:form action="/dashboard/ModifyProblemResources" >
<div id="narrowlist_false">
      <tiles:insert definition=".header.tab">
        <tiles:put name="tabKey" value="dash.settings.DisplaySettings"/>
      </tiles:insert>
</div>
      <tiles:insert definition=".dashContent.admin.generalSettings">
        <tiles:put name="portletName" beanName="portletName" />
      </tiles:insert>

      <table width="100%" cellpadding="0" cellspacing="0" border="0">  
        <tr>
          <td colspan="4" class="BlockContent"><html:img page="/images/spacer.gif" width="1" height="1" border="0"/></td>
        </tr>
        <tr valign="top">
          <td width="50%" class="BlockLabel" valign="center"><fmt:message key="dash.settings.FormLabel.ProblemResources.numberOnDashboard"/></td>
          <td>
              <html:select property="rows" disabled="${not sessionScope.modifyDashboard}">
                <html:option value="5">5</html:option>
                <html:option value="10">10</html:option>
                <html:option value="15">15</html:option>
                <html:option value="20">20</html:option>
                <html:option value="30">30</html:option>
              </html:select>
          </td>
          <td width="80%" class="BlockContent" valign="center">
            &nbsp;
          </td>
        </tr>
        <tr>
          <td colspan="3" class="BlockContent"><html:img page="/images/spacer.gif" width="1" height="1" border="0"/></td>
        </tr>
        <tr>
          <td width="50%" class="BlockLabel" valign="center"><fmt:message key="dash.settings.FormLabel.ProblemResources.numberOfHours"/></td>
          <td>
              <html:select property="hours" disabled="${not sessionScope.modifyDashboard}">
                <html:option value="1">1</html:option>
                <html:option value="4">4</html:option>
                <html:option value="8">8</html:option>
                <html:option value="24">24</html:option>
                <html:option value="48">48</html:option>
              </html:select>
          </td>
          <td width="80%" class="BlockContent" valign="center">
            &nbsp;
          </td>
        </tr>
        <tr>
          <td colspan="3" class="BlockContent"><html:img page="/images/spacer.gif" width="1" height="1" border="0"/></td>
        </tr>
        <tr>
          <td colspan="3" class="BlockBottomLine"><html:img page="/images/spacer.gif" width="1" height="1" border="0"/></td>
        </tr>
      </table>
      &nbsp;<br>

  <c:if test="${not empty problemResources}">   
      <tiles:insert definition=".header.tab">
        <tiles:put name="tabKey" value="dash.home.ProblemResources"/>
      </tiles:insert>

      <display:table cellspacing="0" cellpadding="0" width="100%" action="/Dashboard.do"
                   var="resource" pageSize="-1" items="${problemResources}" >
                
        <display:column width="60%" href="/Resource.do?eid=${resource.resourceType}:${resource.resourceId}" property="entityName" title="dash.home.TableHeader.ResourceName"/>
      
        <display:column width="10%" property="availability" title="resource.common.monitor.visibility.AvailabilityTH" align="center" >
          <display:availabilitydecorator value="${resource.availability}" 
                                         monitorable="true" />
        </display:column>
        
        <display:column width="10%" property="alertCount" title="dash.home.TableHeader.Alerts" align="center"/>          

        <display:column width="10%" property="oobCount" title="dash.home.TableHeader.OOB" align="center" /> 
        
    </display:table>    
  </c:if>

      <tiles:insert definition=".form.buttons">
      <c:if test='${not sessionScope.modifyDashboard}'>
        <tiles:put name="cancelOnly" value="true"/>
        <tiles:put name="noReset" value="true"/>
      </c:if>
      </tiles:insert>

      </html:form>

    </td>
  </tr>
  <tr> 
    <td colspan="3"><html:img page="/images/spacer.gif" width="1" height="13" alt="" border="0"/></td>
  </tr>
</table>
