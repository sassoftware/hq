<%@ page language="java" %>
<%@page import="java.util.*,
				java.net.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib tagdir="/WEB-INF/tags/jsUtils" prefix="jsu" %>
<%@ include file="/common/replaceButton.jsp"%>
<%--
  NOTE: This copyright does *not* cover user programs that use HQ
  program services by normal system calls through the application
  program interfaces provided as part of the Hyperic Plug-in Development
  Kit or the Hyperic Client Development Kit - this is merely considered
  normal use of the program, and does *not* fall under the heading of
  "derived work".
  
  Copyright (C) [2004, 2005, 2006], Hyperic, Inc.
  This file is part of HQ.
  
  HQ is free software; you can redistribute it and/or modify
  it under the terms version 2 of the GNU General Public License as
  published by the Free Software Foundation. This program is distributed
  in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
  even the implied warranty of MERCHANTABILITY or FITNESS FOR A
  PARTICULAR PURPOSE. See the GNU General Public License for more
  details.
  
  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
  USA.
 --%>


<tiles:importAttribute name="showRedraw" ignore="true"/>
<c:if test="${empty showRedraw}">
<c:set var="showRedraw" value="false"/>
</c:if>

<tiles:importAttribute name="form" ignore="true"/>
<c:choose>
  <c:when test="${not empty form}">
    <%-- used only for forms that are not MetricDisplayRangeForm --%>
    <tiles:importAttribute name="formName"/>
    <c:set var="startMonth" value="${form.startMonth}"/>
    <c:set var="startDay" value="${form.startDay}"/>
    <c:set var="startYear" value="${form.startYear}"/>
    <c:set var="endMonth" value="${form.endMonth}"/>
    <c:set var="endDay" value="${form.endDay}"/>
    <c:set var="endYear" value="${form.endYear}"/>
  </c:when>
  <c:otherwise>
    <c:set var="formName" value="MetricDisplayRangeForm"/>
    <c:set var="startMonth" value="${MetricDisplayRangeForm.startMonth}"/>
    <c:set var="startDay" value="${MetricDisplayRangeForm.startDay}"/>
    <c:set var="startYear" value="${MetricDisplayRangeForm.startYear}"/>
    <c:set var="endMonth" value="${MetricDisplayRangeForm.endMonth}"/>
    <c:set var="endDay" value="${MetricDisplayRangeForm.endDay}"/>
    <c:set var="endYear" value="${MetricDisplayRangeForm.endYear}"/>
  </c:otherwise>
</c:choose>
<jsu:importScript path="/js/schedule.js" />
<jsu:importScript path="/js/monitorSchedule.js" />
<jsu:script>
 	var jsPath = "<html:rewrite page="/js/"/>";
 	var cssPath = "<html:rewrite page="/css/"/>";
 	var isMonitorSchedule = false;
	 var imagePath = "/images/";	
</jsu:script>
<%
	String djLocaleString="";
	Locale locale = request.getLocale();
	
	
	String reqLocaleString = request.getLocale().toString();
	
	if(reqLocaleString.equalsIgnoreCase("zh_HANS_CN")){
		locale = new Locale("zh", "CN");
	}else if(reqLocaleString.equalsIgnoreCase("zh_HANT_TW")){
		locale = new Locale("zh", "TW");
	}else if(reqLocaleString.equalsIgnoreCase("zh_HANT_HK")){
		locale = new Locale("zh", "HK");
	}else if(reqLocaleString.equalsIgnoreCase("zh_HANS")){
		locale = new Locale("zh", "CN");
	}else if(reqLocaleString.equalsIgnoreCase("zh_HANT")){
		locale = new Locale("zh", "TW");
	}
	//dojo locale must use lower case string.
	djLocaleString = locale.toString().replaceAll("_","-").toLowerCase();
	
	
