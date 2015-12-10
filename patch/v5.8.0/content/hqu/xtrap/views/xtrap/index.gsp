
<script type="text/javascript">

    // All charts will share the same time and value geometery.
    var timeGeometry = null;
    function getTimeGeometry() {
        if (timeGeometry == null) {
            timeGeometry = new Timeplot.DefaultTimeGeometry({
                gridColor: new Timeplot.Color("#000000"),
                axisLabelsPlacement: "top"
            });
        }
        return timeGeometry;
    }

    var valueGeometry = null;
    function getValueGeometry() {
        if (valueGeometry == null) {
            valueGeometry = new Timeplot.DefaultValueGeometry({
                gridColor: "#000000"
            });
        }
        return valueGeometry;
    }

    var alertSource = new Timeplot.DefaultEventSource();
    <% for (m in measurements) { %>
    <%= "var timeplot${m.id};" %>
    <%= "var metricSource${m.id} = new Timeplot.DefaultEventSource();"%>
    <%= "var valueGeometry${m.id} = new Timeplot.DefaultValueGeometry({ gridColor: \"#000000\" });"%>
    <%= "var plotInfo${m.id} "%> = [
        Timeplot.createPlotInfo({
             <%= "id: \"metricData${m.id}\", "%>
             <%= "dataSource: new Timeplot.ColumnSource(metricSource${m.id},1),"%>
             valueGeometry: getValueGeometry(),
             timeGeometry: getTimeGeometry(),
             lineColor: "#2D6EBE",
             fillColor: "#2D6EBE",
             roundValues: false,
             showValues: true
        }),
        Timeplot.createPlotInfo({
            <%= "id: \"projectionData${m.id}\","%>
            <%= "dataSource: new Timeplot.ColumnSource(metricSource${m.id},2),"%>
            valueGeometry: getValueGeometry(),
            timeGeometry: getTimeGeometry(),
            lineColor: "#F35E0C",
            fillColor: "#F35E0C",
            roundValues: false,
            showValues: true
        }),
        Timeplot.createPlotInfo({
            <%= "id: \"threshold{m.id}\","%>
            <%= "dataSource: new Timeplot.ColumnSource(metricSource${m.id},3),"%>
            valueGeometry: getValueGeometry(),
            timeGeometry: getTimeGeometry(),
            lineColor: "#000000",
            roundValues: false,
            showValues: true
        }),
        Timeplot.createPlotInfo({
            id: "eventData",
            timeGeometry: getTimeGeometry(),
            eventSource: alertSource,
            lineColor: "#0099FF"
        })
    ];
    <% } %>

    hqDojo.ready( function() {
        <% for (m in measurements) { %>
        <%= "timeplot${m.id} = Timeplot.create(document.getElementById(\"plot${m.id}\"), plotInfo${m.id});"%>
        <%= "timeplot${m.id}.loadText('/hqu/xtrap/xtrap/data.hqu?mid=${m.id}&data=${data}&projection=${projection}&threshold=${threshold}', \",\", metricSource${m.id});"%>
        //<%= "timeplot${m.id}.loadXML('/hqu/xtrap/xtrap/alerts.hqu?rid=${m.resource.id}', alertSource);"%>
        <% } %>
    });

    var resizeTimerID = null;
    function repaintCharts() {
        if (resizeTimerID == null) {
            resizeTimerID = window.setTimeout(function() {
                resizeTimerID = null;
                <% for (m in measurements) { %>
                <%= "timeplot${m.id}.repaint();" %>
                <% } %>
            }, 100);
        }
    }
    
	    hqDojo.connect(window, 'onresize', this, "repaintCharts");
    
</script>

<form method="POST" action="#">
    <span><strong>${l.xmtrics}</strong>
        <%= selectList(selectTemplates, [id:'tid',name:'tid'], tid) %>
    </span>
    <span><strong>${l.xknowdatarange}</strong>
        <%= selectList(selectRanges,
     	               [id:'data', name:'data'], data) %>
    </span>
    <span><strong>${l.xprojrange}</strong>
        <%= selectList(selectRanges,
                       [id:'projection', name:'projection'], projection) %>
    </span>
    <span><strong>${l.xthreshold}</strong>
        <input id="threshold" type="text" name="threshold" value="<%="${threshold}"%>"/> <strong><%="(${l.xunits} ${thresholdUnits})"%></strong>
    </span>
    <input type="submit" value="${l.xupdate}" onclick="document.forms[0].submit()">
</form>

<% for (m in measurements) {
    def c = confidence.get(m.id)
%>
<div class="projectionChart">
    <p class="chartTitle">
        <%="<strong>${m.resource.name} - ${m.template.name} ${l.xunits} ${m.template.units} ${l.xconfidence} ${c.displayValue} (${c.value})</strong>"%>
    </p>
    <div id="<%="plot" + m.id%>" style="width: 95%;"></div>
</div>

<% } // for (m in measurements) %>

