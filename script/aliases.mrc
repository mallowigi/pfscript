; --------------------------------------------------
; Aliases used in most of the scripts
; --------------------------------------------------

;sec Shortcuts
;------------------------------------------------
; 1) Shortcuts
;------------------------------------------------

; Return pfscript info
pfscript { return 15[7 Pokémon-France Script version $pfversion 15] - [12 Disponible sur : www.pokemon-france.com/services/chat/download.php 15] }

; Return the pfscript version
pfversion { return 4.0 }

; Shortcut for the left parenthesis
lparen { return $chr(40) }

; Same for right parenthesis
rparen { return $chr(41) }

; Shortcut for the comma
comma { return $chr(44) }

; Return the command char defined in the options
cmdChar { return $readini(mirc.ini,text,commandchar) }

;ces

;sec ReadWrite
;---------------------------------------------------
; 2) Read and Write aliases
;---------------------------------------------------

; Read an item from the pfscript options file
; $1 = section, $2 = item
ri { return $readini($mircdir/pfscript.ini,$$1,$$2) }

;Write an item in the options file
; $1 = section, $2 = item, $3 = value
wi { if ($3- == $null) { remi $$1 $$2 } | else { writeini " $+ $mircdir $+ /pfscript.ini $+ " $$1 $$2 $3- } }

;Remove an item from the options file
; $1 = section, $2 = item
remi { remini " $+ $mircdir $+ /pfscript.ini $+ " $$1 $2 }


; This reads an option from the mircini file
rmi { return $readini($mircini,$$1, $$2) }


; Verifie que le dossier de mirc est ouvert en écriture
; $1 (opt): sous dossier a check
checkWritePerm {
  var %f = temp $+ $ctime $+ .tmp
  write -c $qt($mircdir $+ $iif($1 && $exists($1-),$1- $+ /) $+ %f) Test d'écriture. Vous pouvez supprimer ce fichier.

  .remove $qt($mircdir $+ $iif($1 && $exists($1-),$1- $+ /) $+ %f)
  return $true

  :error
  reseterror
  return $false
}

; Verifie que l'écriture est possible
ensureWrite {
  while (!$checkWritePerm) {
    var %f = $input(Erreur: Le dossier $qt($mircdir) est en lecture seule. $+ $crlf $+ Appuyez sur Retry pour réessayer ou Cancel pour fermer le programme.,rdvh,Erreur,Erreur,kikoololasv)
    if (%f == $cancel) { exit -n }
  }
  var %folders = channels|data|download|images|script
  var %i = 1
  while ($gettok(%folders,%i,124)) {
    var %folder = $ifmatch
    if (!$checkWritePerm(%folder)) { echo -sc info Attention: Le dossier %folder n'est pas ouvert en écriture. Ceci peut causer certains scripts de ne plus fonctionner. Veuillez régler le problème dès que possible. }
    inc %i 
  }
}


;ces

;sec Identifiers
; ---------------------------------------
; 3) Custom identifiers
; ---------------------------------------

;Compute an incremented number
trnum {
  set %trnum $base($calc($base(%trnum,36,10) +1),10,36)
  return %trnum
}

; Test if a word is a command (prefixed with th command prefix)
; $1: Command word
isCmd {
  var %cmdchar = $readini(mirc.ini,text,commandchar)
  if (!%cmdchar) { %cmdchar = / }
  return $iif($left($1,1) == %cmdchar,$true,$false)
}

; True if the phrase is an highlight
isHl {
  if ($highlight) && ($highlight($1-)) { return $true }
  else { return $false }
}

; Checks if a word in a list of tokens is a word in a phrase
; $1: text to match, $2: token list, $3: delimiter
isInPhrase {
  var %text $1
  var %i = 1
  while ($gettok($2,%i,$3)) {
    var %token = $ifmatch

    if (* %token * iswm %text) || (%token * iswm %text) || (* %token iswm %text) || (%token iswm %text) { return $true }
    inc %i
  }
  return $false
}


; Format a public message (according to the options)
pubmsg { 
  var %fmt = $ri(misc,amsg)
  if (%fmt) {
    %fmt = $replace(%fmt,<text>,$+ $1- $+)
    return %fmt
  }
  return $1-
}

