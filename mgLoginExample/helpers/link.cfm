<!---
    Helper functions for generating links
--->
<cfscript>
    /**
    * Return the URL for an exit event (an event whose name is being passed in as a request context value)
    */
    string function exitTo(required string exitName,
                string append="",string anchor="",struct preferredContext) {
        // Default preferredContext = {}
        local.preferredContext = (IsNull(arguments.preferredContext) ? {} : arguments.preferredContext);

        return request.event.linkTo(request.event.getValue(arguments.exitName),
                arguments.append,arguments.anchor,local.preferredContext);
    }
    /**
    * Return the URL for an event (defaults to current event) that also inits the framework
    */
    string function initLinkTo(string eventName) {
        // Default preferredContext = {}
        local.eventName = (IsNull(arguments.eventName) ? request.event.getValue("event") : arguments.eventName);

        return request.event.linkTo(local.eventName,"init","",{init="true"});
    }
</cfscript>