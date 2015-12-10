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

/*----------- start DECLARATIONS -----------*/
var today = new Date();
var date = today.getDate(); // from 1 to 31
var dayOfWeek = today.getDay(); // from 0 to 6 (Sun - Sat)
var month = today.getMonth(); // from 0 to 11
var year = today.getFullYear();

var SEL_STARTYEAR = today.getFullYear();
var SEL_NUMYEARS = 5;

var START_DATE = date;
var START_MONTH = month;
var START_YEAR = year;

var endDate = START_DATE;
var endMonth = START_MONTH;
var endYear = START_YEAR;

/* //in case we want endDate to be different from START_DATE
if (endDate > getAllDaysInMonth(START_MONTH, START_YEAR)) {
  endDate = endDate - getAllDaysInMonth(START_MONTH);
  endMonth = START_MONTH + 1;
  if (endMonth > 11) {
    endMonth = 0;
    endYear = START_YEAR + 1;
  }
}
*/

var schedDate = new Date();
var schedEndDate = new Date();

var monthArr = new Array(
  "01",
  "02",
  "03",
  "04",
  "05",
  "06",
  "07",
  "08",
  "09",
  "10",
  "11",
  "12");

var weekArr = new Array("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday");

var yearArr = new Array();
for (i=0; i<SEL_NUMYEARS; i++) {
  yearArr[i] = SEL_STARTYEAR + i;
  yearOpt = document.getElementById("startYear"+i);
  if (yearOpt != null){
    yearOpt.text=yearArr[i];
    yearOpt.value=yearArr[i];
  }
  
  yearOpt = document.getElementById("endYear"+i);
  if (yearOpt != null){
    yearOpt.text=yearArr[i];
    yearOpt.value=yearArr[i];
  }
}
/*----------- end DECLARATIONS -----------*/

/* start and end parameters are passed in the same fashion as writing a date, i.e. 8/11/74
 * end* parameters may be null or empty
 * recurInterval will be one of "recurNever" "recurDaily" "recurWeekly" "recurMonthly"
 * Month fields are 0 indexed - i.e. Aug == 7
 * Day fields are 1 indexed - i.e 1st == 1
 * Year is literal - "2004" is "2004"
 */
function init(jspStartMonth, jspStartDay, jspStartYear, jspEndMonth, jspEndDay, jspEndYear, recurInterval) {
  if (document.getElementById("recur")!=null) {
    hideDiv("recur");
    hideDiv("recurNever");
    hideDiv("recurDaily");
    hideDiv("recurWeekly");
    hideDiv("recurMonthly");
    hideDiv("recurrenceEnd");
  }
  
  if (recurInterval && (recurInterval != "recurNever")) {
    showDiv("recur");
    setRecurDropdown(recurInterval);
    showDiv(recurInterval);
    showDiv("recurrenceEnd");
  }

  setSelect("startDay", START_DATE-1);
  setSelect("startMonth", START_MONTH);
  setSelect("startYear", START_YEAR - SEL_STARTYEAR);

  setSelect("endDay", endDate-1);
  setSelect("endMonth", endMonth);
  setSelect("endYear", endYear - SEL_STARTYEAR);
  
  // changeDropDown ("startMonth", "startDay", "startYear");
  // changeDropDown ("endMonth", "endDay", "endYear");
  
  if (typeof jspStartMonth != 'undefined') {
    setFullDate(schedDate, jspStartMonth, jspStartDay, jspStartYear);
    // resetDropdowns('startMonth', 'startDay', 'startYear');
    setSelect("startDay", jspStartDay - 1);
    setSelect("startMonth", jspStartMonth);
    setSelect("startYear", jspStartYear - SEL_STARTYEAR);
  }
  
  if (typeof jspEndYear != 'undefined') {
    setFullDate(schedEndDate, jspEndMonth, jspEndDay, jspEndYear);
    // resetDropdowns('endMonth', 'endDay', 'endYear');
    setSelect("endDay", jspEndDay - 1);
    setSelect("endMonth", jspEndMonth);
    setSelect("endYear", jspEndYear - SEL_STARTYEAR);
  }
  
}

/*----------- start SHOW/HIDE DIV -----------*/
function hideAll() {
  hideDiv("recurNever");
  hideDiv("recurDaily");
  hideDiv("recurWeekly");
  hideDiv("recurMonthly");
}
/*----------- end SHOW/HIDE DIV -----------*/
function toggleRadio(eName, index) {
  var list = document.getElementsByName(eName)
  
  for (i=0; i<list.length; i++) {
    list[i].checked=false;
  }
  list[index].checked=true;
}

function turnOnRecurrence(state) {
  if (state == true) {
    showDiv("recur");
    showDiv("recurNever");
  }
  else {
    hideDiv("recur");
    hideAll();
    hideDiv("recurrenceEnd");
  }
}

