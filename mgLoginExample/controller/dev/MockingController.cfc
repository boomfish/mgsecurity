<cfscript>
    /**
    * I generate mock values and structures for the event context
    */
    component extends="ModelGlue.gesture.controller.Controller" {

        /**
        * Generate a series of values and place them in the event context
        *
        * This listener accepts any number of arguments. Each argument name/value pair
        * is converted to a event context name/value pair.
        */
        void function mockValues(required any event) {
            var messageArgs = arguments.event.getAllArguments();
            var argName = "";

            // Convert the message arguments into event values
            for (argName in messageArgs) {
                arguments.event.setValue(argName,messageArgs[argName]);
            }
        }

    	/**
    	* Generate a validation structure and place it in the event context
    	*
        * Message arguments:
        *
        * validation (optional sting, default='validation'): Name of validation structure in event context
        *
        * This listener accepts any number of arguments. Each argument name/value pair
        * (except for 'validation') is converted to a message name/value pair for the validation structure.
    	*/
    	void function mockValidation(required any event) {
    		var validationName = "validation";
    		var messageArgs = arguments.event.getAllArguments();
            var validation = {};
            var argName = "";

            // Process the message arguments
            for (argName in messageArgs) {
            	if (argName eq "validation") {
            		// Argument value is name to use for validation structure
            		validationName = messageArgs[argName];
            	} else {
            		// Argument name is a field name, argument value is its associated validation message(s)
            		validation[argName] = ListToArray(messageArgs[argName],";");
            	}
            }

            // Set the validation structure
            arguments.event.setValue(validationName,validation);
    	}

    }
</cfscript>