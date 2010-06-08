
<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>Model-Glue Login Example</title>
    <link rel="stylesheet" href="css/stylesheet.css" />
    <link rel="stylesheet" href="css/forms.css" />
</head>

<body>
<div>
    <div id="banner">Model-Glue Login Example</div>
    <div>
        <div>
            #viewcollection.getView("topNav")#
            <table width="100%">
            <tr>
                <td valign="top">
                    #viewcollection.getView("body")#
                </td>
                <td width="200" valign="top">
                    #viewcollection.getView("sideNav")#
                </td>
            </tr>
            </table>
            #viewcollection.getView("bottomNav")#
        </div>
    </div>
    <div id="footer" style="clear:both">
                <p>&copy; 2010 Dennis Clark.  This is Free Open Source Software, distributed under a BSD-style license.
                See the LICENSE.txt file for details.</p>
    </div>
</div>
</body>
</html>
</cfoutput>