function getRecurrence() {
  var sel = document.getElementById("recurInterval");
  
  var index = sel.selectedIndex;
  var recurName = sel.options[index].value;
  hideAll();
  showDiv(recurName);
  if (recurName!="recurNever")
    showDiv("recurrenceEnd");
  else
    hideDiv("recurrenceEnd");
}

/*----------- start "service" DATE FUNCTIONS -----------*/
function isThisLeapYear (Year) {
  if (((Year % 4)==0) && ((Year % 100)!=0) || ((Year % 400)==0)) { return (true); }
    else { return (false); }
} 

function getAllDaysInMonth(monthNum, yearNum)  {
  var days;
  if (monthNum==0 || monthNum==2 || monthNum==4 || monthNum==6 || monthNum==7 || monthNum==9 || monthNum==11)  { days=31; }
    else if (monthNum==3 || monthNum==5 || monthNum==8 || monthNum==10) { days=30; }
    else if (monthNum==1)  {
        if (isThisLeapYear(yearNum)) { days=29; }
        else { days=28; }
    }
    return (days);
} 

function setSelect(selId, index) {
  var sel = document.getElementById(selId);
  if (sel) {
    if (index >= 0) {
      sel.selectedIndex = index;
    } else {
      sel.selectedIndex = 0;
    }
  }
}

function setRecurDropdown(recurInterval) {
  var sel = document.getElementById("recurInterval");
  var ind;
  
  switch (recurInterval) {
    case "recurNever":
      ind = 0;
      break;
    case "recurDaily":
      ind = 1;
      break;
    case "recurWeekly":
      ind = 2;
      break;
    case "recurMonthly":
      ind = 3;
      break;
    default:
      ind = 0;
  }
  
  sel.selectedIndex = ind;
}

function getSelectIndex(selId) {
  var sel = document.getElementById(selId);
  return sel.selectedIndex;
}

function getSelectValue(sel) {
  var indexSel = sel.selectedIndex;
  if (indexSel != undefined){
    if (indexSel >= 0) {
      return sel[indexSel].value;
    } else {
      return sel[0].value;
    }
  } else {
      return 0;
  }
}

function changeMonthDropdown (monthDropDown, selectedMonthValue, startMonthIndex){
    if (selectedMonthValue < startMonthIndex)
        selectedMonthValue = startMonthIndex;

    monthDropDown.selectedIndex = selectedMonthValue;
}

function changeDateDropdown (dateDropDown, selectedMonthValue, selectedDateValue, selectedYearValue, startDateIndex) {
  var daysInMonth = getAllDaysInMonth(selectedMonthValue, selectedYearValue);
  var newDateIndex = selectedDateValue - startDateIndex - 1;
  
  dateDropDown.options.length = 0;
  dateDropDown.options.length = daysInMonth - startDateIndex;
  
  for(i=startDateIndex; i<daysInMonth; i++) {
    if (isIE) {
      dateDropDown.options[i-startDateIndex].text = i+1;
      dateDropDown.options[i-startDateIndex].value = i+1;
    }
    else
      dateDropDown.options[i-startDateIndex] = new Option (i+1, i+1);
  }
  
  if (newDateIndex < 0)
    newDateIndex = 0;
  
  
  if (newDateIndex <= dateDropDown.length-1)
    dateDropDown.selectedIndex = newDateIndex;
  else
    dateDropDown.selectedIndex = dateDropDown.length-1;
    
}
/*----------- end "service" DATE FUNCTIONS -----------*/

function changeDropDown(monthId, dateId, yearId) {
  var monthDropDown = document.getElementById(monthId);
  var dateDropDown = document.getElementById(dateId);
  var yearDropDown = document.getElementById(yearId);
  
  var selectedMonthValue = getSelectValue(monthDropDown);
  var selectedDateValue = getSelectValue(dateDropDown);
  var selectedYearValue = getSelectValue(yearDropDown);

  var startMonthIndex = 0;
  var startDateIndex = 0;

  if (selectedYearValue == START_YEAR) {
    startMonthIndex = START_MONTH - 1;
    if (selectedMonthValue < START_MONTH)
      selectedMonthValue = START_MONTH;
    
    if (selectedMonthValue == START_MONTH)
      startDateIndex = START_DATE - 1;
  }
  
  changeMonthDropdown (monthDropDown, selectedMonthValue, startMonthIndex);
  changeDateDropdown (dateDropDown, selectedMonthValue, selectedDateValue, selectedYearValue, startDateIndex);
  
  if (monthId == "startMonth") {
    var endMonthDropDown = document.getElementById("endMonth");
    var endDateDropDown = document.getElementById("endDay");
    var endYearDropDown = document.getElementById("endYear");
    
    changeMonthDropdown (endMonthDropDown, selectedMonthValue, startMonthIndex);
    changeDateDropdown (endDateDropDown, selectedMonthValue, selectedDateValue, selectedYearValue, startDateIndex);
    endYearDropDown.selectedIndex = selectedYearValue - yearArr[0];
  }
}

