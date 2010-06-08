<cfscript>
    /**
    * I help views determine the login status and access level of the current user
    */
    component beans="loginSessionManager" {

	    boolean function isLoggedIn() {
	        return beans.loginSessionManager.isLoggedIn();
	    }

	    boolean function isAdmin() {
	        return beans.loginSessionManager.isAdmin();
	    }

	    boolean function isInAnyRole(required string authorizedRoles) {
	        return beans.loginSessionManager.isInAnyRole(arguments.authorizedRoles);
	    }

	    string function getLoginName() {
	        return beans.loginSessionManager.getLoginName();
	    }

    }
</cfscript>