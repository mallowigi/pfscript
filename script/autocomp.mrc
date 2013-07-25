;---------------------------------------
; Autocomplétion
; Code original par fjxokt (fjxokt@gmail.com)
;---------------------------------------

#features on

on *:START:{
  if ($hget(groups,autocomp) == $null) { hadd -m groups autocomp 1 }
  if ($hget(groups,autocomp) == 1) { 
    splash_text 3 Chargement du script $nopath($script) ...
    .enable #features.autocomp 
    if ($ri(autocomp,use)) { 
      .timer_acopen -mio 0 $ri(autocomp,refresh) acOpen 
      if ($ri(autocomp,save)) { acLoadWords }
      if ($ri(autocomp,limituse)) { .timer_aclimit 0 60 acLimit }
    }
  }
  else { .disable #features.autocomp }
}


; Chargement des alias
on *:LOAD:{ 
  var %yn = $$yndialog(Charger les alias et identifieurs de vos scripts?)
  if (%yn) {
    waitdialog Chargement des alias... Ceci peut prendre plusieurs minutes...
    if (!$window(@mots)) { window -h @mots }
    acLoadAliases
    acLoadScripts
    waitdialog Terminé!
  }
  if ($ri(autocomp,use)) { 
    .timer_acopen -mio 0 $ri(autocomp,refresh) acOpen 
    if ($ri(autocomp,save)) { acLoadWords }
    if ($ri(autocomp,limit)) { .timer_aclimit 0 60 acLimit }
  }
}


on *:UNLOAD:{
  if ($window(@mots)) { window -c @mots }
  if ($isfile($scriptdirac_tmp.txt)) { .remove $qt($scriptdirac_tmp.txt) }
  .timer_ac* off
  if ($hget(groups,autocomp)) { hadd groups autocomp 0 }
}

#features end

; Retourne la largeur de la fenetre de complétion
alias -l acWidth { return $floor($calc(($window($1).w - 10 - $iif($left($1,1) == $chr(35),$iif($gettok($readini(mirc.ini,nicklist,$1),2,44),$v1,90))) / 3)) }

; Ne garde que les X derniers mots si limite
alias acLimit {
  if (!$enabled(autocomp)) { return }
  savebuf @mots $qt($scriptdirac_tmp.txt)
  loadbuf $ri(autocomp,limit) -r @mots $qt($scriptdirac_tmp.txt)
  .remove $qt($scriptdirac_tmp.txt)
}

; Active l'autocomplétion
alias acOpen {
  ; Si la fenetre n'est pas gérée
  if (!$enabled(autocomp)) || ($istok($ri(autocomp,excepts),$active,59)) { return }
  ; Lorsque mIRC n'est pas active, fermer la fenetre de complétion
  if (!$appactive) { window -c @sel }
  ; Changement de fenêtre : fermeture complétion
  if ($active != @sel) && ((%ac.active != $active) || (!$editbox(%ac.active))) { window -c @sel | unset %ac.actual }

  ; Récupération du dernier mot de l'editbox
  var %txt = $gettok($editbox($active),-1,32)
  if ($left(%txt,2) == //) { var %txt = / $+ $right(%txt,-2) }
  ; Si l'editbox n'a pas changé ou que l'editbox est vide, ne rien faire
  if (%ac.actual == %txt) || (!%txt) { return }
  ; Eviter de completer les mots de moins de 4 lettres
  if ($len(%txt) < 4) { window -c @sel | return }
  

  ; Si il y'a un mot a compléter
  if ($fline(@mots,$+(%txt,*),0)) {
    var %max $ifmatch
    var %i 1, %h = $iif($calc($height(*,$window(@mots).font,$window(@mots).fontsize) * %max + 31) < 150,$v1,150)
    if (!$window(@sel)) {
      ; Sauvegarde de la fenetre active (pour le changement de fenetre)
      set -e %ac.active $active
      ; Ouverture de la popup de complétion
      window -soldh +bL @sel $calc($window($active).dx + 8) $calc($window($active).dy + $window($active).h - %h) $acWidth(%ac.active) $calc(%h - 25)
      window -a $iif($chr(32) isin %ac.active,$qt($v2),$v2) 
    }
    ; Remplissage de a fenetre de complétion
    window -o @sel -1 $calc($window($active).dy + $window($active).h - %h - 4) -1 $calc(%h - 27)
    filter -zc @mots @sel $+(%txt,*)
    sline @sel 1
  }
  elseif ($window(@sel)) { window -c @sel | unset %ac.active }
  ; Sauvegarde du dernier mot afin de ne pas rouvrir l'autocomplétion pour rien
  set -e %ac.actual %txt
  set -e %ac.editbox $editbox($active)
}


; Charge les alias des fichiers d'alias
alias acLoadAliases {
  var %alist
  var %i = 1
  while (%i <= $alias(0)) {
    .fopen parser $qt($alias(%i))
    var %brack = 0
    while (!$feof(parser)) {
      var %line = $fread(parser)
      if (!%line) || ($left(%line,1) == $chr(59)) || ($left(%line,1) == $chr(91)) { continue }
      ; Si on croise une accolade ouvrante ne comportant pas d'accolade fermante
      if (*{* iswm %line) && (*}* !iswm %line) { 
        if (%brack == 0) { var %alias = $gettok(%line,1,32) }
        inc %brack
      }
      ; Si on croise une accolade fermante et pas d'accolade ouvrante
      elseif (*}* iswm %line) && (*{* !iswm %line) { dec %brack }
      ; Si on croise une accolade ouvrante et fermante et qu'on est au niveau le plus haut (définition)
      elseif (*{* iswm %line) && (*}* iswm %line) && (%brack == 0) { var %alias $gettok(%line,1,32) }
      ; Sinon, et qu'on est au plus haut niveau
      elseif (%brack == 0) { var %alias $gettok(%line,1,32) }
      ;Suppression des nX=
      if (%alias) && ($chr(61) isin %alias) { %alias = $gettok(%alias,2-,61) }

      ; Cas des identifieurs
      if ($regex(%line,/return [^}|]/)) && (%alias) { var %alias = $ $+ $remove(%alias,/,$) }
      ; Ajout de /
      elseif (%alias) && ($left(%alias,1) != /) && ($left(%alias,1) != $) { var %alias = / $+ %alias }

      if (%alias) && (%brack == 0) { aline -n @mots %alias | var %alias = $null }
    }
    .fclose parser
    inc %i
  }
}

; Charge les alias des scripts
alias acLoadScripts {
  var %alist
  var %i = 1

  while (%i <= $script(0)) {
    var %brack = 0
    .fopen parser $qt($script(%i))
    while (!$feof(parser)) {
      var %line = $fread(parser)
      if (!%line) || ($left(%line,1) == $chr(59)) || ($left(%line,1) == $chr(91)) { continue }
      ; Si on croise une accolade ouvrante ne comportant pas d'accolade fermante
      if (*{* iswm %line) && (*}* !iswm %line) { 
        if (%brack == 0) { 
          if (alias* iswm %line) && (alias -l* !iswm %line) { var %alias = $gettok(%line,2,32) }
        }
        inc %brack
      }
      ; Si on croise une accolade fermante et pas d'accolade ouvrante
      elseif (*}* iswm %line) && (*{* !iswm %line) { dec %brack }
      ; Si on croise une accolade ouvrante et fermante et qu'on est au niveau le plus haut (définition)
      elseif (*{* iswm %line) && (*}* iswm %line) && (%brack == 0) { 
        if (alias* iswm %line) && (alias -l* !iswm %line) { var %alias = $gettok(%line,2,32) }
      }
      ; Sinon, et qu'on est au plus haut niveau
      elseif (%brack == 0) { 
        if (alias* iswm %line) && (alias -l* !iswm %line) { var %alias = $gettok(%line,2,32) }
      }

      ; Cas des identifieurs
      if ($regex(%line,/return [^}|]/)) && (%alias) { var %alias = $ $+ $remove(%alias,/,$) }
      ; Ajout de /
      elseif (%alias) && ($left(%alias,1) != /) && ($left(%alias,1) != $) { var %alias = / $+ %alias }

      if (%alias) && (%brack == 0) { aline -n @mots %alias | var %alias = $null }
    }
    .fclose parser
    inc %i
  }
}