function toggleRecurrence(eName) {
  var startRadio = document.getElementsByName(eName)[1];
  if (startRadio.checked==true) {
    turnOnRecurrence(true);
    getRecurrence();
  }
}
/*----------- start "service" CALENDAR FUNCTIONS -----------*/
function setCalMonth(selId, nav, monthId, dateId, yearId) {
  var modifier = 0;
  if (nav == "left")
    modifier = -1;
  else if (nav == "right")
    modifier = 1;

  var sel = document.getElementById(selId);
  var newMonth = parseInt(getSelectValue(sel)) + modifier;
  
  calDate.setMonth(newMonth);
  
  var calHtml = writeCalBody(calDate.getMonth(), calDate.getFullYear(), monthId, dateId, yearId);
  var bodyHtml = document.getElementById("bodyHtml");
  bodyHtml.innerHTML = calHtml;
}

function setCalYear(selId, monthId, dateId, yearId) {
  var yearSel = document.getElementById(selId);
  var newYear = getSelectValue(yearSel);
  var newMonth = calDate.getMonth(); 
  if (!isMonitorSchedule) {
    if (newYear == START_YEAR && newMonth < START_MONTH)
      newMonth = START_MONTH;
  }

  calDate.setYear(newYear);
  calDate.setMonth(newMonth);
  
  var calHtml = writeCalBody(calDate.getMonth(), calDate.getFullYear(), monthId, dateId, yearId);
  var bodyHtml = document.getElementById("bodyHtml");
  bodyHtml.innerHTML = calHtml;
}

function setFullDate(d, month, date, year) {
  d.setFullYear(year);
  d.setDate(date);
  d.setMonth(month);
}

function getFullDate(d) {
  alert(monthArr[d.getMonth()] + "/" + d.getDate() + "/" + d.getFullYear());
}
/*----------- end "service" CALENDAR FUNCTIONS -----------*/

function cal(monthId, dateId, yearId) {
  var monthDropDown = document.getElementById(monthId);
  var dateSel = document.getElementById(dateId);
  var yearSel = document.getElementById(yearId);
  
  var originalMonth = monthDropDown.selectedIndex;
  var originalDate = dateSel[dateSel.selectedIndex].value;
  var originalYearIndex = yearSel.selectedIndex;
  var originalYear = yearSel[originalYearIndex].value;
  
  if (originalYear == START_YEAR)
    //originalMonth = originalMonth + START_MONTH;
  if(document.getElementById("refreshCont")){
	document.getElementById("refreshCont").value=0;
  }
  writeCal(originalMonth, originalYear, monthId, dateId, yearId);
}

function resetDropdowns(monthId, dateId, yearId) {
  var isStart = false;
  if(monthId == 'startMonth'){
	isStart = true;	
  }
  var parentWin = window.opener;
  var d = new Date();
  // called by /web/resource/server/control/Edit.jsp
  if (parentWin == null) {
    parentWin = window;
    var isSetByJsp = true;
    if (monthId == "startMonth")
      d = schedDate;
    else
      d = schedEndDate;
  }
  else
    d = calDate;
  
  var monthDropDown = parentWin.document.getElementById(monthId);
  var dateDropDown = parentWin.document.getElementById(dateId);
  var yearDropDown = parentWin.document.getElementById(yearId);
  
  var oldMonthValue = monthDropDown[monthDropDown.selectedIndex].value;
  var oldYearValue = yearArr[yearDropDown.selectedIndex];
  
  var startMonthIndex = 0;
  var startDateIndex = 0;
  
  var newMonthValue = d.getMonth(); 
  var newMonthIndex = newMonthValue;
  var newDateValue = d.getDate();
  var newYearValue = d.getFullYear();
  
  yearDropDown.selectedIndex = newYearValue - yearArr[0];

  if (newYearValue == START_YEAR) {
    newMonthIndex = newMonthValue - START_MONTH;
    
    startMonthIndex = START_MONTH;
    if (newMonthIndex < 0)
      newMonthIndex = START_MONTH;
    
    if (newMonthIndex == START_MONTH)
      startDateIndex = START_DATE - 1;
  }
  
  if (oldYearValue != START_YEAR && oldYearValue == newYearValue && oldMonthValue == newMonthValue) {
    monthDropDown.selectedIndex = newMonthValue - startMonthIndex;
    dateDropDown.selectedIndex = newDateValue - 1;
  }
  else {
    changeMonthDropdown (monthDropDown, newMonthValue, startMonthIndex);
    changeDateDropdown (dateDropDown, newMonthIndex, newDateValue, newYearValue, startDateIndex);
  }
  var locale = parentWin.document.getElementById("localeString").value;
  if (isStart){	
	setScheduleDate(yearDropDown.options[yearDropDown.selectedIndex].text,monthDropDown.options[monthDropDown.selectedIndex].text,dateDropDown.options[dateDropDown.selectedIndex].text,parentWin.document.getElementById('scheduleStartDate'),locale);
  }else{  
	setScheduleDate(yearDropDown.options[yearDropDown.selectedIndex].text,monthDropDown.options[monthDropDown.selectedIndex].text,dateDropDown.options[dateDropDown.selectedIndex].text,parentWin.document.getElementById('scheduleEndDate'),locale);
  }
  if (monthId == "startMonth")
    resetDropdowns("endMonth", "endDay", "endYear");
	
  
  if (!isSetByJsp) // called by /web/resource/server/control/Edit.jsp
    self.close();
}

