<link type="text/css" rel="stylesheet" href="${urlFor(asset:'css')}/smoothness/jquery-ui-1.7.1.custom.css" />
<link type="text/css" rel="stylesheet" href="${urlFor(asset:'css')}/depman.css" />

<script src="${urlFor(asset:'js')}/jquery-1.3.2.modified.js" type="text/javascript"></script>
<script type="text/javascript">
	// Because prototype is also being used in HQ, we need to do this to play nice
	jQuery.noConflict();
</script>
<script src="${urlFor(asset:'js')}/jquery-ui-1.7.1.custom.min.js" type="text/javascript"></script>
<script src="${urlFor(asset:'js')}/depman.js" type="text/javascript"></script>

<script type="text/javascript">
	jQuery(document).ready(function() {
		DEPMAN.CONFIRM_REMOVE_ALL_ACTION_MSG = "${l.removeAllConfirmationMessage}";
		DEPMAN.CONFIRM_REMOVE_SELECTED_ACTION_MSG = "${l.removeSelectedConfirmationMessage}";
		DEPMAN.PROCESSING_FILTER_MSG = "${l.filterProcessingMessage}";
		DEPMAN.PROCESSING_REMOVE_SELECTED_MSG = "${l.removeDependenciesProcessingMessage}";
		DEPMAN.PROCESSING_REMOVE_ALL_MSG = "${l.removeAllDependenciesProcessingMessage}";
		DEPMAN.PROCESSING_ADD_SELECTED_MSG = "${l.addDependenciesProcessingMessage}";
		DEPMAN.init({
			topLevelPlatformsDataURL : "<%= urlFor(action : "loadTopLevelPlatforms", encodeUrl:true) %>",
			dependentPlatformsWithParentDataURL : "<%= urlFor(action : "loadAllDependentPlatforms", encodeUrl:true) %>",
			dependentPlatformsDataURL : "<%= urlFor(action : "loadDependentPlatforms", encodeUrl:true) %>",
			availablePlatformsDataURL : "<%= urlFor(action : "loadAvailablePlatforms", encodeUrl:true) %>",
			addDependentPlatformsURL : "<%= urlFor(action : "addDependentPlatforms", encodeUrl:true) %>",
			removeDependentPlatformsURL : "<%= urlFor(action : "removeDependentPlatforms", encodeUrl:true) %>",
			removeAllDependentPlatformsURL : "<%= urlFor(action : "removeAllDependentPlatforms", encodeUrl:true) %>"
		});
    });
    // Highlight Admin Tab
    document.navTabCat = "Admin";
</script>

<div id="depManLayout" style="display: none";>
	<p>
		<span class="instructions">${l.instructions}</span>
	</p>
	<div id="filterTabPanel">
		<ul>
			<strong>${l.Filter}</strong>
			<li><a href="#topLevelFilters">${l.topLevelPlatforms}</a></li>
			<li><a href="#dependentFilters">${l.dependentPlatforms}</a></li>
		</ul>
		<div id="topLevelFilters">
			<span class="instructions">${l.instructionsTopLevelPlatforms}</span>
			<fieldset>
				<p>
					<span>${l.name}</span>
					<input type="text" id="byNameFilterTopLevelPlatforms" value="" onfocus="this.select();" />
				</p>
				<p>
					<span>${l.type}</span>
					<select id="byTypeFilterTopLevelPlatforms">
						<option value="">${l.anyType}</option>
						<%
							topLevelPlatformTypes.each { pType ->
								out.write("<option value=\"" + pType.id + "\">" + pType.name + "</option>")
							}
						%>
					</select>
				</p>
				<p>
					<span>${l.show}</span>
					<select id="byShowFilterTopLevelPlatforms">
						<option selected="selected" value="">${l.all}</option>
						<option value="withdeps">${l.withDeps}</option>
						<option value="wodeps">${l.withoutDeps}</option>
					</select>
				</p>
			</fieldset>
		</div>
		<div id="dependentFilters">
			<span class="instructions">${l.instructionsDependencyPlatforms}</span>
			<fieldset>
				<p>
					<span>${l.name}</span>
					<input type="text" id="byNameFilterDependentPlatforms" value="" onfocus="this.select();" />
				</p>
				<p>
					<span>${l.type}</span>
					<select id="byTypeFilterDependentPlatforms">
						<option value="-1">${l.selectAType}</option>
						<option value="">${l.anyType}</option>
						<%
							availablePlatformTypes.each { pType ->
								out.write("<option value=\"" + pType.id + "\">" + pType.name + "</option>")
							}
						%>
					</select>
				</p>
			</fieldset>
		</div>
	</div>
	<div id="topLevelPlatformsListContainer">
		<ul id="topLevelPlatformsList"></ul>
	</div>
	<div id="dependentPlatformsListContainer" style="display: none;">
		<ul id="dependentPlatformsList">
			<span id="message">${l.findDependentPlatform}</span>
		</ul>
	</div>
	<div id="actionButtonContainer" class="actionButtonContainer" style="display: none;">	
		<input type="button" id="addDependenciesButton" class="button42" value="${l.addDependencies}" />
		<input type="button" id="removeDependenciesButton" class="button42" value="${l.removeSelectedDependencies}" disabled="true" />
		<input type="button" id="removeAllDependenciesButton" class="button42" value="${l.removeAllDependencies}" disabled="true" />
	</div>
	<div id="availablePlatformsDialog" title="${l.availablePlatforms}" style="height: 368px;">
		<div class="filterPanel">
			<strong>${l.Filter}</strong>&nbsp;
			<!--
			<a id="resetAvailablePlatformFilter" href="#">(${l.reset})</a>
			-->
			<fieldset>
				<p>
					<span>${l.name}</span>
					<input type="text" id="byNameFilterAvailablePlatforms" value="" onfocus="this.select();" />
				</p>
				<p>
					<span>${l.type}</span>
					<select id="byTypeFilterAvailablePlatforms">
						<option value="">${l.anyType}</option>
						<%
							availablePlatformTypes.each { pType ->
								out.write("<option value=\"" + pType.id + "\">" + pType.name + "</option>")
							}
						%>
					</select>
				</p>
			</fieldset>
		</div>
		<div id="availablePlatformListContainer">
			<ul id="availablePlatformsList"></ul>
		</div>
		<div class="listActionButtonContainer">
			<input type="button" class="button42" id="selectAllItemsButton" value="${l.selectAll}" />
  			<input type="button" class="button42" id="unselectAllItemsButton" value="${l.unselectAll}" />
   			<input type="button" class="button42" id="associateButton" value="${l.addDependency}" disabled="true" />
			<input type="button" class="button42" id="doneButton" value="${l.done}" />
		</div>
	</div>
</div>
<script>
var div = document.getElementById("migContainer");
var hquTitle=div.getElementsByTagName("table")[0].getElementsByTagName("tbody")[0].getElementsByTagName("tr")[0].getElementsByTagName("td")[2];
hquTitle.innerHTML="${l.depmandescription}";
</script>