<%@ page language="java"%>
<%@ page errorPage="/common/Error.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/tld/hq.tld" prefix="hq" %>
<%@ taglib tagdir="/WEB-INF/tags/jsUtils" prefix="jsu" %>

<jsu:script>
    function checkDateStart(elt) {
        var index = elt.selectedIndex;
        var elems = elt.form.elements;
        for (var i = 0; i < elems.length; i++) {
            if (elems[i] == elt) {
                var startOption = elems[i].options[elems[i].selectedIndex].value;
                var endOption = elems[i + 1].options[elems[i + 1].selectedIndex].value;
                if (startOption == endOption) {
                    disableSaveButton();
                    alert('<fmt:message key="admin.role.error.SelectAnotherStartTime" />');
                } else {
                    enableSaveButton();
                }
            }
        }
    }

  function checkDateEnd(elt) {
      var index = elt.selectedIndex;
      var elems = elt.form.elements;
      for (var i = 0; i < elems.length; i++) {
          if (elems[i] == elt) {
              var endOption = elems[i].options[elems[i].selectedIndex].value;
              var startOption = elems[i - 1].options[elems[i - 1].selectedIndex].value;
              if (endOption == startOption) {
                  disableSaveButton();
                  alert('<fmt:message key="admin.role.error.SelectAnotherEndTime" />');
              } else {
                   enableSaveButton();
              }
          }
        }
  }

     function enableSaveButton() {
    var form = document.forms['RoleCalendarForm'];
    for (var i = 0; i < form.elements.length; i++) {
        if (form.elements[i].type == 'submit' &&
            form.elements[i].className == 'CompactButtonInactive') {
            form.elements[i].disabled = false;
            form.elements[i].className = 'CompactButton';
        }
    }
  }

   function disableSaveButton() {
    var form = document.forms['RoleCalendarForm'];
    for (var i = 0; i < form.elements.length; i++) {
        if (form.elements[i].type == 'submit' &&
            form.elements[i].className == 'CompactButton') {
            form.elements[i].disabled = false;
            form.elements[i].className = 'CompactButtonInactive';
        }
    }
  }
</jsu:script>

<tiles:insert definition=".header.tab">
  <tiles:put name="tabKey" value="admin.role.props.AlertCalendarTab" />
</tiles:insert>

