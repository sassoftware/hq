<%@ page language="java" %>
<%@ page errorPage="/common/Error.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html" %>

    <tr>
      <td class="BlockLabel">
        <fmt:message key="alert.config.props.CB.Recovery"/>
      </td>
      <td class="BlockContent">
        <fmt:message key="alert.config.props.CB.label.SelectAlertName"/>&nbsp
          <html:select property="recoverId" onchange="javascript:checkRecover();">
            <html:option value="" key="alert.dropdown.SelectOption"/>
            <html:optionsCollection property="alertnames" label="key" value="value"/>
          </html:select>
       </td>
    </tr>

