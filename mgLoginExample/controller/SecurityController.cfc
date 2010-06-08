<cfscript>
    /**
    * I log in users (authentication) and check their access (authorization)
    */
    component extends="ModelGlue.gesture.controller.Controller" beans="authenticator,loginSessionManager" {

    	/**
    	* Try to login a user using the submitted loginName and password
    	* 
    	* Message arguments:
    	*
    	* loginNameField (optional sting, default='loginName'): Name of field containing login name
    	* passwordField (optional string, default='password'): Name of field containing password
        * allowBlankLoginName (optional boolean, default=false): If false, automatically reject blank login names
    	* allowBlankPassword (optional boolean, default=true): If false, automatically reject blank passwords
    	*/
    	void function login(required any event) {
    		// Message may specify the fieldnames to use for authentication
    		var loginNameField = arguments.event.getArgument("loginNameField","loginName");
            var passwordField = arguments.event.getArgument("passwordField","password");
            
    		var loginName = Trim(arguments.event.getValue(loginNameField));
    		var password = Trim(arguments.event.getValue(passwordField));
    		var loginToken = 0;
    		var loginFailed = false;
            var validation = {};

    		if (not arguments.event.getArgument("allowBlankLoginName",false) and not Len(loginName)) {
    			loginFailed = true;
    			validation.loginName = ["The Login name field is required but was not provided."];
    		}
            if (not arguments.event.getArgument("allowBlankPassword",true) and not Len(password)) {
                loginFailed = true;
                validation.password = ["The Password field is required but was not provided."];
            }

            if (not loginFailed) {
            	try {
            		// Try to use the submitted loginName and password to get a login token
            		loginToken = beans.authenticator.authenticate(loginName,password);
            	} catch (security.AuthenticationSystemException e) {
            		validation.password = ["An error occurred while attempting to log you in."];
            		arguments.event.setValue("LoginValidation", validation);
            		arguments.event.addResult("LoginFailed");
            		return;
            	}
            	if (IsNull(loginToken)) {
            		// No login token returned by authenticator means invalid credentials
                    loginFailed = true;
                    validation.password = ["Your login name and/or password is incorrect."];
            	} else if (not Len(loginToken.getRoles())) {
            		// A login token with no roles means a valid user with no authorization
                    loginFailed = true;
                    validation.password = ["Your login name and password is valid, but you have not been granted access to this system."];
            	} else {
            		// Login token is good: use it to start a login session
            		beans.loginSessionManager.login(loginToken);
            	}
            }

            if (loginFailed) {
	            arguments.event.setValue("LoginValidation", validation);
	            arguments.event.addResult("LoginFailed");
            } else {
            	arguments.event.setValue("LoginToken", loginToken);
            	arguments.event.addResult("LoginSuccess");
            }
    	}

    	/**
    	* Check that the user is logged in and is in an authorized role
    	*
        * Message arguments:
        *
        * authorizedRoles (optional sting, default='*'): List of authorized user roles; *=all authenticated users are authorized
    	*/
        void function checkAccess(required any event) {
        	var authorizedRoles = arguments.event.getArgument("authorizedRoles", "*");
        	var isAuthorized = false;

        	// Is the current user logged in?
        	if (not beans.loginSessionManager.isLoggedIn()) {
        		arguments.event.addResult("NotLoggedIn");
        		return;
        	}
        	// An authorizedRoles argument of "*" means any logged-in user is authorized
        	if (authorizedRoles is "*") {
        		return;
        	}
        	// Is the current user in an authorized role?
        	if (not beans.loginSessionManager.isInAnyRole(authorizedRoles)) {
        		arguments.event.addResult("NotAuthorized");
        	}
        }

        /**
        * End a login session
        */
        void function logout(required any event) {
        	beans.loginSessionManager.logout();
        }

    }
</cfscript>