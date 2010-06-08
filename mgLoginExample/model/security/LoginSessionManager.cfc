<cfcomponent hint="I start and end user login sessions" output="false" accessors="true">

    <cfproperty name="adminRole" type="string" hint="Name of role that is the superset of all possible roles" />
    <cfproperty name="idleTimeout" type="numeric" hint="Number of idle seconds before automatically ending the login session" />

    <cffunction name="init" output="false">
        <cfset variables.adminRole = "admin" />
        <cfset variables.idleTimeout = 1800 />
        <cfreturn this />
    </cffunction>

    <cffunction returnType="void" name="login" output="false" hint="Use a loginToken to initiate a session">
        <cfargument name="loginToken" type="any" required="true" />

        <cflogin idletimeout="#variables.idleTimeout#">
            <cfloginuser name="#arguments.loginToken.getLoginName()#" password="" roles="#arguments.loginToken.getRoles()#" />
        </cflogin>
    </cffunction>

    <cffunction returnType="void" name="logout" output="false" hint="Terminate a login session">
        <cflogout />
    </cffunction>

   <!--- Query methods --->
<cfscript>
    boolean function isLoggedIn() {
    	return IsUserLoggedIn();
    }

    boolean function isAdmin() {
        return IsUserInRole(variables.adminRole);
    }

    boolean function isInAnyRole(required string authorizedRoles) {
        return IsAdmin() or IsUserInAnyRole(arguments.authorizedRoles);
    }

    string function getLoginName() {
        return GetAuthUser();
    }
</cfscript>

</cfcomponent>