; Charge les mots enregistrés
alias -l acLoadWords {
  if (!$window(@mots)) { window -h @mots }
  if ($exists($qt(data/autocomp.txt))) { loadbuf -r @mots $qt(data/autocomp.txt) }
}

;------------------------------------
; Evenements 
;------------------------------------

#features.autocomp on

on *:INPUT:*:{
  if (!$ri(autocomp,use)) || ($istok($ri(autocomp,excepts),$active,59)) { return }

  ; Si l'utilisateur a appuyé enter/ctrl+enter sur la fenetre de complétion: ajout du mot a la place du dernier mot 
  if ($sline(@sel,1)) {
    if ($ri(autocomp,enter) == 1) || ($ctrlenter) {
    var %d = $sline(@sel,1) 
    set -e %ac.actual %d 
    window -c @sel 
    editbox -a $deltok(%ac.editbox,-1,32) %d 
    halt
    }
  }

  ; Ajout du mot dans les mots à compléter
  if ($ri(autocomp,learn)) {
    if (!$window(@mots)) { window -h @mots }
    ; Evite d'enregistrer les commandes communes telles que echo, say, msg... ceci afin d'éviter d'enregistrer toutes les notices/query/joins... pour rien)
    if ($remove($1,/) isin echo/say/msg/notice/query/ban/nick/join/part/quit/me/whois/whowas/op/deop/hop/halfop/dehalfop/voice/devoice/kick/mode/ctcp) { return }
    ; Si commande ou identifieur (pas tous les mots sinon c le bordel)
    if ($left($1,1) == $chr(47)) { aline -n @mots $1- }
    elseif ($left($1,1) == $chr(36)) { aline -n @mots $1- }
  }
}

