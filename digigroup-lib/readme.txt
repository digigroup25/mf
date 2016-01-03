Local Maven Set Up

To configure your environment to use the Nexus repository manager, follow the steps below:

cd ~/.m2
mv settings.xml settings.xml.old
svn co http://labs.digigroupinc.com/svn/digigroup/maven/3.0.3/conf .
cd <your build root dir>
mvn –U clean install

This last step will take a while because the –U flag forces Maven to re-download artifacts from the repositories you
have set up.  In this case the repository is Nexus so you will see the Nexus URL in the download messages.



Profiles

I've created profiles that will activate when the build is run on different operating systems.  I've only been able to
test the Mac version.  I need to run Maven from the command line in the Linux environment to properly set up the
Linux profile.



Running Unit Tests

Flash Player

I've assumed that the debug version of Flash Player will be used to run the tests.  The debugger version is better
because it gives stack trace information in the test xml files when the test fails.  It also allows logs to be
generated from test runs for debugging purposes (see below).



Flex Unit Logging

To enable trace() output when running FlexUnit from Maven, you have to do a number of things.  First, in the user's home
directory, create a file called mm.cfg.  Add the following lines to the file and save it:

ErrorReportingEnable=1
TraceOutputFileEnable=1

When you run, all trace and error output will be logged to a file.  Here are the file locations for each OS.

Windows 95/98/ME/2000/XP	C:\Documents and Settings\username\Application Data\Macromedia\Flash Player\Logs
Windows Vista				C:\Users\username\AppData\Roaming\Macromedia\Flash Player\Logs
Macintosh OS X				/Users/username/Library/Preferences/Macromedia/Flash Player/Logs/
Linux						/home/username/.macromedia/Flash_Player/Logs/

Presumably Windows 7 follows the Vista location.

The source link for this information is here: http://livedocs.adobe.com/flex/3/html/help.html?content=logging_04.html.