<% 
import org.apache.commons.lang.StringEscapeUtils
%>
<%= hquStylesheets() %>
<%  hquTwoPanedFilter() { w ->
        w.filter(l.filter) {
            w.filterElement(l.minStatus) { 
                out.write(selectList(allStatusVals, 
     	                             [id:'statusSelect',
                                      onchange:'EventLogs_refreshTable(); ']))
            }
            
            w.filterElement(l.type) {
                out.write(selectList(allTypes,
     	                             [id:'typeSelect',
                                      onchange:'EventLogs_refreshTable(); ']))
            }
            
            w.filterElement(l.timeRange) {
                out.write(selectList(timePeriods,
     	                             [id:'timeSelect',
                                      onchange:'EventLogs_refreshTable(); ']))
            }

            w.filterElement([label: l.inGroups, 
                             labelMarkup: "<span style='margin-left:15px'> | <span class='clickText' onclick=\"deselectAll('groupSelect');EventLogs_refreshTable();\">${l.eveLogBTNUnselect}</span></span>" ]) { %>
                <select id="groupSelect" multiple="true" name="groupSelect"
			            style="height:200px; width:180px; border:5px solid #ededed;"
			            onchange="EventLogs_refreshTable();">
     	        <% for (g in allGroups) { %>
			      <option value="${g.id}">${StringEscapeUtils.escapeHtml(g.name)}</option>
                <% } %>
                </select>
            <%
            }
        }
        w.pane {
            out.write(dojoTable(id:'EventLogs', title:l.logs,
                                refresh:60, url:urlFor(action:'logData'),
                                schema:logSchema, numRows:15))
        }
    }
      
    %>
<script src="${urlFor(asset:'js')}/depman.js" type="text/javascript"></script>
<script type="text/javascript">
						hqDojo.require("dijit.dijit");
			          	hqDojo.require("dijit.Dialog");
			          	hqDojo.require("dijit.ProgressBar");
			         			          	
			          	hqDojo.ready(function(){		          		
			          		hqDojo.connect("EventLogs_refreshTable","onchange",function(){runUpdateTable();});
			          		
			          	});
</script>
<script type="text/javascript">
    function getEventLogsUrlMap(id) {
        var res = {};
        var statusSelect = hqDojo.byId('statusSelect');
        var typeSelect   = hqDojo.byId('typeSelect');
        var timeSelect   = hqDojo.byId('timeSelect');
        var groupSelect  = hqDojo.byId('groupSelect');
        res['minStatus'] = statusSelect.options[statusSelect.selectedIndex].value;
        res['type']      = typeSelect.options[typeSelect.selectedIndex].value;
        res['timeRange'] = timeSelect.options[timeSelect.selectedIndex].value;
        res['groups']    = "";
        for (i=0; i<groupSelect.length; i++) {
            if (groupSelect.options[i].selected) {
                res['groups'] = res['groups'] + "," + groupSelect.options[i].value;
            }
        }
        return res;
    }
    function selectAll(box){
        var box = hqDojo.byId(box);
        for(var i = 0; i < box.length; i++)
            box.options[i].selected = true;
    }
    function deselectAll(box){
        var box = hqDojo.byId(box);
        for(var i = 0; i < box.length; i++)
            box.options[i].selected = '';
    }
    
    EventLogs_addUrlXtraCallback(getEventLogsUrlMap);
</script>
<script type="text/javascript">
		var div = document.getElementById("migContainer");
		var hquTitle=div.getElementsByTagName("table")[0].getElementsByTagName("tbody")[0].getElementsByTagName("tr")[0].getElementsByTagName("td")[2];
		hquTitle.innerHTML="${l.eventcenterdescription}";
		
		var divButton = document.getElementById("EventLogs_pageCont").getElementsByTagName("div")[3];
		var leftBtn = divButton.getElementsByTagName("div")[0];
		var rightBtn = divButton.getElementsByTagName("div")[5];
		leftBtn.innerHTML="${l.eveLogBTNNext}";
		rightBtn.innerHTML="${l.eveLogBTNPrevious}";
		var freshBtn = document.getElementById("EventLogs_pageCont").getElementsByTagName("img")[0];
		freshBtn.setAttribute("title","${l.eveLogBTNRefresh}");
		var hanlder =0;
		setInterval(updateEventLogTable, 200);
		
function runUpdateTable() {
    hanlder = setInterval(updateEventLogTable, 100);
}
function updateEventLogTable() {
       
		var eleObject =document.getElementById("_hqu_EventLogs_pageNumbers");
		if ( eleObject== null){
		  return;
		}
		var pageBtn =  document.getElementById("_hqu_EventLogs_pageNumbers");
		var pageNumStr=pageBtn.innerHTML;
		var pageNum = pageNumStr.substring(pageNumStr.lastIndexOf(" "));
		pageBtn.innerHTML="${l.eveLogBTNPage} " + pageNum ;
		
	    clearInterval(hanlder);
	}
</script>
