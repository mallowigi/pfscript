; ----------------------------------------
; Scripts lancés au démarrage
; ----------------------------------------


; Verifie si le fichier pfscript.ini existe, sinon tente de le localiser ou de creer un par défaut
alias -l checkPFScriptIni {
  var %exists = $isfile($qt($mircdir $+ pfscript.ini))
  if (!%exists) {
    var %f = $input(Le fichier pfscript.ini est introuvable. Ce fichier est nécessaire au bon fonctionnement du programme. $crlf $+ Localiser le fichier?,nwd,Warning,Warning,yohohoho)
    if (%f) { 
      %f = $qt($sfile($mircdir,Localisation de pfscript.ini))
      if (!$pfini(%f)) { $input(Le fichier %f n'est pas un fichier pfscript.ini valide. Un nouveau fichier par défaut va être créé.,iod,pfscript.ini manquant ou invalide) | createDefaultIni }
      else { copy $qt(%f) $qt($mircdir $+ pfscript.ini) } 
    }
    else { $input(Création d'un fichier pfscript.ini ayant les valeurs par défaut,iod,Nouveau pfscript.ini) |  createDefaultIni }
  }
}

; Verifie que les sections importantes de pfscript.ini sont présentes
alias -l pfini {
  var %f = $1-
  if (!%f) || (!$isfile(%f)) || ($ini(%f,0) == 0) { return $false }
  else {
    ; 
    var %sections = paths;misc
    var %i = 1
    while ($gettok(%sections,%i,59)) {
      var %sect = $ifmatch
      if (!$ini(%f,%sect,0)) { return $false }
      inc %i
    }
    return $true
  } 
}

alias -l wi {
  writeini -n $qt($mircdir $+ pfscript.ini) $1 $2 $3-
}

; Crée un fichier pfscript par défaut
alias -l createDefaultIni {
  wi paths toolbar data/toolbar.txt
  wi paths sbar data/statusbar.txt
  wi paths fkeys data/fkeys.txt
  wi paths idents data/idents.txt
  wi paths excludes data/excludes.txt
  wi paths prot data/prot.ini
  wi paths kicks data/kicks.txt
  wi paths quits data/quits.txt
  wi paths slaps data/slaps.txt
  wi paths stats data/stats.txt
  wi paths aways data/aways.txt

wi autocomp use 1
wi autocomp save 1
wi autocomp limit 0
wi autocomp excludes
wi autocomp refresh 600
wi autocomp learn 1

  wi tabcomp use 1
  wi tabcomp format <nick> :
  wi tabcomp character :
  wi tabcomp bsundo 1

  wi awaylog use 0
  wi awaylog events 1
  wi awaylog op 1

  wi awaymess use 1
  wi awaymess channel active
  wi awaymess query 1
  wi awaymess exclude 0

  wi awaymisc 
  wi awaymisc noothers 1
  wi awaymisc awayconnect 1
  wi awaymisc autoawayuse 1
  wi awaymisc backnick old
  wi awaymisc nomessage 1
  wi awaymisc notify 0
  wi awaymisc autoaway 10

  wi copypasta paste delay
  wi copypasta delay 500
  wi copypasta limitlines 1
  wi copypasta lines 5
  wi copypasta bytes 200
  wi copypasta notify 0
  wi copypasta crop 1
  wi copypasta cropbytes 200
  wi copypasta strip 1
  wi copypasta strip.cmode 1
  wi copypasta editbox 0

  wi highlights hlactive 1
  wi highlights hlother 1
  wi highlights noticeother 1
  
  wi mails use 0
  wi mails time 10
  wi mails infobox 1
  wi mails sound 0
  wi mails client thunderbird.exe

  wi masks banmask 3
  wi masks ignoremask 3

  wi misc keepkey 1
  wi misc lookupdates 0
  wi misc antiidleuse 1
  wi misc kickcount 1
  wi misc clearcb 0
  wi misc dccinfo 1
  wi misc splash 1
  wi misc tips 1
  wi misc amsg 7~~~~   3«```` <text> 3´´´´»  7~~~~
  wi misc antiidle 150
  wi misc hlactive 1
  wi misc hlother 0
  wi misc noticeother 0
  wi misc serviceswin 1

  wi nicks servers Défaut
  wi nicks nicks.def PFUserPFUser|Aw

  wi query autocloseuse 1
  wi query stats 1
  wi query eventsmp 1
  wi query notify 1
  wi query autoclose 10
  wi query openuse 0
  wi query events jkmnpq

  wi replace filter cq

  wi servers favorites Epiknet

  wi services servers Epiknet

  wi statusbar use 1
  wi statusbar refreshuse 1
  wi statusbar refresh 1

  wi themes folders themes/
  wi themes fontrep 0
  wi themes colors 1
  wi themes format 1
  wi themes loadoptions fcnsbite
  wi themes addoptions ul
  wi themes manageropt p
  wi themes echo 0
  wi themes theme Pokemon Theme
  wi themes scheme Défaut

  wi titlebar use 1
  wi titlebar refreshuse 1
  wi titlebar refresh 1
  wi titlebar format ~~ Pokemon France Script <pfver> ~~ <nick> $iif($status == connected, | Canal: <chan> - Topic: <topic> - Serveur <net>)
  wi titlebar iconuse 0

  wi toolbar use 1
}

; Verifie que tous les scripts requis sont chargés
alias -l checkScripts {
  var %aliases = aliases.als
  var %scripts = dialogboxes.mrc;setup.mrc;subsetup.mrc
  var %i = 1
  while (%i <= $numtok(%aliases,59)) {
    var %f = $gettok(%aliases,%i,59)
    var %look = $+($qt(%f),;,$qt(alias/ $+ %f))
    if (!$alias(%f)) {
      var %j = 1
      while ($gettok(%look,%j,59)) {
        var %path = $ifmatch
        if ($isfile(%path)) { load -a %path | break }
        inc %j
      }
      if (!$alias(%f)) { $input(Le fichier %f est introuvable. Le script risque de ne pas fonctionner correctement. Si vous disposez du script $+ $chr(44) veuillez le placer dans le dossier "alias" ou bien réinstallez le script,wod,%f manquant) | exit }
    }
    inc %i
  }
  var %i = 1
  while (%i <= $numtok(%scripts,59)) {
    var %f = $gettok(%scripts,%i,59)
    var %look = $+($qt(%f),;,$qt(script/ $+ %f))
    if (!$script(%f)) {
      var %j = 1
      while ($gettok(%look,%j,59)) {
        var %path = $ifmatch
        if ($isfile(%path)) { load -rs2 %path | break }
        inc %j
      }
      if (!$script(%f)) { $input(Le fichier %f est introuvable. Le script risque de ne pas fonctionner correctement. Si vous disposez du script $+ $chr(44) veuillez le placer dans le dossier "script" ou bien réinstallez le script.,wod,%f manquant) | exit }
    }
    inc %i
  }
}

; Verifie que les dlls sont bien présentes
alias -l checkDlls {
  ; MDX Check
  if ($findfile($qt($scriptdirdlls),*.mdx,0) != 4) {
    var %m = $input(MDX.DLL ou l'un de ses plugins est manquant. Ce fichier est nécessaire au bon fonctionnement des scripts. $crlf $+ Veuillez indiquer l'emplacement de ces fichiers $+ $chr(44) ils seront copiés dans le dossier "script/dlls". Si vous ne disposez pas de ces fichiers $+ $chr(44) réinstallez le script.,wyd,MDX.DLL manquant)
    if (%m) { 
      var %dir = $sdir($scriptdir,Emplacement de MDX.DLL et de ses plugins)
      if (!$isdir($qt($scriptdir $+ dlls))) { mkdir $qt($scriptdir $+ dlls) }
      if ($findfile(%dir,mdx.dll,0) == 1) && ($findfile(%dir,*.mdx,0) == 4) {
        copy $qt(%dir $+ mdx.dll) $qt($scriptdir $+ dlls/mdx.dll) 
        copy $qt(%dir $+ bars.mdx) $qt($scriptdir $+ dlls/bars.mdx) 
        copy $qt(%dir $+ ctl_gen.mdx) $qt($scriptdir $+ dlls/ctl_gen.mdx) 
        copy $qt(%dir $+ views.mdx) $qt($scriptdir $+ dlls/views.mdx) 
        copy $qt(%dir $+ dialog.mdx) $qt($scriptdir $+ dlls/dialog.mdx) 
      }
      else { $input(Le dossier spécifié ne comporte pas les fichiers requis. Le programme va alors s'arrêter.,wod) | exit }
    }
  }
  ; Szip check
  if ($findfile($qt($scriptdirdlls),szip.dll,0) != 1) {
    var %m = $input(SZIP.DLL est manquant. Ce fichier est nécessaire au bon fonctionnement des scripts. $crlf $+ Veuillez indiquer l'emplacement de ce fichier $+ $chr(44) il sera copié dans le dossier "script/dlls". Si vous ne disposez pas de ce fichier $+ $chr(44) réinstallez le script.,wyd,SZIP.DLL manquant)
    if (%m) { 
      var %dir = $sdir($scriptdir,Emplacement de SZIP.DLL)
      if (!$isdir($qt($scriptdir $+ dlls))) { mkdir $qt($scriptdir $+ dlls) }
      if ($findfile(%dir,szip.dll,0) == 1) {
        copy $qt(%dir $+ szip.dll) $qt($scriptdir $+ dlls/szip.dll) 
      }
      else { $input(Le dossier spécifié ne comporte pas les fichiers requis. Le programme va alors s'arrêter.,wod) | exit }
    }
  }
  ; DCX Check
  if ($findfile($qt($scriptdirdlls),dcx.dll,0) != 1) {
    var %m = $input(DCX.DLL est manquant. Ce fichier est nécessaire au bon fonctionnement des scripts. $crlf $+ Veuillez indiquer l'emplacement de ce fichier  $+ $chr(44) il sera copié dans le dossier "script/dlls". Si vous ne disposez pas de ce fichier $+ $chr(44) réinstallez le script.,wyd,DCX.DLL manquant)
    if (%m) { 
      var %dir = $sdir($scriptdir,Emplacement de DCX.DLL)
      if (!$isdir($qt($scriptdir $+ dlls))) { mkdir $qt($scriptdir $+ dlls) }
      if ($findfile(%dir,dcx.dll,0) == 1) {
        copy $qt(%dir $+ dcx.dll) $qt($scriptdir $+ dlls/dcx.dll) 
      }
      else { $input(Le dossier spécifié ne comporte pas les fichiers requis. Le programme va alors s'arrêter.,wod) | exit }
    }
  }
  ; DOMXML Check
  if ($findfile($qt($scriptdirdlls),domxml.dll,0) != 1) {
    var %m = $input(DOMXML.DLL est manquant. Ce fichier est nécessaire au bon fonctionnement des scripts. $crlf $+ Veuillez indiquer l'emplacement de ce fichier $+ $chr(44) il sera copié dans le dossier "script/dlls". Si vous ne disposez pas de ce fichier $+ $chr(44) réinstallez le script.,wyd,DOMXML.DLL manquant)
    if (%m) { 
      var %dir = $sdir($scriptdir,Emplacement de DOMXML.DLL)
      if (!$isdir($qt($scriptdir $+ dlls))) { mkdir $qt($scriptdir $+ dlls) }
      if ($findfile(%dir,domxml.dll,0) == 1) {
        copy $qt(%dir $+ domxml.dll) $qt($scriptdir $+ dlls/domxml.dll) 
      }
      else { $input(Le dossier spécifié ne comporte pas les fichiers requis. Le programme va alors s'arrêter.,wod) | exit }
    }
  }
  ;XML check
  if ($findfile($qt($scriptdirdlls),xml.dll,0) != 1) {
    var %m = $input(xml.dll est manquant. Ce fichier est nécessaire au bon fonctionnement des scripts. $crlf $+ Veuillez indiquer l'emplacement de ce fichier $+ $chr(44) il sera copié dans le dossier "script/dlls". Si vous ne disposez pas de ce fichier $+ $chr(44) réinstallez le script.,wyd,xml.dll manquant)
    if (%m) { 
      var %dir = $sdir($scriptdir,Emplacement de xml.dll)
      if (!$isdir($qt($scriptdir $+ dlls))) { mkdir $qt($scriptdir $+ dlls) }
      if ($findfile(%dir,xml.dll,0) == 1) {
        copy $qt(%dir $+ xml.dll) $qt($scriptdir $+ dlls/xml.dll) 
      }
      else { $input(Le dossier spécifié ne comporte pas les fichiers requis. Le programme va alors s'arrêter.,wod) | exit }
    }
  }
  ;Font.dll
  if ($findfile($qt($scriptdirdlls),font.dll,0) != 1) {
    var %m = $input(font.dll est manquant. Ce fichier est nécessaire au bon fonctionnement des scripts. $crlf $+ Veuillez indiquer l'emplacement de ce fichier $+ $chr(44) il sera copié dans le dossier "script/dlls". Si vous ne disposez pas de ce fichier $+ $chr(44) réinstallez le script.,wyd,font.dll manquant)
    if (%m) { 
      var %dir = $sdir($scriptdir,Emplacement de font.dll)
      if (!$isdir($qt($scriptdir $+ dlls))) { mkdir $qt($scriptdir $+ dlls) }
      if ($findfile(%dir,font.dll,0) == 1) {
        copy $qt(%dir $+ font.dll) $qt($scriptdir $+ dlls/font.dll) 
      }
      else { $input(Le dossier spécifié ne comporte pas les fichiers requis. Le programme va alors s'arrêter.,wod) | exit }
    }
  }
}

;;; <Doc>
;; Actions effectuées au démarrage du programme: 
;; - Vérification des droits en écriture
;; - Vérification de la présence du fichier de conf pfscript.ini
;; - Vérification de la présence des fichiers obligatoires (aliases.als, dialogboxes.mrc, setup.mrc, subsetup.mrc)
;; - Vérification des dlls
;; - Chargement des états d'activation des fonctionnalités (features)
;; - Autres vérifications (numéro de version, système d'exploitation, commandes bloquées, espace disque)
;; - Changement de l'icône du programme
ON *:START:{
  ; Check write permissions
  ensureWrite

  ; Groups
  hmake groups 10
  if ($isfile($qt(data/groups.ini))) { hload -i groups $qt(data/groups.ini) }

  ;Check pfscript.ini existence
  checkPFscriptIni

  ; Check mandatory scripts existence
  checkScripts
  ;Check Dlls existence
  checkDlls

  ;Other checks
  if ($version < 7.1) { 
    var %u = $input(La version de mIRC que vous utilisez est trop ancienne $+ $chr(44) par conséquent les scripts ne fonctionneront pas correctement. $crlf $+ Veuillez mettre mIRC à jour dès que possible,owd,Mauvaise version)
    noFeatures
  }
  if ($version > 7.19) {
    var %u = $input(La version de mIRC que vous utilisez est ultérieure à la version de développement du script. Par conséquent $+ $chr(44) il est possible que certains scripts ne fonctionnent pas sur cette nouvelle version. $crlf $+ En cas de problème $+ $chr(44) envoyez un mail à l'adresse : mariosmilax@free.fr afin qu'un patch soit créé.,owd,Nouvelle version)
  }
  if ($istok(95 98 Me,$os,32)) {
    var %u = $input(Votre système d'exploitation est obsolète $+ $chr(44) par conséquent certains scripts risquent de ne pas fonctionner correctement. $crlf $+ Les fonctionnalités du script ont été désactivées,owd,Système d'exploitation obsolète)
    noFeatures
  }
  if ($lock(run)) || ($lock(dll)) || ($lock(com)) || ($lock(decode)) {
    var %u = $input(Vous avez bloqué l'une des commandes "Run" $+ $chr(44) "Dll" $+ $chr(44) "Com" ou "Decode" $+ $chr(44) ce qui peut causer certains scripts de ne pas fonctionner. $crlf $+ Veuillez activer ces commandes (Options -> Other -> Lock),owd,Commandes bloquées)
    noFeatures
  }
  if ($disk($left($mircdir,1)).free < 20971520) { 
    var %u = $input(Attention: Il ne vous reste que $bytes($v1,3).suf d'espace libre sur le disque $left($mircdir,2) $+ ! $crlf $+ Il est fortement conseillé de libérer de l'espace disque pour profiter pleinement du script!,owh,Espace disque faible)
  }

  ;Change window props
  if ($isfile(images/masterIRC2.ico)) dcx WindowProps $window(-2).hwnd +i 0 images/masterIRC2.ico
  dcx xSignal 1
  .ial on

}

;;; <Doc>
;; Fermeture du programme: Sauvegarde de l'état d'activation des fonctionnalités
ON *:EXIT:{
  if ($hget(groups)) { write -c $qt(data/groups.ini) | hsave -i groups $qt(data/groups.ini) }
}

; ––––––––––––––––––––––––––––––––––––––––
; Fin de fichier
; ––––––––––––––––––––––––––––––––––––––––
