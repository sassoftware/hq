<% 
import org.apache.commons.lang.StringEscapeUtils
%>
<%= hquStylesheets() %>

<style type="text/css">

    .OpStyleRed {
        background-color: #FFB6C1 !important; /* lightpink */
    }

    .OpStyleGreen {
        background-color: #90EE90 !important; /* lightgreen */
    }

    .OpStyleYellow {
        background-color: #FAFAD2 !important; /* lightgoldenrodyellow */
    }

    .OpStyleOrange {
        background-color: #FFA07A !important; /* lightsalmon */
    }

    .OpStyleGray {
        background-color: #D3D3D3 !important; /* lightgray */
    }

</style>

<!-- Summary header -->
<div id="OpsHeader">
    <div id="OpsHeaderFilters" style="float:left;margin-right:30px">
        <form id="FiltersForm" action="javascript:filtersChanged();">
            <table>
                <tr>
                    <td colspan="2" style="font-weight:bold;text-align:center">${l.opcenterDisFilter}</td>
                </tr>
                <tr>
                    <td nowrap>${l.opcenterDisStatus}:</td>
                    <td>
                        <select id="StatusFilter" onchange="filtersChanged();">
                            <option value="0">${l.opcenterAll}</option>
                            <option value="1">${l.opcenterResDownRess}</option>
                            <option value="2" selected="selected">${l.opcenterAlertAll}</option>
                            <option value="3">${l.opcenterAlertEsca}</option>
                            <option value="4">${l.opcenterAlertNotEsca}</option>

                        </select>
                    </td>
                </tr>
                <tr>
                    <td nowrap>${l.opcenterPlatformFilter}:</td>
                    <td>
                        <input id="HostnameFilter" type="text" size="20" />
                    </td>
                </tr>
                <tr>
                    <td nowrap>${l.opcenterGroupFilter}:</td>
                    <td>
                        <select onchange="filtersChanged();">
                            <option value="-1" selected="selected">${l.opcenterTimeNone}</option>
                            <%
                                groups.each {
                                    out.write('<option value="' + it.id + '">' + StringEscapeUtils.escapeHtml(it.name) + '</option>')
                                }
                            %>
                        </select>
                    </td>
                </tr>
            </table>
        </form>
    </div>

    <div id="OpsHeaderResourceTotals" style="float:left;margin-right:30px">
        <table>
            <tr><td colspan="2" style="text-align:center;font-weight:bold">${l.opcenterFilterTotal}</td></tr>
            <tr>
                <td valign="top">
                    <table border="1">
                        <tr><td colspan="2" style="text-align:center;font-weight:bold">${l.opcenterRes}</td></tr>
                        <tr><td nowrap>${l.opcenterResDownPlat}</td><td class="OpStyleGray" style="width:50px"><div id="DownPlatforms">&nbsp;</div></td></tr>
                        <tr><td nowrap>${l.opcenterResDownRess}</td><td class="OpStyleGray" style="width:50px"><div id="DownResources">&nbsp;</div></td></tr>
                    </table>
                </td>
                <td valign="top">
                    <table border="1">
                        <tr><td colspan="5" style="text-align:center;font-weight:bold">${l.opcenterAlert}</td></tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td>${l.opcenterAlertLow}</td>
                            <td>${l.opcenterAlertMed}</td>
                            <td>${l.opcenterAlertHigh}</td>
                            <td>${l.opcenterAlertTotal}</td>
                        </tr>
                        <tr>
                            <td nowrap>${l.opcenterAlertUnfixed}</td>
                            <td class="OpStyleYellow" style="width:50px"><div id="AlertsUnfixedLow">&nbsp;</div></td>
                            <td class="OpStyleOrange" style="width:50px"><div id="AlertsUnfixedMed">&nbsp;</div></td>
                            <td class="OpStyleRed" style="width:50px"><div id="AlertsUnfixedHigh">&nbsp;</div></td>
                            <td class="OpStyleGray" style="width:50px"><div id="AlertsUnfixed">&nbsp;</div></td>
                        </tr>
                        <tr>
                            <td nowrap>${l.opcenterAlertEsca}</td>
                            <td class="OpStyleYellow" style="width:50px"><div id="AlertsInEscLow">&nbsp;</div></td>
                            <td class="OpStyleOrange" style="width:50px"><div id="AlertsInEscMed">&nbsp;</div></td>
                            <td class="OpStyleRed" style="width:50px"><div id="AlertsInEscHigh">&nbsp;</div></td>
                            <td class="OpStyleGray" style="width:50px"><div id="AlertsInEsc">&nbsp;</div></td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </div>

   <div id="OpsHeaderTableControls" style="clear:both;magin-right:10px">
        <form id="TableControlsForm" action="javascript:refreshOpsDashboard();">
            <table>
                <tr>
                    <td colspan="2" style="font-weight:bold;text-align:center">${l.opcenterTabCtrl}</td>
                </tr>
                <tr>
                    <td nowrap>
                        ${l.opcenterTabPageItems}:
                    </td>
                    <td>
                        <select id="PageSize" onchange="updatePageSize();">
                            <option value="15">15</option>
                            <option value="30">30</option>
                            <option value="50" selected="selected">50</option>
                            <option value="75">75</option>
                            <option value="100">100</option>
                            <option value="32767">${l.opcenterAll}</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td nowrap>
                        ${l.opcenterTabRefresh}:
                    </td>
                    <td>
                        <select id="OpsRefresh" onchange="updateRefreshInterval(this);">
                            <option value="60000" selected="selected">1 ${l.opcenterTimeUnitMin}</option>
                            <option value="120000">2 ${l.opcenterTimeUnitMins}</option>
                            <option value="300000">5 ${l.opcenterTimeUnitMins}</option>
                            <option value="600000">10 ${l.opcenterTimeUnitMins}</option>
                            <option value="900000">15 ${l.opcenterTimeUnitMins}</option>
                            <option value="1800000">30 ${l.opcenterTimeUnitMins}</option>
                            <option value="2700000">45 ${l.opcenterTimeUnitMins}</option>
                            <option value="3600000">60 ${l.opcenterTimeUnitMins}</option>
                            <option value="9223372036854775807">${l.opcenterTimeNone}</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td colspan="2"><div id="OpHeaderLastUpdated" style="font-weight:bold">&nbsp;</div></td>
                </tr>
            </table>
        </form>
    </div>

    <div style="clear:both"></div>