%>
<tiles:insert definition=".portlet.metric.range.error"/>
<input type="hidden" id="localeString" value="<%=djLocaleString%>" />
<input type="hidden" id="sundayLabel" value='<fmt:message key="common.alert.calendar.Sunday"/>' />
<input type="hidden" id="mondayLabel" value='<fmt:message key="common.alert.calendar.Monday"/>' />
<input type="hidden" id="tuesdayLabel" value='<fmt:message key="common.alert.calendar.Tuesday"/>' />
<input type="hidden" id="wednesdayLabel" value='<fmt:message key="common.alert.calendar.Wednesday"/>' />
<input type="hidden" id="thursdayLabel" value='<fmt:message key="common.alert.calendar.Thursday"/>' />
<input type="hidden" id="friddayLabel" value='<fmt:message key="common.alert.calendar.Friday"/>' />
<input type="hidden" id="staturdayLabel" value='<fmt:message key="common.alert.calendar.Saturday"/>' />
<input type="hidden" id="refreshCont" value="0" />
<table border="0" cellspacing="0" cellpadding="0">
  <tr>
  <logic:messagesPresent property="rn">
    <td width="20%" class="ErrorBlock">
  </logic:messagesPresent>
  
  <logic:messagesNotPresent property="rn">
    <td width="20%" class="SmokeyLabel">
  </logic:messagesNotPresent>
  
    <fmt:message key="resource.common.monitor.visibility.DefineRangeLabel"/></td>
<logic:messagesPresent property="rn">
    <td width="80%" class="ErrorField">
</logic:messagesPresent>
<logic:messagesNotPresent property="rn">
    <td width="80%" class="SmokeyContent">
</logic:messagesNotPresent>
      <html:radio property="a" value="1"/>
      <fmt:message key="monitoring.baseline.BlockContent.Last"/>&nbsp;&nbsp;
      <html:text property="rn" size="2" maxlength="3" styleClass="smallBox" onfocus="toggleRadio('a', 0);"/> 
      <html:select property="ru" onchange="toggleRadio('a', 0);">
<!--
        <html:option value="1" key="resource.common.monitor.visibility.metricsToolbar.CollectionPoints"/>
-->
        <html:option value="2"><fmt:message key="resource.common.monitor.visibility.config.Minutes"/></html:option>
        <html:option value="3"><fmt:message key="resource.common.monitor.visibility.config.Hours"/></html:option>
        <html:option value="4"><fmt:message key="resource.common.monitor.visibility.metricsToolbar.Days"/></html:option>
      </html:select>
    </td>
  </tr>
  <logic:messagesPresent property="rn">
  <tr>
       <td class="ErrorField" colspan="2" ><span class="ErrorFieldContent">- <html:errors property="rn"/></span></td>
  </tr>  
  </logic:messagesPresent>

  <tr>
    <td class="SmokeyLabel">&nbsp;</td>
<logic:messagesPresent property="endDate">
    <td width="80%" class="ErrorField">
</logic:messagesPresent>
<logic:messagesNotPresent property="endDate">
    <td width="80%" class="SmokeyContent">
