<div class="gConsoleContainer">
    <label>${l.gconsoleTemplates}</label>
    <fieldset>
    <% if(templates == null || templates.size == 0 ) { %>
        ${l.gconsoleReminder}
    <% } %>
    <% for(t in templates) { %>
      <a class="chooseTemplateLink">${t}</a> |
    <% } %>
    </fieldset>
    <br/>
    <label for="code" style="display:block">${l.gconsoleCode}</label>
    <textarea id="code" rows="30"></textarea>
    <br/><br/>
    
    <div>
        <a id="executeLink" class="buttonGreen" href="#"><span>${l.gconsoleExcute}</span></a>
    </div>
    <br/>
    
    <div id='timeStatus'>
      ${l.gconsoleStatus}
    </div>
    <br/>
    
    <label>${l.gconsoleResult}</label>
    <fieldset>
        <pre>
          <div id='result'></div>
        <pre>
    </fieldset>
</div>
<script type="text/javascript">
document.navTabCat = "Admin";
var gconsoleExecuteUrl = "<%= urlFor(action:"execute", encodeUrl:true) %>";

hqDojo.ready(function() {
	hqDojo.connect(hqDojo.byId("executeLink"), "onclick", function(e) {
		hqDojo.byId('timeStatus').innerHTML = '${l.executing}';
		
		hqDojo.xhrPost({
    		url: gconsoleExecuteUrl,
	    	handleAs: "json-comment-filtered",
    		content: {
        		code:   hqDojo.byId("code").value
	    	},
    		load: function(response, args) {
      			hqDojo.byId('result').innerHTML = response.result;
      			if(hqDojo.byId('result').innerHTML=="null"){
      			 hqDojo.byId('result').innerHTML='${l.nullValue}';
      			}
      			hqDojo.byId('timeStatus').innerHTML = response.timeStatus;
      			
      			if (response.actionToken) {
      				// use new CSRF token for subsequent POST requests
      				gconsoleExecuteUrl = response.actionToken;
      			}
	    	},
    		error: function(response, args) {
      			alert('error! ' + response);
	    	}
	    });
  	});

  	hqDojo.query(".chooseTemplateLink").onclick(function(e) {
  		hqDojo.xhrGet({
    		url: '<%= urlFor(action:"getTemplate") %>',
	    	handleAs: "json-comment-filtered",
    		content: {
        		template: e.target.innerHTML
	        },
    		load: function(response, args) {
      			hqDojo.byId('code').value = response.result;
	    	},
    		error: function(response, args) {
      			alert('error! ' + response);
	    	}
  		});
  	});
});
</script>
<script>
var div = document.getElementById("migContainer");
var hquTitle=div.getElementsByTagName("table")[0].getElementsByTagName("tbody")[0].getElementsByTagName("tr")[0].getElementsByTagName("td")[2];
hquTitle.innerHTML="${l.gconsoledescription}";
</script>