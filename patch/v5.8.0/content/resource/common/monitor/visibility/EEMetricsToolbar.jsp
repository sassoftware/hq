<%@ page language="java" %>
<%@ page errorPage="/common/Error.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<tiles:importAttribute name="widgetInstanceName"/>
<tiles:importAttribute name="useChartButton" ignore="true"/>
<tiles:importAttribute name="useAddButton" ignore="true"/>
<tiles:importAttribute name="useRemoveButton" ignore="true"/>
<tiles:importAttribute name="useBaselinesButtons" ignore="true"/>
<tiles:importAttribute name="useCompareButton" ignore="true"/>
<tiles:importAttribute name="useCurrentButton" ignore="true"/>
<tiles:importAttribute name="useReloadButton" ignore="true"/>
<tiles:importAttribute name="usePager" ignore="true"/>
<tiles:importAttribute name="listItems" ignore="true"/>
<tiles:importAttribute name="listSize" ignore="true"/>
<tiles:importAttribute name="pageSizeParam" ignore="true"/>
<tiles:importAttribute name="pageSizeAction" ignore="true"/>
<tiles:importAttribute name="pageNumParam" ignore="true"/>
<tiles:importAttribute name="pageNumAction" ignore="true"/>
<tiles:importAttribute name="defaultSortColumn" ignore="true"/>

<c:if test="${empty useChartButton &&
              (useAddButton || useRemoveButton || useBaselinesButtons)}">
  <c:set var="useChartButton" value="true"/>
</c:if>

<!--  METRICS TOOLBAR -->
<table width="100%" cellpadding="5" cellspacing="0" border="0" class="ToolbarContent">
  <tr>
<c:if test="${useChartButton}">
    <td width="1" align="left" id="<c:out value="${widgetInstanceName}"/>chartSelectedMetricsTd"><div id="<c:out value="${widgetInstanceName}"/>chartSelectedMetricsDiv"><input id="<c:out value="${widgetInstanceName}"/>chartSelectedMetricsButton" type="button" class="compactbuttoninactive" value="<fmt:message key='button.chartselectedMetrics' />" disabled="disabled" /></div></td>
</c:if>
<c:if test="${useBaselinesButtons}">
    <td width="1" align="left" id="<c:out value="${widgetInstanceName}"/>setBaselinesTd"><div id="<c:out value="${widgetInstanceName}"/>setBaselinesDiv"><input id="<c:out value="${widgetInstanceName}"/>setBaselinesButton" type="button" class="compactbuttoninactive" value="<fmt:message key='button.setBaselines' />" disabled="disabled" /></div></td>
    <!--
    <td width="1" align="left" id="<c:out value="${widgetInstanceName}"/>enableAutoBaselinesTd"><div id="<c:out value="${widgetInstanceName}"/>enableAutoBaselinesDiv"><html:img page="/images/tbb_enableAutoBaselines_gray.gif" border="0"/></div></td>
      -->
</c:if>
<c:if test="${useAddButton}">
    <td width="1" align="left" id="<c:out value="${widgetInstanceName}"/>addToFavoritesTd"><div id="<c:out value="${widgetInstanceName}"/>addToFavoritesDiv"><input id="<c:out value="${widgetInstanceName}"/>addToFavoritesButton" type="button" class="compactbuttoninactive" value="<fmt:message key='button.addtofavorites' />" disabled="disabled" /></div></td>
</c:if>
<c:if test="${useRemoveButton}">
    <td width="1" align="left" id="<c:out value="${widgetInstanceName}"/>removeFromFavoritesTd"><div id="<c:out value="${widgetInstanceName}"/>removeFromFavoritesDiv"><input id="<c:out value="${widgetInstanceName}"/>removeFromFavoritesButton" type="button" class="compactbuttoninactive" value="<fmt:message key='button.removefromfavorites' />" disabled="disabled" /></div></td>
</c:if>
<c:if test="${useCompareButton}">
    <td width="1" align="left" id="<c:out value="${widgetInstanceName}"/>compareTd"><div id="<c:out value="${widgetInstanceName}"/>compareDiv"><input id="<c:out value="${widgetInstanceName}"/>compareButton" type="button" class="compactbuttoninactive" value="<fmt:message key='button.compareMetricsOfSelected' />" disabled="disabled" /></div></td>
</c:if>
<c:if test="${useCurrentButton}">
    <td width="100%" align="right"><fmt:message key="resource.common.monitor.visibility.GetCurrentValuesLabel"/></td>
    <td><html:image property="current" page="/images/4.0/icons/accept.png" altKey="button.ok" border="0"/></td>
</c:if>
<c:if test="${useReloadButton}">
    <td width="100%" align="right"><fmt:message key="resource.common.monitor.visibility.GetCurrentValuesLabel"/></td>
    <td><a href="javascript:location.reload();"><html:img page="/images/4.0/icons/accept.png" altKey="button.ok" border="0"/></a></td>
</c:if>
    <td width="100%"><html:img page="/images/spacer.gif" width="1" height="1" alt="" border="0"/></td>
<c:if test="${usePager}">
  <tiles:insert definition=".controls.paging">
   <tiles:put name="listItems" beanName="listItems"/>
   <tiles:put name="listSize" beanName="listSize"/>
   <tiles:put name="pageSizeParam" beanName="pageSizeParam"/>
   <tiles:put name="pageSizeAction" beanName="pageSizeAction"/>
   <tiles:put name="pageNumParam" beanName="pageNumParam"/>
   <tiles:put name="pageNumAction" beanName="pageNumAction"/>
   <tiles:put name="defaultSortColumn" beanName="defaultSortColumn"/>
  </tiles:insert>
</c:if>
  </tr>
  <c:if test="${iSinEEMetricsDisplay=='Y'}">
  <tr><td>&nbsp;</td></tr>
  </c:if>
</table>
<!--  /  -->