function parentOpen(calDate, currDay, url) {
  var parentWin = window.opener;
  parentWin.document.location =
    url + '&year=' + calDate.getFullYear() + '&month=' + calDate.getMonth() +
          '&day=' + currDay; 
  self.close();
}

function writeCal(month, year, monthId, dateId, yearId) {
  var calPopup = window.open("","calPopup","width=250,height=295,resizable=yes,scrollbars=no,left=600,top=50");
  calPopup.document.open();
  var calHtml = getCalHTMLHead(month, year);
  calHtml += writeCalBody(month, year, monthId, dateId, yearId);
  calHtml += getCalFooter();
  calPopup.document.write(calHtml);
  calPopup.document.close();
}

function writeCalNLV(weekArgs, month, year, monthId, dateId, yearId) {
  var calPopup = window.open("","calPopup","width=250,height=295,resizable=yes,scrollbars=no,left=600,top=50");
  calPopup.document.open();
  var calHtml = getCalHTMLHeadNLV(month, year);
  calHtml += writeCalBodyNLV(month, year, monthId, dateId, yearId, weekArgs);
  calHtml += getCalFooter();
  calPopup.document.write(calHtml);
  calPopup.document.close();
}

function writeCalBody(month, year, monthId, dateId, yearId) {
  var bodyHtml = getCalHeader(month, year, monthId, dateId, yearId);
  bodyHtml += getCalBody(month, year, monthId, dateId, yearId);
  if(document.all && navigator.userAgent.indexOf('Opera') === -1){
	bodyHtml += "<script> \n";  
	  bodyHtml += "if(window.opener.document.getElementById(\"refreshCont\")&&window.opener.document.getElementById(\"refreshCont\").value==0){ \n";
	  bodyHtml += "window.opener.document.getElementById(\"refreshCont\").value=1; \n";
	  bodyHtml += "window.location.reload(); \n";
	  bodyHtml += "} \n";  
	  bodyHtml += "</script> \n";
  }  
  return bodyHtml;
}

function writeCalBodyNLV(month, year, monthId, dateId, yearId, weekArgs) {	
  var bodyHtml = getCalHeaderNLV(month, year, monthId, dateId, yearId, weekArgs);
  bodyHtml += getCalBody(month, year, monthId, dateId, yearId);
  
  return bodyHtml;
}

/*----------- start CALENDAR COMPONENTS (header, body, footer) -----------*/
function getCalHTMLHead(month, year) {
	if(jsPath.indexOf("?")>0){
	  jsPath = jsPath.substring(0,jsPath.indexOf("?")); 
  }
  if(cssPath.indexOf("?")>0){
    cssPath = cssPath.substring(0,cssPath.indexOf("?"));
  }
  var calHtml = "";
  calHtml += "<html style=\"overflow-x: hidden;\">\n" + 
    "<head>\n" + 
    "<title>Calendar</title>\n" + 	
    "<script src=\"" + jsPath + "functions.js\" type=\"text/javascript\"></script>\n" +
    "<script src=\"" + jsPath + "schedule.js\" type=\"text/javascript\"></script>\n";
	
  calHtml += "<script>\n  var djConfig = {};\n	djConfig.parseOnLoad = false;\n";
  calHtml += " djConfig.baseUrl = \"/static/js/dojo/1.5/dojo/\";\n	djConfig.scopeMap = [ [ \"dojo\", \"hqDojo\" ], [ \"dijit\", \"hqDijit\" ], [ \"dojox\", \"hqDojox\" ]  ];\n"
  calHtml += "djConfig.locale=\""+document.getElementById("localeString").value+"\"; \n";	
  
  calHtml += "</script>\n"
  calHtml += "<script src=\"/static/js/dojo/1.5/dojo/dojo.js\" type=\"text/javascript\"></script>\n" ;
  calHtml += "<script> hqDojo.require(\"dojo.date.locale\"); </script>\n";
  
  if (isMonitorSchedule == true)
    calHtml += "<script src=\"" + jsPath + "monitorSchedule.js\" type=\"text/javascript\"></script>\n";
  
  calHtml += "<link rel=stylesheet href=\"" + cssPath + "win.css\" type=\"text/css\">\n" +
    "<script type=\"text/javascript\">\n" +
    "  var imagePath = \"" + imagePath + "\";\n" + 
    "  var jsPath = \"" + jsPath + "\";\n" + 
    "  var cssPath = \"" + cssPath + "\";\n" + 
    "  var calDate = new Date(" + year + ", " + month + ", " + START_DATE + ");\n" + 
    "  var isMonitorSchedule = " + isMonitorSchedule + ";\n" + 
    "</script>\n" + 
    "</head>\n" + 
    "<body class=\"CalBody\">\n" + 
    "<div id=\"bodyHtml\">\n" +     
    "<form>\n";

  return calHtml;
}

