
This is the example Model-Glue application I used for the presentation titled "MVC for the Rest of Us"
that I gave at NCDevCon 2010.

The initial goal of this example was to demonstrate some simple techniques in Model-Glue
to enable parallel collaboration between front-end designers and back-end engineers
in the building of application events, including mock events and unit testing.

A longer-term goal is to to test and implement ideas for building a flexible security framework
for Model-Glue applications.

Requirements:

 * Adobe ColdFusion 9.0 or later (other CFML engines have not been tested)
 * Model-Glue 3.1.299 (later versions have not been tested)
 * ColdSpring 1.2 (later versions have not been tested)

Getting started:

 1. Copy all files into a "mgLoginExample" folder under your ColdFusion web root.
 2. Open config/ColdSpring.xml and edit the value of "passwordFilePath" to point to the physical path
     of the passwd.txt file to use (there is a sample passwd.txt in the same folder).
 3. Start the application at http://<website>/mgLoginExample/index.cfm

WARNING: THE SOLE AUTHENTICATOR SERVICE PROVIDED IS HIGHLY INSECURE AND SHOULD NOT BE USED
IN PRODUCTION ENVIRONMENTS!!!

The biggest deficiency with the authenticator at this time is that it only supports passwords
stored in plaintext.

Any help to make this code safer for production use is welcome!

TODO (not necessarily in order of implementation):

 * Add secure password hashing plugins for authenticators (salted iterative MD5/SHA1; bcrypt)
 * Add a CGI null authenticator (useful for authentication schemes handled by the Web server)
 * Add a CF-ORM authenticator
 * Add an LDAP authenticator
 * Package components and events into actionpacks (security,mocking)

License:

All my code in this project is being released under a FreeBSD-style license (see LICENSE.txt for details).

Some files were generated in part from the Model-Glue application template; I presume these files
are under the same license as Model-Glue (Apache 2.0), but the source files do not make this clear.

For the latest information about this project, visit the project site:


Cheers,

-- Dennis Clark