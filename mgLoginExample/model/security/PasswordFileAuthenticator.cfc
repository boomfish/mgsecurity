<cfscript>
    /**
    * I authenticate a user against a Unix-like password file.
    *
    * @accessors true
    */
    component implements="IAuthenticator" {

    	property string passwordFilePath;
    	property string fieldDelimiter;
    	property string entryDelimiter;

    	function init() {
    		variables.passwordFilePath = "";
    		variables.fieldDelimiter = ":";
            variables.entryDelimiters = chr(13);
    		variables.passwordEntries = {};

    		return this;
    	}

    	// Public interface methods

        any function authenticate(required string loginName, required string password) {
        	var passwordEntry = getPasswordEntry(arguments.loginName);

        	if (StructIsEmpty(passwordEntry)) {
        		return;
        	}
        	if (not checkPassword(arguments.password,passwordEntry)) {
        		return;
        	}

        	return populateLoginToken(newLoginToken(),passwordEntry);
        }

        // Password file methods

        /**
        * Clear all password entries and reload the main password file
        */
        void function reload() {
        	removeAllPasswordEntries();
        	load();
        }

        /**
        * Load the default password file
        */
        void function load() {
        	loadPasswordFile(variables.passwordFilePath);
        }

        numeric function getPasswordEntryCount() {
        	return StructCount(variables.passwordEntries);
        }
        
        // Non-public methods

        /**
        * Load the a password file
        */
        package void function loadPasswordFile(required string filePath) {
            var passwordFileData = FileRead(arguments.filePath);
            var entryNumber = 1;
            var passwordEntryString = GetToken(passwordFileData, entryNumber, variables.entryDelimiters);

            while (Len(passwordEntryString)) {
                addPasswordEntryString(passwordEntryString);
                passwordEntryString = GetToken(passwordFileData, ++entryNumber, variables.entryDelimiters);
            }
        }

        // Password entry methods

        package void function addPasswordEntryString(required string passwordEntryString) {
        	var passwordEntry = convertPasswordEntryString(arguments.passwordEntryString);
        	if (not StructIsEmpty(passwordEntry)) {
                variables.passwordEntries[passwordEntry.loginName] = passwordEntry;
        	}
        }

        package struct function convertPasswordEntryString(required string passwordEntryString) {
            var passwordEntryFieldArray = ListToArray(arguments.passwordEntryString,variables.fieldDelimiter,true);
            if (ArrayLen(passwordEntryFieldArray) lt 3) {
            	return {};
            }
            return {
            	loginName = Trim(passwordEntryFieldArray[1]),
            	password  = Trim(passwordEntryFieldArray[2]),
            	roles     = Trim(passwordEntryFieldArray[3])
            };
        }

        package void function removePasswordEntry(required string loginName) {
            StructDelete(variables.passwordEntries,arguments.loginName);
        }
        package void function removeAllPasswordEntries() {
            variables.passwordEntries = {};
        }
        /**
        * Return a password entry structure if one exists that matches the loginName, or an empty structure otherwise
        */
        package struct function getPasswordEntry(required string loginName) {
            if (StructKeyExists(variables.passwordEntries,arguments.loginName)) {
                return variables.passwordEntries[arguments.loginName];
            }
            return {};
        }

        package struct function getPasswordEntries() {
        	return variables.passwordEntries;
        }

        // Password checking methods

        /**
        * Check a provided password against the one within a password entry
        */
        package boolean function checkPassword(required string password, required struct passwordEntry) {
        	// Plain-text password check
            return (arguments.passwordEntry.password eq Trim(arguments.password));
        }

        // Session token methods

        package any function newLoginToken() {
        	return new LoginToken();
        }

        package any function populateLoginToken(required any loginToken, required struct passwordEntry) {
            arguments.loginToken.setLoginName(arguments.passwordEntry.loginName);
            arguments.loginToken.setRoles(arguments.passwordEntry.roles);
            return loginToken;
        }

     }
</cfscript>