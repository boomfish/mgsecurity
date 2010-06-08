<cfscript>
    /**
    * I am a bean that holds security information about an application user.
    *
    * @accessors true
    */
    component {

    	property string loginName;
    	property string roles;

    	function init() {
    		variables.loginName = "";
    		variables.roles = "";
    		return this;
    	}
    }
</cfscript>