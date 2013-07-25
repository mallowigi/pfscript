;-----------------------------
; Snippet library
; Bibliotheque de fonctions utiles fournies par mishscripts.org
;-----------------------------

; Reverse a text
alias reverse {
  ; First we need the number of characters supplied
  VAR %bt.n = $len($1-)
  ; We replace every space by a HARD-Space, since mIRC strips any spaces but one in remotes
  VAR %bt.ft = $replace($1-,$chr(32),$chr(160))
  ; Now we loop through the text and reverse the letters,
  ; The first will be last and so on
  WHILE (%bt.n > 0) { 
    VAR %bt.bt = %bt.bt $+ $mid(%bt.ft,%bt.n,1)
    DEC %bt.n 
  }
  ; Finally we return the new text
  RETURN %bt.bt 
}

; Return percentage of caps are in a text
alias percentcaps { 
  VAR %t = $remove($strip($1),$chr(32))
  RETURN $calc($regex(%t,/[A-ZÄÖÜ]/g)/$len(%t)*100) 
}

; Compute factorial of a number
alias fact {
  ; We check if the parameter is empty or if its a number
  IF ((!$1) || ($1 !isnum)) { echo -a Fact Error: Valid number is missing | halt }
  ELSE {
    VAR %x = $1, %y = 1
    WHILE (%x) { 
      %y = $calc(%y * %x)
      DEC %x 1 
    }
    RETURN %y
  }
}

; This script kicks all users off a channel that match a certain host. Uses ial so a /who of the chan before hand will increase effectiveness. 
; Syntax: /filterban <chan> <mask> 
alias filterban { 
  VAR %i = 1
  mode $1 +b $2
  WHILE ($nick($$1,%i) != $null) {
    IF ($2 iswm $ial($nick($$1,%i))) && ($nick != $me) { 
       kick $chan $nick($$1,%i) banned (host matches $2) 
    }
    INC %i
  }
}

; Allows you to get environment variables: 
; eg: $GetEnvStr(WinDir) 
; Try too: ComSpec, PATH, TMP/TEMP, SYSTEMDRIVE (winnt & 2000) ... 
alias GetEnvStr {
  .comopen env WScript.Shell
  VAR %r = $com(env,ExpandEnvironmentStrings,3,bstr,$+(%,$1,%))
  IF (%r) { %r = $com(env).result }
  .comclose env
  RETURN $iif(%r == $+(%,$1,%),$null,%r)
}

; $SpecialFolder(String) : Retrieve the path of the windows special folders
; The special folders are: 
; AllUsersDesktop - AllUsersStartMenu - AllUsersPrograms - AllUsersStartup - Desktop - Favorites - Fonts 
; - MyDocuments - NetHood - PrintHood - Programs - Recent - SendTo - StartMenu - Startup - Templates 
; Some of these special folders only work on NT,2000,XP 
alias SpecialFolder {
  .comopen spe WScript.Shell
  VAR %r = $com(spe,SpecialFolders,3,bstr,$1)
  IF (%r) { %r = $com(spe).result }
  .comclose spe
  RETURN %r
}

; $NetInfo(info) : Retrieve network information
; info must be: UserDomain, ComputerName, UserName 
; Note: UserDomain doesn't work on 98/ME 
alias NetInfo {
  .comopen inf WScript.Network
  VAR %r = $com(inf,$1,3)
  IF (%r) { %r = $com(inf).result }
  .comclose inf
  RETURN %r
}



;--------------------------------------
; Fin de fichier
;--------------------------------------