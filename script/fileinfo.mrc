; Author
; FiberOPtics -- mirc.fiberoptics@gmail.com

; Purpose
; Returns up to 37 characteristics of any file. For example version information of .exe files, audio information of .wma/.mp3 files, etc.
; This uses Windows to retrieve the properties, which are the same when you right click a column label in Windows Explorer to specify
; which attributes from a file you want to see as default.


; Requirements
; $fileinfo and $findfileinfo: mIRC 5.91, Windows ME or higher
; /listtags: mIRC 6.14, all OS'es

; Installation
; The snippets go into the remote section because of their alias prefix.
; Press ALT+R -> tab "Remote" -> Paste there.
; You can also put it in the aliases section, provided you remove the alias prefix.

; Info
; Filepath must be the complete filepath, even when the file resides in the mIRC folder.
; Empty values for categories are filled with a zero.
; If you specify a third parameter, this will be used as a separator between the attributes.
; The default is a line feed $lf, which you can parse with $gettok(...,N,10) or //tokenize 10 $fileinfo(...)
; There are two ways of outputting the result.
; 1. Default : "Propertyname: value <separator> ..."
; 2. Raw : "value <seperator> ..."
; The .raw property was added to give scripters more freedom in deciding the format of output.

; Usage:


; $fileinfo(filepath, properties [,separator])[.raw]

; Will retrieve information about a file. The possible properties are listed below.

; $findfileinfo( initialize, properties [, seperator])[.raw]
; $findfileinfo(filepath)
; $findfileinfo(quit)
; Findfileinfo is specifically designed to be used when you want to retrieve properties
; about files from a large collection. For example if you want to retrieve audio properties
; from your audio folder, which may contain hundreds or thousands of files, then $findfileinfo
; will be better suited than fileinfo.
; You first initialize findfileinfo by specifying as first parameter the word "initialize"
; and as second parameters the properties that you will retrieve from each file in the collection.
; Once you are done with retrieving the info, you can use "initialize" again to set new properties
; or you can quit by specifying the keyword "quit". Let's make an example:

; $findfileinfo(initialize, Artist Title Genre Duration Bitrate Audiosamplerate)
; !.echo -q $findfile(d:\my audio\,*,0,aline @info $findfileinfo($1-))
; $findfileinfo(quit)

; /listtags


; This alias will list all available properties that you can use on your system.
; These properties will be in the language of your OS, but you must always use the English properties that you see below.


; Properties
; The following tables lists the available properies:
; Cathegory Property Names
; Audio/Video Title Artist Author AlbumTitle Year TrackNumber Genre Duration BitRate
; Audiosamplesize Audiosamplerate Channels Protected Copyright EpisodeName Comments
; Pictures CameraModel DatePictureTaken Dimensions
; Executables ProgramDescription Company Description FileVersion ProductName ProductVersion
; Misc Attributes Status Owner Subject Category Pages
; Common Name Size Type DateModified DateCreated DateAccessed



; Examples
; $fileinfo(d:\audio\song.wma,Artist Title Genre Duration BitrateAudiosamplerate,**)
; $fileinfo($mircexe,Company Productname Productversion Fileversion Type Name)
; $fileinfo(c:\pics\mypic.jpg,Dimensions Datepicturetaken,-=-).raw