function getCalHTMLHeadNLV(month, year) {
	if(jsPath.indexOf("?")>0){
	  jsPath = jsPath.substring(0,jsPath.indexOf("?")); 
  }
  if(cssPath.indexOf("?")>0){
    cssPath = cssPath.substring(0,cssPath.indexOf("?"));
  }
  var calHtml = "";
  calHtml += "<html style=\"overflow-x: hidden;\">\n" + 
    "<head>\n" + 
    "<title>Calendar</title>\n" + 
    "<script src=\"" + jsPath + "functions.js\" type=\"text/javascript\"></script>\n" +
    "<script src=\"" + jsPath + "schedule.js\" type=\"text/javascript\"></script>\n";
  
  if (isMonitorSchedule == true)
    calHtml += "<script src=\"" + jsPath + "monitorSchedule.js\" type=\"text/javascript\"></script>\n";
  
  calHtml += "<link rel=stylesheet href=\"" + cssPath + "win.css\" type=\"text/css\">\n" +
    "<script type=\"text/javascript\">\n" +
    "  var imagePath = \"" + imagePath + "\";\n" + 
    "  var jsPath = \"" + jsPath + "\";\n" + 
    "  var cssPath = \"" + cssPath + "\";\n" + 
    "  var calDate = new Date(" + year + ", " + month + ", " + START_DATE + ");\n" + 
    "  var isMonitorSchedule = " + isMonitorSchedule + ";\n" + 
    "</script>\n" + 
    "</head>\n" + 
    "<body class=\"CalBody\">\n" + 
    "<div id=\"bodyHtml\">\n" +     
    "<form>\n";

  return calHtml;
}

