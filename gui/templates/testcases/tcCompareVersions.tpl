{*

TestLink Open Source Project - http://testlink.sourceforge.net/ 
 
Purpose: smarty template - compare testcase versions

*}

{include file="inc_head.tpl" openHead='yes' jsValidate="yes"}
{include file="inc_del_onclick.tpl"}

{lang_get var="labels"
          s="select_versions,title_compare_versions_tc,version,compare,modified,modified_by,
          btn_compare_selected_versions, context, show_all,
          warning_context, warning_context_range, warning_empty_context, warning, warning_selected_versions, warning_same_selected_versions"}

<link rel="stylesheet" type="text/css" href="{$basehref}third_party/diff/diff.css">

<script type="text/javascript">

var alert_box_title = "{$labels.warning}";
var warning_empty_context = "{$labels.warning_empty_context}";
var warning_context_range = "{$labels.warning_context_range}";
var warning_selected_versions = "{$labels.warning_selected_versions}";
var warning_same_selected_versions = "{$labels.warning_same_selected_versions}";
var warning_context = "{$labels.warning_context}";

{literal}

function triggerTextfield(field)
{
	if (field.disabled == true) {
    	field.disabled = false;
	} else {
    	field.disabled = true;
	}
}

function valButton(btn) {
    var cnt = -1;
    for (var i=btn.length-1; i > -1; i--) {
        if (btn[i].checked) {
        	cnt = i;
        	i = -1;
        }
    }
    if (cnt > -1) {
    	return true;
    }
    else {
    	return false;
    }
}

function validateForm() {
	if (isWhitespace(document.tc_compare_versions.context.value)) {
	    alert_message(alert_box_title,warning_empty_context);
		return false;
	} else {
		value = parseInt(document.tc_compare_versions.context.value);
		if (isNaN(value))
		{
		   	alert_message(alert_box_title,warning_context);
		   	return false;
		} else if (value < 0) {
			alert_message(alert_box_title,warning_context_range);
		   	return false;
		}
	}
	
	if (!valButton(document.tc_compare_versions.version_left)
			|| !valButton(document.tc_compare_versions.version_right)) {
		alert_message(alert_box_title,warning_selected_versions);
		return false;
	}
	
	for (var i=document.tc_compare_versions.version_left.length-1; i > -1; i--) {
        if (document.tc_compare_versions.version_left[i].checked && document.tc_compare_versions.version_right[i].checked) {
        	alert_message(alert_box_title,warning_same_selected_versions);
        	return false;
        }
    }
}

</script>
{/literal}

</head>
<body>

{if $gui->compare_selected_versions}

	<h1 class="title">{$labels.title_compare_versions_tc}</h1> 
			
	<h2>{$gui->subtitle}</h2>
			
	{foreach item=diff from=$gui->diff_array}
	{assign var="diff" value=$diff}
		
		<div class="workBack" style="width:99%; overflow:auto;">	
		
		<h2>{$diff.heading}</h2>
		
		<fieldset class="x-fieldset x-form-label-left" >
		
		<legend class="legend_container" >{$diff.message}</legend>
		
		{if $diff.count > 0}
			{$diff.diff}
		{/if}
		
		</fieldset>
		</div>
		
	{/foreach}
	</div>	
{else}

	<h1 class="title">{$labels.title_compare_versions_tc}</h1> 
	
	<div class="workBack" style="width:97%;">
	
	<form target="diffwindow" method="post" action="lib/testcases/tcCompareVersions.php" name="tc_compare_versions" 
			onsubmit="return validateForm();" />
	
	<p><input type="submit" name="compare_selected_versions" value="{$labels.btn_compare_selected_versions}" /></p><br/>
		
	<p><table border="0" cellspacing="0" cellpadding="3" style="font-size:small;" width="100%">
	
	    <tr style="background-color:blue;font-weight:bold;color:white">
	        <th width="12px" style="font-weight: bold; text-align: center;">{$labels.version}</td>
	        <th width="12px" style="font-weight: bold; text-align: center;">&nbsp;{$labels.compare}</td>
	        <th style="font-weight: bold; text-align: center;">{$labels.modified}</td>
	        <th style="font-weight: bold; text-align: center;">{$labels.modified_by}</td>
	    </tr>
	
	{counter assign="mycount"}
	{foreach item=tc from=$gui->tc_versions}
		{assign var="tc" value=$tc}
	
	   <tr>
	        <td style="text-align: center;">{$tc.version}</td>
	        <td style="text-align: center;"><input type="radio" name="version_left" value="{$tc.version}" 
	        {if $mycount == 2}
	        	 checked="checked"
	        {/if}
	        />
	        		<input type="radio" name="version_right" value="{$tc.version}" 
	        		{if $mycount == 1}
	        		 checked="checked"
	        		{/if}
	        		/></td>
	        {if $tc.modification_ts != "0000-00-00 00:00:00"}
	        	<td style="text-align: center;">{$tc.modification_ts}</td>
	        	<td style="text-align: center;">{$tc.author_first_name} {$tc.author_last_name}</td>
	        {else}
	        	<td style="text-align: center;">{$tc.creation_ts}</td>
	        	<td style="text-align: center;">{$tc.author_first_name} {$tc.author_last_name}</td>
	        {/if}
	        
	    </tr>
	{counter}
	{/foreach}
	
	</table></p><br/>
	
	<p>{$labels.context} <input type="text" name="context" id="context" maxlength="4" size="4" value="{$gui->context}" />
	<input type="checkbox" id="context_show_all" name="context_show_all" 
	onclick="triggerTextfield(this.form.context);" /> {$labels.show_all} </p><br/>
	
	<p><input type="hidden" name="testcase_id" value="{$gui->tc_id}" />
	<input type="submit" name="compare_selected_versions" value="{$labels.btn_compare_selected_versions}" /></p>
	
	</form>

	</div>

{/if}

</body>

</html>