</div>

<form id="dashboardTable_FixForm" name="dashboardTable_FixForm" method="POST" action="<%= urlFor(absolute:"/alerts/RemoveAlerts.do", encodeUrl:true) %>">

    <!-- Item details -->
<%
  String htmlStr = dojoTable(id:'dashboardTable', title:"${l.opcenterResDetail}",
                  url:urlFor(action:'updateDashboard'),
                  schema:DASHBOARD_SCHEMA, numRows:50, pageControls:true); 
//htmlStr = "";
  htmlStr = htmlStr.replaceAll("autoHeight: 50,","autoHeight: 51,"); 
    
%>
    <%= htmlStr
    %>
    <div id="HQAlertCenterDialog" style="display:none;"></div>
    <div id="TableFooter">
        <div id="dashboardTable_FixedButtonDiv" style="margin-top:6px;float:left">
            <input type="button" id="dashboardTable_FixButton" value="${l.opcenterFIXBtn}"
                    class="CompactButtonInactive" disabled="disabled"
                    onclick="MyAlertCenter.processButtonAction(this)" />
            &nbsp;&nbsp;
            <input type="button" id="dashboardTable_AckButton" value="${l.opcenterAckBtn}"
                   class="CompactButtonInactive" disabled="disabled"
                onclick="MyAlertCenter.processButtonAction(this)" />
            <input type="hidden" name="buttonAction" value="" />
            <input type="hidden" name="output" value="json" />
            <input type="hidden" name="fixedNote" value="" />
            <input type="hidden" name="ackNote" value="" />
            <input type="hidden" name="fixAll" value="false" />
            <input type="hidden" name="pauseTime" value="" />
        </div>
    </div>
</form>

