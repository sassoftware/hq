/* NOTE: We're using "jQuery" instead of "$" to reference jQuery functionality
 *       this has been done to minimize conflicts w/ prototype 
 *       
 * Depends on:
 * 		ui.core.js
 * 		ui.dialog.js
 * 		ui.tabs.js
 * 		ui.selectable.js
*/

var DEPMAN = {
	MAX_STRING_LEN : 70,
	MIN_CHAR_LEN : 2,
	KEYUP_TIMEOUT : 400,
	AVAIL_PLATFORM_CLASS_PREFIX : "availPlatform",
	CONFIRM_REMOVE_ALL_ACTION_MSG : "set with i18n string",
	CONFIRM_REMOVE_SELECTED_ACTION_MSG : "set with i18n string",
	PROCESSING_FILTER_MSG : "set with i18n string",
	PROCESSING_REMOVE_SELECTED_MSG : "set with i18n string",
	PROCESSING_REMOVE_ALL_MSG : "set with i18n string",
	PROCESSING_ADD_SELECTED_MSG : "set with i18n string",
	UPDATED_DEPENDENCY_MSG : "set with i18n string",
	
	_config : {},
	
	_truncateString : function(elem, str) {
		return (str.length > DEPMAN.MAX_STRING_LEN) ? 
		          elem.text(str.substr(0, DEPMAN.MAX_STRING_LEN) + "...").attr({ "title" : str }) :
		          elem.text(str);
	},
	
	init : function(config) {	
		this._config = config;
		
		var self = this;
		
		jQuery("#filterTabPanel").tabs({
			select: function(event, ui) {
				if (!jQuery("#topLevelFilters").hasClass("ui-tabs-hide")) {
					jQuery("#topLevelPlatformsListContainer").hide();
					jQuery("#dependentPlatformsListContainer").show();
				} else {
					jQuery("#topLevelPlatformsListContainer").show();
					jQuery("#dependentPlatformsListContainer").hide();
				}
			}
		});
		jQuery("#availablePlatformsList").selectable({ 
			filter : "li", 
			selected : function() {
				var associateButton = jQuery("#associateButton");
				
				associateButton.removeAttr("disabled");
			},
			unselected : function() {
				var associateButton = jQuery("#associateButton");
				
				if (jQuery("#availablePlatformsList .ui-selected").length == 0) {
					associateButton.attr("disabled", "true");
				}
			}
		});
		jQuery("#availablePlatformsDialog").dialog({ 
			modal: true, 
			autoOpen: false,
			bgiframe: true,
			resizable: false,
			width: 850, // For IE
			zIndex: 50,
			open: function(event, ui) {
				if (jQuery.browser.msie) {
					jQuery("#byTypeFilterTopLevelPlatforms").hide();
					jQuery("#byShowFilterTopLevelPlatforms").hide();
				}else{
					jQuery("#availablePlatformsDialog").height(440);
				}				
			},
			close: function(event, ui) {
				if (jQuery.browser.msie) {
					jQuery("#byTypeFilterTopLevelPlatforms").show();
					jQuery("#byShowFilterTopLevelPlatforms").show();
				}			
			}
		});
		
		if (!jQuery.browser.msie) {
			jQuery("#availablePlatformsDialog").dialog("option", "height", 410);
			jQuery("#availablePlatformsDialog").dialog("option", "width", 800);			
		}
		
		this._bindOnChangeEvents();
		this._bindOnClickEvents();
		this._bindOnKeyUpEvents();
		
		this.populateListOfTopLevelPlatforms({}); 
		this.populateListOfAvailablePlatforms({});
		
		jQuery("#depManLayout").show();
	},
	
	_bindOnChangeEvents : function() {
		jQuery("#byTypeFilterTopLevelPlatforms").bind("change", DEPMAN.filterTopLevelPlatformsList);
		jQuery("#byTypeFilterAvailablePlatforms").bind("change", DEPMAN.filterAvailablePlatformsList);
		jQuery("#byTypeFilterDependentPlatforms").bind("change", DEPMAN.filterDependentPlatformsList);
		jQuery("#byShowFilterTopLevelPlatforms").bind("change", DEPMAN.filterTopLevelPlatformsList);
	},
	
	_bindOnClickEvents : function() {
		jQuery("#selectAllItemsButton").bind("click", DEPMAN.selectAllAvailablePlatformListItems);
		jQuery("#unselectAllItemsButton").bind("click", DEPMAN.unselectAllAvailablePlatformListItems);
		jQuery("#associateButton").bind("click", DEPMAN.addSelectedAvailablePlatformsToTopLevelPlatform);
		jQuery("#removeDependenciesButton").bind("click", DEPMAN.removeSelectedDependentPlatformsFromTopLevelPlatform);
		jQuery("#removeAllDependenciesButton").bind("click", DEPMAN.removeAllDependentPlatformsFromTopLevelPlatform);
		jQuery("#addDependenciesButton").bind("click", function() {	
			jQuery("#availablePlatformsDialog").dialog("open");
		});
		jQuery("#doneButton").bind("click", function() { 
			jQuery("#availablePlatformsDialog").dialog("close"); 
			DEPMAN.unselectAllAvailablePlatformListItems(); 
			
			var associateButton = jQuery("#associateButton");
			
			associateButton.attr("disabled", "true");
		});
	},
	
	_bindOnKeyUpEvents : function() {
		var callbackFunc = function(e) {
			if (DEPMAN._timeout) {
				clearTimeout(DEPMAN._timeout);
			}
			
			DEPMAN._timeout = setTimeout(e.data.func, DEPMAN.KEYUP_TIMEOUT);
		};
		
		jQuery("#byNameFilterTopLevelPlatforms").bind("keyup", { func : DEPMAN.filterTopLevelPlatformsList }, callbackFunc);
		jQuery("#byNameFilterAvailablePlatforms").bind("keyup", { func : DEPMAN.filterAvailablePlatformsList }, callbackFunc);		
		jQuery("#byNameFilterDependentPlatforms").bind("keyup", { func : DEPMAN.filterDependentPlatformsList }, callbackFunc);
	},
	
	_gotoParentPlatform : function(e) {
		DEPMAN._resetTopLevelPlatformFilters();
		jQuery("#byNameFilterTopLevelPlatforms").val(e.data.parentName);
		DEPMAN.filterTopLevelPlatformsList();
		jQuery("#filterTabPanel").tabs("select", 0);
	},
	
	_recurseAndCreateList : function(items, startIndex, pageSize, targetList, refreshSelectable, liRenderFunc, divRenderFunc, afterFunc, spinner) {
		if (items.length > 0) {
			for (var x = startIndex; x < (startIndex + pageSize) && x < items.length; x++) {
				var item = items[x];
				var li = jQuery("<li></li>").attr({ "value" : item.id });
				
				if (refreshSelectable) {
					// Create the li element and it's contents
					// NOTE: Due to a "bug" in the selectable implementation we're adding
					//       the ui-selectee class explicitly here
					li.addClass("ui-state-default ui-selectee");
				}
				
				if (x % 2 != 0) {
					li.addClass("odd-row");
				}
				
				if (jQuery.isFunction(liRenderFunc)) {
					targetList.append(liRenderFunc(item, li));
				} else {
					targetList.append(li);
				}
				
				if (jQuery.isFunction(divRenderFunc)) {
					targetList.append(divRenderFunc(item, li));
				}
			}
			
			var nextStartIndex = startIndex + pageSize;
			
			if ((items.length - nextStartIndex) > 0) {
				setTimeout(DEPMAN._recurseAndCreateList, 100, items, nextStartIndex, pageSize, targetList, refreshSelectable, liRenderFunc, divRenderFunc, afterFunc, spinner);
			} else {
				if (refreshSelectable) {
					if (targetList.hasClass("ui-selectable")) {
						targetList.selectable("refresh");
					} else {
						targetList.selectable({ 
							filter: "li",
							selected : function() {
								var removeSelectedButton = jQuery("#removeDependenciesButton", jQuery("#actionButtonContainer_clone"));
								
								removeSelectedButton.removeAttr("disabled");
							},
							unselected : function() {
								var removeSelectedButton = jQuery("#removeDependenciesButton", jQuery("#actionButtonContainer_clone"));
								
								if (jQuery(".ui-selected", targetList).length == 0) {
									removeSelectedButton.attr("disabled", "true");
								}
							}
						});
					}
				}
				
				var removeAllButton = jQuery("#removeAllDependenciesButton", jQuery("#actionButtonContainer_clone"));
				
				if (items.length > 0) {
					removeAllButton.removeAttr("disabled");
				} else {
					removeAllButton.attr("disabled", "true");
				}
				
				if (jQuery.isFunction(afterFunc)) {
					afterFunc();
				}

				if (spinner) {
					spinner.remove();
				}
			}				
		} else {
			if (spinner) {
				spinner.remove();
			}	
		}
	},
	
	_populateListofData : function(url, params, targetList, container, refreshSelectable, liRenderFunc, divRenderFunc, afterFunc) {
		var spinner = jQuery("span.processing", container);
		
		if (spinner.length == 0) {
			spinner = jQuery("<span></span>").addClass("userMessage processing");
		}
		
		spinner.text(DEPMAN.PROCESSING_FILTER_MSG);
		
		if (container) {
			container.append(spinner);
		}
		
		jQuery.post(url, params, function(data) {
			targetList.empty();
			
			if (data.msg != "") {
				targetList.append(jQuery("<span></span>").text(data.msg).addClass("message"));
				
				if (spinner) {
					spinner.remove();
				}
			} else {
				var count = 0;
				
				DEPMAN._recurseAndCreateList(data.items, count, 100, targetList, refreshSelectable, liRenderFunc, divRenderFunc, afterFunc, spinner);
			}
		}, "json");
	},
	
    populateListOfTopLevelPlatforms : function(params) {
		DEPMAN._populateListofData(DEPMAN._config.topLevelPlatformsDataURL, 
				                   params, 
				                   jQuery("#topLevelPlatformsList"), 
				                   jQuery("#topLevelFilters fieldset"),
				                   false,
				                   function(item, elem) {
									  elem.append(jQuery("<span></span>").addClass("listItem")
											                           .append(jQuery("<span></span>").addClass("ui-icon ui-icon-triangle-1-e"))
											                           .append(jQuery("<span></span>").text(item.name)));
										 
									  elem.addClass("expandable");

									  elem.click(function() {
										 var me = jQuery(this);
										 var panel = jQuery("#expandablePanel" + me.attr("value"));
										 var actionButtonContainer = jQuery("#actionButtonContainer_clone");
										 var collapsePanel = function(li, animate) {
											 li = jQuery(li);

											 jQuery(".ui-icon", li).removeClass("ui-icon-triangle-1-s").addClass("ui-icon-triangle-1-e");
											 
											 var panel = jQuery("#expandablePanel" + li.attr("value"));
											 
											 if (animate) {
												 panel.hide("blind", function() { li.removeClass("expanded"); });
											 } else {
												 panel.hide();
												 li.removeClass("expanded");
											 }
											 
											 panel.remove("#actionButtonContainer_clone");
										 }
										 
										 if (me.hasClass("expanded")) {
											 collapsePanel(me, true);
										 } else {
											 jQuery("li.expanded").each(function(i, item) {
												 collapsePanel(item);
											 });
											 
											 DEPMAN.populateListOfDependentPlatforms({
													parentId : me.attr("value")
											 });

											 var actionButtonContainer = jQuery("#actionButtonContainer_clone");
											
											 if (actionButtonContainer.length == 0) {
												 actionButtonContainer = jQuery("#actionButtonContainer").clone(true).attr({ id: "actionButtonContainer_clone" });
											 }
											 
											 actionButtonContainer.show();
											 panel.append(actionButtonContainer);
											 panel.show("blind");
											 me.addClass("expanded");
											 jQuery(".ui-icon", me).removeClass("ui-icon-triangle-1-e").addClass("ui-icon-triangle-1-s");
									     }
									  });
									  
									  return elem;
								   },
								   
								   function(item, elem) {
									  var panel = jQuery("<div></div>").attr({ id: "expandablePanel" + item.id }).css("display", "none").addClass("expandablePanel");
									  var listContainer = jQuery("<div></div>").addClass("dependencyListContainer");
									  var depUl = jQuery("<ul></ul>").attr({ id: "dependenciesOf" + item.id }).addClass("dependencyList");
									  
									  if (item.deps && item.deps.length > 0) {
										 item.deps.each(function(dep) {
											depUl.append(jQuery("<li></li>").attr({ "value" : dep.id }).text(dep.name));
										 });
									  }

									  panel.append(listContainer.append(depUl));

									  return panel;
								   },
								   
								   function() {
									   var listItems = jQuery("#topLevelPlatformsList li");
									   
									   if (listItems.length == 1) {
										   jQuery(listItems[0]).click();
									   }
								   });
	},
	
	populateListOfDependentPlatforms : function(params) {
		DEPMAN._populateListofData(DEPMAN._config.dependentPlatformsDataURL, 
                				 params, 
                                 jQuery("#dependenciesOf" + params.parentId), 
                                 null,
                                 true,
                                 function(item, elem) {
			 					 	elem.append(DEPMAN._truncateString(jQuery("<span></span>").addClass("platformNameColumn"), item.name))
			 					 	    .append(jQuery("<span></span>").addClass("platformTypeColumn").text(item.type));
					                return elem;
				                 });
		
		var removeSelectedButton = jQuery("#removeDependenciesButton", jQuery("#actionButtonContainer_clone"));
		
		removeSelectedButton.attr("disabled", "true");
	},
	
	_recurseAndCreateDependentList : function(items, startIndex, pageSize, targetList, spinner) {
		if (items.length > 0) {
			for (var x = startIndex; x < (startIndex + pageSize) && x < items.length; x++) {
				var item = items[x];
				var li = jQuery("<li></li>");
				
				if (x % 2 != 0) {
					li.addClass("odd-row");
				}
				
				var contentContainer = jQuery("<div></div>");
				var parentPlatform = jQuery("<a></a>").attr({ 
					"href" : "#",
					"parentId" : item.parent.id,
					"childId" : item.child.id 
				}).text(item.parent.name).bind("click", { "parentName" : item.parent.name }, DEPMAN._gotoParentPlatform);

				contentContainer.text(item.child.name + " > ");
				contentContainer.append(parentPlatform);
				li.append(contentContainer);
				targetList.append(li);
			}
			
			var nextStartIndex = startIndex + pageSize;
			
			if ((items.length - nextStartIndex) > 0) {
				setTimeout(DEPMAN._recurseAndCreateDependentList, 100, items, nextStartIndex, pageSize, targetList, spinner);
			} else {
				if (spinner) {
					spinner.remove();
				}
			}
		}
	},
	
	populateListOfAllDependentPlatforms : function(params) {
		var container = jQuery("#dependentFilters fieldset");
		var spinner = jQuery("span.processing", container);
		
		if (spinner) {
			spinner = jQuery("<span></span>").addClass("userMessage processing");
		}
		
		spinner.text(DEPMAN.PROCESSING_FILTER_MSG);
		container.append(spinner);
		
		var url = DEPMAN._config.dependentPlatformsWithParentDataURL;
		var targetList = jQuery("#dependentPlatformsList");
		
		jQuery.post(url, params, function(data) {
			targetList.empty();
			
			if (data.msg != "") {
				targetList.append(jQuery("<span></span>").text(data.msg).addClass("message"));
				
				if (spinner) {
					spinner.remove();
				}
			} else {
				var count = 0;
				
				DEPMAN._recurseAndCreateDependentList(data.items, count, 50, targetList, spinner);
			}
		}, "json");
	},
	
	populateListOfAvailablePlatforms : function(params) {
		DEPMAN._populateListofData(DEPMAN._config.availablePlatformsDataURL, 
				                 params, 
                                 jQuery("#availablePlatformsList"), 
                                 jQuery("#availablePlatformsDialog .filterPanel fieldset"),
                                 true,
                                 function(item, elem) {
			                        var typeClass = DEPMAN.AVAIL_PLATFORM_CLASS_PREFIX + item.typeId;
			                        
			                        elem.addClass(typeClass).addClass(DEPMAN.AVAIL_PLATFORM_CLASS_PREFIX);
			                        
			                        var strong = DEPMAN._truncateString(jQuery("<strong></strong>").addClass("platformNameColumn"), item.name); 
			                        	
			                        elem.append(strong);
			                        
			                        if (jQuery("#byTypeFilterAvailablePlatforms").val() == "") {
			                        	elem.append(jQuery("<span></span>").addClass("platformTypeColumn").text(item.type));
			                        }
			                        
			                        elem.append(jQuery("<br/>"));
			                        
			        				var description = DEPMAN._truncateString(jQuery("<i></i>"), item.description);
			        				
			        	            return elem.append(description);
                                 });

	},
	
	_selectAllListItems : function(elems) {
		elems.each(function() {
			var selectee = jQuery.data(this, "selectable-item");
			
			selectee.$element.removeClass("ui-selecting").addClass("ui-selected");
			selectee.selecting = false;
			selectee.selected = true;
			selectee.startselected = true;
		});
	},
	
	_unselectAllListItems : function(elems) {
		elems.each(function() {
			var selectee = jQuery.data(this, "selectable-item");

			selectee.$element.removeClass("ui-unselecting").removeClass("ui-selected");
			selectee.unselecting = false;
			selectee.selected = false;
			selectee.startselected = false;
		});
	},
	
	selectAllAvailablePlatformListItems : function() {
		DEPMAN._selectAllListItems(jQuery("#availablePlatformsList .ui-selectee"));
		
		var associateButton = jQuery("#associateButton");
		
		associateButton.removeAttr("disabled");
	},
	
	unselectAllAvailablePlatformListItems : function() {
		DEPMAN._unselectAllListItems(jQuery("#availablePlatformsList .ui-selectee"));
		
		var associateButton = jQuery("#associateButton");
		
		if (jQuery("#availablePlatformsList .ui-selected").length == 0) {
			associateButton.attr("disabled", "true");
		}
	},
	
	_filterPlatformsList : function(showEl, typeEl, nameEl, populateFunc) {
		var show = null;
		
		if (showEl && showEl.val() != "") {
			show = showEl.val();
		}
		
		var typeId = typeEl.val();
		var partialName = nameEl.val();
		
		if (partialName.length == 0 || partialName.length >= DEPMAN.MIN_CHAR_LEN) {
			populateFunc({
				"show" : show,
				"typeId" : typeId,
				"name" : partialName
			});
		}
	},
	
	_resetTopLevelPlatformFilters : function() {
		jQuery("#byShowFilterTopLevelPlatforms").val("");
		jQuery("#byTypeFilterTopLevelPlatforms").val("");
		jQuery("#byNameFilterTopLevelPlatforms").val("");
	},
	
	_resetAvailablePlatformFilters : function() {
		jQuery("#byTypeFilterAvailablePlatforms").val("");
		jQuery("#byNameFilterAvailablePlatforms").val("");
	},
	
	_resetDependentPlatformFilters : function() {
		jQuery("#byTypeFilterDependentPlatforms").val("");
		jQuery("#byNameFilterDependentPlatforms").val("");		
	},
	
	filterTopLevelPlatformsList : function() {
		DEPMAN._filterPlatformsList(jQuery("#byShowFilterTopLevelPlatforms"),
								  jQuery("#byTypeFilterTopLevelPlatforms"), 
				                  jQuery("#byNameFilterTopLevelPlatforms"),
				                  DEPMAN.populateListOfTopLevelPlatforms);
		DEPMAN._resetAvailablePlatformFilters();
		DEPMAN._filterPlatformsList(null,
                					jQuery("#byTypeFilterAvailablePlatforms"), 
                					jQuery("#byNameFilterAvailablePlatforms"),
                					DEPMAN.populateListOfAvailablePlatforms);
	},
	
	filterAvailablePlatformsList : function() {
		DEPMAN._filterPlatformsList(null,
				                  jQuery("#byTypeFilterAvailablePlatforms"), 
	                              jQuery("#byNameFilterAvailablePlatforms"),
	                              DEPMAN.populateListOfAvailablePlatforms);
	},
	
	filterDependentPlatformsList : function() {
		var name = jQuery("#byNameFilterDependentPlatforms");
		var type = jQuery("#byTypeFilterDependentPlatforms");
		
		// We don't want to submit a request unless some criteria is specified 
		// to whittle down the dataset.
		if (name.val() == "" && type.val() == "-1") return;
		
		DEPMAN._filterPlatformsList(null,
				                  jQuery("#byTypeFilterDependentPlatforms"), 
	                              jQuery("#byNameFilterDependentPlatforms"),
	                              DEPMAN.populateListOfAllDependentPlatforms);
	},
	
	_movePlatformDependencies : function(parent, children, isAdding, container) {
		var parentId = parent.attr("value");
		var values = [];
		
		children.each(function() {
			var selectee = jQuery.data(this, "selectable-item");
			
			values.push(selectee.element.value);
		});
		
		// Get the correct action URL
		var url;
		var spinner = jQuery("span.processing", container);
		
		if (spinner.length == 0) {
			spinner = jQuery("<span></span>").addClass("userMessage processing").css("float", "left");
		}
		
		if (isAdding) {
			url = DEPMAN._config.addDependentPlatformsURL;
			spinner.text(DEPMAN.PROCESSING_ADD_SELECTED_MSG);
		} else {
			url = DEPMAN._config.removeDependentPlatformsURL;
			spinner.text(DEPMAN.PROCESSING_REMOVE_SELECTED_MSG);
		}

		if (container) {
			container.prepend(spinner);
		}
		
		// Setup the post params
		var params = {
			"parentId" : parentId,
			"platformId" : values
		};
		
		// Post it!
		jQuery.post(url, params, function(data) {
			var isSuccess = (data.code == "SUCCESS");
			
			if (isSuccess) {
				// Only refresh if all deps are moved
				if (params.platformId.length == jQuery("#dependenciesOf" + params.platformId + " .ui-selectee").length) {
					DEPMAN.filterTopLevelPlatformsList();
				} else {
					DEPMAN._resetAvailablePlatformFilters();
					DEPMAN.filterAvailablePlatformsList();	
				}

				DEPMAN.populateListOfDependentPlatforms(params);
			}
			
			if (spinner) {
				spinner.remove();
			}
			
			if (container) {
				var message = jQuery("<div></div>").addClass("userMessage" + ((!isSuccess) ? " userError" : ""))
				                                     .css({ "float": "left", "text-align": "left" })
				                                     .html(data.msg);
				
				container.prepend(message);
				
				DEPMAN.unselectAllAvailablePlatformListItems();
				
				var fadeTimeout = (!isSuccess) ? 3000 : 2000;
				
				setTimeout(function() {
					message.fadeOut("slow", function() {
						message.remove();
					});
				}, fadeTimeout);
			}
		}, "json");
	},

	addSelectedAvailablePlatformsToTopLevelPlatform : function() {
		var parent = jQuery("#topLevelPlatformsList .expanded");
		var children = jQuery("#availablePlatformsList .ui-selected");
		
		if (parent.length == 0 || children.length == 0) return;
		
		var associateButton = jQuery("#associateButton");
		
		associateButton.attr("disabled", "true");

		DEPMAN._movePlatformDependencies(parent,
				                         children,
				                         true,
				                         jQuery("#availablePlatformsDialog .listActionButtonContainer"));
	},

	removeSelectedDependentPlatformsFromTopLevelPlatform : function() {
		var parent = jQuery("#topLevelPlatformsList .expanded");
		
		if (parent.length == 0) return;
		
		var uniqueKey = parent.attr("value");
		var children = jQuery("#dependenciesOf" + uniqueKey + " .ui-selected");
		
		if (children.length == 0) {
		
		} else if (confirm(DEPMAN.CONFIRM_REMOVE_SELECTED_ACTION_MSG)) {
			DEPMAN._movePlatformDependencies(parent,
	                                         children,
	                                         false,
	                                         jQuery("#actionButtonContainer_clone"));
		}
	},
	
	removeAllDependentPlatformsFromTopLevelPlatform : function() {
		var parent = jQuery("#topLevelPlatformsList .expanded");
		
		if (parent.length == 0) return;
		
		var uniqueKey = parent.attr("value");
		var children = jQuery("#dependenciesOf" + uniqueKey + " .ui-selectee");
		
		if (children.length == 0) {
			
		} else if (confirm(DEPMAN.CONFIRM_REMOVE_ALL_ACTION_MSG)) {
			var container = jQuery("#actionButtonContainer_clone");
			var spinner = jQuery("span.processing", container);
			
			if (spinner.length == 0) {
				spinner = jQuery("<span></span>").addClass("userMessage processing").css("float", "left");
			}
			
			spinner.text(DEPMAN.PROCESSING_ADD_SELECTED_MSG);
			
			container.prepend(spinner);

			var url = DEPMAN._config.removeAllDependentPlatformsURL;
		
			// Setup the post params
			var params = {
				"parentId" : parent.attr("value")
			};
		
			// Post it!
			jQuery.post(url, params, function(data) {
				if (spinner) {
					spinner.remove();
				}

				var isSuccess = (data.code == "SUCCESS");
				
				if (isSuccess) {
					DEPMAN.filterTopLevelPlatformsList();
				} 
					
				if (container) {
					var message = jQuery("<span></span>").addClass("userMessage").css("float", "left").text(data.msg);
					
					if (!isSuccess) {
						message.addClass("userError");
					}
					
					container.prepend(message);
					
					var fadeTimeout = (!isSuccess) ? 3000 : 2000;
					
					setTimeout(function() {
						message.fadeOut("slow", function() {
							message.remove();
						});
					}, fadeTimeout);
				}
			}, "json");
		}
	}
};