; Sauvegarde des mots
on *:EXIT:{
  if ($ri(autocomp,save)) { savebuf @mots data/autocomp.txt }
  if ($isfile($scriptdirac_tmp.txt)) { .remove $qt($scriptdirac_tmp.txt) }
}

; Clic rajoute le mot complété
menu @sel {
  lbclick {
    editbox $iif($chr(32) isin %ac.active,-s,$v2) $deltok($editbox($active),-1,32) $sline(@sel,1)
    set %ac.actual $sline(@sel,1)
    window -c @sel
  }
}

; Completion avec tab
ON *:TABCOMP:*:{
  if (!$window(@sel)) { return }
  var %l = $sline(@sel,1).ln, %n = $line(@sel,0)

  if (%l == %n) sline @sel 1
  else sline @sel $calc(%l + 1)
  halt
}

; Dialog
dialog ac_list {
  title ""
  size -1 -1 169 209
  option dbu
  icon images/masterIRC2.ico
  list 1, 6 5 159 171, size
  button "&Ajouter", 2, 18 179 37 12
  button "&Supprimer", 3, 59 179 51 12
  button "&Vider", 4, 113 179 40 12
  button "&Fermer", 5, 65 194 37 12, ok
}

on *:dialog:ac_list:*:*:{
  if ($devent == init) {
    if (!$window(@mots)) { window -h @mots }
    savebuf @mots $qt($scriptdirac_tmp.txt)
    loadbuf -o $dname 1 $qt($scriptdirac_tmp.txt)
    .remove $qt($scriptdirac_tmp.txt)
    dialog -t $dname Base de données: $did(1).lines terme(s)
  }
  elseif ($devent == sclick) {
    if ($did == 2) { 
      var %d $$input(Entrez le terme à ajouter,ieou,Ajout d'un terme) 
      did -a $dname 1 %d 
      aline @mots %d 
      dialog -t $dname Base de données: $did(1).lines terme(s)
    }
    elseif ($did == 3) && ($did(1).sel) { 
      did -d $dname 1 $v1 
      dline @mots $v1 
      dialog -t $dname Base de données: $did(1).lines terme(s)
    }
    elseif ($did == 4) { 
      if ($$yndialog(Etes-vous sur de vouloir supprimer l'intégralité de la liste ?)) { 
        did -r $dname 1 
        clear -a @mots 
        dialog -t $dname Base de données: $did(1).lines terme(s) 
      } 
    }
  }
}

alias openAcList { opendialog -mh ac_list }

#features.autocomp end
