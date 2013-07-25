;----------------------------------------------
; Controle des options par ligne de commande
;----------------------------------------------


;Raccourci pour eviter de réecrire 50 fois la meme chose
alias -l ed {
  var %use = $ri($1,$2)
  wi $1 $2 $iif(%use == 1,0,1)
  return %use
}

; Affiche un message qui ne sera pas loggé (yo Java 'sup?)
alias -l println {
  echo -ascqng info $1-
}

; Affiche une nouvelle ligne
alias -l newline {
  println -
}

; Affiche un texte précédé et suivi d'une ligne
alias -l printtitle {
  println  $+ $1- $+ 
}

; Affiche une ligne
alias -l printline {
  println 
}

;----------------------------------------------------
; 1) Options générales (misc)
;----------------------------------------------------

;;; <Doc>
;; Modifie les options générales
;; Syntaxe: misc.options [-skuacvdpth] [<nombre>]
;; -s: ouvre les options
;; -k: active/désactive option "garder clé des canaux en mémoire"
;; -u: active/désactive option "vérifier mises à jour"
;; -a suivi d'un nombre: change la durée de l'antiidle
;; -c: active/désactive option "compteur de kicks"
;; -v: active/désactive option "vider le presse papiers"
;; -d: active/désactive option "dcc info a la fin du transfert"
;; -p: active/désactive option "afficher le splash screen"
;; -t: active/désactive option "tips au démarrage"
;; -h: afficher l'aide
alias misc.options {
  if (!$enabled(misc)) { println Fonctionnalité "misc" désactivée | return }
  newline
  if ($0 == 0) { println Syntaxe: misc.options [-skuacvdpth] [<nombre>] }
  else {
    if (h isin $1) { 
      printtitle misc.options 
      println Modifie les options générales (onglet Options Générales) 
      println Syntaxe: misc.options [-skuacvdpth] [<nombre>] 
      println -s: ouvre les options
      println -k: active/désactive option "garder clé des canaux en mémoire"
      println -u: active/désactive option "vérifier mises à jour"
      println -a suivi d'un nombre: change la durée de l'antiidle
      println -c: active/désactive option "compteur de kicks"
      println -v: active/désactive option "vider le presse papiers"
      println -d: active/désactive option "dcc info a la fin du transfert"
      println -p: active/désactive option "afficher le splash screen"
      println -t: active/désactive option "tips au démarrage"
      println -h: afficher l'aide
      printline 
    }
    if (k isin $1) { var %use = $ed(misc,keepkey) | println Les clés des canaux $iif(%use == 0,seront,ne seront plus) automatiquement rajoutées lors de l'entrée sur un canal protégé par une clé (mode +k). }
    if (u isin $1) { var %use = $ed(misc,lookupdates) | println Les mises à jour du script $iif(%use == 0,seront,ne seront plus) vérifiées au démarrage. }
    if (a isin $1) { 
      if ($2) && ($2 isnum 1-9999) { println Le temps d'idle sera réinitialisé toutes les $2 secondes. | wi misc antiidle $2 }
      else { println La réinitialisation automatique du temps d'idle est $iif($ed(misc,antiidleuse) == 0,activée.,désactivée.) }
    }
    if (c isin $1) { var %use = $ed(misc,kickcount) | println L'affichage du compteur de kicks est à présent $iif(%use == 0,activé.,désactivé.) }
    if (v isin $1) { var %use = $ed(misc,clearcb) | println Le presse-papiers $iif(%use == 0,sera à présent automatiquement vidé,ne sera plus vidé) à la fermeture de mIRC. }
    if (d isin $1) { var %use = $ed(misc,dccinfo) | println Les informations du transfert $iif(%use == 0,seront à présent,ne seront plus) affichées à la fin d'un transfert DCC. }
    if (p isin $1) { var %use = $ed(misc,splash) | println Vous avez $iif(%use == 0,activé,désactivé) l'affichage du splash screen au démarrage. }
    if (t isin $1) { var %use = $ed(misc,tips) | println Les astuces du jour (tips) $iif(%use == 0,seront,ne seront plus) affichées au démarrage. }
    if (s isin $1) { setup -c Générales }
  }
  newline
}

;;; <Doc>
;; Change le format des messages publics
;; Syntaxe: misc.format [-sevh] [format]
;; -s: ouvre les options
;; -v: visualise le format actuel
;; -e [format] : change le format
;; -h: afficher l'aide
alias misc.format {
  if (!$enabled(misc)) { println Fonctionnalité "misc" désactivée | return }
  newline
  if ($0 == 0) { println Syntaxe: misc.format [-sevh] [format] }
  else {
    if (h isin $1) { 
      printtitle misc.format 
      println Change le format des messages publics (onglet Options Générales) 
      println Syntaxe: misc.format [-sevh] [format] 
      println -s: ouvre les options
      println -v: visualise le format actuel
      println -e [format] : change le format
      println -h: afficher l'aide
      printline 
    }
    if (v isin $1) { println Format des messages publics: $ri(misc,amsg) }
    elseif (e isin $1) && ($2-) { println Le format des messages publics est à présent: $2- | wi misc amsg $2- }
    if (s isin $1) { setup -c Générales }
  }
  newline
}

;;; <Doc>
;; Modifie le type de masque utilisé pour les bans/ignores
;; Syntaxe: misc.masks [-sbih] [<nombre>]
;; -s : Ouvre les options
;; -b : Modifie le masque de ban avec le type <nombre>
;; -i : Modifie le masque d'ignore avec le type <nombre>
;; -h : afficher l'aide
alias misc.masks {
  newline
  if ($0 == 0) { println Syntaxe: misc.masks [-sbih] [<nombre>] }
  else {
    if (h isin $1) { 
      printtitle misc.masks 
      println Modifie le type de masque utilisé pour les bans/ignores (onglet Options Générales) 
      println misc.masks [-sbih] [<nombre>] 
      println -s : Ouvre les options
      println -b : Modifie le masque de ban avec le type <nombre>
      println -i : Modifie le masque d'ignore avec le type <nombre>
      println -h : afficher l'aide
      printline 
    }
    if (b isin $1) { println Le masque de bans est à présent $mask(nick!user@host.com,$$2) | wi masks banmask $$2 }
    if (i isin $1) { println Le masque d'ignore est à présent $mask(nick!user@host.com,$$2) | wi masks ignoremask $$2 }
    if (s isin $1) { setup -c Générales }
  }
  newline
}

;;; <Doc>
;; Modifie les options des highlights
;; Syntaxe: misc.highlights [-saonih]
;; -s : Ouvre les options
;; -a : Active/Désactive l'affichage des highlights dans la fenêtre active.
;; -o : Active/Désactive l'affichage des highlights dans une fenêtre séparée.
;; -n : Active/Désactive l'affichage des notices dans une fenêtre spécifique.
;; -i : Active/Désactive l'affichage des services dans une fenêtre séparée.
;; -h : afficher l'aide
alias misc.highlights {
  if (!$enabled(misc)) { println Fonctionnalité "misc" désactivée | return }
  newline
  if ($0 == 0) { println Syntaxe: misc.highlights [-saonih] }
  else {
    if (h isin $1) { 
      printtitle misc.highlights 
      println Modifie les options des highlights (onglet Options Générales )
      println misc.highlights [-saonih] 
      println -s : Ouvre les options
      println -a : Active/Désactive l'affichage des highlights dans la fenêtre active.
      println -o : Active/Désactive l'affichage des highlights dans une fenêtre séparée.
      println -n : Active/Désactive l'affichage des notices dans une fenêtre spécifique.
      println -i : Active/Désactive l'affichage des services dans une fenêtre séparée.
      println -h : afficher l'aide
      printline 
    }
    if (a isin $1) { var %use = $ed(misc,hlactive) | println Les highlights $iif(%use == 0,seront,ne seront plus) affichés dans la fenêtre active. }
    if (o isin $1) { var %use = $ed(misc,hlother) | println Les highlights $iif(%use == 0,seront,ne seront plus) affichés dans une fenêtre séparée. }
    if (n isin $1) { var %use = $ed(misc,noticeoter) | println Les notices $iif(%use == 0,seront,ne seront plus) affichées dans une fenêtre spécifique. }
    if (i isin $1) { var %use = $ed(misc,serviceswin) | println Les notices des services IRC $iif(%use == 0,seront,ne seront plus) affichées dans une fenêtre spécifique. }
    if (s isin $1) { setup -c Générales }
  }
  newline
}

;;; <Doc>
;; Actions sur les touches FN
;; Syntaxe: fkeys.keys [-s(f/e/d/c/r/a)h] [<fn>] [<commande> $chr(1) <description>]
;; -s : ouvre les options
;; -f <fn> : recuperer les informations du raccourci
;; -e <fn> <commande> $chr(1) <description>: modifie la touche <fn> avec la <commande> suivie ou non de la <description>
;; -d <fn> : efface le raccourci <fn>
;; -c : efface tous les raccourcis
;; -r <fn> : restaurer la touche <fn> par défaut
;; -a : appliquer tous les raccourcis
;; -h : afficher l'aide
alias fkeys.keys {
  if (!$enabled(fkeys)) { println Fonctionnalité "fkeys" désactivée | return }
  newline
  if ($0 == 0) { println Syntaxe: fkeys.keys [-sfedcrah] [<fn>] [<commande> $ $+ chr(1) <description>] }
  else {
    if (h isin $1) {
      printtitle fkeys.keys
      println Actions sur les touches FN
      println Syntaxe: fkeys.keys [-s(f/e/d/c/r/a)h] [<fn>] [<commande> $ $+ chr(1) <description>]
      println -s : ouvre les options
      println -f <fn> : recuperer les informations du raccourci
      println -e <fn> <commande> $chr(1) <description>: modifie la touche <fn> avec la <commande> suivie ou non de la <description>
      println -d <fn> : efface le raccourci <fn>
      println -c : efface tous les raccourcis
      println -r <fn> : restaurer la touche <fn> par défaut
      println -a : tout restaurer par défaut
      println -h : afficher l'aide
      printline
    }
    if ($regex($1,/[fedr]/)) { 
      if (!$2) { println Syntaxe: fkeys.keys [-(f/e/d/r)] <fn> [<commande> $ $+ chr(1) <description>] }
      else {
        var %info = $fkeys.readKey($2), %opts = $1, %key = $2, %params = $3-
        if (!%info) { println Erreur: $2 n'est pas un raccourci valable! }
        else {
          tokenize 1 %info
          var %f = $replace($1,S,Shift+,C,Ctrl+), %cmd = $2, %desc = $3
          
          if (f isin %opts) {
            if (%cmd) { println La commande $qt(%cmd) est assignée au raccourci %f $+ . | if (%desc) { println Description: %desc } }
            else { println Le raccourci %f n'a pas de commande assignée. }
          }
          elseif (e isin %opts) {
            fkeys.setKey %key %params
            println Le raccourci %f s'est vu assigner la commande $gettok(%params,1,1) $+ .
            if ($gettok(%params,2,1)) { println Description: $ifmatch }
          }
          elseif (d isin %opts) {
            fkeys.setKey %key
            println Le raccourci %f a été effacé.
          }
          elseif (r isin %opts) {
            var %defkey = $fkeys.readDefKey(%key)
            fkeys.setKey %key $gettok(%defkey,2-,1)
            println Le raccourci %f a été restauré à sa valeur par défaut.
          }
        }
      }
      loadFkeysAliases
    }
    elseif ($regex($1,/[ca]/)) {
      var %keys = F1 F2 F3 F4 F5 F6 F7 F8 F9 F10 F11 F12 SF1 SF2 SF3 SF4 SF5 SF6 SF7 SF8 SF9 SF10 SF11 SF12 CF1 CF2 CF3 CF4 CF5 CF6 CF7 CF8 CF9 CF10 CF11 CF12
      var %i = 1
      while ($gettok(%keys,%i,32)) {
        var %key = $ifmatch
        fkeys.setKey %key $iif(a isin $1,$gettok($fkeys.readDefKey(%key),2-,1))
        inc %i
      }
      println Tous les raccourcis FN ont été $iif(a isin $1,restaurés à leur valeur par défaut,effacés) $+ .
      loadFkeysAliases
    }
    if (s isin $1) { setup -c Touches FN }
  }
  newline
}


;;; <Doc>
;; Actions sur les serveurs favoris
;; Syntaxe: servers.favs [-sarpeh] [<nom>] [<option> <valeur>]
;; -s : ouvre les options
;; -a <nom> : ajouter le serveur <nom> à la liste des serveurs favoris
;; -r <nom> : enlever le serveur <nom> de la liste des serveurs favoris
;; -p <nom> : affiche les infos du serveur favori <nom>
;; -e <nom> <option> <valeur> : modifie les options du serveur <nom>:
;; Les options sont: realname, email, nick, anick, port, identd, aconnect, invisible, ssl, reconnect, perform
;; -h : afficher l'aide
alias servers.favs {
  if (!$enabled(serv)) { println Fonctionnalité "servers" désactivée | return }
  newline
  if ($0 == 0) { println Syntaxe: servers.favs [-sarpeh] [<nom>] [<option> <valeur>] }
  else {
    if (h isin $1) {
      printtitle servers.favs
      println Actions sur les serveurs favoris
      println Syntaxe: servers.favs [-sarpeh] [<nom>] [<option> <valeur>]
      println -s : ouvre les options
      println -a <nom> : ajouter le serveur <nom> à la liste des serveurs favoris
      println -r <nom> : enlever le serveur <nom> de la liste des serveurs favoris
      println -p <nom> : affiche les infos du serveur favori <nom>
      println -e <nom> <option> <valeur> : modifie les options du serveur <nom>:
      println Les options sont: realname, email, nick, anick, port, identd, aconnect, invisible, ssl, reconnect, perform
      println -h : afficher l'aide
      printline
    }
    if (a isin $1) { 
      var %old = $ri(servers,favorites) 
      if ($istok(%old,$2,59)) { println Le serveur $2 est déjà un serveur favori. }
      else { wi servers favorites $addtok(%old,$2,59) | println Le serveur $2 a été ajouté à vos serveurs favoris }
    }
    if (r isin $1) { 
      var %old = $ri(servers,favorites) 
      if (!$istok(%old,$2,59)) { println Le serveur $2 n'est pas un serveur favori. }
      else { wi servers favorites $remtok(%old,$2,59) | println Le serveur $2 a été retiré de vos serveurs favoris }
    }
    if (p isin $1) { 
      var %old = $ri(servers,favorites) 
      if (!$istok(%old,$2,59)) { println Le serveur $2 n'est pas un serveur favori. }
      else { println $serverInfos($2) }
    }
    if (e isin $1) {
      var %old = $ri(servers,favorites) 
      if (!$istok(%old,$2,59)) { println Le serveur $2 n'est pas un serveur favori. }
      else { 
        var %opt = $3, %val = $4
        if (!$regex($3,/(realname|email|nick|anick|port|identd|aconnect|invisible|ssl|reconnect|perform)/)) { println Erreur: Le champ $3 n'existe pas }
        else {
        var %info = $ri(servers,servers. $+ $2)
        
        if (%opt == realname) { wi servers servers. $+ $2 $puttok(%info,%val,1,1) }
        elseif (%opt == email) { wi servers servers. $+ $2 $puttok(%info,%val,2,1) }
        elseif (%opt == nick) { wi servers servers. $+ $2 $puttok(%info,%val,3,1) }
        elseif (%opt == anick) { wi servers servers. $+ $2 $puttok(%info,%val,4,1) }
        elseif (%opt == port) { wi servers servers. $+ $2 $puttok(%info,%val,5,1) }
        elseif (%opt == identd) { wi servers servers. $+ $2 $puttok(%info,%val,6,1) }
        elseif (%opt == aconnect) { wi servers servers. $+ $2 $puttok(%info,%val,7,1) }
        elseif (%opt == invisible) { wi servers servers. $+ $2 $puttok(%info,%val,8,1) }
        elseif (%opt == ssl) { wi servers servers. $+ $2 $puttok(%info,%val,9,1) }
        elseif (%opt == reconnect) { wi servers servers. $+ $2 $puttok(%info,%val,10,1) }
        elseif (%opt == perform) { wi servers servers. $+ $2 $puttok(%info,%val,11,1) }
        println Le serveur favori $2 a été modifié. 
        }
      }
    }
    if (s isin $1) { setup -c Serveurs }
  }
  newline
}


;;; <Doc>
;; Change le mode de collage
;; Syntaxe: copypasta.paste [-s(b/n/d)h]
;; -s : ouvre les options
;; -b : Active le mode "Pas de C/C"
;; -n : Active le mode "C/C normal"
;; -d : Active le collage différé
;; -h : afficher l'aide
alias copypasta.paste {
  if (!$enabled(copypasta)) { println Fonctionnalité "copier/coller" désactivée | return }
  newline
  if ($0 == 0) { println Syntaxe: copypasta.paste [-s(b/n/d)h]] }
  else {
    if (h isin $1) {
      printtitle copypasta.paste
      println Change le mode de collage
      println Syntaxe: copypasta.paste [-s(b/n/d)h]
      println -s : ouvre les options
      println -b : Active le mode "Pas de C/C"
      println -n : Active le mode "C/C normal"
      println -d : Active le collage différé
      println -h : afficher l'aide
      printline
    }
    if (b isin $1) { wi copypasta paste no | println Le collage de plusieurs lignes est à présent désactivé. }
    elseif (n isin $1) { wi copypasta paste default | println Vous avez réactivé le comportement de collage par défaut. }
    elseif (d isin $1) { wi copypasta paste delay | println Vous avez activé le collage différé. }
    if (s isin $1) { setup -c Copier/Coller }
  }
  newline
}

;;; <Doc>
;; Modifie les options de C/C différé
;; Syntaxe: copypasta.delay [-sclbnh] [<nombre>]
;; -s : ouvre les options
;; -c <nombre> : Change la valeur du découpage par lignes
;; -l <nombre> : Change la valeur du nombre de lignes minimum
;; -b <nombre> : Change la valeur du nombre d'octets minimum
;; -n : Active/Désactive la notification
;; -h : afficher l'aide
alias copypasta.delay {
  if (!$enabled(copypasta)) { println Fonctionnalité "copier/coller" désactivée | return }
  newline
  if ($0 == 0) { println Syntaxe: copypasta.delay [-sclbnh] [<nombre>] }
  else {
    if (h isin $1) {
      printtitle copypasta.delay
      println Modifie les options de C/C différé
      println Syntaxe: copypasta.delay [-sclbnh] [<nombre>]
      println -s : ouvre les options
      println -c <nombre> : Change la valeur du découpage par lignes
      println -l <nombre> : Change la valeur du nombre de lignes minimum
      println -b <nombre> : Change la valeur du nombre d'octets minimum
      println -n : Active/Désactive la notification
      println -h : afficher l'aide
      printline
    }
    if (c isin $1) { wi copypasta delay $$2 | println Le collage sera différé à raison de $2 ms par ligne. }
    if (l isin $1) { wi copypasta lines $$2 | println Le collage sera différé si le nombre de lignes dépasse $2 . }
    if (b isin $1) { wi copypasta bytes $$2 | println Le collage sera différé si le nombre de caractères dépasse $2 . }
    if (n isin $1) { var %use = $ed(copypasta,notify) | println Vous avez $iif(%use == 0,activé,désactivé) les notifications de collage différé. }
    if (s isin $1) { setup -c Copier/Coller }
  }
  newline
}


;;; <Doc>
;; Modifie les options de C/C
;; Syntaxe: copypasta.options [-sckveh] [<nombre>]
;; -s : ouvre les options
;; -c [<nombre>] : Active/Désactive le coupage de lignes, à raison de <nombre> caractères par ligne si spécifié.
;; -k : Active/Désactive le stripping des codes couleurs
;; -v : Active/Désactive le stripping des codes couleurs uniquement en cas de mode +c
;; -e : Active/Désactive le collage dans l'editbox
;; -h : afficher l'aide
alias copypasta.options {
  if (!$enabled(copypasta)) { println Fonctionnalité "copier/coller" désactivée | return }
  newline
  if ($0 == 0) { println Syntaxe: copypasta.options [-sckveh] [<nombre>] }
  else {
    if (h isin $1) {
      printtitle copypasta.options
      println Modifie les options de C/C
      println Syntaxe: copypasta.options [-sckveh] [<nombre>]
      println -s : ouvre les options
println -c [<nombre>] : Active/Désactive le coupage de lignes, à raison de <nombre> caractères par ligne si spécifié.
println -k : Active/Désactive le stripping des codes couleurs
println -v : Active/Désactive le stripping des codes couleurs uniquement en cas de mode +c
println -e : Active/Désactive le collage dans l'editbox
println -h : afficher l'aide
      printline
    }
    if (c isin $1) { var %use = $ed(copypasta,crop) | println Vous avez $iif(%use == 0,activé,désactivé) le coupage des lignes à coller. | if ($2 isnum) { wi copypasta cropbytes $2 | println Les lignes à coller seront coupées à raison de $2 caractères par ligne. } }
    if (k isin $1) { var %use = $ed(copypasta,strip) | println Les codes couleurs sont à présent $iif(%use == 0,retirés,non retirés) du texte à coller. }
    if (v isin $1) { var %use = $ed(copypasta,strip.cmode) | println Les codes couleurs sont à présent $iif(%use == 0,retirés,non retirés) du texte à coller uniquement lorsque le canal est en mode +c (codes interdits). }
    if (e isin $1) { var %use = $ed(copypasta,editbox) | println Le texte sera à présent collé $iif(%use == 0,uniquement dans l'editbox,sur le canal directement) . }
    if (s isin $1) { setup -c Copier/Coller }
  }
  newline
}


; Active/desactive le logging.
; Syntaxe: activeLog [-soe(t/r/m/c)] [highlight]
; Si les options sont présentes, n'active/desactive pas le logging mais:
; -s: ouvre les options
; -o: active/desactive option "op"
; -e: active/desactive option "events" 
; -t suivi du highlight: ajoute un highlight
; -r suivi du highlight: supprime un highlight
; -m suivi du highlight 1 et du highlight 2: modifie un highlight par un autre highlight
; -c: supprime tous les highlights
; Note: t, r, m et c ne sont pas cumulatifs (i.e n'utiliser que l'un d'entre eux)
alias activeLog { 
  if ($0 == 0) {
    var %use = $enableDisable(awaylog,use)
    echo -sc info Away Logging $iif(%use == 1,désactivé,activé) 
  }
  else {
    if (o isin $1) { var %use = $enableDisable(awaylog,op) | echo -sc info Les kicks/bans/topics/modes sur les canaux où vous êtes op $iif(%use == 1,ne seront plus enregistrés,seront enregistrés) lorsque vous êtes absent. }
    if (e isin $1) { var %use = $enableDisable(awaylog,events) | echo -sc info Les évènements $iif(%use == 1,ne seront plus enregistrés,seront enregistrés) lorsque vous êtes absent. }
    if (t isin $1) && ($2) { var %use = $ri(awaylog,triggers) | wi awaylog triggers $addtok(%use,$2-,59) | if (!$istok(%use,$2-,59)) { echo -sc info Highlight $qt($2-) ajouté à la liste des highlights. } } 
    else if (r isin $1) && ($2) { var %use = $ri(awaylog,triggers) | wi awaylog triggers $remtok(%use,$2-,1,59) | if ($istok(%use,$2-,59)) { echo -sc info Highlight $qt($2-) supprimé de la liste des highlights. } } 
    else if (m isin $1) && ($2) { var %use = $ri(awaylog,triggers) | wi awaylog triggers $$reptok(%use,$2-,$?="Nouveau highlight",1,59) | if ($istok(%use,$2-,59)) { echo -sc info Highlight $qt($2-) remplacé par $qt($!) de la liste des highlights. } }
    else if (c isin $1) { var %use = $?!="Supprimer tous les highlights?" | if (%use == $true) { wi awaylog triggers $null | echo -sc info Liste des highlights vidée. } }
    if (s isin $1) { setup -c Away Mode|Logging } 
  }
}

; Active/desactive le répondeur
; Syntaxe: [-sqc(e/r/m/c)] [canal/query]
; Si les options sont présentes, n'active/ne désactive pas le répondeur mais:
; -s: ouvre les options
; -q: active/desactive le répondeur dans les queries
; -a: switch entre "tous les canaux"/"canal actif seulement"
; -e suivi du canal/query à exclure: ajoute une exclusion
; -r suivi du canal/query à exclure: supprime une exclusion
; -m suivi du canal/query à exclure: modifie une exclusion par une autre
; -c: vide la liste des exclusions
; Note: e, r, m et c ne sont pas cumulatifs (i.e n'utiliser que l'un d'entre eux)
alias activeMess {
  if ($0 == 0) {
    var %use = $enableDisable(awaymess,use)
    echo -sc info Répondeur $iif(%use == 1,désactivé,activé) 
  }
  else {
    if (q isin $1) { var %use = $enableDisable(awaymess,query) | echo -sc info Les messages de répondeur $iif(%use == 1,ne seront plus envoyés,seront à présent envoyés) dans les queries. }
    if (a isin $1) { var %use = $ri(awaymess,channel) | wi awaymess channel $iif(%use == all,active,all) | echo -sc info Les messages de répondeur seront envoyés $iif(%use == all,sur le canal actif seulement.,sur tous les canaux.) }
    if (e isin $1) && ($2) { var %use = $ri(awaymess,channels) | wi awaymess channels $addtok(%use,$2-,59) | if (!$istok(%use,$2-,59)) { echo -sc info Canal/Query $qt($2-) ajouté à la liste des exclusions. } } 
    else if (r isin $1) && ($2) { var %use = $ri(awaymess,channels) | wi awaymess channels $remtok(%use,$2-,1,59) | if ($istok(%use,$2-,59)) { echo -sc info Canal/Query $qt($2-) supprimé de la liste des exclusions. } } 
    else if (m isin $1) && ($2) { var %use = $ri(awaymess,channels) | wi awaymess channels $$reptok(%use,$2-,$?="Nouveau canal/query",1,59) | if ($istok(%use,$2-,59)) { echo -sc info Canal/Query $qt($2-) remplacé par $qt($!) de la liste des exclusions. } }
    else if (c isin $1) { var %use = $?!="Supprimer toutes les exclusions?" | if (%use == $true) { wi awaymess channels $null | echo -sc info Liste des exclusions vidée. } }
    if (s isin $1) { setup -c Away Mode|Messages } 
  }
}

; Modifie le menu "Away Nicknames": ajoute/supprime des serveurs et change les nicks par défaut/away
; Syntaxe: awayNicks -(s/r/d/a) [serveur] [nick]
; -s : Ouvre les options
; -e : Ajoute un serveur, suivi ou non des infos du nick par défaut et nick away
; -r : Supprime un serveur
; -d : Modifie le nick par défaut du serveur selectionné
; -a : Modifie le nick away du serveur donné (si aucun nick par défaut, set aussi celui par défaut)
alias awayNicks {
  if ($0 < 2) { echo -aec info * /awaynicks: Not enough parameters | halt } 
  if (e isin $1) && ($2) { var %use = $ri(nicks,servers) | wi nicks servers $addtok(%use,$2-,59) | if (!$istok(%use,$2-,59)) { echo -sc info Serveur $qt($2-) ajouté. } } 
  else if (r isin $1) && ($2) { var %use = $ri(nicks,servers) | wi nicks servers $remtok(%use,$2-,1,59) | if ($istok(%use,$2-,59)) { remi nicks nicks. $+ $2 | echo -sc info Serveur $qt($2-) supprimé. } } 
  elseif (d isin $1) && ($2) && ($3) { var %use = $ri(nicks,nicks. $+ $2) | wi nicks nicks. $+ $2 $3 $+  $+ $gettok(%use,2,3) | echo -sc info Nick par défaut du serveur $qt($2) remplacé par $qt($3) }
  elseif (a isin $1) && ($2) && ($3) { var %use = $ri(nicks,nicks. $+ $2) | wi nicks nicks. $+ $2 $iif($gettok(%use,1,3),$ifmatch,$3) $+  $+ $3 | echo -sc info Nick away du serveur $qt($2) remplacé par $qt($3) }
  if (s isin $1) { setup -c Away Mode|Autres }
}

; Active/désactive l'autoaway et change certaines options du menu Away|Autres
; Syntaxe: autoAway [-socbmna] [autoawaytime]
; Si les options sont présentes, n'active/ne désactive pas le répondeur mais:
; -s: ouvre les options
; -o: active/desactive l'affichage des messages de répondeur des autres users
; -c: active/desactive la conservation du statut away après reconnexion
; -b: switch entre "ancien pseudo/pseudo par défaut" pour le pseudo de fin d'away
; -m: active/desactive l'envoi des messages d'absent en cas d'auto-away
; -n: active/desactive la fenetre de notification avant la mise en auto-away
; -a: change la valeur d'idle avant la mise en auto-away (en minutes)
alias autoAway {
  if ($0 == 0) { var %use = $enableDisable(awaymisc,autoawayuse) | echo -sc info Le mode away automatique est à présent $iif(%use == 1,désactivé,activé) }
  else {
    if (o isin $1) { var %use = $enableDisable(awaymisc,noothers) | echo -sc info Les messages de répondeur des autres users sont à présents $iif(%use == 1,non affichés,affichés). }
    if (c isin $1) { var %use = $enableDisable(awaymisc,awayconnect) | echo -sc info Le mode away $iif(%use == 1,n'est plus gardé,est gardé) lors des reconnexions. }
    if (b isin $1) { var %use = $ri(awaymisc,backnick) | wi awaymisc backnick $iif(%use == old,default,old) | echo -sc info Le pseudo de retour est à présent $iif(%use == old,le pseudo par défaut,l'ancien pseudo). }
    if (m isin $1) { var %use = $enableDisable(awaymisc,nomessage) | echo -sc info Les messages de répondeur sont $iif(%use == 1,désactivés,activés) si auto-absent. }
    if (n isin $1) { var %use = $enableDisable(awaymisc,notify) | echo -sc info La notification avant l'autoaway est $iif(%use == 1,désactivée,activée). }
    if (a isin $1) && ($2) && ($2 isnum) { wi awaymisc autoaway $2 | echo -sc info Le temps d'activation de l'autoaway est à présent de $calc($2 * 60) secondes. }
    if (s isin $1) { setup -c Away Mode|Autres }
  }
}


; ––––––––––––––––––––––––––––––––––––––––
; Fin de fichier
; ––––––––––––––––––––––––––––––––––––––––
