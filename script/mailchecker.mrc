; ––––––––––––––––––––––––––––––––––––––––
; Mail Checker
; ––––––––––––––––––––––––––––––––––––––––

#features on
ON *:START:{
  if ($hget(groups,mail) == $null) { hadd -m groups mail 1 }
  if ($hget(groups,mail) == 1) { 
    splash_text 3 Chargement du script $nopath($script) ...
    .enable #features.mail

    if ($ri(mails,use) == 1) { 
      var %time = $ri(mails,time)
      .timermailcheck 0 $calc(%time * 60) checkMail
    }
  }
  else { .disable #features.mail }
}

ON *:UNLOAD:{
  if ($hget(groups,mail)) { hadd groups mail 0 }
  .timermailcheck off
}

#features end

; Lit une propriété dans le fichier temporaire mails.ini qui contient le nombre de mails non lus des comptes mails configurés
; $1: section, $2: propriété
alias -l rmi {
  var %f = $qt(data/mails.ini)
  if (!$exists(%f)) { return }

  return $readini(%f,$$1,$$2)
}

; Ecrite une propriété dans le fichier temporaire mails.ini
alias -l wmi {
  var %f = $qt(data/mails.ini)
  if (!$exists(%f)) { write -c %f }
  writeini %f $$1 $$2 $3-
}

; Efface une propriété/section dans le fichier temporaire mails.ini
alias -l remmi {
  var %f = $qt(data/mails.ini)
  if (!$exists(%f)) { write -c %f }
  remini %f $$1 $2
}

; Verifie la présence de nouveaux mails 
alias checkMail {
  if (!$enabled(mail)) { return }

  var %mails = $ri(mails,accounts)
  var %i = 1
  while ($gettok(%mails,%i,59)) {
    var %mail = $v1, %mailinfo = $ri(mails,mail. $+ %mail)
    if (%mailinfo) {
      tokenize 1 %mailinfo
      var %type = $1, %host = $2, %name = $3, %pass = $decode($4), %ssl = $iif($sslready,$5,0)
      var %sockname = $+(mailcheck.,%type,.,%mail)
      var %defport = $iif($1 == pop3,$iif(%ssl == 1,995,110),$iif(%ssl == 1,993,143))
      var %address = $gettok(%host,1,58), %port = $iif($gettok(%host,2,58) isnum 1024-65535,$v1,%defport)

      if (%address) && (%port) && (%sockname) { 
        ; Ouvre le socket pour checker les nouveaux mails
        sockreopen $iif(%ssl,-e) %sockname %address %port
        ; Store le nom d'utilisateur et le mot de passe
        sockmark %sockname $buildtok(1,%mail,%pass)
      }
      else { theme.error Certaines informations du compte %mail sont manquantes ou erronées. | halt }
    }
    inc %i
  }
}

; ferme la socket, unset les variables specifiques et met le statut à erreur
alias -l mail.cancel {
  if ($sock(mailcheck.*,0) == 1) { mail.notify }

  theme.error Connexion au serveur mail $gettok($sockname,3-,46) échouée! (Message: $sock($sockname).wsmsg $+ )
  wmi mails. $+ $gettok($sockname,3-,46) status -ERR
  remmi mails. $+ $gettok($sockname,3-,46) step
  sockclose $sockname
  .timer $+ $sockname off
}

; Meme chose que mail.cancel mais ne se produit qu'en cas de timeout
alias -l mail.timeout {
  if ($sock(mailcheck.*,0) == 1) { mail.notify }

  wmi mails. $+ $gettok($1,3-,46) status -ERR
  remmi mails. $+ $gettok($1,3-,46) step
  if ($sock($1)) sockclose $1
  .timer $+ $1 off
}

; Affiche le nombre de messages non lus
alias mail.notify {
  var %mails = $ri(mails,accounts)
  var %nbmails = 0
  var %message = Vous avez <nbmails> nouveaux messages, dont
  var %tip = Vous avez <nbmails> nouveaux messages!
  var %erreur

  ; Creation des messages à afficher
  if (%mails) {
    var %i = 1
    while ($gettok(%mails,%i,59)) {
      var %mail = $v1
      if (+OK* iswm $rmi(mails. $+ %mail,status)) {
        var %n = $rmi(mails. $+ %mail,unread)
        %message = %message %n messages pour l'adresse %mail $+ ,
        %nbmails = $calc(%nbmails + %n)
      }
      else { %erreur = $iif(%erreur,$v1,Note: Erreur lors de la connexion aux comptes:) %mail - }
      inc %i
    }
    %message = $left(%message,-1) $+ .

    if (%nbmails == 0) {
      %message = Vous n'avez pas de nouveaux messages.
      %tip = Pas de nouveaux messages.
    }
    else { 
      %message = $replace(%message,<nbmails>,%nbmails)
      %tip = $replace(%tip,<nbmails>,%nbmails) 
      if (%nbmails == 1) { %message = $replace(%message,nouveaux,nouveau,messages,message) | %tip = $replace(%tip,nouveaux,nouveau,messages,message) }
    }
  }
  else {
    %message = Vous n'avez pas configuré de comptes mails.
    %tip = Aucun compte mail configuré
  }

  mail.printmessages $buildtok(1,%message,%tip,%erreur)
  ; Infobox
  if ($ri(mails,infobox)) { noop $tb.refMails(%nbmails) }
}


; Afficher les mails selon les options
; $1: message a afficher, $2: tip a afficher, $3: erreur (si il y'a erreur)
alias -l mail.printmessages {
  tokenize 1 $1-
  var %options = $ri(mails,notify), %sound = $ri(mails,sound)

  if (b isin %options) { beep }
  if (e isin %options) { theme.echo -s  $+ $color(info) $+ $1 | if ($3) theme.error -s  $+ $color(info2) $+ $3 }
  if (i isin %options) { noop $pftip(Nouveaux messages,$2) }
  if (n isin %options) && ($status == connected) { notice $me $1 | if ($3) notice $me $3 }
  if (%sound) { .splay $qt($v1) }
}

; Marque tous les messages comme lus
alias mail.markallread {
  if ($$yndialog(Marquer tous les messages comme lus?)) {
    var %mails = $ri(mails,accounts)
    if (%mails) {
      var %i = 1
      while ($gettok(%mails,%i,59)) {
        var %mail = $v1
        wmi mails. $+ %mail unread 0
        inc %i
      }
    }
    checkmail
  }
}


; ----------------------------------------
; Socket events
; ----------------------------------------


#features.mail on

; Verification d'erreur
on *:sockopen:mailcheck.*:{
  if ($sockerr) { mail.cancel }
  wmi mails. $+ $gettok($sockname,3-,46) step 1

  ; Timeout (ne déclenche pas l'affichage)
  .timer $+ $sockname 1 10 mail.timeout $sockname
}


; Verification des mails pop3
on *:sockread:mailcheck.pop3.*:{
  if ($sockerr) { mail.cancel }

  var %line, %mail = $gettok($sockname,3-,46), %step = $rmi(mails. $+ %mail,step)
  sockread %line

  if (+OK* iswm %line) {
    tokenize 1 $sock($sockname).mark

    if (%step == 1) { sockwrite -n $sockname USER $gettok($1,1,64) | wmi mails. $+ %mail step $calc(%step + 1) }
    elseif (%step == 2) { sockwrite -n $sockname PASS $2 | wmi mails. $+ %mail step $calc(%step + 1) }
    elseif (%step == 3) { sockwrite -n $sockname STAT | wmi mails. $+ %mail step $calc(%step + 1) }
    elseif (%step == 4) { 
      var %pop = $gettok(%line,2,32), %nmails = $rmi(mails. $+ %mail,nummails), %umails = $rmi(mails. $+ %mail,unread)
      var %unread = $iif($calc(%pop - %nmails) > 0,$v1,0)
      inc %umails %unread
      wmi mails. $+ %mail nummails %pop
      wmi mails. $+ %mail unread %umails
      wmi mails. $+ %mail status +OK
      sockwrite -n $sockname QUIT
      wmi mails. $+ %mail step $calc(%step + 1)
    }
  }
  elseif (-ERR * iswm %line) {
    sockwrite -n $sockname QUIT
    mail.cancel
  }
}

; IMAP Protocol: FIXME car pas vérifié (besoin d'un compte avec authentification basic)
on *:sockread:mailcheck.imap.*:{
  if ($sockerr) { mail.cancel }

  var %line, %mail = $gettok($sockname,3-,46), %step = $rmi(mails. $+ %mail,step)
  set -e %mail.folders 1
  sockread %line
  tokenize 1 $sock($sockname).mark

  ; 1) Authentification
  if (& OK * iswm %line) {
    if (%step == 1) { sockwrite -n $sockname * LOGIN $gettok($1,1,64) $2 | wmi mails. $+ %mail step $calc(%step + 1) }
    elseif (%step == 2) { sockwrite -n $sockname * LIST "" * | wmi mails. $+ %mail step $calc(%step + 1) }
  }
  ; 2) Comptage des mails
  elseif ($regex(imap,%line,/^\* (\d+) RECENT$/)) {
    var %unread = $regml(imap,1)
    var %nfold = $rmi(mails. $+ %mail,folders), %umails = $rmi(mails. $+ %mail,unread)
    inc %umails %unread
    dec %nfold
    wmi mails. $+ %mail unread %umails
    wmi mails. $+ %mail folders %nfold
    if (%nfold == 1) { wmi mails. $+ %mail status +OK | sockwrite -n $sockname * LOGOUT }
  }
  ; 3) Sous dossiers
  elseif ($regex(imapfolders,%line,/^\* LIST \(.*\) (?:".+"|[^ ]+) (".+"|[^ ]+)/)) && (%mail.folders) {
    var %folder = $regml(imapfolders,1)
    var %nfold = $rmi(mails. $+ %mail,folders)
    inc %nfold
    wmi mails. $+ %mail folders %nfold
    sockwrite -n $sockname * EXAMINE %folder
  }
  elseif (%line == * OK LIST completed.) { unset %mail.folders }
  elseif ($regex(imaperr,%line,/^\* (?:NO|BAD) (.+)/)) { 
    theme.error Erreur: $regml(imaperr,1) ! 
    mail.cancel
  }
}

; Fermeture de la socket et récupération des informations recuperees
on *:sockclose:mailcheck.*:{
  ; Si c'est le dernier socket ouvert, on affiche les notifs
  if ($sock(mailcheck.*,0) == 1) { mail.notify }

  remmi mails. $+ $gettok($sockname,3-,46) step
  remmi mails. $+ $gettok($sockname,3-,46) folders
  .timer $+ $sockname off
  sockclose $sockname
}

#features.mail end

menu menubar,status {
  $iif($enabled(mail),Mails)
  .Vérifier la présence de nouveaux mails:checkMail
  .Ouvrir le client de messagerie:run $$ri(mails,client)
  .Marquer tous les messages comme lus:mail.markallread
}
; ––––––––––––––––––––––––––––––––––––––––
; Fin de fichier
; ––––––––––––––––––––––––––––––––––––––––