<script type="text/javascript">
	hqDojo.require("dijit.dijit");
    hqDojo.require("dijit.Dialog");
    hqDojo.require("dijit.ProgressBar");

	var opsRefreshLock = new Date();
	
    var MyAlertCenter = null;
    hqDojo.ready(function(){
        MyAlertCenter = new hyperic.alert_center("${l.opcenterdescription}");

        hqDojo.connect("dashboardTable_refreshTable", function() { MyAlertCenter.resetAlertTable(hqDojo.byId('dashboardTable_FixForm'));runUpdateTable(); });
    });

    // Handle update to the page size
    function updatePageSize() {

        var form = document.getElementById("TableControlsForm");

        _hqu_dashboardTable_pageSize = form.elements[0].value;
        _hqu_dashboardTable_pageNum = 0;

        refreshOpsDashboard();
    }

    // Handle update to the table refresh interval
    function updateRefreshInterval(refreshElement) {
		// refresh now and startSmartRefresh() will refresh at the next new interval
        var refreshInterval = refreshElement.value;

        clearTimeout(_hqu_dashboardTable_refreshTimeout);
        if (refreshInterval != 9223372036854775807) {
            refreshOpsDashboard();
        }
    }
    
    function startSmartRefresh() {
		// start the refresh timer after the ajax call to get the
		// data and populate the table is done to prevent unnecessary
		// refreshes while the ajax call is still in progress
		opsRefreshLock = null;
        var refreshInterval = document.getElementById("OpsRefresh").value;

        clearTimeout(_hqu_dashboardTable_refreshTimeout);
        if (refreshInterval != 9223372036854775807) {
            _hqu_dashboardTable_refreshTimeout = setTimeout("refreshOpsDashboard()", refreshInterval);
        }	
    }

    function refreshOpsDashboard() {
		if (opsRefreshLock == null) {
			opsRefreshLock = new Date();
			dashboardTable_refreshTable();
		} else {
			// refresh currently in progress.
			// ignore and wait for the next refresh.
			console.info("The Operations Center is currently refreshing (started at " + opsRefreshLock + ").");
		}
	}
	
	function _hqu_dashboardTable_autoRefresh() {
		// this function is called by the hyperic.alert_center api 
		refreshOpsDashboard();
	}

    // Called when any filter is changed to reset the page number and refresh the table.
    function filtersChanged() {
        _hqu_dashboardTable_pageNum = 0;
        refreshOpsDashboard();
    }

    // Called prior to table refresh to get current filters
    function getDashboardFilters() {

        var form = document.getElementById("FiltersForm");

        var typeFilter = form.elements[0].value;
        var platformFilter = form.elements[1].value;
        var groupFilter = form.elements[2].value;

        var res = {};
        if (typeFilter != null) {
            res['typeFilter'] = typeFilter;
        }
        if (platformFilter != null) {
            var escPlatform = escape(platformFilter);
            res['platformFilter'] = escPlatform;  
        }
        if (groupFilter != null) {
            res['groupFilter'] = groupFilter;
        }

        return res;
    }

    function formatValue(val) {
        if (val == undefined) {
            return "N/A";
        } else {
            return val;
        }
    }

	// Little method I got from Sam I Am, may want to formalize this in the future
	var _strSoftHyphen = (navigator.userAgent.toLowerCase().indexOf("applewebkit") > -1 || document.all) ? 
	                     "&shy;" : 
	                     "<wbr/>"; // use soft-hyphen for IE and Opera which are known to implement it correctly
    var _softWrap = function(str, maxcolumns) {
        // these regular expressions need to incorporate variables (function params), 
        // so cant be static properties of the function, to save a few operations in repeated use
        var wordspaceRe = new RegExp('^\\\\w{1,' + maxcolumns + '}\\\\s+');
        var punctuationRe = new RegExp('^[!\\\\._\\\\-\\\\\\\\\\,=\\\\*]{1,' + maxcolumns + '}');
        var wrapstr = "";
        var charCount = 0;

        while(str.length) {
	        var endidx = 1;
    	    // shortcut if there's less remaining characters than the maxcols
        
        	if(str.length < maxcolumns) {
            	wrapstr += _strSoftHyphen + str; 
            	break;
          	}
        	
        	// look ahead for space characters
          	var spaceMatches = str.match(wordspaceRe);
          
          	if(spaceMatches && spaceMatches[0]) {
            	endidx = spaceMatches[0].length;
            	wrapstr += str.substring(0, endidx); 
            	str = str.substring(endidx);
            	charCount = 0; // reset 
            	continue;
          	} else {
            	// handle markup
            	if(str.charAt(0) == "<" && str.indexOf(">") > -1) {
              		endidx = str.indexOf(">");
              		charCount++; // count as one character
            	} else if( str.charAt(0) == "&" && str.match(/^&\\w+;/) ) { 
            		// handle entities
              		endidx = (str.indexOf(";") > -1) ? str.indexOf(";") +1 : str.length;
              		charCount++; // count as one character
            	} else { 
              		var puncMatches = str.match(punctuationRe);
              
              		if(puncMatches && puncMatches[0]) {
			            // handle punctuation
            			endidx = puncMatches[0].length;
                		charCount += endidx; // count as one character
              		} else {
                		charCount++; // default case is just one character
              		}
            	}
          	}
          
          	wrapstr += str.substring(0, endidx);
      
          	if(charCount >= maxcolumns) {
            	wrapstr += _strSoftHyphen;
            	charCount = 0;
          	}
          
          	str = str.substring(endidx);
        }
        
        return wrapstr;
    };
	
    // Called post table refresh with current table data
    function refreshSummaryData(data) {

        var summaryInfo = data.summaryinfo[0];
        
        var updatedDate = new Date(summaryInfo.LastUpdated);
        document.getElementById("OpHeaderLastUpdated").innerHTML =
            "${l.opcenterTabUpdated} " + updatedDate.formatDate('HH:mm:ss') +
            ", ${l.opcenterTabPopulation} " + formatValue(summaryInfo.FetchTime)+ "${l.opcenterTimeUnitMS}";

        document.getElementById("DownPlatforms").innerHTML = formatValue(summaryInfo.DownPlatforms);
        document.getElementById("DownResources").innerHTML = formatValue(summaryInfo.DownResources);

        document.getElementById("AlertsUnfixedLow").innerHTML  = formatValue(summaryInfo.AlertsUnfixedLow);
        document.getElementById("AlertsUnfixedMed").innerHTML  = formatValue(summaryInfo.AlertsUnfixedMed);
        document.getElementById("AlertsUnfixedHigh").innerHTML = formatValue(summaryInfo.AlertsUnfixedHigh);
        document.getElementById("AlertsUnfixed").innerHTML     = formatValue(summaryInfo.AlertsUnfixed);

        document.getElementById("AlertsInEscLow").innerHTML  = formatValue(summaryInfo.AlertsInEscLow);
        document.getElementById("AlertsInEscMed").innerHTML  = formatValue(summaryInfo.AlertsInEscMed);
        document.getElementById("AlertsInEscHigh").innerHTML = formatValue(summaryInfo.AlertsInEscHigh);
        document.getElementById("AlertsInEsc").innerHTML     = formatValue(summaryInfo.AlertsInEsc);

        document.getElementById("_hqu_dashboardTable_pageNumbers").innerHTML =
        "${l.opcenterBTNPage} " + (_hqu_dashboardTable_pageNum + 1) + " /" + formatValue(summaryInfo.NumPages);
    }
	
    dashboardTable_addUrlXtraCallback(getDashboardFilters);
    dashboardTable_addRefreshCallback(refreshSummaryData);
    dashboardTable_addRefreshCallback(startSmartRefresh);
    
    hqDojo.subscribe("XHRComplete", function() {
    	setFoot();
    });
