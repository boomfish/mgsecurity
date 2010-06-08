<cfscript>
    /**
    * I authenticate a user via a login name and password
    */
    interface {

    	/**
    	* I authenticate a user via login name and password. If successful, I return a populated login token, otherwise I return null.
    	*/
    	any function authenticate(required string loginName, required string password);

    }
</cfscript>