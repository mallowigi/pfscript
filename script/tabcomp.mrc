#features on


; Chargement du script: verification d'anciennes copies de iinc
on *:load:{
  .disable #features.iinc_edbox
  .timerreedbox 1 0 .enable #features.iinc_edbox
  if ($isalias(edbox_chk)) {
    ; Cherche si l'alias edbox_chk est bien a la version 1.3
    var %i = $script(0), %j, %text = ;1.3, %nick = $true
    while (%i) { 
      if ($read($script(%i), nw, alias edbox_chk *)) {
        %j = $readn + 1
        if ($read($script(%i), n, %j) != %text) {
          if (%nick) {
            echo -a *** Conflit!!! ***
            echo -a Les fichiers suivants ont d'anciennes copies de l'alias edbox_chk:
            %nick = $false
          }
          dec %j
          echo -a Ligne $base(%j, 10, 10, 5) dans $script(%i)
        }
      }
      dec %i
    }
  }
  .timerreedbox -e
  if ($version < 6) .enable #features.iinc.591
  else .disable #features.iinc.591
  scid -at1 fill_iinc
}

; Déchargement du script
on *:unload:{ 
  if ($hget(iinc)) { 
    hfree iinc 
    hfree -w iinc.? 
    scid -a window -c @iinc. $!+ $!cid 
    .timer 1 0 if ($isalias(edbox_chk) == $!false) hfree edbox
  }  
}
#features end

;Recupere le nom de la fenetre d'iinc
alias -l iinc.win { 
  return @iinc. $+ $cid
}


; ------------------- ALIASES --------------------

; Recupere, ajoute ou supprime une valeur d'une table iinc
; $1: table, $2: clé, $3-: valeur
alias -l getiinc {
  if (!$hget($iinc.win)) { hmake $iinc.win 10 }
  if ($isid) { return $hget($iinc.win,$1 $+ _ $+ $2) }
  if ($0 == 1) { hdel $iinc.win $1 $+ _ $+ $2 } 
  elseif ($0 > 1) { hadd $iinc.win $1 $+ _ $+ $2 $3- }
}

; Renvoie true si l'editbox d'un channel a été autocomplété
alias -l wasCompleted { 
  if ($isid) { return $getiinc(wc,$1,$2-) }
  else { getiinc wc $1 $2- }
}
; Renvoie le nombre d'autocompletions de l'editbox d'un channel
alias -l chanUses { 
  if ($isid) { return $getiinc(cu,$1,$2-) }
  else { getiinc cu $1 $2- }
}
; Renvoie le nombre de mots avant le mot autocomplété
alias -l wordsBefore { 
  if ($isid) { return $getiinc(w,$1,$2-) }
  else { getiinc w $1 $2- } 
}
; Renvoie si le curseur a été déplacé
alias -l isMoved { 
  if ($isid) { return $getiinc(m,$1,$2-) }
  else { getiinc m $1 $2- }
}
; Renvoie le dernier mot autocomplété d'un channel
alias -l lastCompletion { 
  if ($isid) { return $getiinc(lc,$1,$2-) }
  else { getiinc lc $1 $2- }
}
; Renvoie le contenu de l'editbox avant la complétion
alias -l editContents { 
  if ($isid) { return $getiinc(ec,$1,$2-) }
  else { getiinc ec $1 $2- }
}
alias -l formatNick { 
  if ($isid) { return $getiinc(fn,$1,$2-) }
  else { getiinc fn $1 $2- }
}


; Retourne le nick autocomplété avec le format specifié. Si pas de nick fourni, retourne si oui ou non le tabcomp est activé
alias -l completedNick {
  if ($1 == $null) { return 1 }
  else { return $replace(<nick>,$1) }
}

