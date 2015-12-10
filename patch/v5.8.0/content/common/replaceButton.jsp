<script type="text/javascript" src="<html:rewrite page="/static/js/jquery.min.js" />"></script>
<script type="text/javascript">  
    jQuery=$;  
</script> 

<script>
jQuery(function(){
	jQuery('form input[type=image]').each(function(){
    var self = jQuery(this);
    var imgAttr = self.attr('alt');
    var idstr = self.attr("name");
    if (typeof imgAttr !== 'undefined' && imgAttr !== false && document.getElementById(idstr+"_id")== null) { 
    jQuery(this).hide().after('<input type="button" class="button42" id="' + self.attr("name") + '_id" value="' + self.attr("alt") + '" />'); 
    var idstr = self.attr("name");
    jQuery('body').on('click', '#'+idstr+"_id", function(){
    	var ctol = null ;
    	if (document.createEventObject){
    	 ctol = document.getElementById(idstr);
    	}else{
    	 ctol = document.all[idstr];
    	}
        ctol.click();
    });
  }});
});
</script>
