# Read me
 Microsoft Intune deployment and management resources/tools
 Author: Jun

# 1. Put files to be deployed in \Application files\

# 2. Install.ps1

2.1. Edit the $TargetedFolder (line 2) with desired install location

2.2. Edit the $TargetFile (line 37) with the path to the file you need to create shortcut

2.3. Edit  $ShortcutFile (line 38), replace software name only. This creates shortcut in public desktop. The shortcut automatically retrieves the source file icon.

# 3. Uninstall.ps1

3.1. Edit the $TargetedFolder (line 2), same as step 2.1

3.2. Edit $ShortcutPath (line 3) with the path to installed shortcut, same as step 2.2

# 4. Open Win32 Content Prep Tool and compile all the files into intunewin package
The structure of files before compiling should look like this:


    Root folder\
        Application files\
            Filetobecopied1.txt
            Filetobecopied2.csv
            Filetobecopied3.exe
        Install.ps1
        Uninstall.ps1

This way, only Filetobecopied(1,2,3) will be deployed to endpoint devices. Files not in \Application files\ will not be visible to users.

# 5. On Intune, go to Apps/Windows/Add/Win32. Upload the compiled intunewin package from Step 4

5.1. Install command:


    powershell.exe -ExecutionPolicy Bypass -File Install.ps1

(Put quote marks if needed)
    
5.2. Uninstall command:


     powershell.exe -ExecutionPolicy Bypass -File Uninstall.ps1

(Put quote marks if needed)

5.3. Detection rules:

    Path: C:\Program Files (x86)\PBSG Tools\SAP

    File: SAP RDP.rdp

    Method: File exists

(Modify file name and file path based on your previous edits)

# 6. Assign the application.
Wait for some time until it's deployed to endpoint devices.