;Check if it the given font exists
; $1: Font name
isFont {
  var %x = i oW
  if ($width(%x,$$1,10) == $width(%x,MS Shell Dlg,10)) && ($height(%x,$$1,10) == $height(%x,MS Shell Dlg,10)) { return $true }
  elseif ($width(%x,$$1,10) == $width(%x,xqsddc,10)) && ($height(%x,$$1,10) == $height(%x,xqsdqsdsq,10)) { return $false }
  else { return $true }
}

; Shorten a phrase to a given length. Ex: $shorten(3,blablabla) will return "bla..."
; $1: wanted length (>3), $2-: text
; If prop cutpath: cut the path off
shorten {
  if ($prop == cutpath) && ($len($2-) > $1) {
    var %i = 2,%n = $1,%p = $2-
    while (%i < $numtok($2-,92)) {
      %p = $replace(%p,$gettok($2-,%i,92),...)
      inc %i
      if (%i == $numtok($2-,92)) { return %p }
    }
  }
  elseif ($1 > 3) && ($len($2-) > $1) { return $left($2-,$calc($1)) $+ ... }
  return $2-
}

; Create a full filename
mkfullfn {
  var %r = $remove($iif(!$regex($1-,/^"?[a-z]\:(\\.*)?/i),$mircdir) $+ $1-,")
  if ($prop == noqt) { return %r }
  else { return $qt(%r) }
}

; Converts a phrase to a channel name (remove commas and spaces and adds a # if there is no # prefixed)
; Ex: $wordToChannel(heywhat's up = #heywhat'sup)
wordToChannel {
  var %word = $1-
  %word = $remove(%word,$chr(32),$chr(44))
  if ($left(%word,1) != $chr(35)) { %word = $chr(35) $+ %word }
  return %word
}

; Generate a random password
generatePassword { 
  VAR %x = $rand(8,15)
  WHILE (%x) { 
    VAR %y = %y $+ $mid(0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ,$rand(1,62),1)
    DEC %x 
  }
  RETURN %y 
}

; Check if $me can control a channel
; $1: channel
canControl {
  if ($me isop $1) || ($me ishop $1) || (o isincs $usermode) { return $true }
  return $false
}

; Open a custom tooltip (needs the tooltip option to be checked)
; $1: name, $2: text
pftip { 
  if ($isfile(images/mbico.ico)) { return $tip($trnum,$$1,$$2,,images/mbico.ico,,,) }
  else { return $tip($trnum,$$1,$$2) }
}


;ces 

;sec DateAndTime
; ------------------------------------
; 4) Date and time identifiers
; ------------------------------------

; Write the duration in french format
; $1: time in seconds
; if property .short, return in short format
durationfr {
  var %duration = $duration($$1)
  var %result
  if ($prop == short) {
    %duration = $replace(%duration,secs,$chr(32) $+ s,sec,$chr(32) $+ s,mins,$chr(32) $+ m,min,$chr(32) $+ m,hrs,$chr(32) $+ h,hr,$chr(32) $+ h,days,$chr(32) $+ j,day,$chr(32) $+ j,wk,$chr(32) $+ sem)
  }
  else {
    %duration = $replace(%duration,sec,$chr(32) $+ seconde,min,$chr(32) $+ minute,hr,$chr(32) $+ heure,day,$chr(32) $+ jour,wk,$chr(32) $+ semaine)
  }
  return %duration
}

; Write the asctime in french format
asctimefr {
  var %asctime $asctime($1,yyyy:m:ddd:d:H:nn:ss)
  var %year $gettok(%asctime,1,58)
  var %month $gettok(%asctime,2,58)
  var %dayweek $gettok(%asctime,3,58)
  var %days $gettok(%asctime,4,58)
  var %hours $gettok(%asctime,5,58)
  var %mins $gettok(%asctime,6,58)
  var %secs $gettok(%asctime,7,58)

  if ($prop == date) { return %days $+ / $+ %month $+ / $+ %year }
  elseif ($prop == time) { return  %hours $+ h $+ %mins  }
  return $shortdayfr(%dayweek) %days $monthfr(%month) %year à %hours $+ h $+ %mins
}

; Replace the english day names by the french names
shortdayfr {
  if ($1 == Sun) return Dim
  elseif ($1 == Mon) return Lun
  elseif ($1 == Tue) return Mar 
  elseif ($1 == Wed) return Mer
  elseif ($1 == Thu) return Jeu
  elseif ($1 == Fri) return Ven
  elseif ($1 == Sat) return Sam
  elseif ($1 == Sun) return Dim
  else return ???
}

; Replace the english day names by the french names
dayfr {
  if ($1 == Sunday) return Dimanche
  elseif ($1 == Monday) return Lundi
  elseif ($1 == Tuesday) return Mardi
  elseif ($1 == Wednesday) return Mercredi
  elseif ($1 == Thursday) return Jeudi
  elseif ($1 == Friday) return Vendredi
  elseif ($1 == Saturday) return Samedi
  elseif ($1 == Sunday) return Dimanche
  else return ???
}

; Replace the english month names by the french names
shortmonthfr {
  if ($1 == 0) return ???
  elseif ($1 == 1) return Jan
  elseif ($1 == 2) return Fev
  elseif ($1 == 3) return Mar
  elseif ($1 == 4) return Avr
  elseif ($1 == 5) return Mai
  elseif ($1 == 6) return Jun
  elseif ($1 == 7) return Jui
  elseif ($1 == 8) return Aou
  elseif ($1 == 9) return Sep
  elseif ($1 == 10) return Oct
  elseif ($1 == 11) return Nov
  elseif ($1 == 12) return Dec
  else return ???
}

; Replace the english month names by the french names
monthfr {
  if ($1 == 0) return ???
  elseif ($1 == 1) return Janvier
  elseif ($1 == 2) return Fevrier
  elseif ($1 == 3) return Mars
  elseif ($1 == 4) return Avril
  elseif ($1 == 5) return Mai
  elseif ($1 == 6) return Juin
  elseif ($1 == 7) return Juillet
  elseif ($1 == 8) return Août
  elseif ($1 == 9) return Septembre
  elseif ($1 == 10) return Octobre
  elseif ($1 == 11) return Novembre
  elseif ($1 == 12) return Decembre
  else return ???
}

;ces

;sec Lists
;--------------------------------------
; 5) Alias/Commands/Idents list
;--------------------------------------

; Retrieve the list of mirc aliases
cmdList {
  return abook;ajinvite;ame;amsg;anick;aop;avoice;away;background;ban;beep;channel;clear;clearall;clipboard;close; $+ $& $+cnick;color;copy;ctcps;disconnect;dns;ebeeps;echo;editbox;emailaddr;events;exit;findtext;finger;flood;font;fullname; $+ $& $+help;hop;ial;ialclear;identd;ignore;invite;join;kick;linesep;list;load;localinfo;log;mdi;me;menubar;mnick;mode; $+ $& $+msg;nick;noop;notice;notify;omsg;onotice;part;partall;perform;play;pop;protect;pvoice;qme;qmsg;query;quit;raw;reload; $+ $& $+remote;resetidle;run;say;server;showmirc;speak;splay;strip; switchbar;timer;timestamp;titlebar;tnick;toolbar;topic;tray; $+ $& $+treebar;unload;url;vol;who;whois;whowas;winhelp
}

;Return the list of PFscript aliases
aliasList {
  return op;deop;halfop;dehalfop;voice;devoice;j;p;n;w;k;q;send;chat;ping;epik;cyber;host;slaps;newserv;qame;qamsg; $+ $& $+aw;back;pubmsg;qecho;loadtheme;loadscheme;openquotes;themes;openstats;setup;saysong;pfabout
}

; Return the list of custom identifiers
identList {
  var %i = 1
  var %res
  while ($hget(idents,%i).item) {
    %res = $addtok(%res,$ifmatch,59)
  }
  return %res
}

;ces

;sec CustomCommands
; -------------------------------------
; 5) Custom Commands
; -------------------------------------

; Print an echo to all query windows
qecho {
  var %i = 1
  while ($query(%i)) { 
    if ($istok($1-,<query>,32)) { echo $replace($1-,<query>,$query(%i)) }
    else { echo $query(%i) $1- }
    inc %i
  }
}

; Perform an action to all channels where you are on
; $1: command, $2 may be -c : only on controlled channels, otherwise $2-: parameters
execAllChans {
  var %i = 1
  var %canControl = $iif($2 == -c,1,0)
  while (%i <= $chan(0)) {
    var %channel = $chan(%i)
    var %cmd = $remove($replace($1-,<chan>,%channel),-c)
    if (%canControl) {
      if ($canControl(%channel)) { %cmd }
    }
    else { %cmd }
    inc %i
  }
}

;ces

; ––––––––––––––––––––––––––––––––––––––––
; End of file
; ––––––––––––––––––––––––––––––––––––––––