; Enleve certains caracteres sur les nicks (permet de tabber les nicks commencant avec ces caracteres)
; Ex: ^Sasaki^ est tabbable par S
alias -l nickStrip {
  return $iif($remove($1,[,],-,_,`,^,\,$chr(123),$chr(124),$chr(125)) != $null,$ifmatch,$1)
}

; Enleve une ligne a la fenetre
alias -l dline { 
  if ($2 == $null) fill_iinc 
  else dline $1-
}

; Fill the editbox
alias -l eb {
  editbox $1- 
  edbox_reset
}

; Retourne le caractere declenchant la completion
alias -l trig {
  return $ri(tabcomp,character)
}

; Met à jour les fenetres iinc contenant les pseudos sur tous les chans ouverts
alias -l fill_iinc {
  var %i, %j, %text
  if (!$window($iinc.win)) { window -lhnw0 $iinc.win }
  clear $iinc.win
  %i = $chan(0)

  while (%i) {
    %j = $nick($chan(%i),0)
    while (%j) {
      %text = $nick($chan(%i),%j)
      aline $iinc.win $chan(%i) * %text $nickstrip(%text)
      dec %j
    }
    dec %i 
  }
}

;Trouver un match pr la completion
; $1: fenetre active, $2: pseudo a completer, $3: nb de completions précédentes
alias -l iinc {
  if (!$isid) { iinc_config | return }
  var %word = $2, %n = $3, %text, %u

  ; Si on recherche le chan
  if (%n > $fline($iinc.win,$1 * %word,0)) {
    ;active window match
    if (%word iswm $active) && (%n == 1) return $active
    return
  }

  ; Retourne le nick
  %u = $gettok($line($iinc.win,$fline($iinc.win,$1 * %word,%n)),3,32)

  return %text $+ %u
}

; Gestion des signaux "Modif editbox", "Déplacement du curseur", "Sélection"
on *:signal:edit_change:edit_change $1-
on *:signal:edit_cursor:{
  var %active = $remove($active, $chr(32))
  if ($chanUses(%active)) { isMoved %active $true }
}
on *:signal:edit_select:{
  var %active = $remove($active, $chr(32))
  if ($chanUses(%active)) { isMoved %active $true }
}

; Actions lorsque l'editbox change
; $1: Fenetre active
alias -l edit_change {
  var %active = $remove($active,$chr(32)), %editbox = $editbox($active), %text, %n = 0, %word, %nick, %nbwds, %lastcomp

  ; Décomplétion
  ; Si backspace undo coché et touche shift non pressée: supprime le pseudo entier
  if ($mouse.key !& 4) {
    ; Si il y'a eu autocompletion
    if ($chanUses(%active)) {
      ; Si le curseur n'a pas bougé avec les fleches
      if (!$isMoved(%active)) {
        ; Recupere le contenu de l'editbox sauvegardé avant le tab
        %text = $remove($editContents(%active),$trig)

        ; Nombre de mots avant la complétion: Si 0, le recalcule
        if ($wordsBefore(%active)) { %nbwds = $ifmatch }
        else { %nbwds = $numtok(%text, 32) }

        ; %% : Nom fenetre active
        var %% = $1-

        ; %%editbox : contenu de l'editbox actuelle
        tokenize 32 %editbox
        var %%editbox = $1-

        ; %%lastcomp : contenu de l'editbox avec le nick autocomplété (moins derniere lettre)
        tokenize 32 $lastCompletion(%active)
        var %%lastcomp = $1-

        tokenize 32 %%
        ; On en revient au point de départ: si on a une editbox qui est la meme que celle avant la derniere complétion (donc bs efface le nick)
        if (%%lastcomp == %%editbox) {
          %lastcomp = $len($gettok(%text, 1- $+ %nbwds, 32)) + 1
          ; On revient au nick moins la complétion
          eb -ab $+ %lastcomp $+ e $+ %lastcomp %text
          ; Efface les données de complétion
          return $edit_clear
        }
      }

      ; Si on vient juste de completer
      if ($formatNick(%active)) { var %nbwds = $calc(%nbwds + $numtok($completedNick(nick), 32) - 1) }
      if ($numtok($left(%editbox, $editbox($active).selstart), 32) == $iif(%nbwds, %nbwds, 1)) && ($right($left($editbox($active), $editbox($active).selstart), 2) != $str($trig,2)) { return }
    }

    ; Si il n'y a pas eu de completion auparavant et qu'on ne suscite pas de completion, effacer les données de completion
    if ($right($editbox($active), 1) != $trig) { return $edit_clear }
  }

  if ($prop == bschk) { return }

  ; Si le curseur a bougé, pas de raison de garder les données de complétion
  if ($isMoved(%active)) { edit_clear }

  ; Si tabcomp non utilisé ou que l'on ne suscite pas d'autocompletion, pareil
  if ($right($editbox($active),1) != $trig) || ($mid($editbox($active),-2,1) != $trig) {
    edit_clear
    return
  }

  ; %text contient l'editbox moins le dernier mot (mot a completer)
  ; %word contient le dernier mot
  %text = $deltok(%editbox,-1,32)
  %word = $remove($gettok(%editbox,-1,32),$trig) $+ *

  if ($window($1).type isin channel query) {
    ; Si completion effectuée précedemment
    if ($editContents(%active)) {
      %word = $gettok($ifmatch,-1,32) $+ *
      %text = $deltok($ifmatch,-1,32)
    }
    ; Sinon, ajoute les données de completion
    elseif (!$chanUses(%active)) {
      editContents %active %editbox
      wasCompleted %active $true
    }
    %n = $iif($chanUses(%active),$ifmatch,0)

    ; Si le dernier mot (le nick donc) comporte un prefixe (ex @Blaster), sauve le prefixe et le nom séparés
    var %noop = $regex(%word, /^([ $+ $prefix $+ ]*)(.*)/)
    var %pre = $regml(1), %word = $regml(2)

    ;Si pas de nick, juste le prefixe, ne rien faire
    if (%word == *) && (%pre != $null) return

    inc %n
    ; Recupere le pseudo ayant le plus de tab dans la liste des pseudos commencant par ce que vous avez tapé
    %nick = $iinc(%active, %word, %n)
    var %ov = %nick

    ; Si seulement le pseudo a été tapé et rien d'autre, utiliser le format spécial
    if ((%nick != $active) || ($window($active).type != channel)) && ($numtok(%editbox, 32) <= 1) && ($completedNick != 0) && ($mouse.key !& 2) && (%pre == $null) && (%nick != $null) { %nick = $completedNick(%nick) | formatNick %active $true }

    if (%nick) {
      ; Compléter le nick (si ctrl appuyé, ne pas ajouter d'espace)
      eb -a $+ $iif(!$and($mouse.key,2),p) %text %pre $+ %nick
      if (%text == $null) { wordsBefore %active 1 }
      ; Ajouter la valeur du nick complété (moins la derniere lettre pour détecter le bsundo)
      lastCompletion %active %text %pre $+ $left(%nick, -1)
      ; Augmenter le taux d'utilisation de ce pseudo pour ce chan
      chanUses %active %n
    }
    else {
      ; Si pas de complétion possible, supprimer les données de completion
      eb -a $+ $iif($editContents(%active),p $remove($ifmatch,$trig))
      chanUses %active
      editContents %active
    }
    halt
  }
}

; Si le signal "editbox clear", effacer les données de completion
on *:signal:edit_clear:$edit_clear($1-).bschk
; Remet a zero les données de completion
alias -l edit_clear {
  if ($prop == bschk) && ($edit_change().bschk) { return }
  var %active = $remove($active,$chr(32))
  chanUses %active
  editContents %active
  wordsBefore %active
  wasCompleted %active
  isMoved %active
  lastCompletion %active
  formatNick %active
}

;;; <Doc>
;; Effectue l'autocompletion ameliorée
alias -l tabcomp {
  if ($editbox($active).selstart == $editbox($active).selend) {
    var %editbox = $editbox($active), %nbwds = $numtok($left(%editbox,$ifmatch),32), %active = $remove($active,$chr(32)), %n = 0
    var %word = $remove($gettok(%editbox,%nbwds,32),$trig) $+ *, %nick, %text, %lastcomp, %first = $false

    ; Si le curseur a bougé (avec les fleches), raz les données de completion
    if ($isMoved(%active)) { edit_clear }

    ; Nb de mots avant la completion
    if ($wordsBefore(%active)) { %nbwds = $ifmatch }
    else { wordsBefore %active %nbwds }

    ; Enleve le trigger de l'editbox
    if ($editContents(%active)) { %word = $remove($gettok($ifmatch, %nbwds, 32),$trig) $+ * }
    ; Sinon si pas d'autocompletion auparavant, l'ajoute dans la table
    elseif (!$chanUses(%active)) {
      editContents %active %editbox
      if ($right($editbox($active), 1) == $trig) { wasCompleted %active $true }
      %first = $true
    }
    ;%n: nombre de completions antérieures
    %n = $iif($chanUses(%active),$ifmatch,0)

    var %noop = $regex(%word, /^([ $+ $prefix $+ ]*)(.*)/)
    var %pre = $regml(1), %word = $regml(2)

    inc %n

    if (%n == 0) { return }
    if (%word == *) && (%pre != $null) { return }

    ; Trouve le nick
    if ($chr(37) $+ * !iswm $gettok(%editbox,%nbwds,32)) || (!$var($v2)) { %nick = $iinc(%active, %word, %n) }
    var %ov = %nick, %spc = $false

    ; Si le nick seulement et rien d'autre
    if ((%nick != $active) || ($window($active).type != channel)) && ($numtok(%editbox, 32) <= 1) && ($completedNick != 0) && ($mouse.key !& 2) && (%pre == $null) && (%nick != $null) {
      %nick = $completedNick(%nick)
      %spc = $true
      formatNick %active $true
    }

    if (%nick) {
      if (%editbox == $null) {
        %text = %nick
        %nbwds = 1
      }
      else { %text = $puttok(%editbox, %pre $+ %nick, %nbwds, 32) }

      if ($wasCompleted(%active)) { %spc = $true }


      %lastcomp = $calc($len($gettok(%text, 1- $+ %nbwds, 32)) + 1 + $iif((%spc) && (%nbwds == $numtok(%text, 32)), 1, 0))
      eb -a $+ $iif(%spc, p) %text

      if (%editbox == $null) { lastCompletion %active %pre $+ $left(%nick, -1) }
      else { lastCompletion %active $puttok(%editbox, %pre $+ $left(%nick, -1), %nbwds, 32) }

      chanUses %active %n
    }
    else {
      if (%first) {
        var %noop = $complete_code(%editbox, %nbwds)
        return
      }

      %text = $editContents(%active)
      %lastcomp = $calc($len($gettok(%text, 1- $+ %nbwds, 32)) + 1 + $iif(($wasCompleted(%active)) && (%nbwds == $numtok(%text, 32)), 1, 0))
      eb -a $+ $iif($wasCompleted(%active), p) $+ b $+ %lastcomp $+ e $+ %lastcomp %text
      edit_clear
    }
    halt
  }
}

alias -l complete_code {
  return
  var %editbox = $1, %nbwds = $2, %active = $remove($active, $trig)
  var %text = $gettok(%editbox, 1- $+ %nbwds, 32), %re, %pre

  ; = /(?:^|\x20)(\$([^\(\x20]*)\((.*?)\))$/
  ; Thanks jaytea! [(?N) syntax]

  ; support matched parenthesis in parameters ($calc)
  var %re = /(.*(?:^|\x20|\x2C|\())(\x23|(?:\x23?\$[^() ]*(?:(\(([^()]|(?3)|\((?2)\))*\)(?:\.[^ ]+)?)?|(\x25[^ ]+))))$/
  ;var %re = /(.*)(?:^|\x20)(\x23?\$[^()]*(?:(\((?:[^()]|(?2))*\)(?:\.[^ ]+)?)?))$/

  noop $regex(cc, %text, %re)
  %text = $regml(cc, 2)

  ;Temporarily removed due to a mIRC bug affecting other code
  ; .. temporarily reinstated with modification due to a DIFFERENT mIRC bug.
  if ($numtok(%text, 32) == 1) && ($len(%text) <= 90) && ($!input* iswm %text) { return }

  %nick = $eval_code(%text)

  if (%nick == $null) {
    beep 1
    haltdef
    return
  }

  var %op = %nbwds

  %nbwds = $calc(%nbwds - $numtok(%text, 32) + 1) $+ - $+ %nbwds
  ;%t = $instok($deltok(%editbox, %nbwds, 32), %nick, %nbwds, 32)
  %lastcomp = $calc($iif($regml(cc, 1) != $null, $len($regml(cc, 1)), 0) + $len(%nick) + 1 + $iif(($wasCompleted(%active)) && (%op == $numtok(%editbox, 32)), 1, 0))

  var %suf = $gettok(%editbox, $calc(%op + 1) $+ -, 32)
  %text = $+($regml(cc, 1), %nick) %suf

  eb -a $+ $iif($wasCompleted(%a), p) $+ %text

  wordsBefore %active $gettok(%p, 2, 45)
  chanUses %active -1

  %text = $+($regml(cc, 1), $left(%nick, -1)) %suf
  ;if ($left(%nick, -1) != $null) %text = $instok(%t, $ifmatch, %nbwds, 32)

  lastCompletion %active %text
  haltdef
}

; To prevent the completion of variables from completing local vars in the above alias.
alias -l eval_code return $eval($1, 2)

;---------------------------------
; EVENEMENTS
;---------------------------------

#features.tabcomp on

;;; <Doc>
;; Connexion: Ouverture de la fenetre iinc
;; Cette fenetre contiendra diverses informations necessaires a la completion tab ameliorée
;; Les informations seront indiquées au format suivant: <canal> * <nick> <stripnick> 
on *:connect:{
  window -lhnw0 $iinc.win
}

;;; <Doc>
;; Déconnexion: fermeture de la fenêtre iinc
on *:disconnect:{
  if ($window($iinc.win)) { 
    window -c $ifmatch 
    if ($hget($iinc.win)) { .hfree $iinc.win }
  }
}

;;; <Doc>
;; Fermeture de la fenêtre iinc: reouvre la fenetre et remet a jour les pseudos mais avec les stats remises à zero
on *:close:@iinc.*:{
  .timer 1 0 scid $gettok($target,2,46) fill_iinc
}

;;; <Doc>
;; Joindre un canal: Entame le processus d'ajout des pseudos dudit canal dans la fenetre iinc
on me:*:join:#:{
  hadd -m $iinc.win $chan $true
}

;;; <Doc>
;; Sortie du canal: effacement de tous les pseudos du canal quitté
on me:*:part:#:{
  filter -cxww $iinc.win $iinc.win $chan *
}

;;; <Doc>
;; Fermeture d'irc: Fermeture de la fenetre
on me:*:quit:{
  if ($window($iinc.win)) { 
    window -c $ifmatch 
  }
}

;;; <Doc>
;; Lorsque quelqu'un rejoint le canal, le rajouter a la fenetre iinc
on !*:join:*:{
  aline $iinc.win $chan * $nick $nickstrip($nick)
}

;;; <Doc>
;; Changement de nick d'un utilisateur: changement de son nick dans la fenetre iinc
on *:nick:{
  var %i = $fline($iinc.win,& & $nick &,0), %text 
  while (%i) { 
    %text = $fline($iinc.win,& & $nick &,%i) 
    rline $iinc.win %text $gettok($line($iinc.win,%text),1,32) * $newnick $nickstrip($newnick)
    dec %i 
  }
}

;;; <Doc>
;; Lorsque quelqu'un part du canal, effacer son entrée dans la fenêtre iinc associé au canal quitté
on !*:part:*:{
  dline $iinc.win $fline($iinc.win,$chan & $nick &,1)
}

;;; <Doc>
;; Lorsque quelqu'un quitte irc, effacer ses entrées dans la fenêtre iinc
on !*:quit:{ 
  filter -cxww $iinc.win $iinc.win & & $nick &
}

;;; <Doc>
;; Kick: Même chose que /part
on *:kick:*:{
  if ($knick != $me) { dline $iinc.win $fline($iinc.win,$chan & $knick &,1) }
  else { filter -cxww $iinc.win $iinc.win $chan * }
}

;;; <Doc>
;; Lorsqu'on joint le canal, la raw 353 (NAMES) est lancée, ajoute tous les noms dans la fenetre iinc
raw 353:*:{
  ; Si le canal n'est pas géré, ne fait rien
  if (!$hget($iinc.win, $3)) { return }
  var %re = /(?<=\s)[ $+ $prefix $+ ]*(\S*)/g
  ; Récupere les pseudos sans le prefixe
  var %text = $regsubex($4-, %re, \t), %u
  var %i = $numtok(%t,32)
  
  while (%i) {
    ; Ne garder que les nicks
    var %u = $gettok($gettok(%text, %i, 32), 1, 33)
    aline $iinc.win $3 * %u $nickstrip(%u)
    dec %i
  }
}

;;; <Doc>
;; Raw 366: Fin de NAMES: fin du processus d'ajout des noms dans la fenetre iinc
raw 366:*:{ 
  if (!$hget($iinc.win, $2)) { return } 
  .hdel $iinc.win $2 
  if ($hget($iinc.win, 0).item == 0) { hfree $iinc.win }
}

;;; <Doc>
;; Texte sur un canal: met le pseudo tout en haut de la liste de la fenetre iinc et incremente ses stats 
on *:text:*:#:{
  if ($nick == $me) { return } 
  var %text = $nickstrip($nick)
  
  if ($nick ison $chan) { 
    dline $iinc.win $fline($iinc.win,$chan & $nick %text,1) 
    iline $iinc.win 1 $chan * $nick %text
  }
}

; Meme chose pour les actions
on *:action:*:#:{
  if ($nick == $me) { return } 
  var %text = $nickstrip($nick) 
  
  if ($nick ison $chan) { 
    dline $iinc.win $fline($iinc.win,$chan & $nick %text,1) 
    iline $iinc.win 1 $chan * $nick %text
  }
}


; Lorsque le texte est envoyé, effacer le contenu sauvé
on &*:input:*:{
  $edit_clear().nobs 
  if ($timer(edbox) == $null) { edbox_chk }
}

;;; <Doc>
;; Completion tab: appelle la commande tabcomp
on *:tabcomp:#:tabcomp $1-
on *:tabcomp:?:tabcomp $1-
on *:tabcomp:*:{
  if ($editbox($active).selstart == $editbox($active).selend) {
    var %editbox = $editbox($active), %nbwds = $numtok($left(%editbox, $ifmatch), 32), %word, %active = $remove($active, $chr(32))

    if ($editContents(%active)) { %word = $remove($gettok($ifmatch, %nbwds, 32),$trig) $+ * }
    elseif (!$chanUses(%active)) {
      editContents %active %editbox
      if ($right($editbox($active), 1) == $trig) { wasCompleted %active $true }
    }
    %n = $chanUses(%active)

    if ($wordsBefore(%active)) { %nbwds = $ifmatch }
    else { wordsBefore %active %nbwds }

    return $complete_code(%editbox, %nbwds)
  }
}

#features.tabcomp end
; -------------------- FIN EVENTS ----------------


; --------------------- Editbox Checker -----------------------


#features.iinc_edbox on

; Vérifie constamment les données de l'editbox afin de signaler les changements dans celle-ci
alias edbox_chk {
  ;1.3
  ; Lance le timer
  if (!$timer(edbox)) { .timeredbox -oim 0 10 if ($isalias(edbox_chk)) edbox_chk $chr(124) else .timeredbox off }

  var %editbox = $editbox($active), %active = $remove($active,$chr(32)), %win = $window($active).wid, %text, %nocursor = $false
  ; Récupère le hash de l'editbox si il y'a
  tokenize 32 $hget(edbox, %win)

  ;1e etape: Verifier que l'editbox actuelle a changé depuis les 10 dernieres millisecondes (ajout/suppression de caracteres)
  if ($hash($editbox($active),32) != $1) {
    ; Si editbox vide, supprimer le contenu de la base et envoyer le signal "editbox vide"
    if ($hash($editbox($active),32) == $null) {
      hdel edbox $window($active).wid
      .signal -n edit_clear %active
      return
    }
    ; Sinon envoyer le signal "editbox changed"
    else {
      %text = $hash($editbox($active),32)
      .signal -n edit_change %active
      %nocursor = $true
    }
  }

  tokenize 32 $hget(edbox, %win)

  ; %ss: debut de la selection (position du curseur), %se: fin de la selection
  var %ss = $iif($editbox($active).selstart != $null, $ifmatch, 1), %se = $iif($editbox($active).selend != $null, $ifmatch, 1)
  ; %tss: début de la selection 10 ms plus tot, %tse fin de la sélection 10 ms plus tot
  var %tss = $iif($2 != $null, $ifmatch, 1), %tse = $iif($3 != $null, $ifmatch, 1)

  if (%text == $null) { %text = $1 }
  ; Mise a jour de la base
  hadd -m edbox %win %text %ss %se

  ; Si le curseur n'a pas bougé entretemps, sortir de la fonction
  if (%nocursor) return
  ; Sinon, si les positions du curseur ont changé: envoyer un signal de "curseur bougé" ou "sélection"
  if (%ss != %tss) || (%se != %tse) {
    if (%ss == %se) .signal -n edit_cursor %active %ss %se
    else .signal -n edit_select %active %ss %se
  }
}

; Met a jour les données de l'editbox
alias edbox_reset {
  var %ss = $editbox($active).selstart, %se = $editbox($active).selend, %win = $window($active).wid
  hadd -m edbox %win $hash($editbox($active),32) %ss %se
}
#features.iinc_edbox end



; ––––––––––––––––––––––––––––––––––––––––
; Fin de fichier
; ––––––––––––––––––––––––––––––––––––––––
