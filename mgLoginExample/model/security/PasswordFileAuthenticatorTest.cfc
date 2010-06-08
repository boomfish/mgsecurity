<cfscript>
    component extends="mxunit.framework.TestCase" {

    	void function setup() {
    		/*
    		    Contents of test password file:

    		    peter:oleometer:user
                quentin:paragon:manager
                root:diogenes:admin
                selenium:4s^2.4p^4:user
    		*/
    		variables.passwordFilePath = GetDirectoryFromPath(GetCurrentTemplatePath()) & "/testData/testPasswordFile.txt";
            variables.missingPasswordFilePath = GetDirectoryFromPath(GetCurrentTemplatePath()) & "/testData/missingPasswordFile.txt";

    		variables.testSubject = new PasswordFileAuthenticator();
    		variables.testSubject.setPasswordFilePath(variables.passwordFilePath);
    	}

    	void function loadMissingFileShouldThrowException() {
            variables.testSubject.setPasswordFilePath(variables.missingPasswordFilePath);
            try {
            	variables.testSubject.load();
            	fail("load() did not throw an exception");
            } catch (Any e) {}
    	}

        void function getPasswordEntryCountShouldReturnNumberOfLoadedEntries() {
            variables.testSubject.load();
            assertEquals(4,variables.testSubject.getPasswordEntryCount());
        }

        void function getPasswordEntryForMissingUserShouldReturnEmptyStruct() {
            variables.testSubject.load();
            local.passwordEntry = variables.testSubject.getPasswordEntry("nobody");
            assertTrue(IsStruct(local.passwordEntry),"IsStruct()");
            assertTrue(StructIsEmpty(local.passwordEntry),"StructIsEmpty()");
        }

        void function getPasswordEntryForUserShouldReturnCorrectEntry() {
            variables.testSubject.load();
            local.passwordEntry = variables.testSubject.getPasswordEntry("root");
            assertTrue(IsStruct(local.passwordEntry),"IsStruct()");
            assertFalse(StructIsEmpty(local.passwordEntry),"StructIsEmpty()");
            assertEquals("root",local.passwordEntry.loginName,"passwordEntry.loginName");
            assertEquals("admin",local.passwordEntry.roles,"passwordEntry.roles");
        }

        void function getPasswordEntryForRemovedUserShouldReturnEmptyStruct() {
            variables.testSubject.load();
            variables.testSubject.removePasswordEntry("root");
            local.passwordEntry = variables.testSubject.getPasswordEntry("root");
            assertTrue(IsStruct(local.passwordEntry),"IsStruct()");
            assertTrue(StructIsEmpty(local.passwordEntry),"StructIsEmpty()");
        }

        void function getPasswordEntryForNonRemovedUserShouldReturnCorrectEntry() {
            variables.testSubject.load();
            // Remove a user
            variables.testSubject.removePasswordEntry("root");
            // Get the entry for a different user
            local.passwordEntry = variables.testSubject.getPasswordEntry("peter");
            assertTrue(IsStruct(local.passwordEntry),"IsStruct()");
            assertFalse(StructIsEmpty(local.passwordEntry),"StructIsEmpty()");
        }

        void function getPasswordEntryForAnyUserAfterRemoveAllPasswordEntriesShouldReturnEmptyStruct() {
            variables.testSubject.load();
            variables.testSubject.removeAllPasswordEntries();
            debug(variables.testSubject.getPasswordEntries());
            assertEquals(0,variables.testSubject.getPasswordEntryCount(),"getPasswordEntryCount()");
            // getPasswordEntry("peter") should return an empty struct
            local.passwordEntry = variables.testSubject.getPasswordEntry("peter");
            assertTrue(IsStruct(local.passwordEntry),"IsStruct(peter)");
            assertTrue(StructIsEmpty(local.passwordEntry),"StructIsEmpty(peter)");
            // getPasswordEntry("peter") should also return an empty struct
            local.passwordEntry = variables.testSubject.getPasswordEntry("root");
            assertTrue(IsStruct(local.passwordEntry),"IsStruct(root)");
            assertTrue(StructIsEmpty(local.passwordEntry),"StructIsEmpty(root)");
        }

    	void function authenticateMissingUserShouldReturnNull() {
	        variables.testSubject.load();
	        local.token = variables.testSubject.authenticate("nobody","nowhere");
	        assertTrue(IsNull(local.token));
    	}

    	void function authenticateUserWithWrongPasswordShouldReturnNull() {
            variables.testSubject.load();
            // The password for root is "diogenes"
            local.token = variables.testSubject.authenticate("root","aristotle");
            assertTrue(IsNull(local.token));
    	}

        void function authenticateRegularUserWithCorrectPasswordShouldReturnCorrectToken() {
            variables.testSubject.load();
            // The password for peter is "oleometer"
            local.token = variables.testSubject.authenticate("peter","oleometer");
            assertFalse(IsNull(local.token),"IsNull()");
            assertEquals("peter",local.token.getLoginName(),"getLoginName()");
            // Peter is in the user role
            assertEquals("user",local.token.getRoles(),"getRoles()");
        }

        void function authenticateAdminUserWithCorrectPasswordShouldReturnCorrectToken() {
            variables.testSubject.load();
            // The password for root is "diogenes"
            local.token = variables.testSubject.authenticate("root","diogenes");
            assertFalse(IsNull(local.token),"IsNull()");
            assertEquals("root",local.token.getLoginName(),"getLoginName()");
            // Root is in the admin role
            assertEquals("admin",local.token.getRoles(),"getRoles()");
        }

        void function authenticateRemovedUserShouldReturnNull() {
            variables.testSubject.load();
            variables.testSubject.removePasswordEntry("root");
            local.token = variables.testSubject.authenticate("root","diogenes");
            assertTrue(IsNull(local.token));
        }

     }
</cfscript>