<!--  ALERT CALENDAR -->
<html:form action="/admin/role/SaveNotificationCalendar">
  <table width="100%" cellspacing="0" class="TableBottomLine">
    <tr>
      <td class="BlockLabel" width="5%">
        <html:checkbox property="weekdays[1]" onclick="enableSaveButton()" />
      </td>
      <td class="BlockLabel" width="10%" style="text-align: left; padding: 6px;">
        <fmt:message key="admin.role.alert.Monday" />
      </td>
      <td class="BlockLabel" width="5%">
        <fmt:message key="admin.role.alert.from" />
      </td>
      <logic:messagesPresent property="starts[1]"><td class="ErrorField" width="5%"></logic:messagesPresent>
      <logic:messagesNotPresent property="starts[1]"><td class="BlockContent" width="5%"></logic:messagesNotPresent>
      <html:select property="starts[1]" onchange="checkDateStart(this)">
        <html:optionsCollection property="startOptions" />
      </html:select></td>
      <td class="BlockLabel" width="5%"><fmt:message
        key="admin.role.alert.to" /></td>
      <logic:messagesPresent property="starts[1]"><td class="ErrorField" width="23%"><table><tr><td></logic:messagesPresent>
      <logic:messagesNotPresent property="starts[1]"><td class="BlockContent" width="23%"></logic:messagesNotPresent>
        <html:select property="ends[1]" onchange="checkDateEnd(this)">
        <html:optionsCollection property="endOptions" />
      </html:select>
      <logic:messagesPresent property="starts[1]"></td><td class="ErrorFieldContent"><html:errors property="starts[1]"/></td></tr></table></logic:messagesPresent>
      </td>
      <td class="BlockLabel" width="5%">
        <html:checkbox property="excepts[1]" onclick="enableSaveButton()" />
      </td>
      <td class="BlockLabel" width="8%" style="text-align: left;">
        <fmt:message key="admin.role.alert.except" />
      </td>
      <td class="BlockLabel" width="5%">
        <fmt:message key="admin.role.alert.from" />
      </td>
      <logic:messagesPresent property="exstarts[1]"><td class="ErrorField" width="5%"></logic:messagesPresent>
      <logic:messagesNotPresent property="exstarts[1]"><td class="BlockContent" width="5%"></logic:messagesNotPresent>
        <html:select property="exstarts[1]" onchange="checkDateStart(this)">
          <html:optionsCollection property="startOptions" />
        </html:select>
      </td>
      <td class="BlockLabel" width="5%">
        <fmt:message key="admin.role.alert.to" />
      </td>
      <logic:messagesPresent property="exstarts[1]"><td class="ErrorField" width="22%"><table><tr><td></logic:messagesPresent>
      <logic:messagesNotPresent property="exstarts[1]"><td class="BlockContent" width="22%"></logic:messagesNotPresent>
        <html:select property="exends[1]" onchange="checkDateEnd(this)">
          <html:optionsCollection property="endOptions" />
        </html:select>
      <logic:messagesPresent property="exstarts[1]"></td><td class="ErrorFieldContent"><html:errors property="exstarts[1]"/></td></tr></table></logic:messagesPresent>
      </td>
    </tr>
    <tr>
      <td colspan="12" class="BlockBottomLine"> </td>
    </tr>
    <tr>
      <td class="BlockLabel">
        <html:checkbox property="weekdays[2]" onclick="enableSaveButton()"/>
      </td>
      <td class="BlockLabel" style="text-align: left; padding: 6px;">
        <fmt:message key="admin.role.alert.Tuesday" />
      </td>
      <td class="BlockLabel"><fmt:message key="admin.role.alert.from" /></td>
      <logic:messagesPresent property="starts[2]"><td class="ErrorField"></logic:messagesPresent>
      <logic:messagesNotPresent property="starts[2]"><td class="BlockContent"></logic:messagesNotPresent>
        <html:select property="starts[2]" onchange="checkDateStart(this)">
          <html:optionsCollection property="startOptions" />
        </html:select>
      </td>
      <td class="BlockLabel"><fmt:message key="admin.role.alert.to" /></td>
      <logic:messagesPresent property="starts[2]"><td class="ErrorField"><table><tr><td></logic:messagesPresent>
      <logic:messagesNotPresent property="starts[2]"><td class="BlockContent"></logic:messagesNotPresent>
        <html:select property="ends[2]" onchange="checkDateEnd(this)">
          <html:optionsCollection property="endOptions" />
        </html:select>
      <logic:messagesPresent property="starts[2]"></td><td class="ErrorFieldContent"><html:errors property="starts[2]"/></td></tr></table></logic:messagesPresent>
      </td>
      <td class="BlockLabel">
        <html:checkbox property="excepts[2]" onclick="enableSaveButton()" />
      </td>
      <td class="BlockLabel" style="text-align: left;">
        <fmt:message key="admin.role.alert.except" />
      </td>
      <td class="BlockLabel">
        <fmt:message key="admin.role.alert.from" />
      </td>
      <logic:messagesPresent property="exstarts[2]"><td class="ErrorField"></logic:messagesPresent>
      <logic:messagesNotPresent property="exstarts[2]"><td class="BlockContent"></logic:messagesNotPresent>
        <html:select property="exstarts[2]" onchange="checkDateStart(this)">
          <html:optionsCollection property="startOptions" />
        </html:select>
      </td>
      <td class="BlockLabel">
        <fmt:message key="admin.role.alert.to" />
      </td>
      <logic:messagesPresent property="exstarts[2]"><td class="ErrorField"><table><tr><td></logic:messagesPresent>
      <logic:messagesNotPresent property="exstarts[2]"><td class="BlockContent"></logic:messagesNotPresent>
        <html:select property="exends[2]" onchange="checkDateEnd(this)">
          <html:optionsCollection property="endOptions" />
        </html:select>
      <logic:messagesPresent property="exstarts[2]"></td><td class="ErrorFieldContent"><html:errors property="exstarts[2]"/></td></tr></table></logic:messagesPresent>
      </td>
    </tr>
    <tr>
      <td colspan="12" class="BlockBottomLine"> </td>
    </tr>
    <tr>
      <td class="BlockLabel">
        <html:checkbox property="weekdays[3]" onclick="enableSaveButton()"/>
      </td>
      <td class="BlockLabel" style="text-align: left; padding: 6px;">
        <fmt:message key="admin.role.alert.Wednesday" />
      </td>
      <td class="BlockLabel"><fmt:message key="admin.role.alert.from" /></td>
      <logic:messagesPresent property="starts[3]"><td class="ErrorField"></logic:messagesPresent>
      <logic:messagesNotPresent property="starts[3]"><td class="BlockContent"></logic:messagesNotPresent>
        <html:select property="starts[3]" onchange="checkDateStart(this)">
          <html:optionsCollection property="startOptions" />
        </html:select>
      </td>
      <td class="BlockLabel"><fmt:message key="admin.role.alert.to" /></td>
      <logic:messagesPresent property="starts[3]"><td class="ErrorField"><table><tr><td></logic:messagesPresent>
      <logic:messagesNotPresent property="starts[3]"><td class="BlockContent"></logic:messagesNotPresent>
        <html:select property="ends[3]" onchange="checkDateEnd(this)">
          <html:optionsCollection property="endOptions" />
        </html:select>
      <logic:messagesPresent property="starts[3]"></td><td class="ErrorFieldContent"><html:errors property="starts[2]"/></td></tr></table></logic:messagesPresent>
      </td>
      <td class="BlockLabel">
        <html:checkbox property="excepts[3]" onclick="enableSaveButton()" />
      </td>
      <td class="BlockLabel" style="text-align: left;">
        <fmt:message key="admin.role.alert.except" />
      </td>
      <td class="BlockLabel">
        <fmt:message key="admin.role.alert.from" />
      </td>
      <logic:messagesPresent property="exstarts[3]"><td class="ErrorField"></logic:messagesPresent>
      <logic:messagesNotPresent property="exstarts[3]"><td class="BlockContent"></logic:messagesNotPresent>
        <html:select property="exstarts[3]" onchange="checkDateStart(this)">
          <html:optionsCollection property="startOptions" />
        </html:select>
      </td>
      <td class="BlockLabel">
        <fmt:message key="admin.role.alert.to" />
      </td>
      <logic:messagesPresent property="exstarts[3]"><td class="ErrorField"><table><tr><td></logic:messagesPresent>
      <logic:messagesNotPresent property="exstarts[3]"><td class="BlockContent"></logic:messagesNotPresent>
        <html:select property="exends[3]" onchange="checkDateEnd(this)">
          <html:optionsCollection property="endOptions" />
        </html:select>
      <logic:messagesPresent property="exstarts[3]"></td><td class="ErrorFieldContent"><html:errors property="exstarts[3]"/></td></tr></table></logic:messagesPresent>
      </td>
    </tr>
    <tr>
      <td colspan="12" class="BlockBottomLine"> </td>
    </tr>
    <tr>
      <td class="BlockLabel">
        <html:checkbox property="weekdays[4]" onclick="enableSaveButton()"/>
      </td>
      <td class="BlockLabel" style="text-align: left; padding: 6px;">
        <fmt:message key="admin.role.alert.Thursday" />
      </td>
      <td class="BlockLabel"><fmt:message key="admin.role.alert.from" /></td>
      <logic:messagesPresent property="starts[4]"><td class="ErrorField"></logic:messagesPresent>
      <logic:messagesNotPresent property="starts[4]"><td class="BlockContent"></logic:messagesNotPresent>
        <html:select property="starts[4]" onchange="checkDateStart(this)">
          <html:optionsCollection property="startOptions" />
        </html:select>
      </td>
      <td class="BlockLabel"><fmt:message key="admin.role.alert.to" /></td>

      <logic:messagesPresent property="starts[4]"><td class="ErrorField"><table><tr><td></logic:messagesPresent>
      <logic:messagesNotPresent property="starts[4]"><td class="BlockContent"></logic:messagesNotPresent>
        <html:select property="ends[4]" onchange="checkDateEnd(this)">
          <html:optionsCollection property="endOptions" />
        </html:select>
      <logic:messagesPresent property="starts[4]"></td><td class="ErrorFieldContent"><html:errors property="starts[4]"/></td></tr></table></logic:messagesPresent>
      </td>
      <td class="BlockLabel">
        <html:checkbox property="excepts[4]" onclick="enableSaveButton()" />
      </td>
      <td class="BlockLabel" style="text-align: left;">
        <fmt:message key="admin.role.alert.except" />
      </td>
      <td class="BlockLabel">
        <fmt:message key="admin.role.alert.from" />
      </td>
      <logic:messagesPresent property="exstarts[4]"><td class="ErrorField"></logic:messagesPresent>
      <logic:messagesNotPresent property="exstarts[4]"><td class="BlockContent"></logic:messagesNotPresent>
        <html:select property="exstarts[4]" onchange="checkDateStart(this)">
          <html:optionsCollection property="startOptions" />
        </html:select>
      </td>
      <td class="BlockLabel">
        <fmt:message key="admin.role.alert.to" />
      </td>
      <logic:messagesPresent property="exstarts[4]"><td class="ErrorField"><table><tr><td></logic:messagesPresent>
      <logic:messagesNotPresent property="exstarts[4]"><td class="BlockContent"></logic:messagesNotPresent>
        <html:select property="exends[4]" onchange="checkDateEnd(this)">
          <html:optionsCollection property="endOptions" />
        </html:select>
      <logic:messagesPresent property="exstarts[4]"></td><td class="ErrorFieldContent"><html:errors property="exstarts[4]"/></td></tr></table></logic:messagesPresent>
      </td>
    </tr>
    <tr>
      <td colspan="12" class="BlockBottomLine"> </td>
    </tr>
    <tr>
      <td class="BlockLabel">
        <html:checkbox property="weekdays[5]" onclick="enableSaveButton()"/>
      </td>
      <td class="BlockLabel" style="text-align: left; padding: 6px;">
        <fmt:message key="admin.role.alert.Friday" />
      </td>
      <td class="BlockLabel"><fmt:message key="admin.role.alert.from" /></td>
      <logic:messagesPresent property="starts[5]"><td class="ErrorField"></logic:messagesPresent>
      <logic:messagesNotPresent property="starts[5]"><td class="BlockContent"></logic:messagesNotPresent>
        <html:select property="starts[5]" onchange="checkDateStart(this)">
          <html:optionsCollection property="startOptions" />
        </html:select>
      </td>
      <td class="BlockLabel"><fmt:message key="admin.role.alert.to" /></td>
      <logic:messagesPresent property="starts[5]"><td class="ErrorField"><table><tr><td></logic:messagesPresent>
      <logic:messagesNotPresent property="starts[5]"><td class="BlockContent"></logic:messagesNotPresent>
        <html:select property="ends[5]" onchange="checkDateEnd(this)">
          <html:optionsCollection property="endOptions" />
        </html:select>
      <logic:messagesPresent property="starts[5]"></td><td class="ErrorFieldContent"><html:errors property="starts[5]"/></td></tr></table></logic:messagesPresent>
      </td>
      <td class="BlockLabel">
        <html:checkbox property="excepts[5]" onclick="enableSaveButton()" />
      </td>
      <td class="BlockLabel" style="text-align: left;">
        <fmt:message key="admin.role.alert.except" />
      </td>
      <td class="BlockLabel">
        <fmt:message key="admin.role.alert.from" />
      </td>
      <logic:messagesPresent property="exstarts[5]"><td class="ErrorField"></logic:messagesPresent>
      <logic:messagesNotPresent property="exstarts[5]"><td class="BlockContent"></logic:messagesNotPresent>
        <html:select property="exstarts[5]" onchange="checkDateStart(this)">
          <html:optionsCollection property="startOptions" />
        </html:select>
      </td>
      <td class="BlockLabel">
        <fmt:message key="admin.role.alert.to" />
      </td>
      <logic:messagesPresent property="exstarts[5]"><td class="ErrorField"><table><tr><td></logic:messagesPresent>
      <logic:messagesNotPresent property="exstarts[5]"><td class="BlockContent"></logic:messagesNotPresent>
        <html:select property="exends[5]" onchange="checkDateEnd(this)">
          <html:optionsCollection property="endOptions" />
        </html:select>
      <logic:messagesPresent property="exstarts[5]"></td><td class="ErrorFieldContent"><html:errors property="exstarts[5]"/></td></tr></table></logic:messagesPresent>
      </td>
    </tr>
    <tr>
      <td colspan="12" class="BlockBottomLine"> </td>
    </tr>
    <tr>
      <td class="BlockLabel">
        <html:checkbox property="weekdays[6]" onclick="enableSaveButton()"/>
      </td>
      <td class="BlockLabel" style="text-align: left; padding: 6px;">
        <fmt:message key="admin.role.alert.Saturday" />
      </td>
      <td class="BlockLabel"><fmt:message key="admin.role.alert.from" /></td>
      <logic:messagesPresent property="starts[6]"><td class="ErrorField"></logic:messagesPresent>
      <logic:messagesNotPresent property="starts[6]"><td class="BlockContent"></logic:messagesNotPresent>
        <html:select property="starts[6]" onchange="checkDateStart(this)">
          <html:optionsCollection property="startOptions" />
        </html:select>
      </td>
      <td class="BlockLabel"><fmt:message key="admin.role.alert.to" /></td>
      <logic:messagesPresent property="starts[6]"><td class="ErrorField"><table><tr><td></logic:messagesPresent>
      <logic:messagesNotPresent property="starts[6]"><td class="BlockContent"></logic:messagesNotPresent>
        <html:select property="ends[6]" onchange="checkDateEnd(this)">
          <html:optionsCollection property="endOptions" />
        </html:select>
      <logic:messagesPresent property="starts[6]"></td><td class="ErrorFieldContent"><html:errors property="starts[6]"/></td></tr></table></logic:messagesPresent>
      </td>
      <td class="BlockLabel">
        <html:checkbox property="excepts[6]" onclick="enableSaveButton()" />
      </td>
      <td class="BlockLabel" style="text-align: left;">
        <fmt:message key="admin.role.alert.except" />
      </td>
      <td class="BlockLabel">
        <fmt:message key="admin.role.alert.from" />
      </td>
      <logic:messagesPresent property="exstarts[6]"><td class="ErrorField"></logic:messagesPresent>
      <logic:messagesNotPresent property="exstarts[6]"><td class="BlockContent"></logic:messagesNotPresent>
        <html:select property="exstarts[6]" onchange="checkDateStart(this)">
          <html:optionsCollection property="startOptions" />
        </html:select>
      </td>
      <td class="BlockLabel">
        <fmt:message key="admin.role.alert.to" />
      </td>
      <logic:messagesPresent property="exstarts[6]"><td class="ErrorField"><table><tr><td></logic:messagesPresent>
      <logic:messagesNotPresent property="exstarts[6]"><td class="BlockContent"></logic:messagesNotPresent>
        <html:select property="exends[6]" onchange="checkDateEnd(this)">
          <html:optionsCollection property="endOptions" />
        </html:select>
      <logic:messagesPresent property="exstarts[6]"></td><td class="ErrorFieldContent"><html:errors property="exstarts[6]"/></td></tr></table></logic:messagesPresent>
      </td>
    </tr>
    <tr>
      <td colspan="12" class="BlockBottomLine"> </td>
    </tr>
    <tr>
      <td class="BlockLabel">
        <html:checkbox property="weekdays[0]" onclick="enableSaveButton()"/>
      </td>
      <td class="BlockLabel" style="text-align: left; padding: 6px;">
        <fmt:message key="admin.role.alert.Sunday" />
      </td>
      <td class="BlockLabel"><fmt:message key="admin.role.alert.from" /></td>
      <logic:messagesPresent property="starts[0]"><td class="ErrorField"></logic:messagesPresent>
      <logic:messagesNotPresent property="starts[0]"><td class="BlockContent"></logic:messagesNotPresent>
        <html:select property="starts[0]" onchange="checkDateStart(this)">
          <html:optionsCollection property="startOptions" />
        </html:select>
      </td>
      <td class="BlockLabel"><fmt:message key="admin.role.alert.to" /></td>
      <logic:messagesPresent property="starts[0]"><td class="ErrorField"><table><tr><td></logic:messagesPresent>
      <logic:messagesNotPresent property="starts[0]"><td class="BlockContent"></logic:messagesNotPresent>
        <html:select property="ends[0]" onchange="checkDateEnd(this)">
          <html:optionsCollection property="endOptions" />
        </html:select>
      <logic:messagesPresent property="starts[0]"></td><td class="ErrorFieldContent"><html:errors property="starts[0]"/></td></tr></table></logic:messagesPresent>
      </td>
      <td class="BlockLabel">
        <html:checkbox property="excepts[0]" onclick="enableSaveButton()" />
      </td>
      <td class="BlockLabel" style="text-align: left;">
        <fmt:message key="admin.role.alert.except" />
      </td>
      <td class="BlockLabel">
        <fmt:message key="admin.role.alert.from" />
      </td>
      <logic:messagesPresent property="exstarts[0]"><td class="ErrorField"></logic:messagesPresent>
      <logic:messagesNotPresent property="exstarts[0]"><td class="BlockContent"></logic:messagesNotPresent>
        <html:select property="exstarts[0]" onchange="checkDateStart(this)">
          <html:optionsCollection property="startOptions" />
        </html:select>
      </td>
      <td class="BlockLabel">
        <fmt:message key="admin.role.alert.to" />
      </td>
      <logic:messagesPresent property="exstarts[0]"><td class="ErrorField"><table><tr><td></logic:messagesPresent>
      <logic:messagesNotPresent property="exstarts[0]"><td class="BlockContent"></logic:messagesNotPresent>
        <html:select property="exends[0]" onchange="checkDateEnd(this)">
          <html:optionsCollection property="endOptions" />
        </html:select>
      <logic:messagesPresent property="exstarts[0]"></td><td class="ErrorFieldContent"><html:errors property="exstarts[0]"/></td></tr></table></logic:messagesPresent>
      </td>
    </tr>
    <c:if test="${useroperations['modifySubject']}">
    <tr class="ToolbarContent">
      <td colspan="12" class="ListCell" style="padding: 5px;">
        <input type="submit" name="buttonAction"
               value="<fmt:message key="common.label.Save"/>"
               class="CompactButtonInactive" disabled="true">
      </td>
    </tr>
    </c:if>
  </table>
<html:hidden property="r"/>
</html:form>
<!--  /  -->
