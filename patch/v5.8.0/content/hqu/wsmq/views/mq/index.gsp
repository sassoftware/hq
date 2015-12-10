<script language="JavaScript1.2">
    var mq_time = 0;
    var mq_timer;

    function refreshMQ() {
        hqDojo.byId('dataMQ').innerHTML = "Loadin data...";
        new Ajax.Request('<%= urlFor action:'getstatus', eid: eid %>', {method: 'get', onSuccess:showMQCompltetStatus});
    }

    function showMQCompltetStatus(originalRequest) {
        hqDojo.byId('dataMQ').innerHTML = originalRequest.responseText;
        clearTimeout(mq_timer);
        mq_timer=setTimeout("refreshMQ()",mq_time);
    }

    function initMQ()
    {
        refresh60()
        refreshMQ();
    }

    function resetAll() {
        hqDojo.byId('refresh60').innerHTML = '<a href="javascript:refresh60()">1 min</a>';
        hqDojo.byId('refresh120').innerHTML = '<a href="javascript:refresh120()">2 min</a>';
        hqDojo.byId('refresh300').innerHTML = '<a href="javascript:refresh300()">5 min</a>';
        hqDojo.byId('refreshOff').innerHTML  = '<a href="javascript:refreshOff()">OFF';
    }

    function refresh60() {
        resetAll();
        mq_time=60*1000;
        hqDojo.byId('refresh60').innerHTML = '1 min';
    }

    function refresh120() {
        resetAll();
        mq_time=120*1000;
        hqDojo.byId('refresh120').innerHTML = '2 min';
    }

    function refresh300() {
        resetAll();
        mq_time=300*1000;
        hqDojo.byId('refresh300').innerHTML = '5 min';
    }

    function refreshOff() {
        resetAll();
        mq_time=99999*1000;
        hqDojo.byId('refreshOff').innerHTML = "OFF";
    }

    onloads.push( initMQ );
</script>


<table width="100%" cellpadding="5" cellspacing="0" border="0" class="MonitorToolBar">
  <tr>
    <td width="100%" align="center" nowrap>
      <div id="UpdatedTime" style="color: grey">&nbsp;</div>
    </td>

    <td align="right" nowrap>
      <span id="CurrentValuesLabel">Refresh:</span>
      <span id="refresh60"><a href="javascript:refresh60()">1 min</a></span>
      |
      <span id="refresh120">2 min</span>
      |
      <span id="refresh300"><a href="javascript:refresh300()">5 min</a></span>
      |
      <span id="refreshOff"><a href="javascript:refreshOff()">OFF</a></span>
      |
      <span id="refreshOff"><a href="javascript:refreshMQ()">now</a></span>
    </td>

  </tr>
</table>
<span id="dataMQ"></span>