function getCalHeader(month, year, monthId, dateId, yearId) {
var localeString = "";
 if(document.getElementById("localeString")){
	localeString = document.getElementById("localeString").value;
 }else if(window.opener.document.getElementById("localeString")){
	localeString = window.opener.document.getElementById("localeString").value;
 }
 
  var calHtml = "";
  var startIndex = 0;
  var leftNav = "<img src=\"" + imagePath + "schedule_left.gif\" onClick=\"setCalMonth('calMonth', 'left', '" + monthId + "', '" + dateId + "', '" + yearId+ "')\">";
  
  if (!isMonitorSchedule) {
    if (year == START_YEAR) {
      if (month == START_MONTH)
        leftNav = "<img src=\"" + imagePath + "spacer.gif\" height=\"19\" width=\"20\" border=\"0\">";
      startIndex = START_MONTH;
    }
  }
  
  if(isReverseLocale(localeString)){
	calHtml += "<table width=\"230\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">\n" + 
	"      <tr> \n" + 
	"        <td class=\"CalHeader\" width=\"50%\" align=\"right\">\n" + leftNav + "</td>\n" + 
	"        <td class=\"CalHeader\" align=\"center\" nowrap>\n" + 
	"<select name=\"calYear\" id=\"calYear\" onChange=\"setCalYear('calYear', '" + monthId + "', '" + dateId + "', '" + yearId+ "');\">\n";
	for(i=0; i<yearArr.length; i++) {
		var strSelected = "";
		if (yearArr[i]==year) 
		  strSelected = " selected";
		calHtml += "<option value=\"" + yearArr[i] + "\"" + strSelected +">" + yearArr[i] + "</option>\n";
	  }
	  calHtml += "</select>\n" + "  <select name=\"calMonth\" id=\"calMonth\" onChange=\"setCalMonth('calMonth', 'none', '" + monthId + "', '" + dateId + "', '" + yearId+ "');\">";
	  for(i=startIndex; i<12; i++) {
		var strSelected = "";
		if (i==month)
		  strSelected = " selected";
		calHtml += "<option value=\"" + i + "\"" + strSelected +">" + monthArr[i] + "</option>\n";
	  }
  }else{
	calHtml += "<table width=\"230\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">\n" + 
	"      <tr> \n" + 
	"        <td class=\"CalHeader\" width=\"50%\" align=\"right\">\n" + leftNav + "</td>\n" + 
	"        <td class=\"CalHeader\" align=\"center\" nowrap>\n" + 
	"    <select name=\"calMonth\" id=\"calMonth\" onChange=\"setCalMonth('calMonth', 'none', '" + monthId + "', '" + dateId + "', '" + yearId+ "');\">";
	  
	  for(i=startIndex; i<12; i++) {
		var strSelected = "";
		if (i==month)
		  strSelected = " selected";
		calHtml += "<option value=\"" + i + "\"" + strSelected +">" + monthArr[i] + "</option>\n";
	  }

	  calHtml += "</select>&nbsp;/&nbsp;\n" + "<select name=\"calYear\" id=\"calYear\" onChange=\"setCalYear('calYear', '" + monthId + "', '" + dateId + "', '" + yearId+ "');\">\n";
	  for(i=0; i<yearArr.length; i++) {
		var strSelected = "";
		if (yearArr[i]==year) 
		  strSelected = " selected";
		calHtml += "<option value=\"" + yearArr[i] + "\"" + strSelected +">" + yearArr[i] + "</option>\n";
	  }
  }
  
  calHtml +=
"    </select></td>\n" + 
"        <td class=\"CalHeader\" width=\"50%\"><img src=\"" + imagePath + "schedule_right.gif\" onClick=\"setCalMonth('calMonth', 'right', '" + monthId + "', '" + dateId + "', '" + yearId+ "')\"></td>\n" + 
"      </tr>\n" + 
"      <tr> \n" + 
"        <td class=\"BlockContent\">&nbsp;</td>\n" + 
"        <td class=\"BlockContent\"><table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"2\">\n" + 
"            <tr> \n";
if(document.getElementById("sundayLabel")&&document.getElementById("sundayLabel").value){
	calHtml +="              <td class=\"CalDays\">"+document.getElementById("sundayLabel").value+"</td>\n" + 
"              <td class=\"CalDays\">"+document.getElementById("mondayLabel").value+"</td>\n" + 
"              <td class=\"CalDays\">"+document.getElementById("tuesdayLabel").value+"</td>\n" + 
"              <td class=\"CalDays\">"+document.getElementById("wednesdayLabel").value+"</td>\n" + 
"              <td class=\"CalDays\">"+document.getElementById("thursdayLabel").value+"</td>\n" + 
"              <td class=\"CalDays\">"+document.getElementById("friddayLabel").value+"</td>\n" + 
"              <td class=\"CalDays\">"+document.getElementById("staturdayLabel").value+"</td>\n" + 
"            </tr>";
}else if(window.opener.document.getElementById("sundayLabel")&&window.opener.document.getElementById("sundayLabel").value){
	calHtml +="              <td class=\"CalDays\">"+window.opener.document.getElementById("sundayLabel").value+"</td>\n" + 
"              <td class=\"CalDays\">"+window.opener.document.getElementById("mondayLabel").value+"</td>\n" + 
"              <td class=\"CalDays\">"+window.opener.document.getElementById("tuesdayLabel").value+"</td>\n" + 
"              <td class=\"CalDays\">"+window.opener.document.getElementById("wednesdayLabel").value+"</td>\n" + 
"              <td class=\"CalDays\">"+window.opener.document.getElementById("thursdayLabel").value+"</td>\n" + 
"              <td class=\"CalDays\">"+window.opener.document.getElementById("friddayLabel").value+"</td>\n" + 
"              <td class=\"CalDays\">"+window.opener.document.getElementById("staturdayLabel").value+"</td>\n" + 
"            </tr>";
}else{
	calHtml +="              <td class=\"CalDays\">Su</td>\n" + 
"              <td class=\"CalDays\">Mo</td>\n" + 
"              <td class=\"CalDays\">Tu</td>\n" + 
"              <td class=\"CalDays\">We</td>\n" + 
"              <td class=\"CalDays\">Th</td>\n" + 
"              <td class=\"CalDays\">Fr</td>\n" + 
"              <td class=\"CalDays\">Sa</td>\n" + 
"            </tr>";
}

  
  return calHtml;
}