</script>
<script>
var div = document.getElementById("migContainer");
var hquTitle=div.getElementsByTagName("table")[0].getElementsByTagName("tbody")[0].getElementsByTagName("tr")[0].getElementsByTagName("td")[2];
hquTitle.innerHTML="${l.opcenterdescription}";

var divButton = document.getElementById("dashboardTable_pageCont").getElementsByTagName("div")[3];
var leftBtn = divButton.getElementsByTagName("div")[0];
var rightBtn = divButton.getElementsByTagName("div")[5];
leftBtn.innerHTML="${l.opcenterBTNNext}";
rightBtn.innerHTML="${l.opcenterBTNPrevious}";
var freshBtn = document.getElementById("dashboardTable_pageCont").getElementsByTagName("img")[0];
freshBtn.setAttribute("title","${l.opcenterBTNRefresh}");
function updateTable() {
    var eleObject =document.getElementById("_hqu_dashboardTable_pageNumbers");
		if ( eleObject== null){
		   return;
		}
		var pageBtn =  document.getElementById("_hqu_dashboardTable_pageNumbers");
		var pageNumStr=pageBtn.innerHTML;
		var pageNum = 1
		if (pageNumStr == "&nbsp;") {
            pageNum = 1;
    } else {
            pageNum = pageNumStr.substring(pageNumStr.lastIndexOf(" "));;
    }
    if (pageNum == "undefined") {
        pageNum = "N/A";
    }
		pageBtn.innerHTML="${l.opcenterBTNPage} " + pageNum;		
		
		var freshBtn = document.getElementById("dashboardTable_pageCont").getElementsByTagName("img")[0];
		freshBtn.setAttribute("title","${l.opcenterBTNRefresh}");
}

function runUpdateTable() {
	 setTimeout(updateTable,299);
}  
window.onload=runUpdateTable(); 
</script>