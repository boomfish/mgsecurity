<cfcomponent extends="ModelGlue.gesture.controller.Controller" hint="I handle generic Model-Glue events for the application" output="false">

    <!---
        Any function set up to listen for the onRequestStart message happens before any of the <event-handlers>.
        This is a good place to put things like session defaults.
    --->
    <cffunction name="onRequestStart" access="public" returnType="void" output="false">
        <cfargument name="event" type="any" />

        <!--- Create request variable for whether MG debug mode is active --->
        <cfset request.modelGlueDebuggingActive = (getModelGlue().getConfigSetting("debug") neq "none") />
    </cffunction>

    <!---
        Any function set up to listen for the onQueueComplete message happens after all event-handlers are
        finished running and before any views are rendered.  This is a good place to load constants (like UDF
        libraries) that the views may need.
    --->
    <cffunction name="onQueueComplete" access="public" returnType="void" output="false">
		<cfargument name="event" type="any" />

        <!--- Put the event in the request scope to make things easier for helpers --->
        <cfset request.event = arguments.event />
    </cffunction>

	<!---
		Any function set up to listen for the onRequestEnd message happens after views are rendered.
	--->
	<cffunction name="onRequestEnd" access="public" returnType="void" output="false">
		<cfargument name="event" type="any" />

        <!--- This is a MG framework variable to suppress its own log debug output --->
        <cfparam name="request.modelGlueSuppressDebugging" default="false" />

		<!--- If MG debug mode is off or supressed, suppress CF debug output too --->
		<cfif not request.modelGlueDebuggingActive or request.modelGlueSuppressDebugging>
			<cfsetting showdebugoutput="false" />
		</cfif>
	</cffunction>

</cfcomponent>