function getCalHeaderNLV(month, year, monthId, dateId, yearId, weekArgs) {
  var calHtml = "";
  var startIndex = 0;
  var leftNav = "<img src=\"" + imagePath + "schedule_left.gif\" onClick=\"setCalMonth('calMonth', 'left', '" + monthId + "', '" + dateId + "', '" + yearId+ "')\">";
  
  if (!isMonitorSchedule) {
    if (year == START_YEAR) {
      if (month == START_MONTH)
        leftNav = "<img src=\"" + imagePath + "spacer.gif\" height=\"19\" width=\"20\" border=\"0\">";
      startIndex = START_MONTH;
    }
  }
  
  calHtml += "<table width=\"230px\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">\n" + 
"      <tr> \n" + 
"        <td class=\"CalHeader\" width=\"50%\" align=\"right\">\n" + leftNav + "</td>\n" + 
"        <td class=\"CalHeader\" align=\"center\" nowrap>\n" + 
"    <select name=\"calMonth\" id=\"calMonth\" onChange=\"setCalMonth('calMonth', 'none', '" + monthId + "', '" + dateId + "', '" + yearId+ "');\">";
  
  for(i=startIndex; i<12; i++) {
    var strSelected = "";
    if (i==month)
      strSelected = " selected";
    calHtml += "<option value=\"" + i + "\"" + strSelected +">" + weekArgs.monthArray[i] + "</option>\n";
  }

  calHtml += "</select>&nbsp;/&nbsp;\n" + "<select name=\"calYear\" id=\"calYear\" onChange=\"setCalYear('calYear', '" + monthId + "', '" + dateId + "', '" + yearId+ "');\">\n";
  for(i=0; i<yearArr.length; i++) {
    var strSelected = "";
    if (yearArr[i]==year) 
      strSelected = " selected";
    calHtml += "<option value=\"" + yearArr[i] + "\"" + strSelected +">" + yearArr[i] + "</option>\n";
  }
  
  calHtml +=
"    </select></td>\n" + 
"        <td class=\"CalHeader\" width=\"50%\"><img src=\"" + imagePath + "schedule_right.gif\" onClick=\"setCalMonth('calMonth', 'right', '" + monthId + "', '" + dateId + "', '" + yearId+ "')\"></td>\n" + 
"      </tr>\n" + 
"      <tr> \n" + 
"        <td class=\"BlockContent\">&nbsp;</td>\n" + 
"        <td class=\"BlockContent\"><table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"2\">\n" + 
"            <tr> \n" + 
"              <td class=\"CalDays\">"+weekArgs.sunday+"</td>\n" + 
"              <td class=\"CalDays\">"+weekArgs.monday+"</td>\n" + 
"              <td class=\"CalDays\">"+weekArgs.tuesday+"</td>\n" + 
"              <td class=\"CalDays\">"+weekArgs.wednesday+"</td>\n" + 
"              <td class=\"CalDays\">"+weekArgs.thursday+"</td>\n" + 
"              <td class=\"CalDays\">"+weekArgs.friday+"</td>\n" + 
"              <td class=\"CalDays\">"+weekArgs.saturday+"</td>\n" + 
"            </tr>";
  
  return calHtml;
}

function getCalBody (month, year, monthId, dateId, yearId) {
  var calHtml = "";
  var i = 0;
  var coloredDays = 35;
  
  var days = getAllDaysInMonth(month,year);
  var firstOfMonth = new Date (year, month, 1);
  var startingPos = firstOfMonth.getDay();
  days += startingPos;
  
  if (startingPos!=0)
    calHtml += "<tr>\n";
  for (i = 0; i < startingPos; i++) {
    calHtml += "<td class=\"BlockContent\">&nbsp;</td>\n";
  }

  for (i = startingPos; i < days; i++) {
    var dayStr = "";
    
    if (i%7==0 && i!==0)
      calHtml += "</tr>\n" + "<tr>\n";
    else if (i==0)
      calHtml += "<tr>\n";
    
    
    var currDay = i-startingPos+1;
    if (currDay < 10)
      dayStr += "0";
    dayStr += currDay;
    
    if (isMonitorSchedule == true) {
      if (dateId == null || dateId == 'undefined') {
        calHtml += "<td class=\"BlockContent\"><a href=\"javascript:parentOpen(calDate, " + currDay + ", '" + monthId + "');\">" + dayStr + "</a></td>\n";
      }
      else {
        calHtml += "<td class=\"BlockContent\"><a href=\"javascript:setFullDate(calDate, " + month + ", " + currDay + ", " + year + "); resetMonitorDropdowns('" + monthId + "', '" + dateId + "', '" + yearId+ "');\">" + dayStr + "</a></td>\n";
      }
    }
    else {
      if (year == START_YEAR && month == START_MONTH && currDay < START_DATE)
        calHtml += "<td class=\"BlockContent\"><span class=\"CalInactiveDay\">" + dayStr + "</span></td>\n";
      else
        calHtml += "<td class=\"BlockContent\"><a href=\"javascript:setFullDate(calDate, " + month + ", " + currDay + ", " + year + "); resetDropdowns('" + monthId + "', '" + dateId + "', '" + yearId+ "');\">" + dayStr + "</a></td>\n";
    }
    
  }
  
  if (days<=28)
    coloredDays = 28;
  else if (days>35)
    coloredDays = 42;
    
  for (i=days; i<coloredDays; i++)  {
    if ( i%7 == 0 )
      calHtml += "</tr>\n" + "<tr bgcolor=\"#cccccc\">\n";
    calHtml += "<td class=\"BlockContent\">&nbsp;</td>\n";
  }
  
  calHtml += "      </tr>\n" + 
  "    </table></td>\n" +
  "        <td class=\"BlockContent\">&nbsp;</td>\n" + 
  "      </tr>\n" + 
  "      <tr> \n" + 
  "        <td class=\"BlockBottomLine\" colspan=\"3\"><img src=\"" + imagePath + "spacer.gif\" height=\"1\" width=\"1\" border=\"0\"></td>\n" + 
  "      </tr>\n" + 
  "    </table>\n";

  return calHtml;
}

