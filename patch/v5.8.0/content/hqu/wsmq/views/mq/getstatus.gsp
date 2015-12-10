
<% def cont=0 %>
<h2>Channels</h2>
<table border="0" cellpadding="0" cellspacing="0" width="100%">
  <tr class="tableRowHeader">
    <th class="tableRowSorted" width="20%">QManager</th>
    <th class="tableRowSorted" width="20%">Channel</th>
    <th class="tableRowSorted" align="center" width="5%">Msg/min</th>
    <th class="ListHeaderCheckbox" colspan="3" width="10%">Availability</th>
    <th class="tableRowSorted" align="center" width="5%">Msg/min</th>
    <th class="tableRowSorted" width="20%">Channel</th>
    <th class="tableRowSorted" width="20%">QManager</th>
  </tr>
  <% channels.each { channel -> %>
  <tr class="tableRow<%= (((cont++)%2)==0)? "Odd": "Even" %>">
  <td class="tableCell" rowspan="${ channel.target.size }" align="right" valign="top" ><a href="/Resource.do?eid=${ channel.source.queueManagerId }">${channel.source.queueManagerName}</a></td>
  <td class="tableCell" rowspan="${ channel.target.size }" align="right" valign="top" ><a href="/Resource.do?eid=${ channel.source.channelID }">${channel.source.channelName}</a></td>
  <td class="ListCellCheckbox" rowspan="${ channel.target.size }" align="center" valign="middle">${ channel.source.msgs }</td>
  <td class="ListCellCheckbox" rowspan="${ channel.target.size }" align="center" valign="middle"><img name="avail${ channel.source.id }" src="/resource/Availability?timeout=30000&amp;eid=${ channel.source.entityId }#<%=System.currentTimeMillis()%>" alt="" border="0" width="12" height="12"></td>
  <td class="ListCellCheckbox" rowspan="${ channel.target.size }" align="center" valign="middle"><%= (channel.reverse)?"&laquo;&laquo;":"&raquo;&raquo;" %></td>
  <% def item=0;
channel.target.each { target ->
    if(target !=null) {
        if(item>0) {%><tr class="tableRow<%= (((cont++)%2)==0)? "Odd": "Even" %>"><% } %>
  <td class="ListCellCheckbox" align="center" valign="middle"><img name="avail${ target.channelID }" src="/resource/Availability?timeout=30000&amp;eid=${ target.channelID }#<%=System.currentTimeMillis()%>" alt="" border="0" width="12" height="12"></td>
  <td class="ListCellCheckbox" align="center" valign="middle">${ target.msgs }</td>
  <td class="tableCell" align="left" valign="top" ><a href="/Resource.do?eid=${ target.channelID }">${target.channelName }</a></td>
  <td class="tableCell" align="left" valign="top" ><a href="/Resource.do?eid=${ target.queueManagerId }">${target.queueManagerName}</a></td>
  <% if(item++>0) {%><tr class="tableRow<%= (((cont++)%2)==0)? "Odd": "Even" %>"><%}%>
  <% } %>
  <% } %>
  </tr>
  <% } %>
</table>

<% cont=0 %>
<h2>Remote Queues</h2>
<table border="0" cellpadding="0" cellspacing="0" width="100%">
  <tr class="tableRowHeader">
    <th class="tableRowSorted" align="right" width="20%">QManager</th>
    <th class="tableRowSorted" align="right" width="20%">Queue</th>
    <th class="tableRowSorted" align="center" width="5%">Depth</th>
    <th class="ListHeaderCheckbox" colspan="3" width="10%">Availability</th>
    <th class="tableRowSorted" align="center" width="5%">Depth</th>
    <th class="tableRowSorted" width="20%">Queue</th>
    <th class="tableRowSorted" width="20%">QManager</th>
  </tr>
  <% rqueues.each { rq -> %>
  <tr class="tableRow<%= (((cont)%2)==0)? "Odd": "Even" %>">
    <td class="tableCell" align="center" colspan="9" width="10%"><a href="/Resource.do?eid=${ rq.remote.entityId }">${rq.remote.name}</a></td>
  </tr>
  <tr class="tableRow<%= (((cont++)%2)==0)? "Odd": "Even" %>">
    <td class="tableCell" align="right" valign="top" ><a href="/Resource.do?eid=${ rq.transmit.queueManagerId }">${rq.transmit.queueManagerName}</a></td>
    <td class="tableCell" align="right" valign="top" ><a href="/Resource.do?eid=${ rq.transmit.entityId }">${rq.transmit.queueName}</a></td>
    <td class="ListCellCheckbox" align="center" valign="middle">${ rq.transmit.depth }</td>
    <td class="ListCellCheckbox" align="center" valign="middle"><img name="avail${ rq.transmit.id }" src="/resource/Availability?timeout=30000&amp;eid=${ rq.transmit.entityId }#<%=System.currentTimeMillis()%>" alt="" border="0" width="12" height="12"></td>
    <td class="ListCellCheckbox" align="center" valign="middle">&raquo;&raquo;</td>
    <td class="ListCellCheckbox" align="center" valign="middle"><img name="avail${ rq.local.id }" src="/resource/Availability?timeout=30000&amp;eid=${ rq.local.entityId }#<%=System.currentTimeMillis()%>" alt="" border="0" width="12" height="12"></td>
    <td class="ListCellCheckbox" align="center" valign="middle">${ rq.local.depth }</td>
    <td class="tableCell" align="left" valign="top" ><a href="/Resource.do?eid=${ rq.local.entityId }">${rq.local.queueName}</a></td>
    <td class="tableCell" align="left" valign="top" ><a href="/Resource.do?eid=${ rq.local.queueManagerId }">${rq.local.queueManagerName}</a></td>
  </tr>
  <% } %>
