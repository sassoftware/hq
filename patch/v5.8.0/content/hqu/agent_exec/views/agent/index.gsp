<script type="text/javascript">
var fmt      = {};
var commands = [];
var cmd;
var liveResults = [];
var resInfo = {};  
var ajaxCount = 0;
var lastSelected = undefined;

<% for (m in groupMembers) { %>
  resInfo['${m.entityId}'] = {name: "<%= linkTo(h(m.name), [resource:m]) %>" };
<% } %>

<% for (c in commands) { %>
    cmd = '<%= c %>';
    commands.push(cmd);
    fmt[cmd] = [];
    
    <% for (f in cmdFmt[c]) { %>
      fmt[cmd].push('<%= f %>');
    <% } %>
<% } %>

function showResult(eid) {
 //alert("1");
 hqDojo.byId("results_msgLive").innerHTML = "${l.selectResult} (${l.command} " + liveResults.command +
                                       "&nbsp;&nbsp;&nbsp;&nbsp;${l.target} " + resInfo[eid].name+")";
  var results = liveResults.results;
  for (var i=0; i<results.length; i++) {
    var description = '';
    var r = results[i];
    if(r.result.substring(0,12)=='Successfully'){
     description= '${l.successfulMessage} (${l.command} '+liveResults.command+'&nbsp;&nbsp;&nbsp;&nbsp;${l.target}'+resInfo[eid].name+')';
    }
    if(r.result.substring(0,6)=='Failed'){
     description= '${l.failedMessage}';
    }
    if (r.rid == eid) {
      if (r.result) {
      hideErrorPanel();
      hqDojo.byId('result').innerHTML =  "<div class='agentcmd_result'><table cellpadding='0' cellspacing='0' width='100%'><thead><tr><td>${l.result}</td></tr></thead><tbody><tr><td>" + description + "</td></tr></tbody></table></div>";
      } else {
      handleError(r.error);
      //hqDojo.byId('result').innerHTML = r.error;
      }
      break;
    }
  }
  <% if (isGroup) { %>
    if (lastSelected) {
      hqDojo.byId('mem_' + lastSelected).style.color = 'black';
      hqDojo.byId('mem_' + lastSelected).style.fontWeight = 'normal';
    }
    hqDojo.byId('mem_' + eid).style.color = '#60A5EA';
    hqDojo.byId('mem_' + eid).style.fontWeight = 'bold';
    lastSelected = eid;
  <% } %>
}

function processResult(result) {
  liveResults = result;
  <% if (!isGroup) { %>
    showResult('${eid}');
  <% } else { %>
    hqDojo.byId("groupMembers").className = 'hasData';
  
    var res = result.results;
    for (var i=0; i<res.length; i++) {
      var r = res[i];
      
      if (r.result) {
        hqDojo.byId('clicker_' + r.rid).className = 'goodResults';
      } else {
        hqDojo.byId('clicker_' + r.rid).className = 'errorResults';
      }
      if (lastSelected) {
        showResult(lastSelected);
      }
    }
  <% } %>
}

function runCommand() {
  var cmdSelect = hqDojo.byId('commandSelect');  
  if (cmdSelect.selectedIndex == 0)
    return;
  var cmd = cmdSelect.options[cmdSelect.selectedIndex].value;

  var paramSelect = hqDojo.byId('paramSelect');
  var param;
  if (paramSelect != null) {
    if (paramSelect.selectedIndex >= 0)
      param = paramSelect.options[paramSelect.selectedIndex].value;
    else
      return;
  }
  
  var url;
  if (cmd == 'upgrade') {
    url = '<%= urlFor(action:'invoke') %>' + 
            '?cmd=' + cmd + 
            '&bundle=' + param + 
            '&eid=<%= eid %>';
  } 
  else if (cmd == 'push plugin') {
    url = '<%= urlFor(action:'invoke') %>' + 
            '?cmd=' + cmd + 
            '&plugin=' + param + 
            '&eid=<%= eid %>';
  }   
  else {
    url = '<%= urlFor(action:'invoke') %>' + 
            '?cmd=' + cmd + 
            '&eid=<%= eid %>';  
  }
  
  var fmtSelect = hqDojo.byId('fmt_' + cmd);
  if (fmtSelect.selectedIndex != -1) {
    var fmt = fmtSelect.options[fmtSelect.selectedIndex].value;
    url = url + '&formatter=' + fmt;
  } 

  if (++ajaxCount > 0) {
    hqDojo.byId("spinner").style.visibility = 'visible';  
  }
    
  hqDojo.xhrGet({
    url: url,
    handleAs: "json-comment-filtered",
    load: function(response, args) {
      if (--ajaxCount == 0) {
        hqDojo.byId("spinner").style.visibility = 'hidden';  
      }
      processResult(response);
    },
    error: function(response, args) {
      //alert('There has been an error:  ' + err);
    }
  });
}

