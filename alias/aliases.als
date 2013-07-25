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

;Same for left bracket
lbrack { return $chr(91) }

;Same for right bracket
rbrack { return $chr(93) }

; Same for left accolade
lacc { return $chr(123) }

;Same for right accolade
racc { return $chr(125) }

;Same for the dollar
dollar { return $chr(36) }

;Shortcut for the pipe
pipe { return $chr(124) }

; Shortcut for the comma
comma { return $chr(44) }

; Return the command char defined in the options
cmdChar { return $readini(mirc.ini,text,commandchar) }

; Perform a kick followed by a ban
; $1: nick/address
kb { ban -k $1 }

; Open a new server (default epiknet)
; $1:server name
newserv { /server -m $iif($1,$+(irc.,$1,.net),irc.epiknet.org) }
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

; Reads protections ini file
; $1: Section, $2: proprierty
rci {
  var %f = $qt($iif($ri(paths,prot),$v1,data/prots.ini))
  if (!$isfile(%f)) { $errdialog(Le fichier %f n'existe pas!) | halt }

  return $readini(%f,$$1,$$2)
}

; Write a property in the protections ini
; $1: section, $2: property, $3- value
wci {
  var %f = $qt($iif($ri(paths,prot),$v1,data/prots.ini))
  if (!$isfile(%f)) { $errdialog(Le fichier %f n'existe pas!) | halt } 

  if ($3-) { writeini %f $$1 $2 $3- }
  elseif ($2) { remini %f $$1 $2 }
  else { remini %f $$1 }
}


; Retrieve a protection parameter
; $1: channel/default/pprot, $2: protection, $3: parameter
getProtParam {
  if ($1 != pprot) {
    var %cprot = $iif($1 == default,cprot,cprot. $+ $1)
    var %allpreset = $rci(cprot,allpreset), %usepreset = $rci(%cprot,usepreset)
    if (%allpreset) || (%usepreset) { %cprot = def }
    return $rci(%cprot,$2 $+ . $+ $3)
  }
  else {
    return $rci(pprot,$2 $+ . $+ $3)
  }
}

; Changes a protection parameter
; $1: channel/Default/pprot, $2: protection, $3: parameter, $4-: value
setProtParam {
  if ($1 != pprot) {
    var %cprot = $iif($1 == default,cprot,cprot. $+ $1)
    wci %cprot $2 $+ . $+ $3 $4-
  }
  else {
    wci pprot $2 $+ . $+ $3 $4-
  }
}


; This reads an option from the mircini file
rmi { return $readini($mircini,$$1, $$2) }

; Check if a feature is enabled
; $1: feature name
enabled { return $hget(groups,$$1) }

; Enable or disable a feature
; Syntax: /feature <featurename> (on|off)
feature {
  if ($$2 == on) { .signal feature_ $+ $$1 $+ on | hadd groups $$1 1 | .enable $chr(35) $+ features. $+ $$1 | echo -es Feature $$1 activée }
  else { .signal feature_ $+ $$1 $+ off | hadd groups $$1 0 | .disable $chr(35) $+ features. $+ $$1 | echo -es Feature $$1 désactivée }
}

; Disable all features
noFeatures { 
  .disable #features* 
  var %i = 1
  while ($hget(groups,%i).item) {
    hadd groups $ifmatch 0
    inc %i
  }
}

; Enable all features
allFeatures { 
  .enable #features* 
  var %i = 1
  while ($hget(groups,%i).item) {
    hadd groups $ifmatch 1
    inc %i
  }
}

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

; Rename an hash table
; $1: hash table to rename, $2: new name, $3 (optional): size
renameHash {
  hsave $$1 temp
  hfree $$1
  
  hmake $$2 $iif($3,$3,100)
  hload $$2 temp
  .remove temp
}

; Normalize hash table names by removing spaces
; $1: hash table name, $2 (optional): size
normalizeHash {
  var %i = 1
  hmake tmpHash 10
  while ($hget($$1,%i).item) {
    var %item = $ifmatch, %data = $hget($$1,%item)
    var %newitem = $unspace(%item)
    hadd tmpHash %newitem %data
    inc %i
  }
  hfree $$1
  
  renameHash tmpHash $$1 $2
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

; True if $1 is a channel
isChan {
  return $iif($left($1,1) == $chr(35),$true,$false)
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

; Check if a filename represents an image loadable by mirc
; Loadable images are .jpg,.png,.gif,.bmp,.ico,.exe and icl
; $1-: filename
isImage {
  if ($regex($1-,/^.*\.(jpg|png|gif|cmp|ico|icl|exe|jpeg)"?$/i)) { return $true }
  else { return $false }
}

; Retourne le nick par défaut tel qu'indiqué dans les options pour ce serveur, ou votre nick sans la mention "Away" si aucun nick n'a été renseigné
defaultNick {
  var %server = $network
  if (!%server) { %server = def }
  if (!$ri(nicks,nicks. $+ %server)) { %server = def }
  return $iif($gettok($ri(nicks,nicks. $+ %server),1,3),$ifmatch,$remove($me,[Away]))
}

; Retorune le nick away tel qu'indiqué dans les options pour ce serveur, ou votre nick avec la mention "Away" si aucun nick n'a été renseigné
awayNick {
  var %server = $network
  if (!%server) { %server = def }
  if (!$ri(nicks,nicks. $+ %server)) { %server = def }
  return $iif($gettok($ri(nicks,nicks. $+ %server),2,3),$ifmatch,$me $+ [Away])
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

;Check if it the given font exists.
; $1: Font name
isFont {
  ; Exclude windows default fonts
  if ($1 isin Arial,Helvetica,Comic Sans MS,Georgia,Courier New,Impact,Lucida Console,Lucida Sans Unicode,Tahoma,Times New Roman,Trebuchet MS,Verdana,MS Sans Serif,MS Serif) { return $true }

  var %x = Test Text
  ; If width and height coincide, then the font doesn't exist (for some reason, an unexisting font will have the same characteristics as Arial font)
  if ($width(%x,$$1,10) == $width(%x,Arial,10)) && ($height(%x,$$1,10) == $height(%x,Arial,10)) { return $false }
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

; Capitalize a sentence (make the first letter capitalized)
capitalize {
  return $upper($left($1-,1)) $+ $right($1-,-1)
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

; Return identd
identd {
  if ($address($me,5)) { return $remove($gettok($gettok($v1,2,33),1,64),~) }
  elseif ($readini($mircini,ident,active)) {
    if ($gettok($readini($mircini,options,n6),33,44)) { return $gettok($emailaddr,1,64) }
    elseif ($readini($mircini,ident,userid)) { return $v1 }
  }
}

; Build a list of tokens separated by a custom delimeter
; $1: delimiter ascii number, $2-: token list
buildtok {
  var %delim = $1
  var %i = 2, %res
  while (%i < $0) {
    var %res = %res $+ $iif($ [ $+ [ %i ] ] != $null,$v1,$chr(32)) $+ $chr(%delim)
    inc %i 
  }
  %res = %res $+ $ [ $+ [ $0 ] ]
  return %res
}

; Remove specific characters from a nick: the brackets, hyphen, underscore, quote, circonflex, backslash, parenthesis and pipes
; $1: nick
nickStrip {
  return $iif($remove($1,[,],-,_,`,^,\,$chr(123),$chr(124),$chr(125)) != $null,$ifmatch,$1)
}


; Open a custom tooltip (needs the tooltip option to be checked)
; $1: name, $2: text
pftip { return $tip($trnum,$$1,$$2,,images/mbico.ico,,,) }


; Return the current channel topic
activeTopic { return $iif($chan($active).topic,$v1,Pas de topic) }

; Return specified clipboard lines, separated by $crlf
; $1: if N, return line N of cb; if N1,N2... returns lines specified; if N-M returns lines from N to M; and if no arg, returns the first line only
cbcontent {
  if ($0 == 1) { 
    if ($1 isnum) { return $cb($1) }
    elseif ($regex($1,([0-9]+)-([0-9]+))) { 
      var %b1 = $regml(1), %b2 = $regml(2)
      if (%b1 >= %b2) { return $cb(%b1) }
      else {
        var %i = %b1, %Res
        while (%i <= %b2) {
          %res = %res $+ $cb(%i) $+ $crlf
          inc %i
        }
        return %res
      }
    }
  }
  elseif ($0 > 1) {
    var %i = 1, %Res
    while (%i <= $0) {
      var %arg = $ [ $+ [ %i ] ]
      if (%arg !isnum) { inc %i | continue } 
      %res = %res $+ $cb(%arg) $+ $crlf
      inc %i
    }
    return %res
  }
  else { return $cb }
}


; Return number of a certain type of users
; $1: op/hop/voice/reg, $prop: percent : returns the percentage
nusers {
  var %nbr = $nick($chan,0)
  if ($prop == percent) { var %pc = 1 }

  if ($1 == op) {     var %nops = $nick($chan,0,o)   }
  elseif ($1 == hop) {     var %nops = $nick($chan,0,h)  }
  elseif ($1 == voice) {     var %nops = $nick($chan,0,v)  }
  elseif ($1 == reg) {    var %nops = $nick($chan,0,r) }
  else { var %nops = $nick($chan,0,a) }
  return $iif(%pc,$calc((%nops / %nbr) * 100) $+ %,%nops)
}

; Return the common channels with an user
; $1: nick to check
comchans {
  var %result, %i = 1
  while ($comchan($1,%i)) {
    %result = $addtok(%result,$ifmatch,59)
    inc %i
  }
  return %result
}

; Return the channels matching a certain criteria from the channels where a user is on
; $1-: channel list; $prop: op/hop/voice/reg
onchans {
  var %result, %i = 1
  var %sign = $iif($prop == op,@,$iif($prop == hop,%,$iif($prop == voice,+,$iif($prop == reg,-))))
  while ($gettok($1-,%i,32)) {
    var %channel = $ifmatch, %prefix = $left(%channel,1)
    if ($me ison %channel) && ($prop == common) { %channel = $basecolor(3) $+ %channel }
    if (%prefix == %sign) { var %result = %result %channel }
    elseif (%sign == -) && (%prefix !isin @%+) { var %result = %result %channel }

    inc %i
  }
  return %result
}

; Return the clones of a given address
; $1: address mask, $2: channel
clones {
  var %address = $1, %chan = $2
  if (%address !iswm *!*) { %address = $mask(*! $+ %address,2) }
  return $iif($ialchan(%address,%chan,0),$v1,0)
}

; Return the clones of a given address
; $1: address mask, $2: channel
clonenames {
  var %address = $1, %chan = $2
  if (%address !iswm *!*) { %address = $mask(*! $+ %address,2) }
  var %i = 1, %result
  while ($ialchan(%address,%chan,%i)) {
    %result = $addtok(%result,$ifmatch,59)
    inc %i
  }
  return %result
}

; $SpecialFolder(String) : Retrieve the path of the windows special folders
; The special folders are: 
; AllUsersDesktop - AllUsersStartMenu - AllUsersPrograms - AllUsersStartup - Desktop - Favorites - Fonts 
; - MyDocuments - NetHood - PrintHood - Programs - Recent - SendTo - StartMenu - Startup - Templates 
; Some of these special folders only work on NT,2000,XP 
specialFolder {
  .comopen spe WScript.Shell
  var %r = $com(spe,SpecialFolders,3,bstr,$1)
  if (%r) { %r = $com(spe).result }
  .comclose spe
  return %r
}

; Convert a word to a regex matching that word in a phrase.
; If property inv, do the opposite (remove the regex build)
; $1: options (-i: caseless, -g: match all, -u: ungreedy), $2-: regex
wordToRegex {
  if (-* iswm $1) { var %opts = $1, %regex = $2- } 
  else { var %regex = $1- }

  if ($prop == inv) { return $unescape($regml($regex(%regex,/\/\\b\((.*)\)\\b\/.*/U))) }
  else { return /\b( $+ $escape(%regex) $+ )\b/ $+ $iif(i isin %opts,i) $+ $iif(g isin %opts,g) $+ $iif(u isin %opts,U) }
}

; Escape regular expressions metacharacters
; Ex: Hi ^^ I'm $me . => Hi \^\^ I'm \$me \.
; $1: regex
escape {
  var %regex = $1-
  return $replacex(%regex,\,\\,.,\.,$lbrack,\ $+ $lbrack,$rbrack,\ $+ $rbrack,^,\^,$dollar,\ $+ $dollar,*,\*,$lacc,\ $+ $lacc,$racc,\ $+ $racc,?,\?,+,\+,$pipe,\ $+ $pipe,$lparen,\ $+ $lparen,$rparen,\ $+ $rparen)
}

; Unescape an escaped expression
unescape {
  var %expr = $1-
  return $replacex(%expr,\\,\,\.,.,\ $+ $lbrack,$lbrack,\ $+ $rbrack,$rbrack,\^,^,\ $+ $dollar,$dollar,\*,*,\ $+ $lacc,$lacc,\ $+ $racc,$racc,\?,?,\+,+,\ $+ $pipe,$pipe,\ $+ $lparen,$lparen,\ $+ $rparen,$rparen)
}

; Remove spaces in a text and replace em by $chr(1)
; These are merely for adding items into hash tables and stuff
unspace {
  return $replace($1-,$chr(32),$chr(1))
}

; Remove $chr(1) characters and replace em by spaces
space {
  return $replace($1-,$chr(1),$chr(32))
}

; Improved $qt function that quotes even words with quotes in it
qt {
  var %smile = $replace($1-,",$ $+ chr(34))
  return $qt(%smile)
}

; Improved $noqt function that unquote even non-terminated quoted text
; ex: $noqt("kikoo lol) -> kikoo lol; $noqt("this is a "wtf quoted text"") -> this is a " wtf quoted text"
noqt {
  if ("*" iswm $1-) { return $mid($1-,1,$calc($len($1-) - 2)) }
  elseif ("* iswm $1-) { return $mid($1-,1) }
  elseif (*" iswm $1-) { return $mid($1-,0,$calc($len($1-) - 1)) }
  else return $1-
}

;; Function: Draws wrapped text and centers it in a specified block
;; Credit goes to http://www.mircscripts.org/comments.php?cid=2424
;; Usage: /drawwrap <drawtext_options> <window> <colour> <bgcolour> <fontname> <fontsize> <x> <y> <w> <h> <text>
drawwrap {  
  ; Use a regex to retrieve params
  noop $regex(params,$1-,/^(-[a-z]+)? ([^ ]+) ([0-9]+) ([0-9]+)? ("[a-zA-Z 0-9_-]+") ([0-9]+) ([0-9]+) ([0-9]+) ([0-9]+) ([0-9]+) (.*)/)

  var %i = 1, %params = $iif(-* iswm $1,switches) window colour $iif(b isin $1,bgcolour) fname fsize x y w h text
  while ($gettok(%params,%i,32)) {
    var %param = $ifmatch, %regml = $regml(params,%i)
    set -u0 % [ $+ [ %param ] ] %regml
    inc %i
  }
  %i = 1
  if (o isin %switches) { 
    var %command = $boldwrap(%text,%fname,%fsize,%w,1,%i) 
    var %wl = $boldwrap(%text,%fname,%fsize,%w,1,0) 
  }
  else { 
    var %command = $wrap(%text,%fname,%fsize,%w,1,%i) 
    var %wl = $wrap(%text,%fname,%fsize,%w,1,0) 
  }
  
  ; loop through the wrapped lines
  while (%command) {
    var %wrappedtext = $ifmatch
    var %text_w = $width(%wrappedtext,$noqt(%fname),%fsize)
    var %text_h = $height(%wrappedtext,$noqt(%fname),%fsize)
    var %text_x = %x
    ; find the offset to adjust for Y space in order to center block of text
    var %center_y = $calc((%h - %wl * %text_h) / 2)
    ; if the offset is > 0 (the block height < specified height) add the centering offset factor
    var %text_y = $calc($iif(%center_y > 0,%center_y) + %text_h * (%i - 1) + %y)
    ; bound the block of text by the specified height
    if ($calc(%text_y + %text_h) > $calc(%h + %y)) break
    ; draw the bloody text
    drawtext $+(-,$remove(%switches,-),c) %window %colour %bgcolour %fname %fsize %text_x %text_y %w %h %wrappedtext
    inc %i
   
    ;Boldwrap or not
    if (o isin %switches) { 
    var %command = $boldwrap(%text,%fname,%fsize,%w,1,%i) 
    var %wl = $boldwrap(%text,%fname,%fsize,%w,1,0) 
  }
  else { 
    var %command = $wrap(%text,%fname,%fsize,%w,1,%i) 
    var %wl = $wrap(%text,%fname,%fsize,%w,1,0) 
  }
  }
}

; Wrap function for bold text
; Arguments: the same as $wrap
boldwrap {
    var %text = $1, %fname = $2, %fsize = $3, %width = $4, %words = $5, %i = $6
    if (!%text) || (!%fname) || (!%fsize) || (!%width) || (%i == $null) { echo -eg Invalid format: $ $+ boldwrap | halt }
    var %textwid = $width($strip(%text),$noqt(%fname),%fsize,1)
    var %diff = $calc(%textwid - %width)
    if (%diff <= 0) { return $iif(%i == 0,1,%text) }

    .hmake wrap 10
    var %l = 1
    if (%words == 1) {
      var %j = 1, %n = $numtok(%text,32)
      var %phrase = $null
      while (%j <= %n) {
        var %phrasex = %phrase $gettok(%text,%j,32)
        if ($width($strip(%phrasex),$noqt(%fname),%fsize,1) > %width) { 
          .hadd wrap %l %phrase
          inc %l
          var %phrasex = $gettok(%text,%j,32)
        }
        %phrase = %phrasex
        inc %j
      }
      .hadd wrap %l %phrase
      var %return = $hget(wrap,%i)
      .hfree wrap
      if (%i == 0) { return %l }
      return %return
    }
    else {
      var %j = 1, %n = $len($strip(%text))
      var %phrase = $null
      while (%j <= %n) {
        var %phrasex = %phrase $+ $mid(%text,%j,1)
        if ($width($strip(%phrasex),$noqt(%fname),%fsize,1) > %width) {
          .hadd wrap %l %phrase
          inc %l
          var %phrase = $mid(%text,%j,1)
        }
        %phrase = %phrasex
        inc %j
      }
      .hadd wrap %l %phrase
      var %return = $hget(wrap,%i)
      .hfree wrap
      if (%i == 0) { return %l }
      return %return
    }
}


; Do a wordwrap according to number of characters
; Ex: $wrapchar(hello my name is,10,1) -> hello my
wordwrap {
  var %text = $1, %length = $2, %i = $3
  .hmake wrap 10
  var %j = 1, %n = $numtok(%text,32), %l = 1
  var %phrase = $null
  while (%j <= %n) {
    var %phrasex = %phrase $gettok(%text,%j,32)
    if ($len($strip(%phrasex)) > %length) { 
      .hadd wrap %l %phrase
      inc %l
      var %phrasex = $gettok(%text,%j,32)
    }
    %phrase = %phrasex
    inc %j
  }
  .hadd wrap %l %phrase
  var %return = $hget(wrap,%i)
  .hfree wrap
  if (%i == 0) { return %l }
  return %return
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


; Effectue une opération de fenetres sur toutes les fenetres ouvertes (minimiser, maximiser...)
; $1: operation (-xh...)
wins {
  var %s = 1
  while ($scon(%s)) {
    scon %s
    if ($left($1,1) == $chr(45)) {
      var %i = 1
      while ($window(*,%i)) {
        var %t = $window(*,%i)
        window $1 $iif($left(%t,1) == $chr(61),%t,$+(",%t,"))
        inc %i
      }
    }
    inc %s
  }
}


; Replace identifiers (only if idents.mrc not loaded)
; $1- : message to replace
replIdents {
  if ($isalias(replaceIdents)) { return $replaceIdents($1-) }
  else { return $replacex($1-,<uptime>,$!uptime(system,2),$!clipboard,<channels>,$!chan(0),<date>,$!asctime(yyyy:mm:dd),<ip>,$!ip,<mircver>,$!version,<time>,$!asctime(hh:nn:ss),<net>,$!network,<idle>,$!idle,<nick>,$!nick)
  }
}

;Kick a list of nicks comma-separated in the specified channel.
;Syntax: kickAll [+nicklist comma-separated] [#channel] [reason]
; The order is important!
; Exs: kickAll -> kick all selected nicks in the current channel with no reason
; kickAll +n1,n2 #channel -> kick nicks n1 & n2 in channel #channel with no reason
; kickAll #channel blabla bla -> kick selected nicks in #channel with reason "blabla bla"
; kickAll reason to kick -> kick all selected nicks in the current channel with reason "reason to kick"
kickAll {
  if ($0 == 0) { var %nicks = $snick(#), %chan = $chan }
  elseif ($1) {
    if ($left($1,1) == $chr(35)) { var %nicks = $snick($1), %chan = $1, %reason = $2- }
    elseif ($left($1,1) == +) { 
      var %nicks = $right($1,-1)
      if ($2) { 
        if ($left($2,1) == $chr(35)) { var %chan = $2, %reason = $3- }
        else { var %chan = $chan, %reason = $2- }
      }
      else { var %chan = $chan }
    }
    else { var %nicks = $snick($chan), %chan = $chan, %reason = $1- }
  }
  var %i = 1
  while ($gettok(%nicks,%i,44)) {
    var %nick = $v1
    kick %chan %nick %reason
    inc %i
  }
}

; Executes a command on a given network already connected
; $1: network name, $2: connection number (if 0, retrieves all connections to the given network)
; $3- Command(s)
netcmd {
  var %x = 1, %net = $1
  var %n = $2, %total = 0

  while ($scon(%x).cid) {
    if ($scid($v1).network == %net) { 
      inc %total
      if (%total == %n) {
        scon %x
        $3- 
        return
      }
    }
    inc %x
  }
  if (%n == 0) { return %total }
  theme.error Server %net not found in the connected servers !
}

; Open the log viewer for the current channel in the current month/date
; $1 : page num in case the logs are trimmed
viewlog {
  var %logc = $gettok($rmi(options,n1),13,44), %logq = $gettok($rmi(options,n1),14,44)
  var %net = $gettok($rmi(options,n6),32,44), %folder = $gettok($rmi(options,n7),21,44)
  var %logtype = $gettok($rmi(options,n3),30,44)
  
  if ($chan($active) && %logc) || ($query($active) && %logq) {
    if (%net) && (%folder) { var %pathFolder = $logdir $+ $network $+ / }
    else { var %pathfolder = $logdir }
    
    var %chan = $active, %date = $asctime(yyyymm), %day = $iif(%logtype == 0,01,$iif(%logtype == 1,$floor($calc($asctime(dd) / 7)),$asctime(dd)))
    var %files = $findfile(%pathfolder,$+(%chan,.,$iif(%net && !%folder,$network $+ .),%date,%day,*),0)
    if (%files) logview $qt($findfile(%pathfolder,$+(%chan,.,$iif(%net && !%folder,$network $+ .),%date,%day,*),$iif($1,$1,1)))
    else echo -a Pas de logs pour cette fenêtre.
  }
}

;ces

;sec Themes
; ----------------------------------------
; 6) Alias for the themes
; ----------------------------------------

;Retrieve a property of the currently loaded theme, or the type of theme if no argument given
; $1: property
theme.current {
  if (!$enabled(themes)) { return Themes features disabled }
  if ($hget(theme.current,$1)) { return $ifmatch }
  else {
    if ($right($hget(theme.current,file),4) == .mts) { return mts }
    elseif ($right($hget(theme.current,file),4) == .nnt) { return nnt }
    else { return def }
  }
}

; Load a theme from the theme folders (with the theme load and add options)
; $1- can be either: 
;   <none>: unload theme
;   A Theme file (with extension): load the specified file (fast)
;   A Theme name: look for each of the themes if the theme names match partially (ex: Pokemon will match Pokemon theme, slow lookup)
loadTheme {
  if (!$enabled(themes)) { $infodialog(La fonctionnalité des themes est désactivée.Réactivez-la d'abord.) | return }
  if ($1 == <none>) { .theme.unload - $+ $ri(themes,addoptions) | return }
  elseif (*.??? iswm $1-) {
    var %type = $iif($right($1-,4) == .mts,m,$iif($right($1-,4) == .nnt,y))
    .theme.load - $+ $ri(themes,loadoptions) $+ $ri(themes,addoptions) $+ %type $1- | return
  }
  else {
    var %i = 1, %themename = $1-
    while ($themesdir(%i)) {
      var %th = $ifmatch, %j = 1
      while ($findfile(%th,*.mts;*.nnt,%j,var %t = $theme.info(name,$1-))) { 
        var %file = $ifmatch, %type = $iif($right(%file,4) == .mts,m,$iif($right(%file,4) == .nnt,y))
        if (* $+ %themename $+ * iswm %t) { .theme.load - $+ $ri(themes,loadoptions) $+ $ri(themes,addoptions) $+ %type %file | return }
        inc %j
      }
      inc %i
    }
  }
  echo -tce info Theme $1- not found
}

; Reload the loaded theme
refreshTheme {
  if (!$enabled(themes)) { $infodialog(La fonctionnalité des themes est désactivée.Réactivez-la d'abord.) | return }
  var %themefile = $theme.current(file)
  loadTheme %themefile
}

; Change the theme scheme of the currently loaded theme. $1 Can be either: 
;   The scheme index number (fast)
;   The scheme name (slow lookup)
; $1: Scheme number, no parameter for default scheme
loadScheme {
  if (!$enabled(themes)) { $infodialog(La fonctionnalité des themes est désactivée.Réactivez-la d'abord.) | return }
  if ($1 isnum) { .theme.scheme $1- }
  elseif (!$1) { .theme.scheme 0 }
  else {
    var %schn = $hget(theme.current,schemenames)
    var %i = $findtok(%schn,$1-,1,59) | if (%i) { .theme.scheme %i }
  }
}

; Create an alignment by inserting control characters. If the value is negative, insert the characters before.
;$1: message, $2: number of characters to insert
align {
  if ($2 >= 0) { return $strip($1,b) $+ $str( ,$calc($2 - $len($strip($1)))) }
  else { return $str( ,$calc($abs($2) - $len($strip($1)))) $+ $strip($1,b) }
}

; Return parenthesed text
;$1-: text
ptext {
  if (!$enabled(themes)) { return ( $+ $1- $+ ) }
  if ($1) {
    set -nu %::text $1-
    if ($left(%::text,1) == $lparen) && ($right(%::text,1) == $rparen) { %::text = $mid(%::text,1,$calc($len(%::text) - 2)) }
    if ($hget(theme.current,parentext)) { 
      set -nu %:text $theme.parse($iif($theme.current == mts,m,$iif($theme.current == nnt,y,x)),$hget(theme.current,parentext)) 
      set -nu %:text $replace(%:text,% $+ ::text,%::text)
      if ($gettok(%:text,1,32) == !script) {
        if (!$gettok(%:text,2,32)) { return ( $+ %::text $+ ) }
        else { return $eval($gettok(%:text,2-,32),2) }
      }
      else { return %:text %:comments }
    }
    else { return ( $+ %::text $+ ) }
  }
}

; Si pas d'arguments, retourne le nombre de répertoires de themes
; Sinon, retourne le répertoire de theme numéro $1
themesdir {
  var %t = $ri(themes,folders)
  if (!$1) { return $numtok(%t,59) }
  elseif ($1 isnum) { return $gettok(%t,$1,59) }
}

;Retourne la décoration du prefixe
pre {
  if (!$enabled(themes)) { return }
  var %pre = $theme.parse($iif($theme.current == mts,m,$iif($theme.current == nnt,y,x)),$hget(theme.current,prefix))
  return %pre
}

;Return mode (@, %...)
;$1: nick, $2: chan
cmode { return $left($remove($nick($2,$1).pnick,$1),1) }


;Substitution for the echo commands in scripts
theme.echo {
  if (!$enabled(themes)) { !echo $1- }
  if (!$theme.current) { !echo $1- }
  else {
    var %i = $iif($hgt(indent),i $+ $ifmatch)
    if ($1 isnum 0-15) { var %color = $1 | tokenize 32 $2- }
    if ($left($1,1) == -) {
      var %opts = $remove($1,i,t,c)
      if ($window($2)) { theme.vars echo %color %opts $+ %i $2 | set -u %::text $3- | set -u %::target $2 }
      else { theme.vars echo %color %opts $+ %i | set -u %::text $2- }
    }
    else {
      if ($window($1)) { theme.vars echo %color $iif(%i,- $+ %i) $1 | set -u %::text $2- | set -u %::target $1 }
      else { theme.vars echo %color -a $+ %i | set -u %::text $1- }
    }
    if (%::text == $null) { halt }
    theme.text echo $+ $iif($numtok(%:echo,32) == 4,target)
  }
}

;Echo an error in a theme script
theme.error {
  if (!$enabled(themes)) { !echo $1- }
  if ($1- == $null) { halt }
  if ($window($1)) && ($2- == $null) { halt }
  if (!$theme.current) { !echo $1- }
  else {
    var %i = $iif($hgt(indent),i $+ $ifmatch)
    if ($1 isnum 0-15) { var %color = $1 | tokenize 32 $2- }
    if ($left($1,1) == -) {
      var %opts = $remove($1,i,t,c)
      if ($window($2)) { theme.vars echo %color %opts $+ %i $2 | set -u %::text $3- }
      else { theme.vars echo %color %opts $+ %i | set -u %::text $2- }
    }
    else {
      if ($window($1)) { theme.vars echo %color $iif(%i,- $+ %i) $1 | set -u %::text $2- }
      else { theme.vars echo %color -a $+ %i | set -u %::text $1- }
    }
    if (%::text == $null) { halt }
    theme.text error
  }
}

; Echo the away message (optional by scripts)
theme.away {
  if (!$enabled(themes)) { !echo $1- }
  if ($1- == $null) { halt }
  if ($window($1)) && ($2- == $null) { halt }
  if (!$theme.current) { !echo $1- }
  else {
    var %i = $iif($hgt(indent),i $+ $ifmatch)
    if ($left($1,1) == -) {
      if ($window($2)) { theme.vars echo $color(info2) $1 $+ %i $2 | set -u %::text $3- }
      else { theme.vars echo $color(info) $1 $+ %i | set -u %::text $2- }
    }
    else {
      if ($window($1)) { theme.vars echo $color(info2) $iif(%i,- $+ %i) $1 | set -u %::text $2- }
      else { theme.vars echo $color(info) -a $+ %i | set -u %::text $1- }
    }
    if (%::text == $null) { halt }
    theme.text $iif($hgt(away),away,echo)
  }
}

; Send a notice in the given theme format
; $1 : nick, $2: text
theme.notice {
  if (!$enabled(themes)) { !notice $1- | return }
  if (!$theme.current) || (!$server) { !notice $1- }
  elseif ($2 != $null) {
    if ($show) {
      if ($hgt($iif($left($1,1) == $chr(35),noticechanself,noticeself))) {
        theme.vars echo $color(notice) -ta $+ $iif($hgt(indent),i $+ $ifmatch,i12)
        set -nu %::nick $1
        set -nu %::target $1
        set -nu %::chan $1
        set -nu %::address $address($me,5)
        if ($1 ischan) { set -u %::cmode $cmode($me,$1) }
        set -u %::cnick $cnick($1).color
        set -nu %::me $me
        set -nu %::text $2-
        var %m = !.notice
        set -u %:raw $1-
        theme.text $iif($left($1,1) == $chr(35),noticechanself,noticeself) NOTICE
      }
      else { var %m = !notice }
      theme.sound $iif($left($1,1) == $chr(35),noticechanself,noticeself) NOTICE
    }
    else { var %m = !.notice }
    %m $1-
  }
}

; Return a basecolor (Ctrl + K) + the color
basecolor {
  if (!$enabled(themes)) { return  $+ $color(normal) $+  }
  if ($1 isnum) && ($hget(theme.current,basecolors)) { 
    return  $+ $gettok($hget(theme.current,basecolors),$1,44) $+ 
  }
  elseif ($1 isnum) { 
    var %k =  
    if ($1 == 1) { %k = %k $+ $color(normal) }
    elseif ($1 == 2) { %k = %k $+ $color(nick) }
    elseif ($1 == 3) { %k = %k $+ $color(notice) }
    elseif ($1 == 4) { %k = %k $+ $color(quit) }
    else { %k = %k $+ $color(info) }
    return %k $+ 
  }
  else return  $+ $color(normal) $+ 
}

; Retrieve color name from the given index
; ex: colorName(0) = background, colorName(1) = action etc...
colorName {
  if ($1 == 1) { return background }
  elseif ($1 == 2) { return action }
  elseif ($1 == 3) { return ctcp }
  elseif ($1 == 4) { return highlight }
  elseif ($1 == 5) { return info }
  elseif ($1 == 6) { return info2 }
  elseif ($1 == 7) { return invite }
  elseif ($1 == 8) { return join }
  elseif ($1 == 9) { return kick }
  elseif ($1 == 10) { return mode }
  elseif ($1 == 11) { return nick }
  elseif ($1 == 12) { return normal }
  elseif ($1 == 13) { return notice }
  elseif ($1 == 14) { return notify }
  elseif ($1 == 15) { return other }
  elseif ($1 == 16) { return own }
  elseif ($1 == 17) { return part }
  elseif ($1 == 18) { return quit }
  elseif ($1 == 19) { return topic }
  elseif ($1 == 20) { return wallops }
  elseif ($1 == 21) { return whois }
  elseif ($1 == 22) { return editbox }
  elseif ($1 == 23) { return editbox text }
  elseif ($1 == 24) { return listbox }
  elseif ($1 == 25) { return listbox text }
  elseif ($1 == 26) { return gray }
  elseif ($1 == 27) { return title }
  elseif ($1 == 28) { return inactive }
  elseif ($1 == 29) { return treebar }
  elseif ($1 == 30) { return treebar text }
}

; Opposite action : return color index from name (without the "text", e.g "action" and not "action text")
; $1-: name
colorIndex {
  if ($1- == background) { return 1 }
  elseif ($1- == action) { return 2 }
  elseif ($1- == ctcp) { return 3 }
  elseif ($1- == highlight) { return 4 }
  elseif ($1- == info) { return 5 }
  elseif ($1- == info2) { return 6 }
  elseif ($1- == invite) { return 7 }
  elseif ($1- == join) { return 8 }
  elseif ($1- == kick) { return 9 }
  elseif ($1- == mode) { return 10 }
  elseif ($1- == nick) { return 11 }
  elseif ($1- == normal) { return 12 }
  elseif ($1- == notice) { return 13 }
  elseif ($1- == notify) { return 14 }
  elseif ($1- == other) { return 15 }
  elseif ($1- == own) { return 16 }
  elseif ($1- == part) { return 17 }
  elseif ($1- == quit) { return 18 }
  elseif ($1- == topic) { return 19 }
  elseif ($1- == wallops) { return 20 }
  elseif ($1- == whois) { return 21 }
  elseif ($1- == editbox) { return 22 }
  elseif ($1- == editbox text) { return 23 }
  elseif ($1- == listbox) { return 24 }
  elseif ($1- == listbox text) { return 25 }
  elseif ($1- == gray) { return 26 }
  elseif ($1- == title) { return 27 }
  elseif ($1- == inactive) { return 28 }
  elseif ($1- == treebar) { return 29 }
  elseif ($1- == treebox text) { return 30 }
}

; Get the rgb values of a color
; $1 maybe color name, $rgb value of a color
; or if three arguments, rgb values
webcolor {
  if ($remove($1,$chr(44)) isalpha) {
    if ($1 == Aliceblue) { return $rgb(240,248,255) }
    elseif ($1 == Antiquewhite) { return $rgb(250,235,215)  }
    elseif ($1 == Aqua) { return $rgb(0,255,255)  }
    elseif ($1 == Aquamarine) { return $rgb(127,255,212)  }
    elseif ($1 == Azure) { return $rgb(240,255,255)  }
    elseif ($1 == Beige) { return $rgb(245,245,220)  }
    elseif ($1 == Bisque) { return $rgb(255,228,196)  }
    elseif ($1 == Black) { return $rgb(0,0,0)  }
    elseif ($1 == Blanchedalmond) { return $rgb(255,235,205)  }
    elseif ($1 == Blue) { return $rgb(0,0,255)  }
    elseif ($1 == Blueviolet) { return $rgb(138,43,226)  }
    elseif ($1 == Brown) { return $rgb(165,42,42)  }
    elseif ($1 == Burlywood) { return $rgb(222,184,135)  }
    elseif ($1 == Cadetblue) { return $rgb(95,158,160)  }
    elseif ($1 == Chartreuse) { return $rgb(127,255,0)  }
    elseif ($1 == Chocolate) { return $rgb(210,105,30)  }
    elseif ($1 == Coral) { return $rgb(255,127,80)  }
    elseif ($1 == Cornflowerblue) { return $rgb(100,149,237)  }
    elseif ($1 == Cornsilk) { return $rgb(255,248,220)  }
    elseif ($1 == Crimson) { return $rgb(220,20,60)  }
    elseif ($1 == Cyan) { return $rgb(0,255,255)  }
    elseif ($1 == Darkblue) { return $rgb(0,0,139)  }
    elseif ($1 == Darkcyan) { return $rgb(0,139,139)  }
    elseif ($1 == Darkgoldenrod) { return $rgb(184,134,11)  }
    elseif ($1 == Darkgray) { return $rgb(169,169,169)  }
    elseif ($1 == Darkgreen) { return $rgb(0,100,0)  }
    elseif ($1 == Darkkhaki) { return $rgb(189,183,107)  }
    elseif ($1 == Darkmagenta) { return $rgb(139,0,139)  }
    elseif ($1 == Darkolivegreen) { return $rgb(85,107,47)  }
    elseif ($1 == Darkorange) { return $rgb(255,140,0)  }
    elseif ($1 == Darkorchid) { return $rgb(153,50,204)  }
    elseif ($1 == Darkred) { return $rgb(139,0,0)  }
    elseif ($1 == Darksalmon) { return $rgb(233,150,122)  }
    elseif ($1 == Darkseagreen) { return $rgb(143,188,143)  }
    elseif ($1 == Darkslateblue) { return $rgb(72,61,139)  }
    elseif ($1 == Darkslategray) { return $rgb(47,79,79)  }
    elseif ($1 == Darkturquoise) { return $rgb(0,206,209)  }
    elseif ($1 == Darkviolet) { return $rgb(148,0,211)  }
    elseif ($1 == Deeppink) { return $rgb(255,20,147)  }
    elseif ($1 == Deepskyblue) { return $rgb(0,191,255)  }
    elseif ($1 == Dimgray) { return $rgb(105,105,105)  }
    elseif ($1 == Dodgerblue) { return $rgb(30,144,255)  }
    elseif ($1 == Firebrick) { return $rgb(178,34,34)  }
    elseif ($1 == Floralwhite) { return $rgb(255,250,240)  }
    elseif ($1 == Forestgreen) { return $rgb(34,139,34)  }
    elseif ($1 == Fuchsia) { return $rgb(255,0,255)  }
    elseif ($1 == Gainsboro) { return $rgb(220,220,220)  }
    elseif ($1 == Ghostwhite) { return $rgb(248,248,255)  }
    elseif ($1 == Gold) { return $rgb(255,215,0)  }
    elseif ($1 == Goldenrod) { return $rgb(218,165,32)  }
    elseif ($1 == Gray) { return $rgb(128,128,128)  }
    elseif ($1 == Green) { return $rgb(0,128,0)  }
    elseif ($1 == Greenyellow) { return $rgb(173,255,47)  }
    elseif ($1 == Honeydew) { return $rgb(240,255,240)  }
    elseif ($1 == Hotpink) { return $rgb(255,105,180)  }
    elseif ($1 == Indianred) { return $rgb(205,92,92)  }
    elseif ($1 == Indigo) { return $rgb(75,0,130)  }
    elseif ($1 == Ivory) { return $rgb(255,255,240)  }
    elseif ($1 == Khaki) { return $rgb(240,230,140)  }
    elseif ($1 == Lavender) { return $rgb(230,230,250)  }
    elseif ($1 == Lavenderblush) { return $rgb(255,240,245)  }
    elseif ($1 == Lawngreen) { return $rgb(124,252,0)  }
    elseif ($1 == Lemonchiffon) { return $rgb(255,250,205)  }
    elseif ($1 == Lightblue) { return $rgb(173,216,230)  }
    elseif ($1 == Lightcoral) { return $rgb(240,128,128)  }
    elseif ($1 == Lightcyan) { return $rgb(224,255,255)  }
    elseif ($1 == Lightgoldenrodyellow) { return $rgb(250,250,210)  }
    elseif ($1 == Lightgreen) { return $rgb(144,238,144)  }
    elseif ($1 == Lightgrey) { return $rgb(211,211,211)  }
    elseif ($1 == Lightpink) { return $rgb(255,182,193)  }
    elseif ($1 == Lightsalmon) { return $rgb(255,160,122)  }
    elseif ($1 == Lightseagreen) { return $rgb(32,178,170)  }
    elseif ($1 == Lightskyblue) { return $rgb(135,206,250)  }
    elseif ($1 == Lightslategray) { return $rgb(119,136,153)  }
    elseif ($1 == Lightsteelblue) { return $rgb(176,196,222)  }
    elseif ($1 == Lightyellow) { return $rgb(255,255,224)  }
    elseif ($1 == Lime) { return $rgb(0,255,0)  }
    elseif ($1 == Limegreen) { return $rgb(50,205,50)  }
    elseif ($1 == Linen) { return $rgb(250,240,230)  }
    elseif ($1 == Magenta) { return $rgb(255,0,255)  }
    elseif ($1 == Maroon) { return $rgb(128,0,0)  }
    elseif ($1 == Mediumauqamarine) { return $rgb(102,205,170)  }
    elseif ($1 == Mediumblue) { return $rgb(0,0,205)  }
    elseif ($1 == Mediumorchid) { return $rgb(186,85,211)  }
    elseif ($1 == Mediumpurple) { return $rgb(147,112,216)  }
    elseif ($1 == Mediumseagreen) { return $rgb(60,179,113)  }
    elseif ($1 == Mediumslateblue) { return $rgb(123,104,238)  }
    elseif ($1 == Mediumspringgreen) { return $rgb(0,250,154)  }
    elseif ($1 == Mediumturquoise) { return $rgb(72,209,204)  }
    elseif ($1 == Mediumvioletred) { return $rgb(199,21,133)  }
    elseif ($1 == Midnightblue) { return $rgb(25,25,112)  }
    elseif ($1 == Mintcream) { return $rgb(245,255,250)  }
    elseif ($1 == Mistyrose) { return $rgb(255,228,225)  }
    elseif ($1 == Moccasin) { return $rgb(255,228,181)  }
    elseif ($1 == Navajowhite) { return $rgb(255,222,173)  }
    elseif ($1 == Navy) { return $rgb(0,0,128)  }
    elseif ($1 == Oldlace) { return $rgb(253,245,230)  }
    elseif ($1 == Olive) { return $rgb(128,128,0)  }
    elseif ($1 == Olivedrab) { return $rgb(104,142,35)  }
    elseif ($1 == Orange) { return $rgb(255,165,0)  }
    elseif ($1 == Orangered) { return $rgb(255,69,0)  }
    elseif ($1 == Orchid) { return $rgb(218,112,214)  }
    elseif ($1 == Palegoldenrod) { return $rgb(238,232,170)  }
    elseif ($1 == Palegreen) { return $rgb(152,251,152)  }
    elseif ($1 == Paleturquoise) { return $rgb(175,238,238)  }
    elseif ($1 == Palevioletred) { return $rgb(216,112,147)  }
    elseif ($1 == Papayawhip) { return $rgb(255,239,213)  }
    elseif ($1 == Peachpuff) { return $rgb(255,218,185)  }
    elseif ($1 == Peru) { return $rgb(205,133,63)  }
    elseif ($1 == Pink) { return $rgb(255,192,203)  }
    elseif ($1 == Plum) { return $rgb(221,160,221)  }
    elseif ($1 == Powderblue) { return $rgb(176,224,230)  }
    elseif ($1 == Purple) { return $rgb(128,0,128)  }
    elseif ($1 == Red) { return $rgb(255,0,0)  }
    elseif ($1 == Rosybrown) { return $rgb(188,143,143)  }
    elseif ($1 == Royalblue) { return $rgb(65,105,225)  }
    elseif ($1 == Saddlebrown) { return $rgb(139,69,19)  }
    elseif ($1 == Salmon) { return $rgb(250,128,114)  }
    elseif ($1 == Sandybrown) { return $rgb(244,164,96)  }
    elseif ($1 == Seagreen) { return $rgb(46,139,87)  }
    elseif ($1 == Seashell) { return $rgb(255,245,238)  }
    elseif ($1 == Sienna) { return $rgb(160,82,45)  }
    elseif ($1 == Silver) { return $rgb(192,192,192)  }
    elseif ($1 == Skyblue) { return $rgb(135,206,235)  }
    elseif ($1 == Slateblue) { return $rgb(106,90,205)  }
    elseif ($1 == Slategray) { return $rgb(112,128,144)  }
    elseif ($1 == Snow) { return $rgb(255,250,250)  }
    elseif ($1 == Springgreen) { return $rgb(0,255,127)  }
    elseif ($1 == Steelblue) { return $rgb(70,130,180)  }
    elseif ($1 == Tan) { return $rgb(210,180,140)  }
    elseif ($1 == Teal) { return $rgb(0,128,128)  }
    elseif ($1 == Thistle) { return $rgb(216,191,216)  }
    elseif ($1 == Tomato) { return $rgb(255,99,71)  }
    elseif ($1 == Turquoise) { return $rgb(64,224,208)  }
    elseif ($1 == Violet) { return $rgb(238,130,238)  }
    elseif ($1 == Wheat) { return $rgb(245,222,179)  }
    elseif ($1 == White) { return $rgb(255,255,255)  }
    elseif ($1 == Whitesmoke) { return $rgb(245,245,245)  }
    elseif ($1 == Yellow) { return $rgb(255,255,0)  }
    elseif ($1 == YellowGreen) { return $rgb(154,205,50)  }
  }
  elseif ($remove($1,$chr(44)) == $1) { return $1 } 
  elseif ($remove($1,$chr(44)) isnum) { return $rgb($1-) }
  else { return $rgb(0,0,0)  }
}
;ces


;sec stats
;------------------------------------------
; 7) Statistics
;------------------------------------------

; Retrieve a statistic
; If $1 == -c, $2 = stat section name (chan/query), $3 stat name
; Otherwise, $1 is the stat name in the global section
getStat {
  var %f = $hget(stats)

  if (!%f) { hmake stats 100 }
  if ($1 == -c) { return $iif($hget(stats,$$2 $+ . $+ $$3),$ifmatch,0) }
  return $iif($hget(stats,globals. $+ $$1),$ifmatch,0)
}

; Retrieve a statistic for a specified channel/query
getCStat { return $getStat(-c,$1,$2) }

; Add a new stat section
; $1: section
addSection { hadd stats sections $addtok($hget(stats,sections),$$1,59) }

; Write a statistic value
; If $1 == -c, $2 = stat section name (chan/query), $3 stat name and $4-: value
; Otherwise, $1 is the stat name in the global section and $2- the value
writeStat {
  var %f = $hget(stats)

  if (!%f) { hmake stats 100 }
  if ($1 == -c) { 
    if (!$istok($hget(stats,sections),$$2,59)) { addSection $$2 }
    hadd stats $$2 $+ . $+ $$3 $$4- 
  }
  else { hadd stats globals. $+ $$1 $$2- }
}

;Increment a statistic
; If $1 == -c, $2 = stat section name (chan/query), $3 stat name and $4 (optional): inc value
; Otherwise, $1 is the stat name in the global section and $2 the inc value
incStat {
  var %f = $hget(stats)

  if (!%f) { hmake stats 100 }
  if ($1 == -c) { 
    if (!$istok($hget(stats,sections),$$2,59)) { addSection $$2 }
    hinc stats $$2 $+ . $+ $$3 $4 
  }
  else { hinc stats globals. $+ $$1 $2 } 
}

; Retrieve the average of a stat per day
; $1: stat name
avgPerDay {
  var %mircdate = $file(mirc.exe).ctime
  var %duration = $round($calc($calc($ctime - %mircdate) / 86400),0)
  echo a %duration
  var %stat = $getStat($1)
  if (%stat) { return $round($calc(%stat / %duration),2) }
}
;ces


;sec mdxdcx
;--------------------------------------
; 8) MDX/DCX
;--------------------------------------
;-------------------------------------------------
; Functions for the dcx.dll usages
; Given by http://dcx.scriptsdb.org/index.htm
; DO NOT UNLOAD!!!
; ------------------------------------------------

; Calls mdx dll
; $1: function, $2- parameters
mdx {
  var %m = $dll(script/dlls/mdx.dll,$1,$2-)
  if (ERROR * iswmcs %m) { echo -a MDX warning $gettok(%m,3-,32) }
}

; Call a mdx plugin
; $1: plugin name
mdxfile {
  return $+(script/dlls/,$1,.mdx)
}

; Mark the current dialog with mdx
mdxload {
  mdx SetMircVersion $version
  mdx MarkDialog $dname $dialog($dname).hwnd
}

; didtok mdx version
; $1: dname, $2: did, $3: token delimiter, $4: column delimiter; $5-: tokens
mdidtok {
  var %dname $1, %did $2, %delimtok $3, %delimcol $4, %tokens $5-
  did -hr %dname %did
  
  var %n = 1
  while ($gettok(%tokens,%n,%delimtok)) {
    var %tok = $ifmatch
    %tok = $replace(%tok,%delimcol,$chr(9) $+ 0 0 0 $+ $chr(32))
    did -a %dname %did 1 + 0 0 0 %tok
  
    inc %n
  }
  did -v %dname %did
  
}

; Shortcut to designate the script dir (unlike $scriptdir)
scdir { return $mircdir $+ script/ }

; Call the dcx dll
; $1: function, $2- parameters
dcx {
  if ($isid) returnex $dll($scdir $+ /dlls/dcx.dll,$1,$2-)
  else dll " $+ $scdir $+ /dlls/dcx.dll" $1 $2-
}

; Unload dcx dll
udcx {
  if ($dcx(IsUnloadSafe)) $iif($menu, .timer 1 0) dll -u dcx.dll
  else echo 4 -qmlbfti2 [DCX] Unable to Unload Dll.
}

; DCX Xdid command (cf dcxdoc)
xdid {
  if ( $isid ) returnex $dcx( _xdid, $1 $2 $prop $3- )
  dcx xdid $2 $3 $1 $4-
}

; DCX Xdialog command (cf dcxdoc)
xdialog {
  if ( $isid ) returnex $dcx( _xdialog, $1 $prop $2- )
  dcx xdialog $2 $1 $3-
}

; DCX xpop command (cf dcxdoc)
xpop {
  if ( $isid ) returnex $dcx( _xpop, $1 $prop $2- )
  dcx xpop $2 $1 $3-
}

; DCX xpopup command (cf dcxdoc)
xpopup {
  if ( $isid ) returnex $dcx( _xpopup, $1 $prop $2- )
  dcx xpopup $2 $1 $3-
}

; DCX Xmenubar command (cf dcxdoc)
xmenubar {
  if ($isid) returnex $dcx(_xmenubar, $prop $1-)
  dcx xmenubar $1-
}

; DCX mpopup command (cf dcxdoc)
mpopup {
  dcx mpopup $1 $2
}

; DCX xdock command (cf dcxdoc)
xdock {
  if ($isid) returnex $dcx( _xdock, $1 $prop $2- )
  dcx xdock $1-
}

; DCX xtray command (cf dcxdoc)
xtray {
  if ($isid) returnex $dcx(TrayIcon, $1 $prop $2-)
  dcx TrayIcon $1-
}

; DCX xstatusbar command (cf dcxdoc)
xstatusbar {
  !if ($isid) returnex $dcx( _xstatusbar, mIRC $prop $1- )
  dcx xstatusbar $1-
}

; DCX xtreebar command (cf dcxdoc)
xtreebar {
  !if ($isid) returnex $dcx( _xtreebar, mIRC $prop $1- )
  dcx xtreebar $1-
}

; DCX dcxml command (cf dcxdoc)
dcxml {
  !if ($isid) returnex $dcx( _dcxml, $prop $1- )
  dcx dcxml $1-
}

;xdidtok dialog ID N C Item Text[[C]Item Text[C]Item Text]...
;xdidtok $dname 1 0 44 SomeText1,SomeText2
; xdidtok is only meant for list control!
xdidtok {
  if ($0 < 5) { echo 4 -smlbfti2 [ERROR] /xdidtok Invalid args | halt }
  xdid -A $1 $2 $3 +T $4 $5-
}

; Shortcut to write a tab separated line (often used in mdx and dcx commands)
; Syntax: $tab(param1,param2,...)
tab {
  var %i = 1, %tab
  while (%i <= $0) {
    if ($eval($+($,%i),2) != $null) {
      %tab = $instok(%tab,$eval($+($,%i),2),$calc($numtok(%tab,9) + 1),9)
    }
    inc %i
  }
  return %tab
}

; Add a new item to a treeview (without icon)
; $1: treeview id; $2: path (_ separated), $3: flags; $4-: text,tooltip text (tab separated)
treeview.additem {
  xdid -a $dname $$1 $replace($$2,_,$chr(32)) $chr(9) $$3 0 0 0 0 0 0 0 $$4-
}

; Add a new divider and sets two panels (if no width/height supplied, divide in equal sizes). Note: the panels created will have id $divider_id + 1 and + 2 respectively.
; $1: divider id; $2: vertical/horizontal; $3 (optional) : left/top panel width/height, $4 (optional): min left width/height, $5 (optional): min right width/height
divider {
  xdialog -c $dname $$1 divider 0 0 $dialog($dname).w $dialog($dname).h $iif($2 == vertical,$ifmatch)
  if ($3) { xdid -v $dname $$1 $3 }
  xdid -l $dname $$1 $iif($4,$4,10) 0 $chr(9) $calc($$1 + 1) panel 0 0 $dialog($dname).w $dialog($dname).h
  xdid -r $dname $$1 $iif($5,$5,10) 0 $chr(9) $calc($$1 + 2) panel 0 0 $dialog($dname).w $dialog($dname).h
}

; Add a new button with supplied text. If $1 == 0, add it to the dialog, otherwise add it to the container whose id is $1
; $1:container id, $2: button id, $3: text, $4: coords, $5 (optional): options
button {
  tokenize 44 $1-
  if ($1 == 0) { xdialog -c $dname $$2 button $$4 $5 }
  else { xdid -c $dname $1 $$2 button $$4 $5 }
  xdid -t $dname $$2 $$3 
}


; Create a preview window to be show inside a dialog box
; $1 : dialog name of the host dialog, $2 : button id of the host button
prevwindow {
  mdx SetControlMDX $1-2 Window > $mdxfile(dialog)
  var %win = @prev. $+ $1 $+ . $+ $2
  window -phf %win -1 -1 -1 -1
  did -a $1 $2 grab $window(%win).hwnd %win
}

; Show a preview of a text
; $1 : dialog host, $2: button id host, $3: fontsize, $4: color/message type, $5: bold or not, $6-: text
prevbmp {
  var %win = @prev. $+ $1 $+ . $+ $2
  if (!$window(%win)) { prevwindow $1 $2 }

  drawrect -nf %win $color(back) 1 0 0 $window(%win).w $window(%win).h
  if ($0 >= 6) {
    drawwrap -npb $+ $iif($5 == 1,o) %win $iif($4 isnum,$4,$color($4)) $color(back) $qt($window(Status Window).font) $3 2 1 $window(%win).w $window(%win).h $6-
  }
  drawdot %win
}


; Get the col value of a line from a mdx listview
; $1: dialog name, $2: id of the listview, $3: line number, $4: col number
getColValue {
  if (!$dialog($$1)) { return $null }
  else {
    var %line = $did($1,$2,$3).text
    var %cell = $gettok($gettok(%line,$4,9),$iif($4 == 1, 6-, 5-),32)
    return %cell
  }
}

; Create a new popup using dcx
; $1 (optional): popup name
newpopup {
  var %popup $iif($1,$1,xpopup. $+ $trnum)
  xpopup -c %popup office2003
  popupcolor %popup
}

; Sets the color of the xpopup depending on the windows colors
; $1: popup name
popupcolor { xpopup -p $1 $rgb(hilight) $rgb(face) $rgb(3dlight) $rgb(shadow) $rgb(shadow) $rgb(shadow) $rgb(230,247,253) $rgb(shadow) $rgb(shadow) $rgb(text) }

; Add a menu item to a xpopup
; $1: popup name, $2- : parameters ([PATH] $chr(9) [FLAGS] [ID] [ICON] [TEXT])
newmenu { xpop -a $1 $2- }

; Display a xpopup (usually when right clicking)
; $1: popup name
displaypopup { xpopup -s $1 +lt $mouse.dx $mouse.dy | xpopup -d $1 }

; Enforce the use of positive number in editboxes
; $1: dname, $2: did
colorBadNumber {
  if ($did($1,$2) !isnum) || ($did($1,$2) <= 0) { 
    mdx SetColor $1 $2 textbg 255
    return $false
  }
  else {
    mdx SetColor $1 $2 textbg $rgb(255,255,255)
    return $true
  }
}

; Change the page for mdx listviews to the event page.
; $1: dialog name, $2: list id
mdxPageEvent { did -i $1 $2 1 page event }

; Fetch the last checkbox checked/unchecked of a mdx list
; $1: dialog name, $2: list id
lastCheck { mdxPageEvent $$1 $$2 | return $gettok($did($$1,$$2,1),3,32) }

; Saves the content of an multi-editbox in one value
; $1: dialog name, $2: id of the box
getEditboxValue {
  var %i = 1, %lines = $did($$1,$$2).lines
  var %res
  while (%i <= %lines) {
    %res = %res $did($1,$2,%i)
    inc %i
  }
  return %res
}

; Show an image only if the image exists
; $1: dname, $2: did, $3: image path quoted, $4 (optional): icon number
showImage {
  if ($isfile($3)) && ($isimage($3)) { did -g $1 $2 $4 $3 | did -v $1 $2 }
  else { did -h $1 $2 }
}

; Write a text in the splash window (if still opened)
; $1: splash window text id, $2-: text
splash_text { 
  if ($ri(misc,splash) == 1) && ($dialog(splash)) { 
    .timersplash $+ $trnum -m 100 1 xdid -t splash $1 $2- 
  } 
}

;ces

;----------------------------------------
; 9) Socket identifiers
;----------------------------------------

;sec Socket

; Open a socket and if its already open, close it and reopen it
; $1: either the socket name or the options [-de], $2: socket name if $1: [-de]
sockreopen {
  sockclose $iif(-* iswm $1,$2,$1)
  sockopen $1-
}

;ces

;-----------------------------------------
; 10) IRC Command redefinitions
;-----------------------------------------

;sec Redefinitions

; Redefinition of join: join with channel key completion
join {
  if ($enabled(misc)) { keyjoin $1- }
  else { !join $1- }
}

;Redefinition of notice: notice in specific window
notice {
  if ($enabled(misc)) { newnotice $1- }
  elseif ($enabled(themes)) { theme.notice $1- }
  else { !notice $1- }
}

; Redefinition of ban: ban with the given mask
ban {
  if ($enabled(misc)) { maskban $1- }
  else { !ban $1- }
}

; Redefinition of ignore: ignore with the given mask
ignore {
  if ($enabled(misc)) { maskignore $1- }
  else { !ignore $1- }
}

; Redefinition of fopen: fclose if already opened
fopen {
  if ($fopen($$1)) { .fclose $$1 }
  !fopen $$1 $2-
}

; Redefinition of the server command: connection with favorite server's parameters
server {
  if ($enabled(servers)) { favserver $1- }
  else { !server $1- }
}
;ces



; ––––––––––––––––––––––––––––––––––––––––
; End of file
; ––––––––––––––––––––––––––––––––––––––––