</table>

<% cont=0 %>
<h2>Cluster Channels</h2>
<table border="0" cellpadding="0" cellspacing="0" width="100%">
  <tr class="tableRowHeader">
    <th class="tableRowSorted" width="20%">QManager</th>
    <th class="tableRowSorted" width="20%">Channel</th>
    <th class="tableRowSorted" align="center" width="5%">Msg/min</th>
    <th class="ListHeaderCheckbox" colspan="3" width="10%">Availability</th>
    <th class="tableRowSorted" align="center" width="5%">Msg/min</th>
    <th class="tableRowSorted" width="20%">Channel</th>
    <th class="tableRowSorted" width="20%">QManager</th>
  </tr>
  <% clusterChannels.each { channel -> %>
  <tr class="tableRow<%= (((cont)%2)==0)? "Odd": "Even" %>">
  <td class="tableCell" rowspan="${ channel.target.size }" align="right" valign="top" ><a href="/Resource.do?eid=${ channel.source.queueManagerId }">${channel.source.queueManagerName}</a></td>
  <td class="tableCell" rowspan="${ channel.target.size }" align="right" valign="top" ><a href="/Resource.do?eid=${ channel.source.channelID }">${channel.source.channelName}</a></td>
  <td class="ListCellCheckbox" rowspan="${ channel.target.size }" align="center" valign="middle">${ channel.source.msgs }</td>
  <td class="ListCellCheckbox" rowspan="${ channel.target.size }" align="center" valign="middle"><img name="avail${ channel.source.id }" src="/resource/Availability?timeout=30000&amp;eid=${ channel.source.entityId }#<%=System.currentTimeMillis()%>" alt="" border="0" width="12" height="12"></td>
  <td class="ListCellCheckbox" rowspan="${ channel.target.size }" align="center" valign="middle"><%= (channel.reverse)?"&laquo;&laquo;":"&raquo;&raquo;" %></td>
  <% def item=0;
            channel.target.each { target ->
                if(target !=null) {
                    if(item>0) {%><tr class="tableRow<%= ((cont%2)==0)? "Odd": "Even" %>"><% } %>
  <td class="ListCellCheckbox" align="center" valign="middle"><img name="avail${ target.channelID }" src="/resource/Availability?timeout=30000&amp;eid=${ target.channelID }#<%=System.currentTimeMillis()%>" alt="" border="0" width="12" height="12"></td>
  <td class="ListCellCheckbox" align="center" valign="middle">${ target.msgs }</td>
  <td class="tableCell" align="left" valign="top" ><a href="/Resource.do?eid=${ target.channelID }">${target.channelName }</a></td>
  <td class="tableCell" align="left" valign="top" ><a href="/Resource.do?eid=${ target.queueManagerId }">${target.queueManagerName }</a></td>
  <% if(item++>0) {%><tr class="tableRow<%= ((cont%2)==0)? "Odd": "Even" %>"><%}%>
  <% } %>
  <% } %>
  </tr>
  <% cont++ } %>
</table>

<% cont=0 %>
<h2>Cluster Queues</h2>
<table border="0" cellpadding="0" cellspacing="0" width="50%">
  <tr class="tableRowHeader">
    <th class="tableRowSorted" align="right" width="40%">QManager</th>
    <th class="tableRowSorted" align="right" width="40%">Queue</th>
    <th class="tableRowSorted" align="center" width="10%">Depth</th>
    <th class="ListHeaderCheckbox" colspan="3" width="20%">Availability</th>
  </tr>
  <% clusterQueuesList.each { clusterQueues -> %>
  <tr class="tableRow<%= (((cont)%2)==0)? "Odd": "Even" %>">
    <td class="tableRowSorted" align="center" colspan="3"><b>Cluster: </b><a href="/Resource.do?eid=${ clusterQueues.clusterId }">${ clusterQueues.clusterName }</a></td>
    <td class="ListCellCheckbox" align="center" valign="middle"><img name="avail${ clusterQueues.clusterId }" src="/resource/Availability?timeout=30000&amp;eid=${ clusterQueues.clusterId }#<%=System.currentTimeMillis()%>" alt="" border="0" width="12" height="12"></td>
  </tr>
  <% clusterQueues.queues.each { q -> %>
  <tr class="tableRow<%= (((cont++)%2)==0)? "Odd": "Even" %>">
    <td class="tableCell" align="right" valign="top" ><a href="/Resource.do?eid=${ q.queueManagerId }">${ q.queueManagerName }</a></td>
    <td class="tableCell" align="right" valign="top" ><a href="/Resource.do?eid=${ q.entityId }">${ q.queueName}</a></td>
    <td class="ListCellCheckbox" align="center" valign="middle">${ q.depth }</td>
    <td class="ListCellCheckbox" align="center" valign="middle"><img src="/resource/Availability?timeout=30000&amp;eid=${ q.entityId }#<%=System.currentTimeMillis()%>" alt="" border="0" width="12" height="12"></td>
  </tr>
  <% } %>
  <% } %>
</table>