alias fileinfo {
  VAR %e = RETURN $+($chr(3),$color(info),$,fileinfo:), %result

  ; Basic error checking, the reason is explained in the error message that is returned.

  IF ($version < 5.91) { %e This snippet requires atleast mIRC 5.91. }
  IF ($istok($OS,95 98,32)) { %e This snippet can only work on Windows ME or higher. }
  IF (!$isid) { %e This function can only be used as an identifier. }
  IF (!$isfile($1)) { %e File doesn't exist: $1- }
  IF (* !iswm $2) { %e You didn't specify a property to retrieve. }

  ; Setting some variables, taking advantage of /var's ability to assign multiple variables on a single line.
  ; The variable %mss will be used as the name of our main COM objet. We use the identifier $ticks in it
  ; to make sure that the name is unique, and thus doesn't collide with another object with the same name.

  VAR %mss = mss $+ $ticks, %t, %n = $crlf, %file = $1, %list, %sep = $iif($len($3)," $+ $3",vblf)
  VAR %props = $&
    Name Size Type DateModified DateCreated DateAccessed Attributes Status Owner Author Title $&
    Subject Category Pages Comments Copyright Artist AlbumTitle Year TrackNumber Genre Duration $&
    BitRate Protected CameraModel DatePictureTaken Dimensions . . EpisodeName ProgramDescription . $&
    Audiosamplesize Audiosamplerate Channels Company Description FileVersion ProductName ProductVersion

  ; Tokenizing parameter $2 from the identifier, which holds the list of properties for which you
  ; want to retrieve info. The looping is done using a while loop with the condition ($0), which
  ; will keep looping until there are no more tokens left.

  tokenize 32 $2
  WHILE ($0) {

    ; If we find the specified property in the list of properties (%props)...

    IF ($findtok(%props,$1,1,32)) {

      ; ... then add the name of the property ($1) as well as its index ($ifmatch - 1) to a
      ; comma seperated variable %list which will look like: name:0,size:1,type:2 etc.

      %list = $addtok(%list,$+(",$1,:,$calc($ifmatch - 1),"),44)
    }

    ; Tokenize all other tokens except the first one so that the second token in the list
    ; now becomes the first token $1

    tokenize 32 $2-
  }
  IF (!%list) { %e You didn't supply any valid properties. }

  ; Open the MSScriptControl.ScriptControl object which is a script interpreter, able to
  ; interpret both VBscript or Jscript, thus giving us the functionality of those languages from
  ; within mIRC. The name of the object is assigned to the value of variable %mss.

  .comopen %mss MSScriptControl.ScriptControl

  ; If there was an error opening the object, then we must stop the alias.

  IF ($comerr) { %e Error opening ScriptControl object. }

  ; Set the language of the script interpreter to vbscript. Setting a property requires number 4
  ; as third parameter in a $com call, and what we are passing is a basic string (bstr) by reference (*)

  %t = $com(%mss,language,4,bstr*,vbscript)

  ; We now populate the variable %t with the code that will do the actual retrieving of the info.
  ; This code is in Visualbasicscript, and each line of code is seperated by a $crlf, which is a
  ; combination of a carriage return ($cr) and a line feed ($lf).
  ; We use the $& identifier in mIRC to be able to put our code on multiple lines, but when mIRC
  ; will interpret it, it will put all the lines on one single line and treat them as such.
  ; I cannot comment in between this lines because of the $& identifier, so I will write a summary
  ; of it here instead.

  ; list = array( %list )
  ; -> create an array "list" that will hold our properties from the variable %list. We cannot put
  ;    array(%list) because mIRC wouldn't be able to evaluate the %list identifier. mIRC doesn't
  ;    understand VBScript, so as far as it is concerned it just sees a basic string with no
  ;    meaning in mIRC Scripting.

  ; set shell = createobject("shell.application")
  ; -> create the main object that will retrieve the info

  ; set folder = shell.namespace(" $+ $nofile(%file) $+ ")
  ; -> retrieve a reference to the folder where the file resides of which we want to find the info.
  ;    We call this object "folder". $nofile(<path>) returns the path of a file without the filename.

  ; set item = folder.parsename(" $+ $nopath(%file) $+ ")
  ; -> retrieve a reference to the file by using $nopath which returns the filename of a filepath
  ;    without the folderpath. This item in other words, is a reference to the actual file of
  ;    which we will retrieve information.

  ; for each param in list
  ; -> initializing a for each loop, which will loop through each property that we had stored
  ;    earlier in our array "list". the variable "param" will each time be a <name>:<index> pair.

  ; tmp = split(param,":")
  ; -> split this parameter up into the name and the index and store it in array tmp, which we can then
  ;    access with tmp(1) being the index number, and tmp(2) being the name of the property.

  ; prop = folder.getdetailsof(item,tmp(1))
  ; -> assign the value of the property that we access with tmp(1) and store it in variable prop.
  ;    We now have retrieved the value that we were looking for.

  ; if len(prop) = 0 then prop = 0
  ; -> if the value of the property was empty, we will replace it with a 0.

  ; $iif($prop != raw,prop = tmp(0) & ": " & prop)
  ; -> If the user specified the .raw property, we will not include the name of the property in our
  ;    final result. If they didn't specify it, we include it by assigning tmp(0) to variable prop.

  ; result = result & prop & %sep
  ; -> we store the value of variable prop into variable result, which is what we will return to mIRC
  ;    once we have looped through all parameters.

  ; next
  ; -> this tells VBscript to continue with the loop from the top again, thus going to the next parameter.

  ; result = left(result,len(result) - len( %sep ))
  ; -> we are done with looping, and now have the variable result with all our information we requested
  ;    This variable's value will now be retrieved back with regular mIRC scripting.

  %t = $&
    list = array( %list ) %n $&
    set shell = createobject("shell.application") %n $&
    set folder = shell.namespace(" $+ $nofile(%file) $+ ") %n $&
    set item = folder.parsename(" $+ $nopath(%file) $+ ") %n $&
    for each param in list %n $&
    tmp = split(param,":") %n $&
    prop = folder.getdetailsof(item,tmp(1)) %n $&
    if len(prop) = 0 then prop = 0 %n $&
    $iif($prop != raw,prop = tmp(0) & ": " & prop) %n $&
    result = result & prop & %sep %n $&
    next %n $&
    result = left(result,len(result) - len( %sep ))

  ; This if check does two things:
  ; 1) It evaluates two times a $com call, first time with method "executestatement" which will execute
  ;    the code that we had filled our variable %t with. Therefore we pass this variable %t as an argument
  ;    to the $com call. Secondly, it evaluates another $com call by calling the "eval" property on the COM
  ;    object. That will make the code that we just executed evaluated, and allows us to retrieve the value
  ;    of the VBscript variable "result". Therefore we pass this variable as a bstr* to the $com call.
  ; 2) It checks to see if both $com calls were successfully. If they were, they both returned "1",
  ;    which makes the code proceed to the statement: %result = $com(%mss).result
  ;    If they weren't successful, then it goes to the statement: %e Error executing VBScript to retrieve fileinfo.
  ;    Don't confuse the .result property of $com() with our VBscript variable "result". They have nothing to do with
  ;    each other. $com(<object>) result will always store the result of property call on an object in mIRC. It's
  ;    simply a coincidence that I used the name "result" to store the properties in VBscript.

  IF ($com(%mss,executestatement,1,bstr*,%t)) && ($com(%mss,eval,3,bstr*,result)) {
    %result = $com(%mss).result
  }
  ELSE { %e Error executing VBScript to retrieve fileinfo. }

  ; This error label will make mIRC jump to here in case any error has occured when mIRC was interpreting
  ; the code. In here, we close the com object if it was still open, but first resetting it to free any
  ; resources used in the VBScript code such as our open objects. We use this method instead of adding
  : something like: set shell = nothing. Normally this works in VBScript, but the Script Interpreter
  : doesn't perform it properly, therefore the reset method.

  :error
  IF ($com(%mss)) { .comclose %mss $com(%mss,reset,1) }

  ; We return our result which was stored earlier in variable %result if no error has happened.
  ; If an error has happened, %result will just be empty, so it will return nothing.

  RETURN %result
}

; Use this alias if you want to use fileinfo on a large collection of files at once when
; used with $findfile on an entire folder and subfolders
;
; First initialize with: $findfileinfo(initialize,<properties>)
; Call it with:          $findfileinfo(<filepath>)
; Free resources with:   $findfileinfo(quit)
;

alias findfileinfo {

  ; Commenting for this snippet will be less than for $fileinfo, because a lot of the code is the same.
  ; I will only explain the differences, and why exactly I made it different.

  ; Instead of using a unique variable like in $fileinfo, we specify as name "findfileinfo", because
  ; this object must remain open in your mIRC until you decide to manually close it with $findfileinfo(quit)

  VAR %t, %obj = findfileinfo

  ; If you specifyed $findfileinfo(initialize) then...

  IF ($1 == initialize) {

    ; Exact same code as for $fileinfo until the VBscript code.

    VAR %e = RETURN $+($chr(3),$color(info),$,findfileinfo:)
    IF ($version < 5.91) { %e This snippet requires atleast mIRC 5.91. }
    IF ($istok($OS,95 98,32)) { %e This snippet can only work on Windows ME or higher. }
    IF ($2 == $null) { %e you must specify properties to retrieve. }
    IF ($com(%obj)) { .comclose %obj }
    .comopen %obj MSScriptControl.ScriptControl
    VAR %sep = $iif($len($3)," $+ $3",vblf), %n = $crlf, %list
    VAR %props = $&
      Name Size Type DateModified DateCreated DateAccessed Attributes Status Owner Author Title $&
      Subject Category Pages Comments Copyright Artist AlbumTitle Year TrackNumber Genre Duration $&
      BitRate Protected CameraModel DatePictureTaken Dimensions . . EpisodeName ProgramDescription . $&
      Audiosamplesize Audiosamplerate Channels Company Description FileVersion ProductName ProductVersion
    tokenize 32 $2
    WHILE ($0) {
      IF ($findtok(%props,$1,1,32)) {
        %list = $addtok(%list,$+(",$1,:,$calc($ifmatch - 1),"),44)
      }
      tokenize 32 $2-
    }
    IF (!%list) { %e you didn't specify any valid properties. }
    %t = $com(%obj,language,4,bstr*,vbscript)

    ; You will notice here that unlike in $fileinfo, the VBScript starts different.
    ; Here I am creating a function in VBScript called "FindFileInfo" that takes two parameters,
    ; being a path to a folder (dir) and a file name (file). At the end of the VBscript, we finish
    ; the declaration of the function with the statement "End Function".

    %t = $&
      Function FindFileInfo(dir,file) %n $&
      list = array( %list ) %n $&
      set shell = createobject("shell.application") %n $&
      set folder = shell.namespace(dir) %n $&
      set item = folder.parsename(file) %n $&
      for each index in list %n $&
      tmp = split(index,":") %n $&
      prop = folder.getdetailsof(item,tmp(1)) %n $&
      if len(prop) = 0 then : prop = 0 : end if %n $&
      $iif($prop != raw,prop = tmp(0) & ": " & prop) %n $&
      %obj = %obj & prop & %sep %n $&
      next %n $&
      %obj = left( %obj ,len( %obj ) - len( %sep )) %n $&
      End Function

    ; Instead of doing "executestatement" and "eval" like in $fileinfo, all we do is add this FindFileInfo
    ; function to the Script interpreter without making it do anything. For this we use the "addcode" method.
    ; We do this because with future calls of FindFileInfo, we only then need to do a simple "eval" to get our
    ; required results. The main difference here is that the properties to retrieve have been hardcoded in the
    ; VBScript function. With each call of $findfileinfo it will retrieve the same properties, only the file
    ; will be different.

    %t = $com(%obj,addcode,1,bstr*,%t)

    ; %t will store the value of our $com call. If it was successful1 (1) return $true, else return $false.

    RETURN $iif(%t == 1,$true,$false)
  }

  ; If you specified $findfileinfo(quit) then...

  ELSEIF ($1 == quit) {

    ; If the COM object exists, let's close it, because we don't need it anymore.
    ; We now will free any resources used by the Script Interpreterincluding objects by
    ; using the reset method (1) on the main COM object %obj

    IF ($com(%obj)) { .comclose %obj $com(%obj,reset,1) }
  }
  ELSE {

    ; If you didn't specify a valid filepath, then return.

    IF (!$isfile($1)) { RETURN }

    ; If our object is open (it will be if you initialized it before) then...

    IF ($com(%obj)) {

      ; ...first assign the string FindFileinfo("<folderpath>","<filename>") to variable %t.

      %t = $+(FindFileInfo,$chr(40),",$nofile($1),",$chr(44),",$nopath($1),") )

      ; Now we call our main object, and ask it to evaluate the function FindFileinfo with the specified parameters.
      ; You can compare this process with calling an identifier in mIRC with parameters.

      %t = $com(%obj,eval,3,bstr*,%t)

      ; The result is stored in $com(%obj).result (if any) and that is what we return.

      RETURN $com(%obj).result

      ; The entire reason that we use this approach with adding a function to the VBScript interpreter,
      ; is that unlike with fileinfo, we don't need to go to the process of creating the VBScript code,
      ; adding it, executing it, and doing the eval call on it. Instead, we add the code once with
      ; $findfileinfo(initialize,<properties>) and then just call this function each time. This is handy
      ; when retrieving information from a large collection of files at once like with $findfile,
      ; thus saving precious processing time.

    }
  }
}

alias listtags {

  ; If the version of mIRC where the user wants this to run, is under 6.14
  ; then we must stop the alias as it will not work. The reason we need 6.14 is
  ; because the code uses "dispatch", something that was only fixed in that version.
  ; $fileinfo and $findfileinfo do not use dispatch, so for them the requirement
  ; is only mIRC 5.91.

  IF ($version < 6.14) { RETURN }

  ; Create unique COM object names so that they don't interfere with other COM
  ; objects that migth be open on the user's mIRC. $ticks ensures that the variable
  ; name, and thus the object name is unique.

  VAR %t = $ticks, %i = 0
  VAR %objShell = a $+ %t, %objFolder = b $+ %t

  ; Open the main COM object being shell.application, and assign it to value of %objshell

  .comopen %objShell shell.application

  ; If there was no error when opening the object then...

  IF (!$comerr) {

    ; ... Use the namespace method on the Shell object, by specifying the name of this method
    ; and specifying the number "1". We pass the value of a path to a file (here $mircini).
    ; We create a new child object with the use of dispatch*. This object is a folder, which
    ; will be the main mIRC folder.

    %t = $com(%objShell,namespace,1,bstr,$mircdir,dispatch* %objFolder)

    ; If the folder object was created successfully then...

    IF ($com(%objFolder)) {
      echo -ac info * Listing available properties on your system...

      ; We loop from 1 till 40, looping through all possible properties that you can retrieve on your system.
      ; Some properties will not exist on your system, and thus will echo an empty value.

      WHILE (%i < 40) {

        ; Invoke the "getdetailsof" method on our folder object, passing the variable %i that serves as our
        ; index number of the property name that we want to retrieve. This %i variable is passed as data type
        ; uint, which means unsigned integer. We could use i1, i2, i4, it's not so important in this case.

        %t = $com(%objFolder,getdetailsof,1,bstr*,null,uint,%i)

        ; The result of our "getdetailsof" method is stored in $com(<object>).result, so we echo
        ; this along with the index number.

        echo -a Index %i - $com(%objFolder).result
        INC %i
      }

      ; We are finished with looping, and can now close our folder object.

      .comclose %objFolder
    }

    ; We can now also close our main Shell object, because we are done.

    .comclose %objShell
  }
}

;--------------------------------
; Fin de fichier
;--------------------------------