function handleError(er) {
    var msgPanelObj = hqDojo.byId("messagePanel");
    if(msgPanelObj.style.display != "block") {
        msgPanelObj.style.display = "block";
    }

    if (er.search(/Unknown command/) < 0)
        hqDojo.byId("messagePanelMessage").innerHTML = er;
    else
        hqDojo.byId("messagePanelMessage").innerHTML = "${l.agentUnknownCommand}";
}

function hideErrorPanel() {
      var msgPanelObj = hqDojo.byId("messagePanel");
            if(msgPanelObj.style.display = "block") {
            msgPanelObj.style.display = "none";
            hqDojo.byId("messagePanelMessage").innerHTML = '';
            }
}

var legends = {};
legends['restart'] = '${l.restart}';
legends['ping'] = '${l.ping}';
legends['upgrade'] = '${l.upgrade}';
legends['push plugin'] = '${l.push_plugin}';

function updateLegend(select){
    var legendDiv = hqDojo.byId("legend");
    if(select.selectedIndex <= 0){
        legendDiv.innerHTML = "";
        return;
    }
    legendDiv.innerHTML = legends[select.options[select.selectedIndex].value];
}

function updateCmdOptions(select){
    var options = hqDojo.byId("cmdOptions");

      var paramSelect = hqDojo.byId("paramSelect");
      if (paramSelect != null)
        options.removeChild(paramSelect);
      var paramLbl = hqDojo.byId("paramLbl");
      if (paramLbl != null)
        options.removeChild(paramLbl);
      var execute = hqDojo.byId("execute");
      if (execute != null)
        options.removeChild(execute);
        
   if(select.selectedIndex <= 0) {
       return;
   }
   else if (select.options[select.selectedIndex].value == 'upgrade') {
     
        <% if (bundles != []) { %>
            var paramLbl = document.createElement('div');
            paramLbl.setAttribute("id", "paramLbl");
            paramLbl.setAttribute("class", "instruction1");
            paramLbl.innerHTML="${l.selectUpgradeableAgent}";
            options.appendChild(paramLbl);
            
            var paramSelect = document.createElement('select');
            paramSelect.setAttribute("id", "paramSelect");
            paramSelect.setAttribute("style", "margin-bottom:5px;");
            var option;
            <% for (b in bundles) { %>
                 option = document.createElement('option');
                 option.setAttribute("value", "${b}");
                 option.innerHTML="${h b}";
                 paramSelect.appendChild(option);
            <% } %>
           options.appendChild(paramSelect);
     
            var execBtn = document.createElement('input');
            execBtn.setAttribute("type", "button");
            execBtn.setAttribute("id", "execBtn");
            execBtn.setAttribute("value", "Execute");
            execBtn.onclick = function() { runCommand() };

            var execute = document.createElement('div');
            execute.setAttribute("id", "execute");
            execute.appendChild(execBtn);
            options.appendChild(execute);
        <% } else { %>
            var paramLbl = document.createElement('div');
            paramLbl.setAttribute("id", "paramLbl");
            paramLbl.setAttribute("class", "instruction1");
            paramLbl.innerHTML="There are no agent bundles available for upgrade.";
            options.appendChild(paramLbl);
         <% } %>
    }
   else if (select.options[select.selectedIndex].value == 'push plugin') {
     
        <% if (plugins != []) { %>
            var paramLbl = document.createElement('div');
            paramLbl.setAttribute("id", "paramLbl");
            paramLbl.setAttribute("class", "instruction1");
            paramLbl.innerHTML="${l.selectServerPlugin}";
            options.appendChild(paramLbl);
            
            var paramSelect = document.createElement('select');
            paramSelect.setAttribute("id", "paramSelect");
            paramSelect.setAttribute("style", "margin-bottom:5px;");
            var option;
            <% for (p in plugins) { %>
                 option = document.createElement('option');
                 option.setAttribute("value", "${p}");
                 option.innerHTML="${h p}";
                 paramSelect.appendChild(option);
            <% } %>
           options.appendChild(paramSelect);
     
            var execBtn = document.createElement('input');
            execBtn.setAttribute("type", "button");
            execBtn.setAttribute("id", "execBtn");
            execBtn.setAttribute("value", "Execute");
            execBtn.onclick = function() { runCommand() };
            var execute = document.createElement('div');

            execute.setAttribute("id", "execute");
            execute.appendChild(execBtn);
            options.appendChild(execute);
        <% } else { %>
            var paramLbl = document.createElement('div');
            paramLbl.setAttribute("id", "paramLbl");
            paramLbl.setAttribute("class", "instruction1");
            paramLbl.innerHTML="There are no server plugins available to push.";
            options.appendChild(paramLbl);
         <% } %>
    }    
    else  {
            var execBtn = document.createElement('input');
            execBtn.setAttribute("type", "button");
            execBtn.setAttribute("id", "execBtn");
            execBtn.setAttribute("value", "Execute");
            execBtn.onclick = function() { runCommand() };

            var execute = document.createElement('div');
            execute.setAttribute("id", "execute");
            execute.appendChild(execBtn);
            options.appendChild(execute);
    }
}

