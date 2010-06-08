
<!--- Validation messages from processing the form (or empty if form has not been processed)--->
<cfset validation = event.getValue("LoginValidation", {}) />

<cfoutput>
<cfform name="loginForm" action="#helpers.link.exitTo('xe.login')#" class="edit">
	<fieldset class="login">
        <div class="formfield">
	        <label for="loginName"><b>Login:</b></label>
	        <div>
		        <cfinput type="text" class="shortinput" id="loginName" name="loginName" value="#event.getValue('loginName')#" />
	        </div>
	        <cfmodule template="/ModelGlue/customtags/validationErrors.cfm" property="loginName" validation="#validation#" />
        </div>

        <div class="formfield">
	        <label for="password"><b>Password:</b></label>
	        <div>
		        <cfinput type="password" class="shortinput" id="password" name="password" />
	        </div>
	        <cfmodule template="/ModelGlue/customtags/validationErrors.cfm" property="password" validation="#validation#" />
        </div>
		<div class="controls">
			<input type="submit" value="Log In" />
		</div>
	</fieldset>
</cfform>
</cfoutput>