function getCalFooter() {
  return "</form>\n" +
"</div></body>\n" +
"</html>\n";
}
/*----------- end CALENDAR COMPONENTS (header, body, footer) -----------*/

function setScheduleDate(year,month,day,inputItem,locale){		
	if(parseInt(day)){
		var dayInt = parseInt(day);
		if(dayInt<10){
			day = '0'+dayInt;
		}
	}
	var dateString = getDateByLocale(year,month,day,locale);
	if(dateString){			
		inputItem.value = dateString;
	}
}

function getDateByLocale(year,month,day,locale){
	var dateString = year+'-'+month+'-'+day;		
	var date = new Date(year,parseInt(month)-1,day);		
	return hqDojo.date.locale.format(date, {selector:'date',formatLength:'medium'});
}

function getDateByLocale2(year,month,day,locale){
	var dateString = "";
	locale = locale.toLowerCase();
	locale = locale.replace("_","-");
	var shortYear = year.substring(2,year.length);
	var shortMonth = month.substring(1,month.length);
	var shortDay = day.substring(1,day.length);		
	if(locale.indexOf('en')==0){			
		if(locale=='en-us'){
			dateString = month+"/"+day+"/"+year;
		}else if(locale=='en-au'||locale=='en-be'||locale=='en-bw'||locale=='en-in'||locale=='en-nz'){			
			dateString = day+"/"+month+"/"+shortYear;
		}else if(locale=='en-ca'){			
			dateString = shortYear+"-"+month+"-"+day;
		}else if(locale=='en-cb'||locale=='en-jm'||locale=='en-ph'){
			dateString = shortMonth+"/"+shortDay+"/"+shortYear;
		}else if(locale=='en-gb'||locale=='en-ie'||locale=='en-mt'){
			dateString = day+"/"+month+"/"+year;
		}else if(locale=='en-hk'||locale=='en-sg'){
			dateString = shortDay+"/"+shortMonth+"/"+shortYear;
		}else if(locale=='en-za'){
			dateString = year+"/"+month+"/"+day;
		}else if(locale=='en-zw'){
			dateString = shortDay+"/"+shortMonth+"/"+year;
		}else{		
			dateString = month+"/"+day+"/"+year;
		}			
	}else{
		dateString = year+"/"+month+"/"+day;
	}
	return dateString;
}

function setStartDateInput(){
	var startMonth = hqDojo.byId('startMonth');
	var startDay = hqDojo.byId('startDay');
	var startYear = hqDojo.byId('startYear');
	setScheduleDate(startYear.options[startYear.selectedIndex].text,startMonth.options[startMonth.selectedIndex].text,startDay.options[startDay.selectedIndex].text,hqDojo.byId('scheduleStartDate'),hqDojo.byId("localeString").value);
}

function setEndDateInput(){
	var endMonth = hqDojo.byId('endMonth');
	var endDay = hqDojo.byId('endDay');
	var endYear = hqDojo.byId('endYear');
	setScheduleDate(endYear.options[endYear.selectedIndex].text,endMonth.options[endMonth.selectedIndex].text,endDay.options[endDay.selectedIndex].text,hqDojo.byId('scheduleEndDate'),hqDojo.byId("localeString").value);	
}

function isReverseLocale(localeString){
	var isReverse = false;
	if(localeString.indexOf('ja')==0||localeString.indexOf('zh')==0||localeString.indexOf('ko')==0){
		isReverse = true;
	}
	return isReverse;
}