<script type="text/javascript">
    document.navTabCat = "Admin";
</script>
<html>
    <%
        def version = plugin.descriptor.get('plugin.version')
        def clientPackage = "hqapi1-client-" + version + ".tar.gz"
        def apijarUrl = "/" + urlFor(asset:clientPackage)
    %>
    <h2>${l.hqapi1header}</h2>

    ${l.hqapi1Memo}<br>

    <h3>${l.hqapi1Download}</h3>
    <ul>
        <li>
            ${l.hqapi1Download} <a href="${apijarUrl}">${clientPackage}</a>
        </li>
    </ul>

    <h3>${l.hqapi1MethodStatic}</h3>

    <table border="1">
        <thead>
            <tr>
                <td>${l.hqapi1SMethod}</td><td>${l.hqapi1STotalCall}</td><td>${l.hqapi1SMinTime}</td><td>${l.hqapi1SMaxTime}</td><td>${l.hqapi1STotalTime}</td>                
            </tr>
        <%
            stats.each { k, v ->
        %>
                <tr>
                    <td>${k}</td><td>${v.calls}</td><td>${v.minTime}</td><td>${v.maxTime}</td><td>${v.totalTime}</td>
                </tr>
        <%
            }
        %>
        </thead>
    </table>
   
</html>

<script>
var div = document.getElementById("migContainer");
var hquTitle=div.getElementsByTagName("table")[0].getElementsByTagName("tbody")[0].getElementsByTagName("tr")[0].getElementsByTagName("td")[2];
hquTitle.innerHTML="${l.hqapi1description}";
</script>