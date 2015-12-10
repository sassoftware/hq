<%@ page language="java" %>
<%@ page errorPage="/common/Error.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/tld/hq.tld" prefix="hq" %>

<!--  BASELINE CONFIG TITLE -->
<tiles:insert definition=".header.tab">  
  <tiles:put name="tabKey" value="admin.settings.BaselineConfigTab"/>  
</tiles:insert>
<!--  /  -->

<!--  Baseline configuration -->
<table width="100%" cellpadding="0" cellspacing="0" border="0" class="tableBottomLine">
  <!-- Baseline frequency -->
  <tr>
    <td width="30%" class="BlockLabel"><fmt:message key="admin.settings.BaselineFrequencyLabel"/></td>
    <td width="40%" class="BlockContent">
      <table width="100%" cellpadding="0" cellspacing="0" border="0">
        <tr>
<logic:messagesPresent property="baselineFrequencyVal">
          <td class="ErrorField">
            <html:text size="2" property="baselineFrequencyVal" />
          </td>
          <td class="ErrorField" width="100%">
            <fmt:message key="admin.settings.Days"/>
          </td>
</logic:messagesPresent>          
<logic:messagesNotPresent property="baselineFrequencyVal">
          <td class="BlockContent">
            <html:text size="2" property="baselineFrequencyVal" />
          </td>
          <td class="BlockContent" width="100%">
            <fmt:message key="admin.settings.Days"/>
          </td>
</logic:messagesNotPresent>          
        </tr>
<logic:messagesPresent property="baselineFrequencyVal">
        <tr>
          <td class="ErrorField" colspan="2">
            <span class="ErrorFieldContent">- <html:errors property="baselineFrequencyVal"/></span>            
          </td>
        </tr>
</logic:messagesPresent>
<logic:messagesNotPresent property="baselineFrequencyVal">
        <tr>
          <td class="BlockContent" colspan="2">
          </td>
        </tr>
</logic:messagesNotPresent>
      </table>
    </td>
    <td colspan="2" class="BlockLabel">
    </td>
  </tr>
  <!-- Baseline dataset -->
  <tr>
    <td class="BlockLabel"><fmt:message key="admin.settings.BaselineDataSet"/></td>
    <td class="BlockContent">
      <table width="100%" cellpadding="0" cellspacing="0" border="0">
        <tr>
<logic:messagesPresent property="baselineDataSetVal">
          <td class="ErrorField">
            <html:text size="2" property="baselineDataSetVal" />
          </td>
          <td class="ErrorField" width="100%">
            <fmt:message key="admin.settings.Days"/>
          </td>
</logic:messagesPresent>          
<logic:messagesNotPresent property="baselineDataSetVal">
          <td class="BlockContent">
            <html:text size="2" property="baselineDataSetVal" />
          </td>
          <td class="BlockContent" width="100%">
            <fmt:message key="admin.settings.Days"/>
          </td>
</logic:messagesNotPresent>          
        </tr>
<logic:messagesPresent property="baselineDataSetVal">
        <tr>
          <td class="ErrorField" colspan="2">
            <span class="ErrorFieldContent">- <html:errors property="baselineDataSetVal"/></span>            
          </td>
        </tr>
</logic:messagesPresent>
<logic:messagesNotPresent property="baselineDataSetVal">
        <tr>
          <td class="BlockContent" colspan="2">
          </td>
        </tr>
</logic:messagesNotPresent>
      </table>
    </td>
    <td class="BlockLabel"/>
    <td class="BlockContent">
    </td>
  </tr>
  <!-- Baseline min set -->
  <tr>
    <td class="BlockLabel"><fmt:message key="admin.settings.BaselineMinSet"/></td>
    <td class="BlockContent"><html:text size="3" property="baselineMinSet"/></td>
    <td class="BlockContent" colspan="2">&nbsp;</td>
  </tr>
  <tr>
    <td class="BlockLabel"><fmt:message key="admin.settings.OOBEnabled"/></td>
    <td class="BlockContent">
        <html:radio value="true" property="oobEnabled"/><fmt:message key="ON"/>
        <html:radio value="false" property="oobEnabled"/><fmt:message key="OFF"/></td>
    <td class="BlockContent" colspan="2">&nbsp;</td>
  </tr>
</table>

<!--  /  -->


