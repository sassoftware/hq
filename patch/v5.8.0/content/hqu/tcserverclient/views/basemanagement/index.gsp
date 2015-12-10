
<html>
    <%
        def version = plugin.descriptor.get('plugin.version')
        def apijarUrl = "/" + urlFor(asset:fileName)
    %>

    <h2>${l.tcservercHeader}</h2>


    <h3>${l.tcservercDownload}</h3>
    <ul>
        <li>
            ${l.tcservercDownload} - <a href="${apijarUrl}">tcserver-scripting-client.zip</a>
        </li>
    </ul>
	
   
</html>
<script>
var div = document.getElementById("migContainer");
var hquTitle=div.getElementsByTagName("table")[0].getElementsByTagName("tbody")[0].getElementsByTagName("tr")[0].getElementsByTagName("td")[2];
hquTitle.innerHTML="${l.tcserverclientdescription}";
</script>