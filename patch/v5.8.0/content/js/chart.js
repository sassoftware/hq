// NOTE: This copyright does *not* cover user programs that use HQ
// program services by normal system calls through the application
// program interfaces provided as part of the Hyperic Plug-in Development
// Kit or the Hyperic Client Development Kit - this is merely considered
// normal use of the program, and does *not* fall under the heading of
// "derived work".
// 
// Copyright (C) [2004, 2005, 2006], Hyperic, Inc.
// This file is part of HQ.
// 
// HQ is free software; you can redistribute it and/or modify
// it under the terms version 2 of the GNU General Public License as
// published by the Free Software Foundation. This program is distributed
// in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
// even the implied warranty of MERCHANTABILITY or FITNESS FOR A
// PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
// 
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
// USA.


/*-- START chart.js --*/



function onClickFun(btnid){
return function(){
 document.getElementById(btnid).click();
}
}




function ReplaceButton(divId, tdId, tdState, btnId, btnFunction) {
	var td = document.getElementById(tdId);
  if (td == null)
        return;
 	var oldDiv = document.getElementById(divId);
	var newDiv = document.createElement("DIV");
	newDiv.setAttribute("id", divId);
	var oldBtn = document.getElementById(btnId);
	var newLabel;
	if (oldBtn != null)
        newLabel=oldBtn.getAttribute("value");

	var txtState = "enabled";
	if (tdState=="off"){
		txtState = "disabled";
	}
	var inputName = btnFunction;
	if (tdState == "on") {
		var newInput = document.createElement("INPUT");
		newInput.setAttribute("id", btnId);
		newInput.setAttribute("type", "BUTTON");
		newInput.setAttribute("value", newLabel);
		newInput.setAttribute("class", "button42");
		newInput.setAttribute("name", inputName+"_button");
		if (document.createEventObject){
		    newInput.attachEvent("onclick",onClickFun(newInput.id+'_img_id'));
		}else{
		    newInput.setAttribute("onclick","document.getElementById(this.id+'_img_id').click();");
		}
		newInput.removeAttribute("disabled");
		newDiv.appendChild(newInput);
		var newImageInput = document.createElement("INPUT");
        newImageInput.setAttribute("type", "image");
        newImageInput.setAttribute("name", inputName);
        newImageInput.setAttribute("id", btnId+"_img_id");
        //newImageInput.setAttribute("style","display:none;");
        newImageInput.style.display="none";
        newDiv.appendChild(newImageInput);
	}
	else {
		var newInput = document.createElement("INPUT");
		newInput.setAttribute("id", btnId);
		newInput.setAttribute("type", "BUTTON");
		newInput.setAttribute("value", newLabel);
		newInput.setAttribute("class", "button42");
		newInput.setAttribute("name", inputName);
		newInput.setAttribute("disabled",txtState);
		if (document.createEventObject){
		}else{
		 newInput.removeAttribute("class");
		}
		newDiv.appendChild(newInput);
	}
	if (td!=null)
		td.replaceChild(newDiv,oldDiv);
}
function ToggleButtons(widgetInstanceName, prefix, form) {
    var btnFunction = "redraw";
    var btnId = prefix + "RedrawButton";

    var numSelected = getWidgetProperty(widgetInstanceName, "numSelected");

    if (numSelected < 0) {
        numSelected = getNumCheckedByClass(form, "listMember");
        setWidgetProperty(widgetInstanceName, "numSelected", numSelected);
    }

    if (numSelected == 0) {
        ReplaceButton(prefix + "RedrawDiv", prefix + "RedrawTd", "off", btnId, btnFunction);
    }

    else if (numSelected >= 1) {
        ReplaceButton(prefix + "RedrawDiv", prefix + "RedrawTd", "on", btnId, btnFunction);
    }
}

function ToggleSelection(e, widgetProperties, maxNum, messageStr) {
    if (isIE)
        e = event.srcElement;

    if (maxNum!=null) {
        var numChecked = getNumChecked(e.form, e.getAttribute("name"));
        if (numChecked > maxNum) {
            e.checked = false;
            alert(messageStr);
            return;
        }
    }

    widgetInstanceName = widgetProperties["name"];
    var prefix = widgetInstanceName;

    var form = e.form;
    var numSelected = getWidgetProperty(widgetInstanceName, "numSelected");

    if (e.checked) {
        highlight(e);
        setWidgetProperty(widgetInstanceName, "numSelected", ++numSelected);
    } else {
        unhighlight(e);
        var numSelected = getWidgetProperty(widgetInstanceName, "numSelected");
        setWidgetProperty(widgetInstanceName, "numSelected", --numSelected);
    }

    ToggleButtons(widgetInstanceName, prefix, form);
}

function getNumChecked(uList, nameStr) {
    var len = uList.elements.length;
    var numCheckboxes = 0;

    for (var i = 0; i < len; i++) {
        var e = uList.elements[i];
        if (e.getAttribute("name")==nameStr && e.checked) {
            numCheckboxes++;
        }
    }

    return numCheckboxes;
}

function checkboxToggled(cb, hidden) {
    var checkbox = document.getElementsByName(cb)[0];
    var field = document.getElementsByName(hidden)[0];

    if (checkbox.checked) {
        field.value = "true";
    } else {
        field.value = "false";
    }
}

function testCheckboxes(widgetInstanceName) {
  var e = document.getElementById("privateChart");
  var thisForm = e.form;

  var numChecked = getNumCheckedByClass(thisForm, "metricList") + getNumCheckedByClass(thisForm, "resourceList");
  setWidgetProperty(widgetInstanceName, "numSelected", numChecked);
  
  ToggleButtons(widgetInstanceName, widgetInstanceName, thisForm);
}
/*-- END chart.js --*/