hqDojo.ready(function(){
    updateLegend(hqDojo.byId("commandSelect"));
});


</script>
<div class="messagePanel messageInfo" style="display:none;" id="messagePanel"><div class="infoIcon"></div><span id="messagePanelMessage"></span></div>
<div class="outerLiveDataCont" style="clear:both;">

  <div class="leftbx">

    <div class="leftboxborder">

      <div class="BlockTitle"><div style="float:left;">${l.excuteCommand}</div><div class="acLoader2" id="spinner" style="display:inline;float:right;"></div>
      <br class="clearBoth">
      </div>

      <div class="fivepad">

        <div style="padding-left:5px;">
            <div class="instruction1">${l.selectAgent}</div>
        <select id="commandSelect" onchange="updateLegend(this);updateCmdOptions(this);" style="margin-bottom:5px;">
        <% for (c in commands) { %>
          <option value="${c}">${h c}</option>
        <% } %>
      </select>
      </div>
      <div id="legend" style="padding: 1px 5px 5px 2px; font-style: italic;"></div>
      <div id="cmdOptions" style="padding: 1px 5px 5px 2px; font-style: italic;"></div>
      <% if (isGroup) { %>
        <div class="grpmembertext">Group Members</div>
        <div id="groupMembers" class="pendingData">
        <ul>
        <% for (m in groupMembers) { %>
        <li>
        <div id="clicker_${m.entityId}" style="float:left;display:inline;height:16px;width:18px;" class="restingExec" onclick="showResult('${m.entityId}')" title="Click to view query information on this resource">&nbsp;&nbsp;&nbsp;&nbsp;</div>
        <div class="groupMemberName"><span id="mem_${m.entityId}">${h m.name}</span></div>

            <br class="clearBoth">
        </li>
        <% } %>
        </ul>
        </div>
        <% } %>

    <div id="formatters_cont">
      <% for (c in commands) { %>
      <div id="fmt_cont_${c}" style="display:none">
        Formatter:
        <select id="fmt_${c}">
          <% for (f in cmdFmt[c]) { %>
            <option value="${f}">${formatters[f].name}</option>
          <% } %>
        </select>
      </div>
      <% } %>
    </div>


  </div>
</div>

</div>

<div id="result_cont">
  <div id="results_msgLive"></div>
  <div id="result" class="bxblueborder"></div>
</div>
 <div style="height:1px;width:1px;clear:both;">&nbsp;</div>
</div>
