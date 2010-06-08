<cfoutput>
<p>
    <a href="#helpers.link.exitTo('xe.home')#">Home</a>
    <cfif helpers.login.isLoggedIn()>
        <cfif helpers.login.isInAnyRole('manager')>
    | <a href="#helpers.link.exitTo('xe.manager')#">Manager</a>
        </cfif>
        <cfif helpers.login.isInAnyRole('admin')>
    | <a href="#helpers.link.exitTo('xe.admin')#">Admin</a>
        </cfif>
    | <a href="#helpers.link.exitTo('xe.logout')#">Logout</a>
    <cfelse>
    | <a href="#helpers.link.exitTo('xe.login')#">Log In</a>
    </cfif>
</p>
</cfoutput>