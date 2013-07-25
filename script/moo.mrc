;.oO{ moo script v3.17 by HM2K }Oo. - IRC@HM2K.ORG

;description:
;no more moo.dll! -- this script uses $com to lookup the WMI functions to return specified system information.
;moo script was originally created to display your system information via IRC, including: operating system, uptime, cpu, memory usage, graphics card, resolution, network details and hard drive details.

;installation:
;NOTICE: please unload and remove any old moo scripts, else this script may not work.
;make sure moo.mrc is in your $mircdir then type: /load -rs moo.mrc

;Please make sure you have the latest windows updates or the latest WMI core (http://www.microsoft.com/downloads/details.aspx?FamilyID=98a4c5ba-337b-4e92-8c18-a63847760ea5&DisplayLang=en)
;Also, please use the latest version of mIRC, ideally mIRC v6.16 and above...

;usage:
;for moo type: /moo or !moo (if enabled)
;for uptime only type: /up or !uptime (if enabled)

;history:
;moo script v3.17	- added moo cpu architecture descriptors on request of ROBERT PICARD
;moo script v3.16	- Added /stat and /statself (thanks TBF), and fixed local echoing.
;moo script v3.15	- Fixed a few bugs + Fixed the repeat checker + Out of beta
;moo script v3.14	- Change the WMI lookup location of the rammax inline with the ramuse.
;moo script v3.13	- Changed the ram function to use a more reliable WMI location, added OSArchitecture (osarc) for Vista, fixed CPU load to not return anything if there's no load.
;moo script v3.12	- Minor tweaks, a few code changes, added /moo echo and a few more functions.
;moo script v3.11	- Added some new features and made it easier to style the output, added some additional notes
;moo script v3.1	- Added the long awaited flood protection, simple lookup error checking, more/better functions, quicker script
;moo script v3.0	- The whole script was changed, no more moo.dll, it now uses WMI however this version MUST be run on mIRC v6.16 or above.
;[moo] script v2.27	- !moo trigger fix, now turned off by default to stop abuse
;[moo] script v2.26	- Lots of little changes made up till this version, including getmoo.
;[moo] script v2.23	- changed some alias' to alias -l, fixed small bugs, added new featuers
;[moo] script v2.22	- minor bug fixes, bold added etc.
;[moo] script v2.21	- added a feature to turn the !moo get and !getmoo on or off, and fixed a few bugs.
;[moo] script v2.2	- name change, completly changed the /moo and !moo system, should work better now, no mistakes.
;moo script v2.13	- still a few mistakes, changes made, mbm5 isn't functioning correctly...
;moo script v2.12	- many small changes and fixes made, mbm5 was fixed also.
;moo script v2.11	- simple bug fixes.
;moo script v2.1	- minor modifications, final public release.
;moo script v2.0	- New name, new style, new script, same idea.
;MooDll Script v1.21	- Many bug fixes, first public release
;MooDll Script v1.0	- Original private release, very simple, buggy.

;todo:
; - Fix the network traffic readings
; - Test on Windows Vista

;thanks to...
;Mark (from influenced.net) for the original concept and for letting me know that he was not creating a new moo.dll
;HndlWCare who inspired me to write this for saying: "moo.dll was written by a college student roommate of one of our ops who has admitted inserting a backdoor into it" -- none of this is true, there IS NO backdoor in moo.dll and just like there is NO backdoor in this script. HndlWCare you are an idiot.
;Moondawn for listening to me rant.
;and also the beta testers... square, ryguy, Petersen, OutCast3k and PRO1.


;--------------------------------------------------------------------------------------------------------
;SETTINGS - START
;--------------------------------------------------------------------------------------------------------

; Liste des canaux ou vous ne voulez pas afficher l'output
alias -l moo.banchans return #php #windows #eztv

; Style de l'affichage
alias -l moo.style return $+(,$1,:)

;--------------------------------------------------------------------------------------------------------
;SETTINGS - END
;--------------------------------------------------------------------------------------------------------

;NOTICE: DO NOT edit below unless you know what you're doing. If you do make any changes, please let me know! :)

; Version de moo
alias -l moo.ver return Moo Script v3.17

; Alias pour appeler moo
alias moo.stat moo $1-
alias moo.statself moo echo $1-


; Affiche les infos pc
; Usage : /moo : Affiche les infos sur le canal actif
; /moo echo [os/up/cpu/gfx/res/ram/hdd/net] : Affiche pour soi
; /moo [os/up/cpu/gfx/res/ram/hdd/net] : Affiche sur le canal l'info sélectionnée
alias moo {
  if (!$1) { $iif($active == Status Window,echo -gta,$iif($chan,msg $chan,say)) $moo.return | return }
  if ($1 == echo) {
    if ($moo.func($2)) { var %moo.var $ifmatch | echo -a moo: %moo.var }
    else { echo -a $moo.return }
    return
  }
  if ($moo.func($1)) { var %moo.var $ifmatch | $iif($active == Status Window,echo -gta,$iif($chan,msg $chan,say)) moo: %moo.var }
}


;Retourne les infos demandées dans un ordre particulier
alias -l moo.return {
  var %name = $moo.info(name)
  if (%name) { return $moo.func(os) -- $moo.func(up) -- $moo.func(cpu) -- $moo.func(gfx) -- $moo.func(res) -- $moo.func(ram) -- $moo.func(hdd) -- $moo.func(net) }
  else { return lookup error }
}

;this section was created so you can easily change the options for what is returned

; Retourne les infos sur le matériel demandé
; Options: os: Systeme d'exploitation
; up : Temps d'uptime
; cpu : Memoire CPU
; gfx : Carte graphique
; res : Résolution
; ram : Mémoire vive
; hdd : Capacité disque
; net : Carte réseau
alias -l moo.func {
  if ($1 == os) { return $+(14[,2,OS :, ,$moo.info(ostitle),14]) }
  if ($1 == up) { return $+(14[,4,Uptime :, ,$duration($moo.info(up)),14]) }
  if ($1 == cpu) { return $+(14[,5,Mémoire CPU :, ,$moo.info(cpuname) $brak($moo.info(cpuarch)) at $moo.info(cpuspeed) $moo.info(cpuload),14]) }
  if ($1 == gfx) { return $+(14[,6,Carte Graphique :, ,$moo.info(gfxmake) $moo.info(gfxproc),14]) }
  if ($1 == res) { return $+(14[,3,Résolution :, ,$moo.info(res),14]) }
  if ($1 == ram) { var %moo.rammax = $moo.info(rammax) | var %moo.ramuse = $moo.info(ramuse) | return $+(14[,10,RAM :, ,$+($round($calc(%moo.rammax - %moo.ramuse),0),/,%moo.rammax,MB) $+($chr(40),$round($calc((%moo.rammax - %moo.ramuse) / %moo.rammax * 100),2),%,$chr(41)) $moo.rambar($round($calc((%moo.rammax - %moo.ramuse) / %moo.rammax * 100),2)),14]) }
  if ($1 == hdd) { return $+(14[,12,HDD :, ,$moo.info(hdd),14]) }
  if ($1 == net) { return $+(14[,13,Réseau :, ,$iif($moo.info(netname),$ifmatch $iif($moo.info(netspeed), - $ifmatch, ) $moo.info(netin) Up $moo.info(netout) Down, ),14]) }
  elseif ($moo.info($1)) { return $moo.style($1) $ifmatch }
}

;Retourne les informations du matériel demandé en utilisant WMI
; Voir ci dessous pour les types d'infos demandées. Vous pouvez aussi en rajouter, pour cela, lisez la documentation de WMI.
alias moo.info {
  if ($1 == name) { return $wmiget(Win32_ComputerSystem).Name }
  if ($1 == ostitle) { return $wmiget(Win32_OperatingSystem).Caption }
  if ($1 == ossp) { return $wmiget(Win32_OperatingSystem).CSDVersion }
  if ($1 == osver) { return $wmiget(Win32_OperatingSystem).Version }
  if ($1 == osinstall) { var %time = $ctime($iif($wmiget(Win32_OperatingSystem).InstallDate,$+($mid($ifmatch,7,2),/,$mid($ifmatch,5,2),/,$mid($ifmatch,1,4)) $+($mid($ifmatch,9,2),:,$mid($ifmatch,11,2),:,$mid($ifmatch,13,2)))) | return $asctime(%time) $brak($duration($calc($ctime - %time)) ago) }
  if ($1 == osarc) { return $wmiget(Win32_OperatingSystem).OSArchitecture }
  if ($1 == up) { return $uptime(system,3) }
  if ($1 == cpuname) { return $wmiget(Win32_Processor).Name }
  if ($1 == cpuspeed) { return $+($wmiget(Win32_Processor).CurrentClockSpeed,MHz) }
  if ($1 == cpuload) { return $iif($wmiget(Win32_Processor).LoadPercentage,$brak($+($ifmatch,% Load)),) }
  if ($1 == cputotal) { return $wmiget(Win32_ComputerSystem).NumberOfProcessors }
  if ($1 == cpuarch) { return $mooarch($wmiget(Win32_Processor).Architecture) }
  if ($1 == gfxmake) { return $wmiget(Win32_VideoController).AdapterCompatibility }
  if ($1 == gfxproc) { return $wmiget(Win32_VideoController).VideoProcessor }
  if ($1 == gfxram) { return $bytes($wmiget(Win32_VideoController).AdapterRam,3).suf }
  if ($1 == res) { return $+($wmiget(Win32_VideoController).currenthorizontalresolution,x,$wmiget(Win32_VideoController).currentverticalresolution) }
  if ($1 == resbit) { return $wmiget(Win32_VideoController).currentbitsperpixel $+ bit }
  if ($1 == resrate) { return $wmiget(Win32_VideoController).currentrefreshrate $+ Hz }
  if ($1 == rammax) { return $round($calc($wmiget(Win32_OperatingSystem).TotalVisibleMemorySize / 1024),1) }
  if ($1 == ramuse) { return $round($calc($wmiget(Win32_OperatingSystem).FreePhysicalMemory / 1024), 1) }
  if ($1 == netname) { return $wmiget(Win32_PerfRawData_Tcpip_NetworkInterface).Name }
  if ($1 == netspeed) { return $calc($wmiget(Win32_PerfRawData_Tcpip_NetworkInterface).CurrentBandwidth / 1000000) $+ MB/s }
  if ($1 == netin) { return $bytes($wmiget(Win32_PerfRawData_Tcpip_NetworkInterface).BytesReceivedPersec).suf }
  if ($1 == netout) { return $bytes($wmiget(Win32_PerfRawData_Tcpip_NetworkInterface).BytesSentPersec).suf }
  if ($1 == hdd) { var %i 1 | while (%i <= $disk(0)) { if ($disk(%i).type == fixed) var %var %var $disk(%i).path $+($bytes($disk(%i).free).suf,/,$bytes($disk(%i).size).suf) $+ $chr(44) | inc %i } | return $left(%var,-1) }
  if ($1 == sound) { return $wmiget(Win32_SoundDevice).Name }
  if ($1 == mobo) { return $wmiget(Win32_BaseBoard).Manufacturer $wmiget(Win32_BaseBoard).Product }
}

;moo cpu architecture descriptors
alias -l mooarch {
  if ($1 == 0) { return x86 }
  if ($1 == 1) { return MIPS }
  if ($1 == 2) { return Alpha }
  if ($1 == 3) { return PowerPC }
  if ($1 == 6) { return Intel Itanium Processor Family (IPF) }
  if ($1 == 9) { return x64 }
}

;moo rambar - the famous rambar from the original script with a couple of changes
alias -l moo.rambar {
  if ($len($1) < 990) {
    var %moo.rb.size = 10
    var %moo.rb.used = $round($calc($1 / 100 * %moo.rb.size),0)
    var %moo.rb.unused = $round($calc(%moo.rb.size - %moo.rb.used),0)
    var %moo.rb.usedstr = $str(|,%moo.rb.used)
    var %moo.rb.unusedstr = $str(-,%moo.rb.unused)
    if ((%moo.rb.usedstr) && (%moo.rb.unusedstr)) return $+(14[,9,%moo.rb.usedstr,,%moo.rb.unusedstr,14])
  }
}

;Get WMI data - this is the most useful function here, this only works if mIRC has the $COM function, its very useful, but a little slow.
alias wmiget {
  var %com = cominfo, %com2 = cominfo2, %com3 = cominfo3
  if ($com(%com)) { .comclose %com }
  if ($com(%com2)) { .comclose %com2 }
  if ($com(%com3)) { .comclose %com3 }
  .comopen %com WbemScripting.SWbemLocator
  var %x = $com(%com,ConnectServer,3,dispatch* %com2), %x = $com(%com2,ExecQuery,3,bstr*,select $prop from $1,dispatch* %com3), %x = $comval(%com3,$iif($2,$2,1),$prop)
  if ($com(%com)) { .comclose %com }
  if ($com(%com2)) { .comclose %com2 }
  if ($com(%com3)) { .comclose %com3 }
  return %x
}

;backets - I got fed up of repeating the same thing
alias -l brak return $+($chr(40),$1-,$chr(41))

;uptime script - this is the short uptime script created to return your current update and retain your best uptime
on *:CONNECT: moo.up x

; Affichage de l'uptime
alias moo.up {
  var %moo.up = $getStat(maxUptime)
  $iif($timer(moo_up) == $null,.timermoo_up 0 60 moo.up x)
  if (($uptime(system,3) >= %moo.up) || (%moo.up == $null)) { writeStat maxUptime $uptime(system,3) }

  if ($1 == x) { halt }
  elseif ($1 == echo) { var %say = echo }
  else { var %say = $iif($active == Status Window,echo,say) }
  %say 7Windows $OS Uptime: $durationfr($uptime(system,3)) $chr(40) $+ 8Meilleur temps: $durationfr(%moo.up) $+ $chr(41)
}


;moo triggers - public display, sharing the script and ctcp moo

#!uptime on
on *:TEXT:!uptime:#: if (!$istok($moo.banchans,$chan,32)) { moo.up | $repeatcheck(!uptime) }
#!uptime end

#!moo off
on *:TEXT:!moo*:#: if (!$istok($moo.banchans,$chan,32)) { moo $2 | $repeatcheck(!moo) }
#!moo end

#!getmoo on
on *:TEXT:!getmoo:*: {
  if ($chan) { .notice $nick moo: To get $moo.ver type: "/msg $me !getmoo" (set "/dccignore off" first) | $repeatcheck(!getmoo) | halt }
  else { .close -m $nick | .dcc send $nick $script | .notice $nick moo: Once you receive the script issue: "/load -rs $nopath($script) $+ ", and don't forget to do "/dccignore on" | $repeatcheck(!getmoo) | halt }
}
#!getmoo end

#ctcpmoo off
CTCP *:*:*: if (($1 == MOO) || ($1 == VERSION)) { .ctcpreply $nick $1 $moo.ver by HM2K | $repeatcheck(ctcpmoo) }
#ctcpmoo end

alias -l repeatcheck { ;v0.12 by HM2K - will disable the appropriate group if its flooded
  var %rep.lim = 3
  var %rep.t.lim = 25
  var %rep.t.expr = 10
  if (%rep.lockusr- [ $+ [ $nick ] ]) { echo $ifmatch | haltdef }
  inc $+(-u,%rep.t.lim,$chr(32),%,rep-,$nick,.,$len($strip($1-)),.,$hash($strip($1-),32)) 1
  if (%rep- [ $+ [ $nick ] $+ . $+ [ $len($strip($1-)) ] $+ . $+ [ $hash($strip($1-),32) ] ] == %rep.lim) {
    ;ignore -u60 $address($nick,5)
    if ($group($chr(35) $+ $1) == on) { .disable $chr(35) $+ $1 | .echo -gat $1 is $group($chr(35) $+ $1) due to a repeat flood from $iif($chan,$nick in $chan,$nick) $+ , to re-enable: /enable $chr(35) $+ $1 }
    .set $+(-u,%rep.t.expr,$chr(32),%,rep.lockusr-,$nick) 1
  }
}

;onload and onunload checks - making sure everything is as it should be
on *:LOAD: { moo.up x }
on *:UNLOAD: { .timermoo_up off | $iif($input(Effacer le meilleur temps d'uptime?,y,Reset stat),writeStat maxUpdate,) }

;the menus - only simple at the moment, however this script is designed to utilise the /moo and !moo triggers
menu menubar {
  Outils
  .$moo.ver
  ..Afficher tout (/moo)
  ...Sur le canal:moo
  ...Seulement pour moi:moo echo
  ..Uptime (/up)
  ...Sur le canal:moo.up
  ...Seulement pour moi:moo.up echo
  ..-
  ..!moo trigger ( $+ $group(#!moo) $+ ):{
    if ($group(#!moo) != on) { .enable #!moo }
    else { .disable #!moo }
    .echo -ga moo: !moo is $group(#!moo)
  }
  ..!uptime trigger ( $+ $group(#!uptime) $+ ):{
    if ($group(#!uptime) != on) { .enable #!uptime }
    else { .disable #!uptime }
    .echo -ga moo: !uptime is $group(#!uptime)
  }
  ..!getmoo trigger ( $+ $group(#!getmoo) $+ ):{
    if ($group(#!getmoo) != on) { .enable #!getmoo }
    else { .disable #!getmoo }
    .echo -ga moo: !getmoo is $group(#!getmoo)
  }
  ..ctcp moo trigger ( $+ $group(#ctcpmoo) $+ ):{
    if ($group(#ctcpmoo) != on) { .enable #ctcpmoo }
    else { .disable #ctcpmoo }
    .echo -ga moo: ctcpmoo is $group(#ctcpmoo)
  }
  ..-
  ..Décharger Moo Script:unload $script
}

;------------------------------
; End of File
;:-----------------------------