</logic:messagesNotPresent>
      <html:radio property="a" value="2"/>
      <fmt:message key="monitoring.baseline.BlockContent.WithinRange"/>
      <br>

      <table width="100%" border="0" cellspacing="3" cellpadding="5" id="dateTimeInput">
        <tr> 
          <td><html:img page="/images/spacer.gif" width="20" height="20" border="0"/></td>
          <td nowrap>
            <fmt:message key="monitoring.baseline.BlockContent.From"/></td>
          <td width="100%" nowrap>
		  <input type="text" id="scheduleStartDate" value="" readonly="readonly" disabled />
            <html:select property="startMonth" styleId="startMonth" onchange="toggleRadio('a', 1); changeMonitorDropDown('startMonth', 'startDay', 'startYear');" style="display:none;"> 
              <html:option value="0"><fmt:message key="resource.control.schedule.jan"/></html:option>
              <html:option value="1"><fmt:message key="resource.control.schedule.feb"/></html:option>
              <html:option value="2"><fmt:message key="resource.control.schedule.mar"/></html:option>
              <html:option value="3"><fmt:message key="resource.control.schedule.apr"/></html:option>
              <html:option value="4"><fmt:message key="resource.control.schedule.may"/></html:option>
              <html:option value="5"><fmt:message key="resource.control.schedule.jun"/></html:option>
              <html:option value="6"><fmt:message key="resource.control.schedule.jul"/></html:option>
              <html:option value="7"><fmt:message key="resource.control.schedule.aug"/></html:option>
              <html:option value="8"><fmt:message key="resource.control.schedule.sep"/></html:option>
              <html:option value="9"><fmt:message key="resource.control.schedule.oct"/></html:option>
              <html:option value="10"><fmt:message key="resource.control.schedule.nov"/></html:option>
              <html:option value="11"><fmt:message key="resource.control.schedule.dec"/></html:option>
            </html:select>
            <html:select property="startDay" styleId="startDay" onchange="toggleRadio('a', 1);" style="display:none;"> 
              <html:option value="1">01</html:option>
              <html:option value="2">02</html:option>
              <html:option value="3">03</html:option>
              <html:option value="4">04</html:option>
              <html:option value="5">05</html:option>
              <html:option value="6">06</html:option>
              <html:option value="7">07</html:option>
              <html:option value="8">08</html:option>
              <html:option value="9">09</html:option>
              <html:option value="10">10</html:option>
              <html:option value="11">11</html:option>
              <html:option value="12">12</html:option>
              <html:option value="13">13</html:option>
              <html:option value="14">14</html:option>
              <html:option value="15">15</html:option>
              <html:option value="16">16</html:option>
              <html:option value="17">17</html:option>
              <html:option value="18">18</html:option>
              <html:option value="19">19</html:option>
              <html:option value="20">20</html:option>
              <html:option value="21">21</html:option>
              <html:option value="22">22</html:option>
              <html:option value="23">23</html:option>
              <html:option value="24">24</html:option>
              <html:option value="25">25</html:option>
              <html:option value="26">26</html:option>
              <html:option value="27">27</html:option>
              <html:option value="28">28</html:option>
              <html:option value="29">29</html:option>
              <html:option value="30">30</html:option>
              <html:option value="31">31</html:option>
            </html:select>
            <html:select property="startYear" styleId="startYear" onchange="toggleRadio('a', 1); changeMonitorDropDown('startMonth', 'startDay', 'startYear');" style="display:none;"> 
              <html:options property="yearOptions"/>
            </html:select>&nbsp;<!--<html:link href="#" onclick="toggleRadio('a', 1); calMonitor('startMonth', 'startDay', 'startYear'); return false;"><html:img page="/images/schedule_iconCal.gif" width="19" height="17" altKey="button.popupCalendar" titleKey="button.popupCalendar" border="0"/></html:link>-->
			<input type="hidden" id="calendarTitle" value="<fmt:message key='common.alert.calendar.title'/>"/>
			<html:link href="#" onclick="calUntilNow('startMonth', 'startDay', 'startYear'); return false;"><html:img page="/images/schedule_iconCal.gif" altKey="button.popupCalendar" titleKey="button.popupCalendar" width="19" height="17" hspace="5" border="0"/></html:link>
            &nbsp;<fmt:message key="schedule.datatime.separator"/>&nbsp;
			</td>
			<td nowrap>
            <html:text property="startHour" styleClass="smallBox" size="2" maxlength="2" onfocus="toggleRadio('a', 1);"/>&nbsp;:&nbsp;<html:text property="startMin" styleClass="smallBox" size="2" maxlength="2" onfocus="toggleRadio('a', 1);"/>&nbsp;
			</td>
			<td nowrap>
            <html:select property="startAmPm" onchange="toggleRadio('a', 1);"> 
              <html:option value="am"><fmt:message key="common.label.time.am"/></html:option>
              <html:option value="pm"><fmt:message key="common.label.time.pm"/></html:option>
            </html:select>&nbsp;
			</td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
          <td nowrap>
            <fmt:message key="monitoring.baseline.BlockContent.To"/>&nbsp;</td>
          <td width="100%" nowrap>
			<input type="text" id="scheduleEndDate" value="" readonly="readonly" disabled />
            <html:select property="endMonth" styleId="endMonth" onchange="toggleRadio('a', 1); changeMonitorDropDown('endMonth', 'endDay', 'endYear');" style="display:none;"> 
              <html:option value="0"><fmt:message key="resource.control.schedule.jan"/></html:option>
              <html:option value="1"><fmt:message key="resource.control.schedule.feb"/></html:option>
              <html:option value="2"><fmt:message key="resource.control.schedule.mar"/></html:option>
              <html:option value="3"><fmt:message key="resource.control.schedule.apr"/></html:option>
              <html:option value="4"><fmt:message key="resource.control.schedule.may"/></html:option>
              <html:option value="5"><fmt:message key="resource.control.schedule.jun"/></html:option>
              <html:option value="6"><fmt:message key="resource.control.schedule.jul"/></html:option>
              <html:option value="7"><fmt:message key="resource.control.schedule.aug"/></html:option>
              <html:option value="8"><fmt:message key="resource.control.schedule.sep"/></html:option>
              <html:option value="9"><fmt:message key="resource.control.schedule.oct"/></html:option>
              <html:option value="10"><fmt:message key="resource.control.schedule.nov"/></html:option>
              <html:option value="11"><fmt:message key="resource.control.schedule.dec"/></html:option>
            </html:select>
            <html:select property="endDay" styleId="endDay" onchange="toggleRadio('a', 1);" style="display:none;"> 
              <html:option value="1">01</html:option>
              <html:option value="2">02</html:option>
              <html:option value="3">03</html:option>
              <html:option value="4">04</html:option>
              <html:option value="5">05</html:option>
              <html:option value="6">06</html:option>
              <html:option value="7">07</html:option>
              <html:option value="8">08</html:option>
              <html:option value="9">09</html:option>
              <html:option value="10">10</html:option>
              <html:option value="11">11</html:option>
              <html:option value="12">12</html:option>
              <html:option value="13">13</html:option>
              <html:option value="14">14</html:option>
              <html:option value="15">15</html:option>
              <html:option value="16">16</html:option>
              <html:option value="17">17</html:option>
              <html:option value="18">18</html:option>
              <html:option value="19">19</html:option>
              <html:option value="20">20</html:option>
              <html:option value="21">21</html:option>
              <html:option value="22">22</html:option>
              <html:option value="23">23</html:option>
              <html:option value="24">24</html:option>
              <html:option value="25">25</html:option>
              <html:option value="26">26</html:option>
              <html:option value="27">27</html:option>
              <html:option value="28">28</html:option>
              <html:option value="29">29</html:option>
              <html:option value="30">30</html:option>
              <html:option value="31">31</html:option>
            </html:select>
            <html:select property="endYear" styleId="endYear" onchange="toggleRadio('a', 1); changeMonitorDropDown('endMonth', 'endDay', 'endYear');" style="display:none;">
              <html:options property="yearOptions"/>
            </html:select>&nbsp;
			<html:link href="#" onclick="calUntilNow('endMonth', 'endDay', 'endYear'); return false;"><html:img page="/images/schedule_iconCal.gif" altKey="button.popupCalendar" titleKey="button.popupCalendar" width="19" height="17"  hspace="5" border="0"/></html:link>
			<!--<html:link href="#" onclick="toggleRadio('a', 1); calMonitor('endMonth', 'endDay', 'endYear'); return false;"><html:img page="/images/schedule_iconCal.gif" width="19" height="17" alt="" border="0"/></html:link>-->
            &nbsp;<fmt:message key="schedule.datatime.separator"/>&nbsp;
			</td>
			<td nowrap>
            <html:text property="endHour" styleClass="smallBox" size="2" maxlength="2" onfocus="toggleRadio('a', 1);"/>&nbsp;:&nbsp;<html:text property="endMin" styleClass="smallBox" size="2" maxlength="2" onfocus="toggleRadio('a', 1);"/>&nbsp;
			</td>
			<td nowrap>
            <html:select property="endAmPm" onchange="toggleRadio('a', 1);">
              <html:option value="am"><fmt:message key="common.label.time.am"/></html:option>
              <html:option value="pm"><fmt:message key="common.label.time.pm"/></html:option>
            </html:select>&nbsp;
			</td>
			<jsu:script>									
				setStartDateInput();					
				setEndDateInput();	
				var localString = hqDojo.byId("localeString").value;				
				if(localString.indexOf('ja')>-1||localString.indexOf('zh')>-1||localString.indexOf('ko')>-1){
					var trs = hqDojo.query("tr",hqDojo.byId("dateTimeInput"));
					for(var i=0;i<trs.length;i++){
						var tds = hqDojo.query("td",trs[i]);
						var lastTd = tds[tds.length-1].innerHTML;
						tds[tds.length-1].innerHTML = tds[tds.length-2].innerHTML;
						tds[tds.length-2].innerHTML = lastTd;
					}
				}		
				
			</jsu:script>
        </tr>
<logic:messagesPresent property="endDate">
        <tr> 
          <td colspan="5">
            <span class="ErrorFieldContent">- <html:errors property="endDate"/></span>
          </td>
        </tr>
</logic:messagesPresent>
      </table>

    </td>
  </tr>
  <c:if test="${showRedraw}">
  <tr>
      <td class="SmokeyContent" colspan="2" align="center"><html:image property="advanced" altKey="button.redraw" page="/images/fb_redraw.gif" border="0" onmouseover="imageSwap(this, imagePath + 'fb_redraw', '_over');" onmouseout="imageSwap(this, imagePath +  'fb_redraw', '');" onmousedown="imageSwap(this, imagePath +  'fb_redraw', '_down')"/></td>
  </tr>
  </c:if>
  <tr>
    <td class="SmokeyLabel">&nbsp;</td>
    <td class="SmokeyContent"><span class="CaptionText"><fmt:message key="resource.common.monitor.visibility.TheseSettings"/></span></td>
  </tr>
</table>