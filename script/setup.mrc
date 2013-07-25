; -------------------------------------------------
; Options du programme
; -------------------------------------------------


; Ouvre les options
; Syntaxe: setup [-c <section>] : Ouvre les options a la section souhaitée
; Dans le cas des sous sections, utiliser la syntaxe <section>|<sous-section>
alias setup {
  opendialog -md settings
  if ($1 == -c) {
    tokenize 124 $2-
    if ($2) { var %w = $didwm(settings,1,* $+ $2 $+ *) }
    else { var %w = $didwm(settings,1,* $+ $1 $+ *) }
    did -c settings 1 %w
    changeSection $did(settings,1,%w).seltext
  }
}

; Affiche la section sélectionnée
alias -l changeSection {
  var %section = $remove($1-,$chr(160))
  var %t = $sectionToTab(%section) %section

  tokenize 32 %t
  if ($1 == 10) { did -ra settings 11 $2- }
  did -f settings $1 $+ ,1
  dialog -t settings PF Script $pfversion Préférences - $2- [/setup]
}

dialog settings {
  title "Options du PF Script"
  size -1 -1 607 430
  option pixels
  icon images/masterIRC2.ico, 0

  list 1, 3 6 126 384, size
  button "OK", 2, 3 394 124 24, ok

  ;Script logo
  tab "script", 100, -100 -100 1000 1000
  box "Pokemon France Script", 110, 132 4 471 328, tab 100
  icon 111, 197 25 330 246, mirc.exe, 0, tab 100 hide
  text "Options du PF Script", 112, 192 275 400 50, tab 100

  ;Away logging
  tab "awlog", 200, hide
  box "Away Logging", 210, 132 4 471 271, tab 200
  check "Activer l'&away logging", 211, 142 20 124 18, tab 200
  check "Logger les &évènements (join/part/nick/...)", 212, 160 56 318 18, tab 200
  check "Logger kicks,topics et bans sur les canaux où vous êtes &op", 213, 160 38 358 18, tab 200
  text "Autres highlights:", 214, 180 76 192 14, tab 200
  list 220, 178 92 292 174, tab 200 sort size extsel vsbar
  button "&Ajouter", 221, 475 90 80 24, tab 200
  button "&Editer", 222, 475 118 80 24, tab 200
  button "&Supprimer", 223, 475 146 80 24, tab 200
  button "&Vider", 224, 475 174 80 24, tab 200

  ;Away messages
  tab "awmsg", 300, hide
  box "Répondeur", 310, 132 4 471 318, tab 300
  check "Activer le &répondeur (écrit un message rappelant que vous êtes absent)", 311, 142 20 444 18, tab 300
  radio "Canal acti&f seulement", 312, 160 38 128 18, tab 300
  radio "&Tous les canaux", 313, 160 56 92 18, tab 300
  check "&Queries et chats", 314, 160 74 234 18, tab 300
  check "E&xclure les canaux/queries:", 315, 160 92 220 18, tab 300
  list 320, 160 110 250 182, tab 300 sort size extsel vsbar
  button "&Ajouter", 321, 414 110 80 24, tab 300
  button "&Editer", 322, 414 138 80 24, tab 300
  button "&Supprimer", 323, 414 166 80 24, tab 300
  button "&Vider", 324, 414 194 80 24, tab 300

  ;Away Misc
  tab "awmisc", 400, hide
  box "Pseudos en mode absent", 410, 132 4 471 92, tab 400
  text "Serveur", 411, 142 24 44 14, tab 400
  combo 412, 285 20 171 156, tab 400 sort drop
  button "+", 413, 460 20 26 20, tab 400
  button "-", 414, 486 20 26 20, disable tab 400
  text "Nick par défaut", 415, 142 46 136 14, tab 400
  edit "", 416, 284 42 173 22, tab 400 autohs limit 30
  text "Nick mode away", 417, 142 68 78 14, tab 400
  edit "", 418, 284 64 173 22, tab 400 autohs limit 30

  box "Auto-away", 420, 132 102 471 188, tab 400
  check "&Ne pas afficher les messages d'away des autres users", 421, 142 118 284 18, tab 400
  check "&Garder le mode away lors des reconnexions", 422, 142 136 240 18, tab 400
  check "&Automatiquement activer le mode away si idle de plus de ", 423, 142 154 292 18, tab 400
  edit "", 424, 432 152 46 22, tab 400 center
  text "minutes", 425, 484 156 40 14, tab 400
  check "&Désactiver le répondeur", 426, 160 174 210 18, tab 400
  check "&Prévenir avant l'auto-away", 427, 160 192 176 18, tab 400
  text "Une fois de retour, prendre:", 428, 162 212 162 14, tab 400
  radio "Pseudo par &défaut", 429, 286 230 120 18, tab 400
  radio "&Ancien pseudo", 430, 286 248 100 18, tab 400
  
  ;Messages d'away prédef
  tab "awmsg", 450, hide
  box "Messages d'absence", 460, 132 4 471 306, tab 450
  list 470, 141 20 368 282, tab 450 sort size extsel 
  button "&Ajouter", 471, 513 21 80 24, tab 450
  button "&Editer", 472, 513 53 80 24, tab 450
  button "&Supprimer", 473, 513 85 80 24, tab 450
  button "&Vider", 474, 513 109 80 24, tab 450
  button "&Défaut", 475, 513 276 80 24, tab 450

  box "Preview", 480, 132 314 471 76, tab 450
  button "", 481, 142 330 450 40, disable tab 450


  ; Raccourcis clavier
  tab "fkeys", 500
  box "Touches FN", 510, 132 4 471 368, tab 500
  list 520, 142 20 368 342, tab 500 size
  button "&Effacer", 521, 515 21 80 24, disable tab 500
  button "Effacer &tout", 522, 515 45 80 24, tab 500
  button "Par &défaut", 523, 515 77 80 24, tab 500
  button "Restau&rer tout", 524, 515 101 80 24, tab 500
  button "Appliquer", 525, 515 340 80 24, tab 500
  button "Editer", 526, 515 135 80 24, tab 500

  ; Barre de titre
  tab "titlebar", 600, hide
  box "Barre de titre personnalisée", 610, 132 4 471 148, tab 600
  check "&Activer la barre de titre personnalisée", 611, 143 20 300 18, tab 600
  check "Actualiser le &titre toutes les", 612, 163 40 150 18, tab 600
  edit "", 613, 315 38 50 22, tab 600 limit 3 center
  text "seconde(s)", 614, 369 40 54 14, tab 600
  text "Format du titre:", 615, 163 64 450 14, tab 600
  edit "", 616, 315 62 280 22, tab 600 autohs limit 300
  text "Note: Vous pouvez utiliser vos identifieurs persos dans le format ainsi que les identifieurs de base de mIRC (ex: $iif($chan,Canal: <chan>))", 617, 163 86 435 28, tab 600 
  check "&Icône personnalisée", 618, 163 128 150 14, tab 600
  edit "", 619, 315 126 260 22, tab 600 autohs read limit 300
  icon 620, 577 128 16 16, mirc.exe, 0, tab 600 small

  ;Autres options
  tab "m2", 700
  box "Options Générales", 710, 132 4 471 147, tab 700
  check "Garder les clés des canaux en &mémoire", 711, 142 21 302 14, tab 700
  check "Vérifier les mises à &jour au démarrage", 712, 142 37 226 14, tab 700
  check "Activer l'&Anti-Idle (reinitialiser le temps d'idle après", 713, 142 53 274 14, tab 700
  edit "", 714, 420 49 42 22, tab 700 center
  text "secondes d'idle)", 715, 468 53 84 14, tab 700
  check "Afficher le compteur de &kicks", 716, 142 69 200 14, tab 700
  check "Vider le &presse-papier à la fermeture", 717, 142 85 224 14, tab 700
  check "&DCC Info à la fin d'un transfert", 718, 142 101 276 14, tab 700
  check "Afficher le &splash screen", 719, 142 117 166 14, tab 700
  check "Afficher les &tips au démarrage", 720, 142 133 166 14, tab 700

  box "Format des messages publics:", 730, 132 156 471 46, tab 700
  edit "", 731, 142 172 247 22, tab 700 autohs limit 100
  button "", 732, 393 172 200 20, disable tab 700

  box "Masques", 740, 132 208 471 70, tab 700
  text "Masque de &ban:", 741, 142 228 91 14, tab 700
  text "Masque d'i&gnore:", 742, 142 252 106 14, tab 700
  combo 743, 280 224 164 140, tab 700 drop
  combo 744, 280 248 164 140, tab 700 drop

  ; Highlights
  box "Options des Highlights", 750, 132 282 471 90, tab 700
  check "Afficher &highlights dans la fenêtre active", 751, 142 300 304 14, tab 700
  check "Afficher highlights dans une &fenêtre séparée", 752, 142 316 300 14, tab 700
  check "Afficher &notices dans une fenêtre séparée", 753, 142 332 304 14, tab 700
  check "Afficher &services dans une fenêtre séparée", 754, 142 348 304 14, tab 700

  ;Protections des canaux
  tab "cprot", 800, hide
  box "Protections des canaux", 810, 132 4 471 97, tab 800
  text "Canal", 811, 160 24 84 16, tab 800
  combo 812, 338 20 200 156, tab 800 size drop
  button "&+", 813, 541 20 26 20, tab 800
  button "&-", 814, 567 20 26 20, disable tab 800
  check "Utiliser protections par &défaut sur ce canal", 815, 142 60 270 18, tab 800
  check "Utiliser protections par défaut sur &tous les canaux", 816, 142 42 270 18, tab 800
  text "Affecte aussi:", 817, 160 80 80 16, tab 800
  check "O&ps/Halfops", 818, 242 78 90 18, tab 800
  check "&Voices", 819, 334 78 84 18, tab 800

  box "Options de protection", 820, 132 105 471 252, tab 800
  list 830, 140 121 454 190, tab 800 size
  button "&Défaut", 831, 141 315 80 24, tab 800
  button "&Changer", 832, 512 315 80 24, disable tab 800

  ;Protections personnelles
  tab "pprot", 900, hide
  box "Protections personnelles", 910, 132 4 471 254, tab 900
  list 920, 139 20 455 201, tab 900 size
  button "&Défaut", 921, 139 225 80 24, tab 900
  button "&Changer", 922, 512 225 80 24, disable tab 900

  ;Exclusions
  tab "excludes", 950, hide
  box "Exclusions", 960, 132 4 471 318, tab 950
  list 970, 139 20 369 274, tab 950 sort size extsel vsbar
  button "&Ajouter", 971, 513 21 80 24, tab 950
  button "&Editer", 972, 513 53 80 24, tab 950
  button "&Supprimer", 973, 513 85 80 24, tab 950
  button "&Vider", 974, 513 117 80 24, tab 950
  check "E&xclure aussi les users de la mIRC protect list", 975, 141 298 270 18, tab 950

  ;Barre d'état
  tab "stbar", 1000, hide
  box "Status Bar", 1010, 132 4 471 378, tab 1000
  check "&Activer barre d'état perso", 1011, 142 20 140 18, tab 1000
  check "Actua&liser toutes les", 1012, 160 40 120 18, tab 1000
  edit "", 1013, 280 38 40 22, tab 1000 limit 3 center
  text "secondes", 1014, 324 42 50 16, tab 1000
  list 1020, 139 64 369 310, tab 1000 size
  button "A&jouter", 1021, 513 66 80 24, tab 1000
  button "&Editer", 1022, 513 98 80 24, tab 1000
  button "&Supprimer", 1023, 513 128 80 24, tab 1000
  button "&Vider", 1024, 513 154 80 24, tab 1000
  button "6", 1025, 513 234 80 24, tab 1000
  button "5", 1026, 513 210 80 24, tab 1000
  button "&Prédéfinis", 1027, 513 292 80 24, tab 1000
  button "&Importer", 1028, 513 318 80 24, tab 1000
  button "Sau&ver sous", 1029, 513 344 80 24, tab 1000

  ; Serveurs
  tab "servcon", 1100, hide
  box "Serveurs favoris", 1110, 132 4 471 158, tab 1100
  list 1120, 142 39 185 112, tab 1100 sort size
  button "4", 1121, 334 70 32 24, disable tab 1100
  button "3", 1122, 334 102 32 24, disable tab 1100
  list 1130, 373 40 185 112, tab 1100 size
  text "Serveurs disponibles", 1123, 142 22 185 14, tab 1100 center
  text "Serveurs favoris", 1133, 373 22 185 14, tab 1100 center
  button "5", 1131, 562 70 32 24, disable tab 1100
  button "6", 1132, 562 102 32 24, disable tab 1100

  box "Paramètres des serveurs favoris", 1140, 132 170 471 192, tab 1100
  text "Serveur", 1141, 142 190 80 14, tab 1100 hide
  text "Nom Complet", 1142, 142 190 70 14, tab 1100
  text "Adresse email", 1143, 142 212 68 14, tab 1100
  text "Pseudonyme", 1144, 142 234 68 14, tab 1100
  text "Alternatif", 1145, 142 256 56 14, tab 1100
  text "Port par défaut", 1146, 142 278 86 14, tab 1100
  text "Identd UserID", 1147, 142 300 68 14, tab 1100
  check "&Connexion au démarrage", 1148, 457 188 140 18, 3state tab 1100
  check "Mode &Invisible", 1149, 457 208 100 18, 3state tab 1100 
  check "Utiliser &SSL", 1150, 457 228 100 18, 3state tab 1100 
  check "&Reconnexion auto", 1151, 457 248 140 18, 3state tab 1100 
  check "Activer &Perform", 1152, 457 268 140 18, 3state tab 1100 
  text "Note: Laissez un champ vide pour utiliser la valeur par défaut (dans le cas des checkboxes, la valeur par défaut est représentée par le 3e état)", 1153, 142 322 404 32, tab 1100

  combo 1161, 239 186 203 160, tab 1100 sort size drop hide
  edit "", 1162, 238 186 205 22, tab 1100 autohs limit 50
  edit "", 1163, 238 208 205 22, tab 1100 autohs limit 50
  edit "", 1164, 238 230 205 22, tab 1100 autohs limit 30
  edit "", 1165, 238 252 205 22, tab 1100 autohs limit 30
  edit "", 1166, 238 274 205 22, tab 1100 autohs limit 30
  edit "", 1167, 238 296 205 22, tab 1100 autohs limit 30

  ;Messages prédéfinis de kick
  tab "kickmsg", 1200, hide
  box "Messages de Kick prédéfinis", 1210, 132 4 471 306, tab 1200
  list 1220, 141 20 368 282, tab 1200 sort size extsel 
  button "&Ajouter", 1221, 513 21 80 24, tab 1200
  button "&Editer", 1222, 513 53 80 24, tab 1200
  button "&Supprimer", 1223, 513 85 80 24, tab 1200
  button "&Vider", 1224, 513 109 80 24, tab 1200
  button "&Défaut", 1225, 513 277 80 24, tab 1200

  box "Preview", 1230, 132 314 471 66, tab 1200
  button "", 1231, 142 330 450 40, disable tab 1200

  ;  Messages prédéfinis de Quit
  tab "quitmsg", 1300, hide
  box "Messages de Quit prédéfinis", 1310, 132 4 471 306, tab 1300
  list 1320, 141 20 368 282, tab 1300 sort size extsel 
  button "&Ajouter", 1321, 513 21 80 24, tab 1300
  button "&Editer", 1322, 513 53 80 24, tab 1300
  button "&Supprimer", 1323, 513 85 80 24, tab 1300
  button "&Vider", 1324, 513 109 80 24, tab 1300
  button "&Défaut", 1325, 513 276 80 24, tab 1300

  box "Preview", 1330, 132 314 471 94, tab 1300
  button "", 1331, 142 330 450 40, disable tab 1300
  text "Astuce: Pour afficher un quit aléatoire de la liste ci-dessus, vous pouvez remplir le champ 'Quit Message' dans les Options de mIRC avec la valeur '$quitmessage' (sans guillemets).", 1332, 141 372 449 32, tab 1300  

  ;Slaps prédéfinis
  tab "slaps", 1400, hide
  box "Slaps prédéfinis", 1410, 132 4 471 306, tab 1400
  list 1420, 141 20 368 282, tab 1400 sort size extsel 
  button "&Ajouter", 1421, 513 21 80 24, tab 1400
  button "&Editer", 1422, 513 53 80 24, tab 1400
  button "&Supprimer", 1423, 513 85 80 24, tab 1400
  button "&Vider", 1424, 513 109 80 24, tab 1400
  button "&Défaut", 1425, 513 276 80 24, tab 1400

  box "Preview", 1430, 132 314 471 76, tab 1400
  button "", 1431, 142 330 450 40, disable tab 1400

  ; Idents perso
  tab "idents", 1500, hide
  box "Identifieurs personnalisés", 1510, 132 4 471 375, tab 1500
  list 1520, 141 22 370 346, tab 1500 size
  button "&Ajouter", 1521, 513 21 80 24, tab 1500
  button "&Editer", 1522, 513 53 80 24, tab 1500
  button "&Supprimer", 1523, 513 85 80 24, tab 1500
  button "&Vider", 1524, 513 109 80 24, tab 1500
  button "&Défaut", 1525, 513 346 80 24, tab 1500

  ;Nickserv
  tab "nserv", 1600, hide
  box "Services de nicks (NickServ)", 1610, 132 4 471 208, tab 1600
  text "Serveur", 1611, 142 24 86 16, tab 1600
  combo 1612, 302 20 218 400, tab 1600 size drop
  button "&+", 1613, 524 43 30 20, tab 1600
  button "&-", 1614, 556 43 30 20, disable tab 1600
  text "Nick", 1615, 142 47 48 14, tab 1600
  combo 1616, 302 43 220 22, tab 1600 drop autohs limit 30
  text "Password", 1617, 142 70 50 14, tab 1600
  edit "", 1618, 302 66 220 22, tab 1600 pass autohs limit 60
  edit "", 1619, 302 66 220 22, tab 1600 autohs limit 60 hide
  button "Afficher", 1620, 524 65 62 24, tab 1600
  button "Cacher", 1621, 524 65 62 24, tab 1600 hide
  radio "Utiliser '/&ns identify <password>'", 1622, 142 90 198 18, tab 1600 group
  radio "Utiliser '/&msg nickserv identify <password>'", 1623, 142 108 230 18, tab 1600
  check "Activer l'auto-&ghost", 1624, 142 126 244 18, tab 1600
  check "&Greet personnel", 1625, 142 146 108 18, tab 1600
  edit "", 1626, 302 144 290 22, tab 1600 autohs limit 255
  text "Preview", 1627, 157 170 108 14, tab 1600
  button "", 1628, 302 168 290 30, tab 1600 disable

  box "Actions", 1630, 132 213 470 143, tab 1600
  text "Choisissez un pseudo dans la liste précédente et effectuez les actions désirées. Notez que cela ne s'applique pas sur certains serveurs. Pour plus d'informations, tapez /ns help", 1631, 142 228 448 28, tab 1600
  button "Voir les pseudos du groupe", 1632, 142 260 150 22, tab 1600
  button "Grouper un pseudo" 1633, 300 260 140 22, tab 1600 size drop
  button "Effacer pseudo", 1634, 446 260 150 22, tab 1600
  button "Enregistrer un pseudo", 1635, 142 286 150 22, tab 1600
  button "Voir la liste des accès", 1636, 300 286 140 22, tab 1600
  button "Récupérer mot de passe", 1637, 448 286 150 22, tab 1600
  button "Changer mot de passe", 1638, 142 312 150 22, tab 1600
  button "Changer de langue", 1639, 300 312 140 22, tab 1600
  button "Changer de mail", 1640, 448 312 150 22, tab 1600


  ;Chanserv
  tab "cserv", 1650, hide
  box "Services de canaux (ChanServ)", 1660, 132 4 471 208, tab 1650
  text "Serveur", 1661, 142 24 86 16, tab 1650
  combo 1662, 302 20 218 400, tab 1650 size drop
  button "&+", 1663, 524 43 30 20, tab 1650
  button "&-", 1664, 556 43 30 20, disable tab 1650
  text "Canal", 1665, 142 47 48 14, tab 1650
  combo 1666, 302 43 220 22, tab 1650 drop autohs limit 30
  text "Password", 1667, 142 70 50 14, tab 1650
  edit "", 1668, 302 66 220 22, tab 1650 pass autohs limit 60
  edit "", 1669, 302 66 220 22, tab 1650 autohs limit 60 hide
  button "Afficher", 1670, 524 65 62 24, tab 1650
  button "Cacher", 1671, 524 65 62 24, tab 1650 hide
  radio "Utiliser '/&cs identify <password>'", 1672, 142 90 198 18, tab 1650 group
  radio "Utiliser '/&msg chanserv identify <password>'", 1673, 142 108 230 18, tab 1650
  check "Activer l'auto-&unban", 1674, 142 126 244 18, tab 1650
  check "&Greet personnel", 1675, 142 146 108 18, tab 1650
  edit "", 1676, 302 144 290 22, tab 1650 autohs limit 255
  text "Preview", 1677, 157 170 108 14, tab 1650
  button "", 1678, 302 168 290 30, tab 1650 disable

  box "Actions", 1680, 132 213 470 153, tab 1650
  text "Choisissez un canal dans la liste précédente et effectuez les actions désirées. Notez que cela ne s'applique pas sur certains serveurs. Pour plus d'informations, tapez /cs help", 1681, 142 228 448 28, tab 1650
  button "Voir la liste des accès", 1682, 142 260 150 22, tab 1650
  button "Ajouter un accès" 1683, 300 260 140 22, tab 1650 size drop
  button "Supprimer un accès", 1684, 446 258 150 22, tab 1650
  button "Voir la liste des akicks", 1685, 142 284 150 22, tab 1650
  button "Ajouter un akick" 1686, 300 284 140 22, tab 1650 size drop
  button "Supprimer un akick", 1687, 446 284 150 22, tab 1650
  button "Enregistrer un canal", 1688, 142 312 150 22, tab 1650
  button "Effacer le canal", 1689, 300 312 140 22, tab 1650
  button "Récupérer mot de passe", 1690, 448 312 150 22, tab 1650
  button "Changer mot de passe", 1691, 142 336 150 22, tab 1650
  button "Changer le topic", 1692, 300 336 140 22, tab 1650
  button "Changer de description", 1693, 448 336 150 22, tab 1650

  ;Botserv
  tab "bserv", 1700, hide
  box "Services de Bots (BotServ)", 1710, 132 4 471 208, tab 1700
  text "Serveur", 1711, 142 24 86 16, tab 1700
  combo 1712, 302 20 218 400, tab 1700 size drop
  button "&+", 1713, 524 43 30 20, tab 1700
  button "&-", 1714, 556 43 30 20, disable tab 1700
  text "Canal", 1715, 142 47 48 14, tab 1700
  combo 1716, 302 43 220 22, tab 1700 drop autohs limit 30
  text "Bot", 1717, 142 70 50 14, tab 1700
  edit "", 1718, 302 66 220 22, tab 1700 autohs limit 60
  button "Assigner", 1719, 524 65 62 24, tab 1700
  text "Note: Assurez vous d'assigner l'un des bots disponibles du serveur. Pour voir la liste des bots disponibles, tapez /bs botlist.", 1720, 142 91 460 44, tab 1700
  radio "Utiliser '/&bs assign'", 1721, 142 120 198 18, tab 1700 group
  radio "Utiliser '/&msg botserv assign'", 1722, 142 136 230 18, tab 1700
  check "Message de &Greet", 1723, 142 156 108 18, tab 1700
  edit "", 1724, 302 154 290 22, tab 1700 autohs limit 255
  text "Preview", 1725, 157 180 108 14, tab 1700
  button "", 1726, 302 178 290 30, tab 1700 disable

  box "Actions", 1730, 132 213 470 104, tab 1700
  text "Choisissez un canal dans la liste précédente et effectuez les actions désirées. Notez que cela ne s'applique pas sur certains serveurs. Pour plus d'informations, tapez /bs help", 1731, 142 228 448 28, tab 1700
  button "Voir la liste des Badwords", 1732, 142 260 150 22, tab 1700
  button "Ajouter un badword" 1733, 300 260 140 22, tab 1700 size drop
  button "Supprimer un badword", 1734, 446 260 150 22, tab 1700
  button "Désassigner le bot", 1735, 142 284 150 22, tab 1700
  button "Config. protections", 1736, 300 284 150 22, tab 1700

  ;Toolbar
  tab "tbedit", 1800, hide
  box "Toolbar", 1810, 132 4 471 408, tab 1800
  check "&Activer la barre d'outils perso", 1811, 142 20 160 18, tab 1800
  list 1820, 141 40 368 364, tab 1800 size
  button "&Ajouter", 1821, 513 42 80 24, tab 1800
  button "Séparateu&r", 1822, 513 66 80 24, tab 1800
  button "&Editer", 1823, 513 98 80 24, tab 1800
  button "&Supprimer", 1824, 513 130 80 24, tab 1800
  button "&Vider", 1825, 513 154 80 24, tab 1800
  button "5", 1826, 513 208 80 24, tab 1800
  button "6", 1827, 513 232 80 24, tab 1800
  button "&Predéfinis", 1828, 513 310 80 24, tab 1800
  button "&Importer", 1829, 513 336 80 24, tab 1800
  button "Sau&ver sous", 1830, 513 362 80 24, tab 1800

  ;Mail Checker
  tab "mail", 2000, hide
  box "Vérification de mails", 2010, 132 4 471 158, tab 2000
  check "&Activer le mail-checker", 2011, 142 20 126 14, tab 2000
  text "Vérifier toutes les", 2012, 160 38 100 14, tab 2000
  edit "", 2013, 256 36 50 20, tab 2000 limit 3 center
  text "minutes", 2014, 324 38 44 16, tab 2000
  check "Afficher le nombre de mails dans l'&infobox", 2015, 160 56 304 14, tab 2000
  text "Lors de la réception d'un nouveau mail...", 2016, 160 72 203 14, tab 2000
  check "&Emettre un bip", 2017, 178 88 120 14, tab 2000
  check "Echo &fenêtre active", 2018, 178 104 120 14, tab 2000
  check "&Infobulle", 2019, 300 88 120 14, tab 2000
  check "Envoyer &notice", 2020, 300 104 120 14, tab 2000
  check "Jouer &son personnalisé", 2021, 178 120 130 14, tab 2000
  edit "", 2022, 316 118 240 20, tab 2000 autohs limit 255 disable 
  text "Client de messagerie", 2023, 160 142 120 14, tab 2000
  edit "", 2024, 316 140 160 18, tab 2000 autohs limit 120 disable
  button "...", 2025, 480 140 25 18, tab 2000

  box "Informations du compte", 2030, 132 162 471 134, tab 2000
  text "Adresse email", 2031, 142 182 100 14, tab 2000
  combo 2032, 280 178 213 160, tab 2000 sort size drop
  button "&+", 2033, 499 178 26 20, tab 2000
  button "&-", 2034, 525 178 26 20, tab 2000
  text "Type de protocole", 2035, 142 204 100 14, tab 2000
  radio "&POP3", 2036, 280 202 50 18, tab 2000 group
  radio "&IMAP", 2037, 342 202 50 18, tab 2000
  text "Serveur[:port]", 2038, 142 226 100 14, tab 2000
  edit "", 2039, 280 222 213 22, tab 2000 autohs limit 100 
  check "Utiliser &SSL", 2040, 499 224 100 18, tab 2000
  text "Nom du compte", 2041, 142 248 100 14, tab 2000
  edit "", 2042, 280 244 213 22, tab 2000 autohs limit 100
  text "Password", 2043, 142 270 100 14, tab 2000
  edit "", 2044, 280 266 213 22, tab 2000 pass autohs limit 60
  edit "", 2045, 280 266 213 22, tab 2000 hide autohs limit 60
  button "Afficher", 2046, 499 266 100 20, tab 2000
  button "Cacher", 2047, 499 266 100 20, hide tab 2000

  ;Correction
  tab "correc", 2100, hide
  box "Correction automatique", 2110, 132 4 471 348, tab 2100
  text "Corriger :", 2111, 142 20 126 14, tab 2100
  check "Canaux", 2112, 152 36 60 14, tab 2100
  check "Queries", 2113, 224 36 60 14, tab 2100
  text "Mots/Expressions :", 2114, 142 58 200 14, tab 2100
  list 2120, 142 74 370 270, tab 2100 extsel size
  button "&Ajouter", 2121, 514 74 80 24, tab 2100
  button "&Editer", 2122, 514 100 80 24, tab 2100
  button "&Supprimer", 2123, 514 126 80 24, tab 2100
  button "&Vider", 2124, 514 152 80 24, tab 2100

  ;Gestion des themes
  tab "themes", 2200, hide
  box "Theme Manager", 2210, 132 4 471 218, tab 2200
  text "Thème Actuel:", 2211, 142 24 80 14, tab 2200
  combo 2212, 222 22 200 80, tab 2200 drop
  combo 2216, -1 -1 -1 -1, tab 2200 drop hide
  text "Scheme Actuel:", 2213, 142 48 80 14, tab 2200
  combo 2214, 222 46 200 80, tab 2200 drop
  text "Répertoires de thèmes", 2215, 142 80 130 14, tab 2200
  list 2220, 142 96 368 140, tab 2200 extsel
  button "&Ajouter", 2221, 515 96 80 24, tab 2200
  button "&Editer", 2222, 515 128 80 24, tab 2200
  button "&Supprimer", 2223, 515 160 80 24, tab 2200
  button "&Vider", 2224, 515 192 80 24, tab 2200
  box "Lors du chargement d'un thème", 2225, 132 224 471 100, tab 2200
  check "Charger tous les schemes", 2226, 142 240 200 14, tab 2200
  check "Décharger l'ancien thème", 2227, 142 256 200 14, tab 2200
  check "Minimiser toutes les fenêtres", 2228, 142 272 200 14, tab 2200
  check "Effacer toutes les fenêtres", 2229, 142 288 200 14, tab 2200
  check "Afficher barre de progression", 2230, 142 304 200 14, tab 2200
  text "Charger:", 2239, 342 240 100 14, tab 2200
  check "Polices", 2231, 342 256 100 14, tab 2200
  check "Couleurs", 2232, 342 272 100 14, tab 2200
  check "Couleurs nicks", 2233, 342 288 100 14, tab 2200
  check "Sons", 2234, 342 304 100 14, tab 2200
  check "Images de fond", 2235, 444 256 100 14, tab 2200
  check "Toolbar/Switchbar", 2236, 444 272 104 14, tab 2200
  check "Timestamp", 2237, 444 288 100 14, tab 2200
  check "Evènements", 2238, 444 304 100 14, tab 2200
  box "Autres Options", 2240, 132 324 471 80, tab 2200
  check "&Remplacer police par:", 2241, 142 342 120 14, tab 2200
  edit "", 2242, 300 340 160 18, tab 2200 disable autohs limit 255
  check "Colorier les &pseudonymes", 2243, 142 360 140 14, tab 2200
  check "Commande &echo personnalisée", 2244, 142 378 180 14, tab 2200

  ;Copypasta
  tab "coypasta", 2300, hide
  box "Collage différé", 2310, 132 4 471 148, tab 2300
  radio "&Empêcher le collage de plusieurs lignes", 2311, 141 20 200 18, tab 2300
  radio "&Différer le collage de plusieurs lignes à raison de", 2312, 141 40 248 18, tab 2300
  edit "", 2313, 390 38 32 22, disable tab 2300 limit 4 center
  text "ms par ligne", 2314, 428 42 104 14, tab 2300
  check "Seulement si &plus de", 2315, 159 62 112 18, disable tab 2300
  edit "", 2316, 276 60 32 22, disable tab 2300 limit 4 center
  text "lignes ou", 2317, 312 64 56 14, disable tab 2300
  edit "", 2318, 276 84 32 22, disable tab 2300 limit 5 center
  text "octets copiés", 2319, 312 86 54 14, disable tab 2300
  check "&Notifier en cas de collage différé", 2320, 159 106 200 18, disable tab 2300
  radio "&Pas de C/C différé", 2321, 141 126 124 18, tab 2300

  box "Options de collage", 2330, 132 158 471 100, tab 2300
  check "&Couper les lignes de plus de", 2331, 141 174 150 18, tab 2300
  edit "", 2332, 295 172 32 22, tab 2300 limit 3 center
  text "caractères", 2333, 329 176 52 16, tab 2300
  check "Enlever les co&des de contrôle (gras, couleur...)", 2334, 141 193 349 18, tab 2300
  check "Seulement en cas de mode +c", 2335, 159 212 189 18, tab 2300
  check "Coller dans l'editbox seulement", 2336, 141 231 393 20, tab 2300

  ; Queries
  tab "queries", 2400, hide
  box "Messages privés (Queries)", 2410, 132 4 471 120, tab 2400
  check "&Fermer la fenêtre après inactivité de plus de", 2411, 142 22 230 14, tab 2400
  edit "", 2412, 374 18 40 22, tab 2400 center
  text "minutes", 2413, 420 22 42 14, tab 2400
  check "Afficher &stats des queries lors de leur ouverture", 2414, 142 38 280 14, tab 2400
  check "Afficher é&vènements dans les queries ouvertes:", 2415, 142 54 300 14, tab 2400
  check "&Joins", 2416, 160 70 46 14, tab 2400
  check "Chgts. &Nicks", 2417, 270 70 80 14, tab 2400
  check "&Parts", 2418, 378 70 46 14, tab 2400
  check "&Kicks", 2419, 160 86 46 14, tab 2400
  check "Nick pers&o", 2420, 270 86 70 14, tab 2400
  check "&Quits", 2421, 378 86 46 14, tab 2400
  check "&Modes", 2422, 160 102 46 16, tab 2400
  check "Noti&fications", 2423, 270 102 80 14, tab 2400

  box "Ouverture automatique", 2430, 132 126 471 180, tab 2400
  check "Ouvrir automatiquement une query avec les nicks:", 2431, 142 144 300 14, tab 2400
  list 2440, 142 160 268 130, tab 2400 sort size vsbar extsel
  button "&Ajouter", 2441, 415 160 80 24, tab 2400
  button "&Editer", 2442, 415 186 80 24, tab 2400
  button "&Supprimer", 2443, 415 212 80 24, tab 2400
  button "&Vider", 2444, 415 238 80 24, tab 2400

  ;tabcomp
  tab "tabcomp", 2500
  box "Complétion améliorée (Tab)", 2510, 132 4 471 103, tab 2500
  check "&Activer la complétion améliorée", 2511, 142 22 230 14, tab 2500
  text "Déclencheur:", 2512, 162 42 76 14, tab 2500
  edit "", 2513, 270 38 174 22, tab 2500 autohs limit 1
  text "Format: ", 2514, 162 66 240 14, tab 2500
  edit "", 2515, 270 62 174 22, tab 2500 autohs limit 50
  button "", 2516, 448 63 146 20, disable tab 2500
  check "Activer le &delete Tab (effacer le pseudo entier par la touche Del)", 2517, 142 85 360 15, tab 2500

  ;Rss feeds
  tab "rss", 2600, hide
  box "RSS Feeds", 2610, 132 4 471 200, tab 2600
  check "Activer &RSS Feeds", 2611, 142 20 116 18, tab 2600
  list 2620, 157 38 437 129, tab 2600 size
  button "&Ajouter", 2621, 158 170 72 24, tab 2600
  button "&Editer", 2622, 238 170 72 24, tab 2600
  button "&Supprimer", 2623, 448 170 72 24, tab 2600
  button "&Vider", 2624, 520 170 72 24, tab 2600

  box "Options RSS", 2630, 132 207 471 115, tab 2600
  check "Récupérer toutes les", 2631, 142 226 102 14, tab 2600
  edit "", 2632, 265 222 40 22, tab 2600 center
  text "minutes (pref. 10 ou plus)", 2633, 310 226 176 14, tab 2600
  check "Afficher les news dans une fenêtre &séparée", 2634, 142 244 226 18, tab 2600
  check "Chaque news possède sa &PROPRE fenêtre", 2635, 162 262 226 18, tab 2600
  check "Montrer &messages d'erreur", 2636, 142 280 148 18, tab 2600
  check "Envoyer une notification lors de nouvelles news", 2637, 142 298 246 18, tab 2600
  
  ;Blacklist, Whitelist
  tab "blist", 2700, hide
  box "Blacklist", 2710, 132 4 471 400, tab 2700
  text "Canal", 2711, 160 24 84 16, tab 2700
  combo 2712, 338 22 200 156, tab 2700 size drop
  button "&+", 2713, 541 24 26 20, tab 2700
  button "&-", 2714, 567 24 26 20, disable tab 2700
  list 2720, 140 50 354 290, tab 2700 size
  button "&Ajouter", 2721, 500 70 80 24, tab 2700
  button "&Editer", 2722, 500 98 80 24, disable tab 2700
  button "&Supprimer", 2723, 500 128 80 24, disable tab 2700
  button "&Vider", 2724, 500 158 80 24, disable tab 2700

  tab "wlist", 2750, hide
  box "Whitelist", 2760, 132 4 471 400, tab 2750
  text "Canal", 2761, 160 24 84 16, tab 2750
  combo 2762, 338 22 200 156, tab 2750 size drop
  button "&+", 2763, 541 24 26 20, tab 2750
  button "&-", 2764, 567 24 26 20, disable tab 2750
  list 2770, 140 50 354 290, tab 2750 size
  button "&Ajouter", 2771, 500 70 80 24, tab 2750
  button "&Editer", 2772, 500 98 80 24, disable tab 2750
  button "&Supprimer", 2773, 500 128 80 24, disable tab 2750
  button "&Vider", 2774, 500 158 80 24, disable tab 2750

  ;Autocompletion
  tab "autocomp", 2800, hide
  box "Autocomplétion", 2810, 132 4 471 126, tab 2800
  check "Activer l'auto&complétion", 2811, 142 22 230 14, tab 2800
  text "Ouvrir le panneau de complétion après", 2812, 152 38 190 14, tab 2800
  edit "", 2813, 348 36 60 20, tab 2800
  text "ms", 2814, 414 38 30 14, tab 2800
  check "Charger les mots au &démarrage", 2815, 152 56 230 14, tab 2800
  check "Activer l'&apprentissage", 2816, 152 72 230 14, tab 2800
  check "&Limiter le nombre de mots à ", 2817, 152 88 150 14, tab 2800
  edit "", 2818, 308 86 60 18, tab 2800
  text "mot(s)", 2819, 374 88 30 14, tab 2800
  check "Compléter avec la touche Entrée", 2820, 152 104 180 14, tab 2800
  
  box "Exclusions", 2850, 132 130 471 160, tab 2800
  text "Exclure les fenêtres:", 2851, 142 146 230 14, tab 2800
  list 2860, 142 162 268 140, tab 2800
  button "&Ajouter", 2861, 415 162 80 24, tab 2800
  button "&Editer", 2862, 415 190 80 24, disable tab 2800
  button "&Supprimer", 2863, 415 218 80 24, disable tab 2800
  button "&Vider", 2864, 415 246 80 24, tab 2800
  
  button "Editer la &base de données", 2870, 202 300 200 24, tab 2800
  
  ;Sous-catégories
  tab "subcat", 10
  text "", 11, 173 106 400 50, tab 10 center
  text "Choisissez une sous-catégorie", 12, 223 166 288 36, tab 10 center

  ; Chemins des fichiers
  tab "paths", 20
  box "Chemins de fichiers", 30, 132 4 471 400, tab 20
  text "Dans la plupart des cas, ne modifiez pas ces valeurs à moins d'être certains de savoir ce que vous faites!", 29, 142 22 400 28, tab 20
  text "", 31, 142 52 100 14, tab 20 hide
  edit "", 32, 244 50 260 18, tab 20 hide disable
  button "...", 33, 506 50 20 18, tab 20 hide
  text "", 34, 142 70 100 14, tab 20 hide
  edit "", 35, 244 68 260 18, tab 20 hide disable
   button "...", 36, 506 68 20 18, tab 20 hide
  text "", 37, 142 88 100 14, tab 20 hide
  edit "", 38, 244 86 260 18, tab 20 hide disable
   button "...", 39, 506 86 20 18, tab 20 hide
  text "", 40, 142 106 100 14, tab 20 hide
  edit "", 41, 244 104 260 18, tab 20 hide disable
   button "...", 42, 506 104 20 18, tab 20 hide
  text "", 43, 142 124 100 14, tab 20 hide
  edit "", 44, 244 122 260 18, tab 20 hide disable
   button "...", 45, 506 122 20 18, tab 20 hide
  text "", 46, 142 142 100 14, tab 20 hide
  edit "", 47, 244 140 260 18, tab 20 hide disable
   button "...", 48, 506 140 20 18, tab 20 hide
  text "", 49, 142 170 100 14, tab 20 hide
  edit "", 50, 244 168 260 18, tab 20 hide disable
   button "...", 51, 506 168 20 18, tab 20 hide 
  text "", 52, 142 188 100 14, tab 20 hide
  edit "", 53, 244 186 260 18, tab 20 hide disable
   button "...", 54, 506 186 20 18, tab 20 hide
  text "", 55, 142 206 100 14, tab 20 hide
  edit "", 56, 244 204 260 18, tab 20 hide disable
   button "...", 57, 506 204 20 18, tab 20 hide
  text "", 58, 142 224 100 14, tab 20 hide
  edit "", 59, 244 222 260 18, tab 20 hide disable
   button "...", 60, 506 222 20 18, tab 20 hide
  text "", 61, 142 242 100 14, tab 20 hide
  edit "", 62, 244 240 260 18, tab 20 hide disable
   button "...", 63, 506 240 20 18, tab 20 hide
  text "", 64, 142 270 100 14, tab 20 hide
  edit "", 65, 244 268 260 18, tab 20 hide disable
   button "...", 66, 506 268 20 18, tab 20 hide
  text "", 67, 142 288 100 14, tab 20 hide
  edit "", 68, 244 286 260 18, tab 20 hide disable
   button "...", 69, 506 286 20 18, tab 20 hide
}


; Recupere le numero du tab en fonction du nom de section
alias -l sectionToTab {
  var %t = $1-

  if (*-Options-* iswm %t) { return 100 }
  elseif (*Chemins* iswm %t) { return 20 }
  elseif (*Options Générales* iswm %t) { return 10 }
  elseif (*Générales* iswm %t) { return 700 }
  elseif (*Touches FN* iswm %t) { return 500 }
  elseif (*Serveurs* iswm %t) { return 1100 }
  elseif (*Copier/Coller* iswm %t) { return 2300 }
  elseif (*Queries* iswm %t) { return 2400 }
  elseif (*Correction* iswm %t) { return 2100 }
  elseif (*Tab Comp.* iswm %t) { return 2500 }
  elseif (*Autocomplétion* iswm %t) { return 2800 }

  elseif (*Away Mode* iswm %t) { return 10 }
  elseif (*Logging* iswm %t) { return 200 }
  elseif (*Répondeur* iswm %t) { return 300 }
  elseif (*Auto-Away* iswm %t) { return 400 }
  elseif (*Mess. d'absence* iswm %t) { return 450 }

  elseif (*Barres* iswm %t) { return 10 }
  elseif (*Titlebar* iswm %t) { return 600 }
  elseif (*Status Bar* iswm %t) { return 1000 }
  elseif (*Toolbar* iswm %t) { return 1800 }

  elseif (*Protections* iswm %t) { return 10 }
  elseif (*Canaux* iswm %t) { return 800 }
  elseif (*Personnelles* iswm %t) { return 900 }
  elseif (*Exceptions* iswm %t) { return 950 }
  elseif (*Blacklist* iswm %t) { return 2700 }
  elseif (*Whitelist* iswm %t) { return 2750 }

  elseif (*Messages prédef.* iswm %t) { return 10 }
  elseif (*Kicks* iswm %t) { return 1200 }
  elseif (*Quits* iswm %t) { return 1300 }
  elseif (*Slaps* iswm %t) { return 1400 }
  elseif (*Identifieurs* iswm %t) { return 1500 }

  elseif (*Services IRC* iswm %t) { return 10 }
  elseif (*NickServ* iswm %t) { return 1600 }
  elseif (*ChanServ* iswm %t) { return 1650 }
  elseif (*BotServ* iswm %t) { return 1700 }

  elseif (*Infos* iswm %t) { return 10 }
  elseif (*Mails* iswm %t) { return 2000 }
  elseif (*Flux RSS* iswm %t) { return 2600 }

  elseif (*Thèmes* iswm %t) { return 2200 }
}

; Affiche la liste des sections (no mdx version)
alias -l initOptionsList {
  did -a $dname 1 -------Options-------
  if ($enabled(misc)) || ($enabled(fkeys)) || ($enabled(servers)) || ($enabled(copypasta)) || ($enabled(query)) || ($enabled(replace)) || ($enabled(tabcomp) {
    did -a $dname 1 $str($chr(160),2) $+ Options générales
    if ($enabled(dev)) did -a $dname 1 $str($chr(160),4) $+ Chemins
    if ($enabled(misc)) { did -a $dname 1 $str($chr(160),4) $+ Générales }
    if ($enabled(fkeys)) { did -a $dname 1 $str($chr(160),4) $+ Touches FN }
    if ($enabled(servers)) { did -a $dname 1 $str($chr(160),4) $+ Serveurs }
    if ($enabled(copypasta)) { did -a $dname 1 $str($chr(160),4) $+ Copier/Coller }
    if ($enabled(query)) { did -a $dname 1 $str($chr(160),4) $+ Queries }
    if ($enabled(replace)) { did -a $dname 1 $str($chr(160),4) $+ Correction }
    if ($enabled(tabcomp)) { did -a $dname 1 $str($chr(160),4) $+ Tab Comp. }
    if ($enabled(autocomp)) { did -a $dname 1 $str($chr(160),4) $+ Autocomplétion }
  }

  if ($enabled(away)) {
    did -a $dname 1 $str($chr(160),2) $+ Away Mode
    did -a $dname 1 $str($chr(160),4) $+ Logging
    did -a $dname 1 $str($chr(160),4) $+ Répondeur
    did -a $dname 1 $str($chr(160),4) $+ Auto-Away
    if ($enabled(messages)) did -a $dname 1 $str($chr(160),4) $+ Mess. d'absence
  }

  if ($enabled(titlebar)) || ($enabled(statbar)) || ($enabled(toolbar)) {
    did -a $dname 1 $str($chr(160),2) $+ Barres
    if ($enabled(titlebar)) { did -a $dname 1 $str($chr(160),4) $+ Titlebar }
    if ($enabled(statbar)) { did -a $dname 1 $str($chr(160),4) $+ Status Bar }
    if ($enabled(toolbar)) { did -a $dname 1 $str($chr(160),4) $+ Toolbar }
  }

  if ($enabled(prots)) {
    did -a $dname 1 $str($chr(160),2) $+ Protections
    did -a $dname 1 $str($chr(160),4) $+ Canaux
    did -a $dname 1 $str($chr(160),4) $+ Personnelles
    did -a $dname 1 $str($chr(160),4) $+ Exceptions
    did -a $dname 1 $str($chr(160),4) $+ Blacklist
    did -a $dname 1 $str($chr(160),4) $+ Whitelist
  }

  if ($enabled(messages)) {
    did -a $dname 1 $str($chr(160),2) $+ Messages prédef.
    did -a $dname 1 $str($chr(160),4) $+ Kicks
    did -a $dname 1 $str($chr(160),4) $+ Quits
    did -a $dname 1 $str($chr(160),4) $+ Slaps
    if ($enabled(idents)) { did -a $dname 1 $str($chr(160),4) $+ Identifieurs }
  }

  if ($enabled(serv)) {
    did -a $dname 1 $str($chr(160),2) $+ Services IRC
    did -a $dname 1 $str($chr(160),4) $+ NickServ
    did -a $dname 1 $str($chr(160),4) $+ ChanServ
    did -a $dname 1 $str($chr(160),4) $+ BotServ
  }

  if ($enabled(mail)) || ($enabled(rss)) {
    did -a $dname 1 $str($chr(160),2) $+ Autres Infos
    if ($enabled(mail)) { did -a $dname 1 $str($chr(160),4) $+ Mails }
    if ($enabled(rss)) { did -a $dname 1 $str($chr(160),4) $+ Flux RSS }
  }

  if ($enabled(themes)) { did -a $dname 1 $str($chr(160),2) $+ Thèmes }
}


; Initialise les listes avec MDX
alias -l initListsMDX {
  ;rss feeds
  mdx SetControlMDX $dname 2620 ListView report noheader showsel checkboxes sortascending labeltip rowselect > $mdxfile(views) 
  ;fkeys
  mdx SetControlMDX $dname 520 ListView report nosortheader showsel single rowselect > $mdxfile(views) 
  ;toolbar, statusbar, themes
  mdx SetControlMDX $dname 1020,1820 ListView report nosortheader showsel infotip rowselect multiselect > $mdxfile(views) 
  ;Idents
  mdx SetControlMDX $dname 1520 ListView report showsel single rowselect infotip > $mdxfile(views) 
  ;personal protect, protect
  mdx SetControlMDX $dname 920,830 ListView report rowselect showsel single checkboxes infotip > $mdxfile(views) 
  ; Kicks, Quits and slaps (and away messages)
  mdx SetControlMDX $dname 1220,1320,1420,470 ListView report showsel single labeltip rowselect grid > $mdxfile(views) 
  ; Correction
  mdx SetControlMDX $dname 2120 ListView report sortascending showsel rowselect labeltip > $mdxfile(views)
  
  ; Reglages des headers des listes: dimensions, noms, police...
  ;RSS,Pprot,Statbar,Cprot
  did -i $dname 2620,920,1020,830 1 settxt bgcolor none 
  ;Bindings
  did -i $dname 520 1 headerdims 80:1 100:2 180:3 
  did -i $dname 520 1 headertext + 0 Touche(s) $+ $chr(9) $+ + 0 Commande $+ $chr(9) $+ + 0 Description        
  ;Protection perso
  did -i $dname 920 1 headerdims 100:1 60:2 60:3 200:4
  did -i $dname 920 1 headertext + 0 Type $+ $chr(9) $+ +c 0 Nombre $+ $chr(9) $+ +c 0 Intervalle $+ $chr(9) $+ + 0 Action(s)    
  ;Status bar  
  did -i $dname 1020 1 headerdims 170:1 130:2 70:3
  did -i $dname 1020 1 headertext + 0 Texte $+ $chr(9) $+ + 0 Commande $+ $chr(9) $+ + 0 Largeur
  ;RSS  
  did -i $dname 2620 1 headerdims 180:1 225:2
  ;Idents
  did -i $dname 1520 1 headerdims 90:1 170:2 100:3
  did -i $dname 1520 1 headertext +r 0 Identifieur $+ $chr(9) $+ + 0 Description $+ $chr(9) $+ + 0 Valeur
  ;Custom toolbar  
  did -i $dname 1820 1 headerdims 100:1 120:2 130:3
  did -i $dname 1820 1 headertext + 0 Nom $+ $chr(9) $+ + 0 Infobulle $+ $chr(9) $+ + 0 Commande
  ;Channel protections  
  did -i $dname 830 1 headerdims 100:1 60:2 60:3 200:4
  did -i $dname 830 1 headertext + 0 Type $+ $chr(9) $+ +c 0 Nombre $+ $chr(9) $+ +c 0 Intervalle $+ $chr(9) $+ + 0 Action(s)
  ; Mess predef
  did -i $dname 1220,1320,1420,470 1 headerdims 100:1 400:2
  did -i $dname 1220,1320,1420,470 1 headertext + 0 Nom $+ $chr(9) $+ + 0 Message
  ; Correction
  did -i $dname 2120 1 headerdims 180:1 180:2
  did -i $dname 2120 1 headertext + 0 Texte/Expression $+ $chr(9) $+ + 0 Correction
  
}

; Rafraichit les infos sur le serveur selectionné (Away|Autres)
alias -l loadServerAwayInfo {
  var %server = $did(412).seltext
  if (%server == Défaut) { %server = def }
  did -ra $dname 416 $gettok($ri(nicks,nicks. $+ %server),1,3)
  did -ra $dname 418 $gettok($ri(nicks,nicks. $+ %server),2,3)
  did $iif(%server == def,-b,-e) $dname 414
}

; Initialise l'onglet "serveurs favoris"
alias -l initServers {
  ; Loading the servers from the servers.ini file
  var %servini = $iif($exists($mircdir $+ servers.ini),$mircdir $+ servers.ini,$iif($exists($readini(mirc.ini,files,servers)),$readini(mirc.ini,files,servers),$null))

  if (%servini == $null) { return }
  var %nbservers = $ini(%servini,servers,0)
  var %i = 0
  if (%nbservers == 0) { return }

  var %favorites $ri(servers,favorites)
  .hmake servers 50
  while (%i <= %nbservers) {
    var %serv = $readini(%servini,servers,n $+ %i)
    if ($regex(serv,%serv,/^.+SERVER:.+GROUP:(.+)/i)) && ($regml(serv,1) !isnum) {
      var %group $ifmatch
      if (%group !isin %favorites) && ($hget(servers,%group) == $null) { 
        did -a $dname 1120,1612,1662,1712 %group
        hadd servers %group :)
      }
    }
    inc %i
  }
  .hfree servers
}

; Met a jour les infos du serveur sélectionné
alias -l loadServerInfo {
  var %server = $did(1130).seltext
  if (!%server) { halt }
  did -e $dname 1141-1153,1161-1167
  if (!$sslready) { did -b $dname 1150 }
  var %servinfo = $ri(servers,servers. $+ %server)

  tokenize 1 %servinfo 
  did -ra $dname 1162 $1
  did -ra $dname 1163 $2
  did -ra $dname 1164 $3
  did -ra $dname 1165 $4
  did -ra $dname 1166 $5
  did -ra $dname 1167 $6

  did $iif($7,-c,-u) $dname 1148
  did $iif($8,-c,-u) $dname 1149
  did $iif($9,-c,-u) $dname 1150
  did $iif($10,-c,-u) $dname 1151
  did $iif($11,-c,-u) $dname 1152
}


; Ecrit les modifications
alias -l writeServerInfo {
  var %server = $did(1130).seltext
  if (!%server) { halt }
  var %rname = $iif($did(1162),$v1,$rmi(mirc,user))
  var %email = $iif($did(1163),$v1,$rmi(mirc,email))
  var %nick = $iif($did(1164),$v1,$rmi(mirc,nick))
  var %anick = $iif($did(1165),$v1,$rmi(mirc,anick))
  var %port = $iif($did(1166),$v1,$rmi(text,defport))
  var %identd = $iif($did(1167),$v1,$rmi(ident,userid))
  var %startup = $iif($did(1148).state < 2,$v1,$gettok($rmi(options,n0),1,44))
  var %invisible = $iif($did(1149).state < 2,$v1,$gettok($rmi(options,n4),10,44))
  var %ssl = $iif($did(1150).state < 2,$v1,$sslready)
  var %autoreco = $iif($did(1151).state < 2,$v1,$gettok($rmi(options,n3),5,44))
  var %perform = $iif($did(1152).state < 2,$v1,$gettok($rmi(options,n0),19,44))

  wi servers servers. $+ %server $buildtok(1,%rname,%email,%nick,%anick,%port,%identd,%startup,%invisible,%ssl,%autoreco,%perform)
}

; Retourne l'état des ids 2416 à 2423 pour etre ecrits dans les options
alias -l queryEvents {
  return $+($iif($did(2416).state,j),$iif($did(2417).state,n),$iif($did(2418).state,p),$iif($did(2419).state,k),$iif($did(2420).state,o),$iif($did(2421).state,q),$iif($did(2422).state,m),$iif($did(2423).state,f))
}

; Charge les infos du nick sélectionné pour le serveur sélectionné
alias -l loadServiceInfo {
  var %service = $iif($1,$1,all)
  if (%service == all) { lsf nick | lsf chan | lsf bot | return }

  var %didserv = $iif(%Service == nick,1612,$iif(%service == chan,1662,1712))
  var %didnc = $iif(%Service == nick,1616,$iif(%service == chan,1666,1716))
  var %didpass = $iif(%Service == nick,1618,1668)
  var %didbp = $iif(%service == nick,1620,1670)

  did -r $dname %didnc
  did -v $dname %didpass | did -h $dname $calc(%didpass + 1)
  did -v $dname %didbp | did -h $dname $calc(%didbp + 1)
  var %serv = $did(%didserv).seltext

  if (%service == nick) {
    did $iif(%serv,-e,-b) $dname 1612-1628
    didtok $dname 1616 59 $ri(services,nicks. $+ %serv)
    did -c $dname 1616 1
    var %nick = $did(%didnc).seltext
    did $iif(%nick,-e,-b) $dname 1614-1628,1630-1640
    var %ninfo = $ri(services,$buildtok(46,%service,%serv,%nick))
    did $iif($status == connected && %nick,-e,-b) $dname 1630-1640
    loadServiceSubInfo %service %ninfo
  }
  elseif (%service == chan) {
    did $iif(%serv,-e,-b) $dname 1662-1678
    didtok $dname 1666 59 $ri(services,chans. $+ %serv)
    did -c $dname 1666 1
    var %nick = $did(%didnc).seltext
    did $iif(%nick,-e,-b) $dname 1664-1678,1680-1693
    var %ninfo = $ri(services,$buildtok(46,%service,%serv,%nick))
    did $iif($status == connected && %nick,-e,-b) $dname 1680-1693
    loadServiceSubInfo %Service %ninfo
  }
  elseif (%service == bot) {
    did $iif(%serv,-e,-b) $dname 1712-1726
    didtok $dname 1716 59 $ri(services,bots. $+ %serv)
    did -c $dname 1716 1
    var %nick = $did(%didnc).seltext
    did $iif(%nick,-e,-b) $dname 1714-1726,1730-1736
    var %ninfo = $ri(services,$buildtok(46,%service,%serv,%nick))
    did $iif($status == connected && %nick,-e,-b) $dname 1730-1736
    loadServiceSubInfo %service %ninfo
  }
}

; Utilisé pour ne changer que les champs du nick sélectionné
alias -l loadServiceSubInfo {
  var %Service = $1
  tokenize 1 $2-
  if (%service == nick) {
    did -ra $dname 1618,1619 $decode($1)
    did -u $dname 1622,1623
    did -c $dname $iif($2 == 1,1622,1623)
    did $iif($3 == 1,-c,-u) $dname 1624
    did $iif($4 == 1,-c,-u) $dname 1625
    did -ra $dname 1626 $5-
    prevbmp $dname 1628 12 notice 0 $5-
  }
  elseif (%service == chan) {
    did -ra $dname 1668,1669 $decode($1)
    did -u $dname 1672,1673
    did -c $dname $iif($2 == 1,1672,1673)
    did $iif($3 == 1,-c,-u) $dname 1674
    did $iif($4 == 1,-c,-u) $dname 1675
    did -ra $dname 1676 $5-
    prevbmp $dname 1678 12 notice 0 $5-
  }
  elseif (%service == bot) {
    did -ra $dname 1718 $1
    did -u $dname 1721,1722
    did -c $dname $iif($2 == 1,1721,1722)
    did $iif($3 == 1,-c,-u) $dname 1723
    did -ra $dname 1724 $4-
    prevbmp $dname 1726 12 notice 0 $4-
  }
}


; Ecrit les modifications du service IRC
alias -l writeServiceInfo {
  var %service = $iif($1,$1,all)
  if (%service == all) { wsf nick | wsf chan | wsf bot | return }

  var %didserv = $iif(%Service == nick,1612,$iif(%service == chan,1662,1712))
  var %serv = $did(%didserv).seltext
  if (!%serv) { return }

  if (%service == nick) {
    var %nick = $did(1616).seltext
    if (!%nick) { return }
    var %pass = $did(1618)
    var %cmd = $did(1622).state
    var %ghost = $did(1624).state
    var %greet = $did(1625).state
    var %greet2 = $did(1626)

    wi services $buildtok(46,nick,%serv,%nick) $buildtok(1,$encode(%pass),%cmd,%ghost,%greet,%greet2)
  }
  elseif (%service == chan) {
    var %nick = $did(1666).seltext
    if (!%nick) { return }
    var %pass = $did(1668)
    var %cmd = $did(1672).state
    var %ghost = $did(1674).state
    var %greet = $did(1675).state
    var %greet2 = $did(1676)

    wi services $buildtok(46,chan,%serv,%nick) $buildtok(1,$encode(%pass),%cmd,%ghost,%greet,%greet2)
  }
  elseif (%service == bot) {
    var %nick = $did(1716).seltext
    if (!%nick) { return }
    var %bot = $did(1718)
    var %cmd = $did(1721).state
    var %greet = $did(1723).state
    var %greet2 = $did(1724)

    wi services $buildtok(46,bot,%serv,%nick) $buildtok(1,%bot,%cmd,%greet,%greet2)
  }
}

; Fichue récursion...
alias -l lsf { loadServiceInfo $1- }
alias -l wsf { writeServiceInfo $1- }

; Retourne l'état des ids 2017 à 2020
alias -l mailEvents {
  return $+($iif($did(2017).state,b),$iif($did(2018).state,e),$iif($did(2019).state,i),$iif($did(2020).state,n))
}

; Charge les infos du mail sélectionné
alias -l loadMailInfo {
  var %seltext = $did(2032).seltext
  if (%seltext) {
    var %info = $ri(mails,mail. $+ %seltext)
    
      tokenize 1 %info
      did -c $dname $iif($1 == pop3,2036,2037)
      did -u $dname $iif($1 == pop3,2037,2036)
      did -ra $dname 2039 $2
      did -ra $dname 2042 $3
      did -ra $dname 2044,2045 $decode($4)
      did $iif($5 == 1,-c,-u) $dname 2040
    
  }
}

; Ecrit les informations du mail sélectionné
alias -l writeMailInfo {
  var %seltext = $did(2032).seltext
  if (%seltext) {
    var %pop = $iif($did(2036).state,pop3,imap)
    var %server = $did(2039), %name = $did(2042), %pass = $encode($did(2044)), %ssl = $did(2040).state
    wi mails mail. $+ %seltext $buildtok(1,%pop,%server,%name,%pass,%ssl)
  }
}

; Retourne l'état des ids 2226 à 2238
alias -l themeOptions {
  var %addoptions = $iif($did(2226).state,h) $+ $iif($did(2227).state,u) $+ $iif($did(2228).state,w) $+ $iif($did(2229).state,l) $+ $iif($did(2230).state,g)
  var %loadoptions = $iif($did(2231).state,f) $+ $iif($did(2232).state,c) $+ $iif($did(2233).state,n) $+ $iif($did(2234).state,s) $+ $iif($did(2235).state,b) $+ $iif($did(2236).state,i) $+ $iif($did(2237).state,t) $+ $iif($did(2238).state,e)
  wi themes loadoptions %loadoptions
  wi themes addoptions %addoptions
}

; Initialisation des listes (pas trop compliquees pour ne pas etre dans une alias specifique)
alias -l initLists {
  if ($enabled(away)) {
    ;Away Logging
    var %trig = $ri(awaylog,triggers)
    if (%trig != $null) { didtok $dname 220 59 %trig }
    did -c $dname 220 1

    ;Away Messaging
    var %mess = $ri(awaymess,channels)
    if (%mess != $null) { didtok $dname 320 59 %mess }
    did -c $dname 320 1  
    
    ; Away messages
    if ($enabled(messages)) mess.reflist aways
  }

  if ($enabled(fkeys)) {
    ; Peupler la liste des fkeys
    fkeys.loadref
  }

  if ($enabled(prots)) {
    ; Initialisation des protections channels et perso
    cprot.reflist
    pprot.reflist
    ; Peupler la liste des exclusions
    excludes.loadref
    ; Whitelist et blacklist
    bwlist.reflist
    bwlist.reflist w
  }

  if ($enabled(statbar)) {
    ; Initialisation de la statusbar perso
    statusbar.reflist
  }

  if ($enabled(servers)) {
    ; Liste des serveurs pref
    initServers
    didtok $dname 1130 59 $ri(servers,favorites)
  }

  if ($enabled(messages)) {
    ; Kicks predef
    mess.reflist kicks
    ; Quits predef
    mess.reflist quits
    ; slaps predef
    mess.reflist slaps
  }

  if ($enabled(toolbar)) {
    ; Initialisation de la toolbar perso
    toolbar.reflist
  }

  if ($enabled(idents)) {
    ; Charge les idents perso
    idents.loadref
  }

  if ($enabled(replace)) {
    ; Peupler les remplacements
    replace.load
  }

  if ($enabled(themes)) {
    ;Themes
    didtok $dname 2220 59 $ri(themes,folders)
    did -c $dname 2220 1
  }
  if ($enabled(rss)) {
    ; Peupler la liste des rss 
    rss.loadfeeds
  }
  if ($enabled(query)) {
    ; Autoopen query nicks
    didtok $dname 2440 59 $ri(query,nicks)
    did -c $dname 2440 1
  }
  if ($enabled(autocomp)) {
    didtok $dname 2860 59 $ri(autocomp,excludes)
  }
}

; Remplit les comboboxes
alias -l fillComboBoxes {
  if ($enabled(away)) {
    ; Combobox des serveurs utilisés dans le menu "Away|Autres"
    didtok $dname 412 59 $ri(nicks,servers)
    did -c $dname 412 1
    loadServerAwayInfo
  }

  if ($enabled(misc)) {
    ; Ajout des options de masque dans le menu Misc 2
    var %i = 0
    while (%i < 10) {
      did -a $dname 743,744 $+([,%i,]) $mask(nick!ident@some.host.com,%i)
      inc %i
    }
  }

  if ($enabled(prots)) {
    ; Ajout des channels dans la liste des protections
    did -ra $dname 812 Tous
    didtok $dname 812 59 $rci(cprot,channels)
    did -c $dname 812 1
    did -ra $dname 2712 Tous
    didtok $dname 2712 59 $ri(blist,channels)
    did -c $dname 2712 1
    did -ra $dname 2762 Tous
    didtok $dname 2762 59 $ri(wlist,channels)
    did -c $dname 2762 1
  }

  if ($enabled(serv)) {
    ; Nickserv, Chanserv et Botserv
    didtok $dname 1612,1662,1712 59 $ri(servers,favorites)
    did -c $dname 1612,1662,1712 1
    loadServiceInfo
  }

  if ($enabled(mail)) {
    ;Mail
    didtok $dname 2032 59 $ri(mails,accounts)
    did -c $dname 2032 1
    loadMailInfo
  }

  if ($enabled(themes)) {
    ; Themes and schemes
    theme.loadThemes
  }
}

; Active/Désactive des items
alias -l enableDisableItems {
  if ($enabled(away)) {
    ; Away Logging
    did $iif($ri(awaylog,use) == 1,-e,-b) $dname 212-214,220-224
    ; Away Messages
    did $iif($ri(awaymess,use) == 1,-e,-b) $dname 312-315,320-324
    if ($ri(awaymess,exclude) != 1) { did -b $dname 320-324 }
    ;Away Misc
    did $iif($ri(awaymisc,autoawayuse) == 1,-e,-b) $dname 426-427
  }
  if ($enabled(titlebar)) {
    ;Titlebar
    did $iif($ri(titlebar,use) == 1,-e,-b) $dname 612-620
    if ($did(611).state == 1) { 
      did $iif($ri(titlebar,refreshuse) == 1,-e,-b) $dname 613-614
      did $iif($ri(titlebar,icon) == 1,-e,-b) $dname 619-620
    }
  }
  if ($enabled(misc)) {
    ; Misc 2
    did -e $dname 710-720,730-732,740-744
    did -e $dname 750-754
  }
  if ($enabled(prots)) {
    ; Channel protections
    if ($rci(cprot,allpreset) == 1) { did -b $dname 815,817-819,830-832 }
    if ($did(812).seltext == Tous) { did -b $dname 814,815 }
    else {
      if ($rci(cprot. $+ $did(812).seltext,usepreset) == 1) { did -b $dname 830-831 }
    }
    ; Blist/Wlist
    if ($did(2712).seltext == Tous) { did -b $dname 2714 }
    if ($did(2762).seltext == Tous) { did -b $dname 2764 }
  }
  if ($enabled(statbar)) {
    ; Statusbar
    did $iif($ri(statusbar,use) == 1,-e,-b) $dname 1012-1014,1020-1029
  }
  if ($enabled(servers)) {
    ; Serveurs pref
    did $iif($ri(servers,favorites),-e,-b) $dname 1130,1140-1153,1161-1167
    did $iif($did(1130).sel,-e,-b) $dname 1140-1153
  }
  if ($enabled(serv)) {
    ;Services IRC
    did $iif($ri(services,servers),-e,-b) $dname 1613-1628,1663-1678,1713-1726
    var %nick = $did(1616).seltext,%chan1 = $did(1666).seltext, %chan2 = $did(1716).seltext
    did $iif(%nick,-e,-b) $dname 1614
    did $iif(%chan1,-e,-b) $dname 1664
    did $iif(%chan2,-e,-b) $dname 1714
    did $iif($status == connected,-e,-b) $dname 1632-1640,1682-1692,1732-1736
  }
  if ($enabled(toolbar)) {
    ; Toolbar
    did $iif($ri(toolbar,use) == 1,-e,-b) $dname 1820-1830
  }
  if ($enabled(mail)) {
    ; Mail Checker
    did $iif($ri(mails,use) == 1,-e,-b) $dname 2012-2021
    did $iif($ri(mails,accounts),-e,-b) $dname 2034-2047
    if (!$sslready) { did -b $dname 2040 }
  }
  if ($enabled(themes)) {
    did $iif($ri(themes,theme),-e,-b) $dname 2213,2214
  }
  if ($enabled(copypasta)) {
    ; Copypasta
    did $iif($ri(copypasta,paste) == delay,-e,-b) $dname 2313-2320
    did $iif($ri(copypasta,limitlines) == 1,-e,-b) $dname 2316-2319
    did $iif($ri(copypasta,crop) == 1,-e,-b) $dname 2332-2333
    did $iif($ri(copypasta,strip) == 1,-e,-b) $dname 2335
  }
  if ($enabled(rss)) {
    ; RSS
    did $iif($ri(rss,use) == 1,-e,-b) $dname 2620-2624
  }
  if ($enabled(query)) {
    ; Misc 1: Query
    did -e $dname 2410-2423
    did $iif($ri(query,eventsmp) == 1,-e,-b) $dname 2416-2423
    did $iif($ri(query,openuse) == 1,-e,-b) $dname 2440-2444
  }
  if ($enabled(tabcomp)) {
    ; Misc 1: tabcomp
    did -e $dname 2510-2517
    did $iif($ri(tabcomp,use) == 1,-e,-b) $dname 2512-2516
  }
  if ($enabled(autocomp)) {
    did $iif($ri(autocomp,use) == 1,-e,-b) $dname 2812-2820
    if ($ri(autocomp,use) == 1) { did $iif($ri(autocomp,limituse) == 1,-e,-b) $dname 2818-2819 }
    
  }

  ; Désactive les boutons Suppr,Editer et Vider des listes
  if ($enabled(away)) {
    ; Away Logging
    if ($did(220).lines == 0) { did -b $dname 222-224 }
    ; Away Messages
    if ($did(320).lines == 0) { did -b $dname 322-324 } 
    ; Mess d'absence
    if ($enabled(messages)) { if ($did(470).lines == 1) { did -b $dname 472-474 } }
  }
  if ($enabled(prots)) {
    ; Excludes
    if ($did(970).lines == 0) { did -b $dname 972-974 }  
    if ($did(2720).lines == 0) { did -b $dname 2722-2724 }
    if ($did(2770).lines == 0) { did -b $dname 2772-2774 }
  }
  if ($enabled(statbar)) {
    ; Statusbar
    if ($did(1020).lines == 1) { did -b $dname 1022-1026,1029 }
  }
  if ($enabled(messages)) {
    ; Messages predef
    if ($did(1220).lines == 1) { did -b $dname 1222-1224 } 
    if ($did(1320).lines == 1) { did -b $dname 1322-1324 } 
    if ($did(1420).lines == 1) { did -b $dname 1422-1424 } 
  }
  if ($enabled(idents)) {
    if ($did(1520).lines == 1) { did -b $dname 1522-1523 }
  }
  if ($enabled(toolbar)) {
    ; Toolbar
    if ($did(1820).lines == 1) { did -b $dname 1823-1827,1830 }
    else { 
      did -b $dname 1823-1827
      if ($did(1820).lines > 1) { did -e $dname 1825 }
    }
  }
  if ($enabled(replace)) {
    if ($did(2120).lines == 0) { did -b $dname 2122-2124 }
  }
  if ($enabled(themes)) {
    ; Themes
    if ($did(2220).lines == 0) { did -b $dname 2222-2224 }
  }  
  if ($enabled(rss)) {
    ; RSS
    if ($did(2620).lines == 1) { did -b $dname 2622-2624 }
  }
  ; Query
  if ($enabled(query)) {
    if ($did(2440).lines == 0) { did -b $dname 2442-2444 }
  }
  ; Autocomp
  if ($enabled(autocomp)) {
    if ($did(2860).lines == 0) { did -b $dname 2862-2864 }
  }
}

; Coche/Décoche selon les options
alias -l checkBoxes {
  if ($enabled(away)) {
    ; Away Logging
    if ($ri(awaylog,use) == 1) { did -c $dname 211 }
    if ($ri(awaylog,events) == 1) { did -c $dname 212 }
    if ($ri(awaylog,op) == 1) { did -c $dname 213 }
    ; Away Messages
    if ($ri(awaymess,use) == 1) { did -c $dname 311 }
    did -c $dname $iif($ri(awaymess,channel) == active,312,313)
    if ($ri(awaymess,query) == 1) { did -c $dname 314 }
    if ($ri(awaymess,exclude) == 1) { did -c $dname 315 }
    ; Away Misc
    if ($ri(awaymisc,noothers) == 1) { did -c $dname 421 }
    if ($ri(awaymisc,awayconnect) == 1) { did -c $dname 422 }
    if ($ri(awaymisc,autoawayuse) == 1) { did -c $dname 423 }
    if ($ri(awaymisc,autoaway) > 0) { did -ra $dname 424 $ifmatch }
    if ($ri(awaymisc,nomessage) == 1) { did -c $dname 426 }
    if ($ri(awaymisc,notify) == 1) { did -c $dname 427 }
    did -c $dname $iif($ri(awaymisc,backnick) == old,430,429)
    ; Mess abs
    if ($enabled(messages)) prevbmp $dname 481 10 action 2
  }
  if ($enabled(titlebar)) {
    if ($ri(titlebar,use) == 1) { did -c $dname 611 }
    if ($ri(titlebar,refreshuse) == 1) { did -c $dname 612 }
    if ($ri(titlebar,refresh) > 0) { did -ra $dname 613 $ifmatch }
    did -ra $dname 616 $ri(titlebar,format)
    if ($ri(titlebar,iconuse) == 1) { did -c $dname 618 }
    did -ra $dname 619 $ri(titlebar,icon)
    if ($ri(titlebar,icon)) { did -g $dname 620 $qt($longfn($v1)) }
  }
  if ($enabled(misc)) {
    ; Misc
    if ($ri(misc,keepkey) == 1) { did -c $dname 711 }
    if ($ri(misc,lookupdates) == 1) { did -c $dname 712 }
    if ($ri(misc,antiidleuse) == 1) { did -c $dname 713 }
    if ($ri(misc,antiidle) > 0) { did -ra $dname 714 $ifmatch }
    if ($ri(misc,kickcount) == 1) { did -c $dname 716 }
    if ($ri(misc,clearcb) == 1) { did -c $dname 717 }
    if ($ri(misc,dccinfo) == 1) { did -c $dname 718 }
    if ($ri(misc,splash) == 1) { did -c $dname 719 }
    if ($ri(misc,tips) == 1) { did -c $dname 720 }
    did -ra $dname 731 $ri(misc,amsg)
    prevbmp $dname 732 10 own 0 $replace($ri(misc,amsg),<text>,Bonjour tout le monde!)
    if ($ri(misc,hlactive) == 1) { did -c $dname 751 }
    if ($ri(misc,hlother) == 1) { did -c $dname 752 }
    if ($ri(misc,noticeother) == 1) { did -c $dname 753 }
    if ($ri(misc,serviceswin) == 1) { did -c $dname 754 }
  }
  ; Misc 2: Masks
  did -c $dname 743 $calc($ri(masks,banmask) + 1)
  did -c $dname 744 $calc($ri(masks,ignoremask) + 1)
  if ($enabled(prots)) {
    ; Channel Protections
    if ($rci(cprot,allpreset) == 1) { did -c $dname 816 }
    var %cprot = $iif($did(812).seltext == Tous,cprot,cprot. $+ $did(812).seltext)
    if ($rci(%cprot,usepreset) == 1) { did -c $dname 815 }
    if ($rci(%cprot,punishops) == 1) { did -c $dname 818 }
    if ($rci(%cprot,punishvoices) == 1) { did -c $dname 819 }
    ; Exclusions
    if ($rci(excludes,others) == 1) { did -c $dname 975 }
  }
  if ($enabled(statbar)) {
    ; Statusbar
    if ($ri(statusbar,use) == 1) { did -c $dname 1011 }
    if ($ri(statusbar,refreshuse) == 1) { did -c $dname 1012 }
    if ($ri(statusbar,refresh) > 0) { did -ra $dname 1013 $ifmatch }
  }
  if ($enabled(messages)) {
    prevbmp $dname 1231 10 kick 2
    prevbmp $dname 1331 10 quit 2
    prevbmp $dname 1431 10 action 2
  }
  if ($enabled(rss)) {
    ; RSS
    if ($ri(rss,use) == 1) { did -c $dname 2611 }
    if ($ri(rss,fetch) == 1) { did -c $dname 2631 }
    if ($ri(rss,time) > 0) { did -ra $dname 2632 $ifmatch }
    if ($ri(rss,allinone) == 1) { did -c $dname 2634 }
    if ($ri(rss,ownwindow) == 1) { did -c $dname 2635 }
    if ($ri(rss,errorshow) == 1) { did -c $dname 2636 }
    if ($ri(rss,notify) == 1) { did -c $dname 2637 }
  }
  if ($enabled(toolbar)) {
    ; Toolbar
    if ($ri(toolbar,use) == 1) { did -c $dname 1811 }
  }
  if ($enabled(mail)) {
    ; Mail Checker
    if ($ri(mails,use) == 1) { did -c $dname 2011 }
    if ($ri(mails,time) > 0) { did -ra $dname 2013 $ifmatch }
    if ($ri(mails,infobox) == 1) { did -c $dname 2015 }
    var %events = $ri(mails,notify)
    if (b isin %events) { did -c $dname 2017 }
    if (e isin %events) { did -c $dname 2018 }
    if (i isin %events) { did -c $dname 2019 }
    if (n isin %events) { did -c $dname 2020 }
    if ($ri(mails,sound)) { did -c $dname 2021 | did -ra $dname 2022 $v1 }
    if ($ri(mails,client)) { did -ra $dname 2024 $v1 }
  }
  if ($enabled(replace)) {
    ; Correction
    if (c isin $ri(replace,filter)) { did -c $dname 2112 }
    if (q isin $ri(replace,filter)) { did -c $dname 2113 }
  }
  if ($enabled(themes)) {
    ; Themes
    var %addoptions = $ri(themes,addoptions), %loadoptions = $ri(themes,loadoptions)
    if (h isin %addoptions) { did -c $dname 2226 }
    if (u isin %addoptions) { did -c $dname 2227 }
    if (w isin %addoptions) { did -c $dname 2228 }
    if (l isin %addoptions) { did -c $dname 2229 }
    if (g isin %addoptions) { did -c $dname 2230 }
    
    if (f isin %loadoptions) { did -c $dname 2231 }
    if (c isin %loadoptions) { did -c $dname 2232 }
    if (n isin %loadoptions) { did -c $dname 2233 }
    if (s isin %loadoptions) { did -c $dname 2234 }
    if (b isin %loadoptions) { did -c $dname 2235 }
    if (i isin %loadoptions) { did -c $dname 2236 }
    if (t isin %loadoptions) { did -c $dname 2237 }
    if (e isin %loadoptions) { did -c $dname 2238 }
    
    if ($ri(themes,fontrep) == 1) { did -c $dname 2241 | did -ra $dname 2242 $ri(themes,font) }
    if ($ri(themes,colors) == 1) { did -c $dname 2243 }
    if ($ri(themes,echo) == 1) { did -c $dname 2244 }
  }
  if ($enabled(copypasta)) {
    ; Copypasta
    did -c $dname $iif($ri(copypasta,paste) == no,2311,$iif($ri(copypasta,paste) == delay,2312,2321))
    did -ra $dname 2313 $ri(copypasta,delay)
    if ($ri(copypasta,limitlines) == 1) { did -c $dname 2315 }
    did -ra $dname 2316 $ri(copypasta,lines)
    did -ra $dname 2318 $ri(copypasta,bytes)
    if ($ri(copypasta,notify) == 1) { did -c $dname 2320 }
    if ($ri(copypasta,crop) == 1) { did -c $dname 2331 }
    did -ra $dname 2332 $ri(copypasta,cropbytes)
    if ($ri(copypasta,strip) == 1) { did -c $dname 2334 }
    if ($ri(copypasta,strip.cmode) == 1) { did -c $dname 2335 }
    if ($ri(copypasta,editbox) == 1) { did -c $dname 2336 }
  }
  if ($enabled(query)) {
    ; Misc 1: Query
    if ($ri(query,autocloseuse) == 1) { did -c $dname 2411 }
    if ($ri(query,autoclose) > 0) { did -ra $dname 2412 $ifmatch }
    if ($ri(query,stats) == 1) { did -c $dname 2414 }
    if ($ri(query,eventsmp) == 1) { did -c $dname 2415 }
    ; Cocher les types de query
    var %qtype = $ri(query,events)
    if (j isin %qtype) { did -c $dname 2416 }
    if (n isin %qtype) { did -c $dname 2417 }
    if (p isin %qtype) { did -c $dname 2418 }
    if (k isin %qtype) { did -c $dname 2419 }
    if (o isin %qtype) { did -c $dname 2420 }
    if (q isin %qtype) { did -c $dname 2421 }
    if (m isin %qtype) { did -c $dname 2422 }
    if (f isin %qtype) { did -c $dname 2423 }

    if ($ri(query,openuse) == 1) { did -c $dname 2431 }
  }
  if ($enabled(tabcomp)) {
    ; Misc 1: Auto-tab
    if ($ri(tabcomp,use) == 1) { did -c $dname 2511 } 
    did -ra $dname 2513 $ri(tabcomp,character) 
    did -ra $dname 2515 $ri(tabcomp,format)
    if ($ri(tabcomp,bsundo) == 1) { did -c $dname 2517 }
    prevbmp $dname 2516 11 own 0 $replace($ri(tabcomp,format),<nick>,$me) salut ca va?
  }
  if ($enabled(autocomp)) {
    if ($ri(autocomp,use) == 1) { did -c $dname 2811 }
    did -ra $dname 2813 $ri(autocomp,refresh)
    if ($ri(autocomp,save) == 1) { did -c $dname 2815 }
    if ($ri(autocomp,learn) == 1) { did -c $dname 2816 }
    if ($ri(autocomp,limituse) == 1) { did -c $dname 2817 }
    did -ra $dname 2818 $ri(autocomp,limit)
    if ($ri(autocomp,enter) == 1) { did -c $dname 2820 }
  }
}

alias -l loadPaths {
  var %i = 31
  
  if ($enabled(fkeys)) {
    did -v $dname $+(%i,-,$calc(%i + 2))
    did -a $dname %i Raccourcis Fn
    did -ra $dname $calc(%i + 1) $ri(paths,fkeys)
    inc %i 3
  }
  if ($enabled(replace)) {
    did -v $dname $+(%i,-,$calc(%i + 2))
    did -a $dname %i Auto-Correction
    did -ra $dname $calc(%i + 1) $ri(paths,replace)
    inc %i 3
  }
  if ($enabled(idents)) {
    did -v $dname $+(%i,-,$calc(%i + 2))
    did -a $dname %i Identifieurs
    did -ra $dname $calc(%i + 1) $ri(paths,idents)
    inc %i 3
  }
  if ($enabled(stats)) {
    did -v $dname $+(%i,-,$calc(%i + 2))
    did -a $dname %i Statistiques
    did -ra $dname $calc(%i + 1) $ri(paths,stats)
    inc %i 3
  }
  if ($enabled(prot)) {
    did -v $dname $+(%i,-,$calc(%i + 2))
    did -a $dname %i Protections
    did -ra $dname $calc(%i + 1) $ri(paths,prot)
    inc %i 3
  }
  if ($enabled(prot)) {
    did -v $dname $+(%i,-,$calc(%i + 2))
    did -a $dname %i Exceptions
    did -ra $dname $calc(%i + 1) $ri(paths,excludes)
    inc %i 3
  }
  if ($enabled(toolbar)) {
    did -v $dname $+(%i,-,$calc(%i + 2))
    did -a $dname %i Toolbar
    did -ra $dname $calc(%i + 1) $ri(paths,toolbar)
    inc %i 3
  }
  if ($enabled(statbar)) {
    did -v $dname $+(%i,-,$calc(%i + 2))
    did -a $dname %i Status Bar
    did -ra $dname $calc(%i + 1) $ri(paths,sbar)
    inc %i 3
  }
  if ($enabled(messages)) {
    did -v $dname $+(%i,-,$calc(%i + 2))
    did -a $dname %i Kicks
    did -ra $dname $calc(%i + 1) $ri(paths,kicks)
    inc %i 3
  }
  if ($enabled(messages)) {
    did -v $dname $+(%i,-,$calc(%i + 2))
    did -a $dname %i Quits
    did -ra $dname $calc(%i + 1) $ri(paths,quits)
    inc %i 3
  }
  if ($enabled(messages)) {
    did -v $dname $+(%i,-,$calc(%i + 2))
    did -a $dname %i Slaps
    did -ra $dname $calc(%i + 1) $ri(paths,slaps)
    inc %i 3
  }
  if ($enabled(messages)) {
    did -v $dname $+(%i,-,$calc(%i + 2))
    did -a $dname %i Mess. d'absence
    did -ra $dname $calc(%i + 1) $ri(paths,aways)
    inc %i 3
  }
  
}


on *:dialog:settings:*:*:{
  if ($devent == init) {
    mdxload
    initOptionsList
    showImage $dname 111 $qt(images/splash.png)

    did -f $dname 1

    ;Initialisation des headers et des propriétés des listes
    initListsMDX

    ; Creer les boutons fleche droite, gauche, haut et bas... 
    mdx SetFont $dname 1025,1026,1121,1122,1131,1132,1826,1827 24 300 Webdings

    ; Changement de police pour les catégories
    mdx SetFont $dname 11,111,112 40 700 Tahoma 
    mdx SetFont $dname 12 20 700 Tahoma

    ;Initialisation des comboboxes
    fillComboBoxes

    ; Remplissage des listes
    initLists

    ; Active/desactive elements
    enableDisableItems

    ; Coche les checkboxes/remplit les editbox
    checkBoxes

    ; Mise en gras des titres de section
    mdx SetFont $dname 30,110,210,310,410,420,460,510,610,710,730,740,750,810,820,910,960,1010,1110,1140,1210,1230,1310,1330,1410,1430,1510,1610,1630,1660,1680,1710,1730,1810,2010,2030,2110,2210,2225,2240,2310,2330,2410,2430,2510,2610,2630,2710,2760,2810,2850 14 700 Tahoma
    
    ; Menu des chemins
    loadPaths
  }
  elseif ($devent == dclick) {
    ; Away triggers
    if ($did == 220) && ($did(220).sel) { awaytrigger.edit }
    ; Away Messages
    elseif ($did == 320) && ($did(320).sel) { awaymess.edit }
    ; Messages ad'absence
    elseif ($did == 470) && ($did(470).sel) { mess.edit aways }
    ; Raccourcis
    elseif ($did == 520) && ($did(520).sel) { fkeys.edit }
    ; Protections canaux
    elseif ($did == 830) && ($did(830).sel) { cprot.changeprot }
    ; Protections personnelles
    elseif ($did == 920) && ($did(920).sel) { pprot.changeprot }
    ; Exclusions
    elseif ($did == 970) && ($did(970).sel) { excludes.edit }
    ; Statusbar
    elseif ($did == 1020) && ($did(1020).sel) { statusbar.edit }
    ; Messahes prédéfinis
    elseif ($did == 1220) && ($did(1220).sel) { mess.edit kicks }
    elseif ($did == 1320) && ($did(1320).sel) { mess.edit quits }
    elseif ($did == 1420) && ($did(1420).sel) { mess.edit slaps }
    ; Idents
    elseif ($did == 1520) && ($did(1520).sel) { idents.edit }
    ; Toolbar
    elseif ($did == 1820) && ($did(1820).sel) && (Separateur !isin $did(1820).seltext)  { toolbar.edit }
    ; Themes
    elseif ($did == 2220) && ($did(2220).sel) { folder.edit }
    ;Query
    elseif ($did == 2440) && ($did(2440).sel) { qnick.edit }
    ;Blacklist/Wlist
    elseif ($did == 2720) && ($did(2720).sel) { bwlist.edit b }
    elseif ($did == 2770) && ($did(2770).sel) { bwlist.edit w }
    ; Autocorrection
    elseif ($did == 2120) && ($did(2120).sel) { replace.edit }
    ; Autocomp
    elseif ($did == 2860) && ($did(2860).sel) { ac.edit }
  }
  elseif ($devent == sclick) {
    ; Sections selection
    if ($did == 1) { changeSection $did(1).seltext }
    ;Logo click : open browser
    elseif ($did == 111) { run explorer.exe http://www.pokemon-france.com/services/chat/ }
    ;Away Logging
    elseif ($did == 211) { 
      did $iif($did(211).state == 1,-e,-b) $dname 212-214,220-224
      did -u $dname 220
      if ($did(220).lines == 0) { did -b $dname 222-224 }
      if (!$did(220).sel) { did -b $dname 222-223 }
      wi awaylog use $did(211).state
    }
    elseif ($did == 212) { wi awaylog events $did(212).state }
    elseif ($did == 213) { wi awaylog op $did(213).state }
    elseif ($did == 220) {
      if ($did(220).sel) { did -e $dname 222,223,224 }
      else { did -b $dname 222,223 }
    }
    elseif ($did == 221) { awaytrigger.add }
    elseif ($did == 222) { awaytrigger.edit }
    elseif ($did == 223) { awaytrigger.del }
    elseif ($did == 224) { awaytrigger.clear }
    ; Away Messages
    elseif ($did == 311) {
      did $iif($did(311).state == 1, -e, -b) $dname 312-315,320-324
      did -u $dname 320
      if ($did(320).lines == 0) { did -b $dname 322-324 }
      if (!$did(320).sel) { did -b $dname 322-323 }
      wi awaymess use $did(311).state
    }
    elseif ($did == 312) { 
      did -b $dname 314-315,320-324
      wi awaymess channel active 
    }
    elseif ($did == 313) { 
      did -e $dname 314-315,320-324
      if ($did(320).lines == 0) { did -b $dname 322-324 }
      if (!$did(320).sel) { did -b $dname 322-323 }
      wi awaymess channel all 
    }
    elseif ($did == 314) { wi awaymess query $did(314).state }
    elseif ($did == 315) { 
      did $iif($did(315).state == 1, -e, -b) $dname 320-324
      if ($did(320).lines == 0) { did -b $dname 322-324 }
      if (!$did(320).sel) { did -b $dname 322-323 }
      wi awaymess exclude $did(315).state 
    }
    elseif ($did == 320) {
      if ($did(320).sel) { did -e $dname 322-324 }
      else { did -b $dname 322-323 }
    }
    elseif ($did == 321) { awaymess.add }
    elseif ($did == 322) { awaymess.edit }
    elseif ($did == 323) { awaymess.del }
    elseif ($did == 324) { awaymess.clear }
    ; Away misc
    elseif ($did == 412) { 
      loadServerAwayInfo 
      if ($did(412).seltext != Défaut) { did -e $dname 414 }
      else { did -b $dname 414 }
    }
    elseif ($did == 413) { servers.add | loadServerAwayInfo }
    elseif ($did == 414) { servers.del | loadServerAwayInfo }
    elseif ($did == 421) { wi awaymisc noothers $did($did).state }
    elseif ($did == 422) { wi awaymisc awayconnect $did($did).state }
    elseif ($did == 423) { 
      wi awaymisc autoawayuse $did($did).state
      did $iif($did($did).state == 1,-e,-b) $dname 426-427
      .timeraway.autoidle -i $iif($did($did).state == 1,0 30 checkidle,off)
    }
    elseif ($did == 426) { wi awaymisc nomessage $did($did).state }
    elseif ($did == 427) { wi awaymisc notify $did($did).state }
    elseif ($did == 429) { wi awaymisc backnick default }
    elseif ($did == 430) { wi awaymisc backnick old }
    ; Slaps prédef.
    elseif ($did == 470) {
      var %defmsg = $me est à présent absent: <text> $1
      var %preview = $getColValue($dname,$did,$did($did).sel,2)
      if ($enabled(themes)) && ($theme.current) {
        var %quitmessage = $iif($hget(theme.current,away),$v1,%defmsg)
        theme.vars
        set -nu %::nick $me
        set -u %::cnick $cnick($me).color
        set -nu %::address fake@address.com
        set -nu %::text %preview
        var %quitmessage = $theme.parse($iif($theme.current == mts,m,y),%quitmessage)
        %quitmessage = [ [ %quitmessage ] ] 
        %quitmessage = $replace(%quitmessage,% $+ ::text,%::text)
        
        %defmsg = %quitmessage
      }
      else { %defmsg = $replace(%defmsg,<text>,%preview) }
      prevbmp $dname 481 11 action 1 $replaceidents($replace(%defmsg,/me,,$ $+ 1,Might))
      did $iif($did($did).seltext,-e,-b) $dname 472-473
    }
    elseif ($did == 471) { mess.add aways }
    elseif ($did == 472) { mess.edit aways }
    elseif ($did == 473) { mess.del aways }
    elseif ($did == 474) { mess.clear aways }
    elseif ($did == 475) { mess.def aways }
    ; Raccourcis
    elseif ($did == 520) {
      if ($did(520).sel) { did -e $dname 521,523,526 }
      else { did -b $dname 521,523,526 }
    }
    elseif ($did == 521) { fkeys.delsel }
    elseif ($did == 522) { fkeys.delall }
    elseif ($did == 523) { fkeys.setdef }
    elseif ($did == 524) { fkeys.restoreall }
    elseif ($did == 525) { loadFkeysAliases | $infodialog(Raccourcis appliqués!) }
    elseif ($did == 526) { fkeys.edit }
    ; Titlebar
    elseif ($did == 611) { 
      did $iif($did($did).state == 1,-e,-b) $dname 612-620 
      wi titlebar use $did($did).state 
      activeTitlebar
    }
    elseif ($did == 612) { 
      did $iif($did($did).state == 1,-e,-b) $dname 613-614 
      wi titlebar refreshuse $did($did).state
      .timertitlebar -io 0 $ri(titlebar,refresh) refreshTitlebar 
    }
    elseif ($did == 618) { 
      did $iif($did($did).state == 1,-e,-b) $dname 619-620
      wi titlebar iconuse $did($did).state
      activeTitlebar
    }
    elseif ($did == 620) { 
      var %icon = $$sfile($did(619)/*.ico,Choisissez une icône)
      wi titlebar icon $shortfn(%icon)
      did -g $dname 620 $qt(%icon)
      did -ra $dname 619 $shortfn(%icon)
      activeTitlebar
    }
    ;Options générales
    elseif ($did == 711) { 
      if (!$hget(chankeys)) { hmake chankeys 10 }
      var %f = $qt(data/chankeys.txt)
      if ($exists(%f)) {
        if ($did($did).state == 1) { hload chankeys %f }
        else { hsave chankeys %f }
      }
      wi misc keepkey $did($did).state 
    }
    elseif ($did == 712) { wi misc lookupdates $did($did).state }
    elseif ($did == 713) { 
      did $iif($did($did).state == 1,-e,-b) $dname 714
      var %time = $did(714)
      if (%time > 0) { .timerantiidle -i $iif($did($did).state == 1,0 %time resetidle,off) }
      wi misc antiidleuse $did($did).state 
    }
    elseif ($did == 716) { wi misc kickcount $did($did).state }
    elseif ($did == 717) { wi misc clearcb $did($did).state }
    elseif ($did == 718) { wi misc dccinfo $did($did).state }
    elseif ($did == 719) { wi misc splash $did($did).state }
    elseif ($did == 720) { wi misc tips $did($did).state } 
    elseif ($did == 743) { wi masks banmask $calc($did($did).sel - 1) }
    elseif ($did == 744) { wi masks ignoremask $calc($did($did).sel - 1) }
    ; Highlights
    elseif ($did == 751) { wi misc hlactive $did($did).state }
    elseif ($did == 752) { wi misc hlother $did($did).state }
    elseif ($did == 753) { wi misc noticeother $did($did).state }
    elseif ($did == 754) { wi misc serviceswin $did($did).state }
    ;Channel protections
    elseif ($did == 812) { 
      did $iif($did($did).seltext == Tous,-b,-e) $dname 814,815
      cprot.reflist
    }
    elseif ($did == 813) { cprot.add }
    elseif ($did == 814) { cprot.del }
    elseif ($did == 816) { 
      did $iif($did($did).state == 1,-b,-e) $dname 815,817-819,830-831
      if ($did(812).seltext == Tous) { did -b $dname 815 }
      wci cprot allpreset $did($did).state
    }
    elseif ($did == 815) { 
      did $iif($did($did).state == 1,-b,-e) $dname 816,817-819,830-831
      wci cprot. $+ $did(812).seltext usepreset $did($did).state
    }
    elseif ($did == 818) { 
      wci $iif($did(812).seltext != Tous,cprot. $+ $did(812).seltext,cprot) punishops $did($did).state 
    }
    elseif ($did == 819) { 
      wci $iif($did(812).seltext != Tous,cprot. $+ $did(812).seltext,cprot) punishvoices $did($did).state 
    }
    elseif ($did == 830) { 
      did $iif($did($did).sel,-e,-b) $dname 832 
      ; Clic sur la checkbox
      if (stateclick isin $did($did,1)) {
        var %sel = $lastCheck($dname,$did)
        setProtParam $iif($did(812).seltext != Tous,$did(812).seltext,default) $getColValue($dname,830,%sel,1) use $iif($gettok($did(830,%sel),5,32) == 2,0,1)
      }
    }
    elseif ($did == 831) { cprot.resetdef  }
    elseif ($did == 832) { cprot.changeprot }
    ; Personal protections
    elseif ($did == 920) {
      did $iif($did($did).sel,-e,-b) $dname 922
      ; Clic sur la checkbox
      if (stateclick isin $did($did,1)) {
        var %sel = $lastCheck($dname,$did)
        setProtParam pprot $getColValue($dname,920,%sel,1) use $iif($gettok($did(920,%sel),5,32) == 2,0,1)
      }
    }
    elseif ($did == 921) { pprot.resetdef  }
    elseif ($did == 922) { pprot.changeprot }
    ; Excludes
    elseif ($did == 970) { did $iif($did($did).sel,-e,-b) $dname 972-973 }
    elseif ($did == 971) { excludes.add }
    elseif ($did == 972) { excludes.edit }
    elseif ($did == 973) { excludes.del }
    elseif ($did == 974) { excludes.clear }
    elseif ($did == 975) { wci excludes others $did($did).state }
    ; Status bar
    elseif ($did == 1011) {
      did $iif($did($did).state == 1,-e,-b) $dname 1012-1014,1020-1029
      if ($did(1020).enabled) {
        if ($did(1020).lines <= 1) { did -b $dname 1022-1026 }
        else { did -b $dname 1022-1023,1025-1026 }
      }
      wi statusbar use $did($did).state
      if ($did(1020).lines > 1) { activeStatusbar $iif($did($did).state == 0,-u) }
    }
    elseif ($did == 1012) { 
      did $iif($did($did).state,-e,-b) $dname 1013
      wi statusbar refreshuse $did($did).state 
    }
    elseif ($did == 1020) {
      if ($did(1020).enabled) {
        if ($did($did).sel) { did -e $dname 1022-1023,1025-1026 }
        else { did -b $dname 1022-1023,1025-1026 }
        if ($did($did).sel == $did($did).lines) { did -b $dname 1025 }
        if ($did($did).sel == 2) { did -b $dname 1026 }
      }
    }
    elseif ($did == 1021) { statusbar.add }
    elseif ($did == 1022) { statusbar.edit }
    elseif ($did == 1023) { statusbar.del }
    elseif ($did == 1024) { statusbar.clear }
    elseif ($did == 1025) { statusbar.move down }
    elseif ($did == 1026) { statusbar.move up }
    elseif ($did == 1027) {
      newpopup statusmenu
      newmenu statusmenu 1 $chr(9) + 1 0 &Défaut (HeartGold)
      newmenu statusmenu 2 $chr(9) + 2 0 &Défaut (NNscript)
      newmenu statusmenu 3 $chr(9) + 3 0 &Infos de connexion
      newmenu statusmenu 4 $chr(9) + 4 0 &Fils RSS
      displaypopup statusmenu
    }
    elseif ($did == 1028) { statusbar.import }
    elseif ($did == 1029) { statusbar.save }
    ; Favoris
    elseif ($did == 1120) { 
      did $iif($did(1120).sel,-e,-b) $dname 1121 
      did $iif($did(1120).sel,-b,-e) $dname 1122 
    }
    elseif ($did == 1121) { 
      var %line = $did(1120).sel, %seltext = $did(1120).seltext
      did -d $dname 1120 %line
      did -a $dname 1130 %seltext
      var %favs = $ri(servers,favorites)
      wi servers favorites $addtok(%favs,%seltext,59)
      if ($did(1120).lines == 0) { did -b $dname 1121 }
    }
    elseif ($did == 1122) {
      var %line = $did(1130).sel, %seltext = $did(1130).seltext
      did -d $dname 1130 %line
      did -a $dname 1120 %seltext
      var %favs = $ri(servers,favorites)
      wi servers favorites $remtok(%favs,%seltext,1,59)
      if ($did(1130).lines == 0) { did -b $dname 1122 }
      did -b $dname 1141-1153,1161-1167
    }
    elseif ($did == 1130) { 
      did $iif($did(1130).sel,-e,-b) $dname 1122 
      did $iif($did(1130).sel,-b,-e) $dname 1121
      if ($did(1130).seltext) { 
        did $iif($did(1130).sel == 1,-b,-e) $dname 1131
        did $iif($did(1130).sel == $did(1130).lines,-b,-e) $dname 1132
        loadServerInfo
      }
      else { did -b $dname 1141-1153,1161-1167 }
    }
    elseif ($did == 1131) { 
      var %sel = $did(1130).sel, %seltext = $did(1130).seltext
      if (%sel) {
        var %usel = $calc(%sel - 1)
        did -d $dname 1130 %sel
        did -i $dname 1130 %usel %seltext
        did -c $dname 1130 %usel
        did $iif($did(1130).sel == 1,-b,-e) $dname 1131
        did $iif($did(1130).sel == $did(1130).lines,-b,-e) $dname 1132
        wi servers favorites $didtok($dname,1130,59)
      }
    }
    elseif ($did == 1132) {
      var %sel = $did(1130).sel, %seltext = $did(1130).seltext
      if (%sel) {
        var %dsel = $calc(%sel + 1)
        did -d $dname 1130 %sel
        did -i $dname 1130 %dsel %seltext
        did -c $dname 1130 %dsel
        did $iif($did(1130).sel == 1,-b,-e) $dname 1131
        did $iif($did(1130).sel == $did(1130).lines,-b,-e) $dname 1132
        wi servers favorites $didtok($dname,1130,59)
      }
    }
    elseif ($did >= 1148 && $did <= 1152) { writeServerInfo }
    ; Kicks prédef.
    elseif ($did == 1220) {
      var %defmsg = $me a kické BadGuy de #channel $lparen $+ <text> $+ $rparen
      var %preview = $getColValue($dname,$did,$did($did).sel,2)
      if ($enabled(themes)) && ($theme.current) {
        var %kmessage = $iif($hget(theme.current,kick),$v1,%defmsg)
        theme.vars
        set -nu %::nick $me
        set -nu %::cnick $cnick($me).color
        set -nu %::address fake@address.com
        set -nu %::chan #channel
        set -nu %::knick BadGuy
        set -nu %::kcmode +
        set -nu %::kaddress bad@guy.com
        set -nu %::text %preview
        set -nu %::parentext $ptext(%preview)
        var %kmessage = $theme.parse($iif($theme.current == mts,m,y),%kmessage)
        %kmessage = [ [ %kmessage ] ] 
        %kmessage = $replace(%kmessage,% $+ ::text,%::text)
      
        %defmsg = %kmessage
      }
      else { %defmsg = $replace(%defmsg,<text>,%preview) }
      prevbmp $dname 1231 11 kick 1 $replaceidents(%defmsg)
      did $iif($did($did).seltext,-e,-b) $dname 1222-1223
    }
    elseif ($did == 1221) { mess.add kicks }
    elseif ($did == 1222) { mess.edit kicks }
    elseif ($did == 1223) { mess.del kicks }
    elseif ($did == 1224) { mess.clear kicks }
    elseif ($did == 1225) { mess.def kicks }
    ; Quits prédef.
    elseif ($did == 1320) {
      var %defmsg = $me a quitté IRC $lparen $+ <text> $+ $rparen
      var %preview = $getColValue($dname,$did,$did($did).sel,2)
      if ($enabled(themes)) && ($theme.current) {
        var %quitmessage = $iif($hget(theme.current,quit),$v1,%defmsg)
        theme.vars
        set -nu %::nick $me
        set -u %::cnick $cnick($me).color
        set -nu %::address fake@address.com
        set -nu %::text %preview
        set -nu %::parentext $ptext(%preview)
        var %quitmessage = $theme.parse($iif($theme.current == mts,m,y),%quitmessage)
        %quitmessage = [ [ %quitmessage ] ] 
        %quitmessage = $replace(%quitmessage,% $+ ::text,%::text)
        
        %defmsg = %quitmessage
      }
      else { %defmsg = $replace(%defmsg,<text>,%preview) }
      prevbmp $dname 1331 11 quit 1 $replaceidents(%defmsg)
      did $iif($did($did).seltext,-e,-b) $dname 1322-1323
    }
    elseif ($did == 1321) { mess.add quits }
    elseif ($did == 1322) { mess.edit quits }
    elseif ($did == 1323) { mess.del quits }
    elseif ($did == 1324) { mess.clear quits }
    elseif ($did == 1325) { mess.def quits }
    ; Slaps prédef.
    elseif ($did == 1420) {
      var %defmsg = $me <text> $1
      var %preview = $getColValue($dname,$did,$did($did).sel,2)
      if ($enabled(themes)) && ($theme.current) {
        var %quitmessage = $iif($hget(theme.current,actionchanself),$v1,%defmsg)
        theme.vars
        set -nu %::nick $me
        set -u %::cnick $cnick($me).color
        set -nu %::address fake@address.com
        set -nu %::text %preview
        var %quitmessage = $theme.parse($iif($theme.current == mts,m,y),%quitmessage)
        %quitmessage = [ [ %quitmessage ] ] 
        %quitmessage = $replace(%quitmessage,% $+ ::text,%::text)
        
        %defmsg = %quitmessage
      }
      else { %defmsg = $replace(%defmsg,<text>,%preview) }
      prevbmp $dname 1431 11 action 1 $replaceidents($remove(%defmsg,/me))
      did $iif($did($did).seltext,-e,-b) $dname 1422-1423
    }
    elseif ($did == 1421) { mess.add slaps }
    elseif ($did == 1422) { mess.edit slaps }
    elseif ($did == 1423) { mess.del slaps }
    elseif ($did == 1424) { mess.clear slaps }
    elseif ($did == 1425) { mess.def slaps }
    ;Idents
    elseif ($did == 1520) { did $iif($did($did).sel,-e,-b) $dname 1522-1523 }
    elseif ($did == 1521) { idents.add }
    elseif ($did == 1522) { idents.edit }
    elseif ($did == 1523) { idents.del }
    elseif ($did == 1524) { idents.clear }
    elseif ($did == 1525) { idents.def }
    ;Services: Nickserv
    elseif ($did == 1612) { loadServiceInfo nick }
    elseif ($did == 1613) { nserv.add | loadServiceInfo nick }
    elseif ($did == 1614) { nserv.del | loadServiceInfo nick }
    elseif ($did == 1616) { 
      var %serv = $did(1612).seltext, %nick = $did($did).seltext
      loadServiceSubInfo nick $ri(services,$buildtok(46,nick,%serv,%nick))
    }
    elseif ($did == 1620) { 
      did -h $dname 1618,1620
      did -v $dname 1619,1621
    }
    elseif ($did == 1621) {
      did -h $dname 1619,1621
      did -v $dname 1618,1620
    }
    elseif ($did >= 1622) && ($did <= 1625) { writeServiceInfo nick }
    elseif ($did >= 1632) && ($did <= 1640) { 
      var %serv = $did(1612).seltext, %nick = $did(1616).seltext, %pass = $did(1619)
      if ($did == 1632) { 
        netcmd %serv 1 nick %nick | netcmd %serv 1 ns glist 
      }
      elseif ($did == 1633) { 
        var %pseudo = $$inputdialog(Entrez un pseudo que vous voulez grouper au pseudo sélectionnéNote: Assurez-vous d'entrer un pseudo qui n'est pas déjà enregistré!)
        netcmd %serv 1 nick %pseudo | netcmd %serv 1 ns group %nick %pass
      }
      elseif ($did == 1634) {
        if ($$yndialog(Êtes-vous sur de vouloir dropper le pseudo sélectionné? Cette action est irréversible.)) {
          nserv.del | loadServiceInfo nick
          netcmd %serv 1 nick %nick | netcmd %serv 1 ns drop %nick
        }
      }
      elseif ($did == 1635) {
        var %infos = $$formdialog(Vous êtes sur le point d'enregistrer le pseudo %nick sur le serveur %serv . Veuillez renseigner un mot de passe ainsi qu'une adresse mail nécessaire à l'activation du nick enregistré.,Mot de passe,Email,%pass)
        tokenize 1 %infos
        if ($0 == 2) { 
          netcmd %serv 1 nick %nick | netcmd %serv 1 ns register $1 $2 
        }
      }
      elseif ($did == 1636) { netcmd %serv 1 nick %nick | netcmd %serv 1 ns alist }
      elseif ($did == 1637) {  netcmd %serv 1 nick %nick | netcmd %Serv 1 ns sendpass %nick }
      elseif ($did == 1638) { 
        var %newpass = $$inputdialog(Entrez le nouveau password pour le nick %nick .Notez que cette commande change le mot de passe spécifié au dessus sans prendre en compte la réponse du serveur. Soyez donc vigilants et assurez-vous que les informations entrées sont exactes.)
        netcmd %serv 1 nick %nick | netcmd %Serv 1 ns set password %newpass
        did -ra $dname 1618,1619 %newpass 
      }
      elseif ($did == 1639) {
        var %newlang = $$inputdialog(Entrez le nouveau numéro correspondant à la langue employée par les services. Pour connaître quels numéros correspondent à quelle langue $+ $comma tapez /ns help set language.)
        netcmd %serv 1 nick %nick | netcmd %serv 1 ns set language %newlang
      }
      elseif ($did == 1640) {
        var %newmail = $$inputdialog(Entrez le nouveau mail qui sera utilisé pour la récupération des mots de passe. Assurez-vous d'entrer un format de mail convenable.)
        netcmd %serv 1 nick %nick | netcmd %serv 1 ns set email %newmail
      }
    }
    ;Services: Chanserv
    elseif ($did == 1662) { loadServiceInfo chan }
    elseif ($did == 1663) { cserv.add | loadServiceInfo chan }
    elseif ($did == 1664) { cserv.del | loadServiceInfo chan }
    elseif ($did == 1666) { 
      var %serv = $did(1662).seltext, %nick = $did($did).seltext
      loadServiceSubInfo chan $ri(services,$buildtok(46,chan,%serv,%nick))
    }
    elseif ($did == 1670) { 
      did -h $dname 1668,1670
      did -v $dname 1669,1671
    }
    elseif ($did == 1671) {
      did -h $dname 1669,1671
      did -v $dname 1668,1670
    }
    elseif ($did >= 1672) && ($did <= 1675) { writeServiceInfo chan }
    elseif ($did >= 1682) && ($did <= 1693) { 
      var %serv = $did(1662).seltext, %chan = $did(1666).seltext, %pass = $did(1669)
      if ($did == 1682) { netcmd %serv 1 cs access %chan list }
      elseif ($did == 1683) { 
        var %newaxx = $$formdialog(Entrez le nick que vous voulez ajouter aux accès de %chan ainsi que le niveau d'accès que vous voulez lui accorder.,Pseudo,Niveau d'accès)
        tokenize 1 %newaxx 
        netcmd %serv 1 cs access %chan add $1 $2
      }
      elseif ($did == 1684) {
        var %axx = $$inputdialog(Entrez le pseudo que vous voulez enlever de la liste d'accès)
        netcmd %serv 1 cs access %chan del %axx
      }
      elseif ($did == 1685) { netcmd %serv 1 cs akick %chan list }
      elseif ($did == 1686) { 
        var %newaxx = $$formdialog(Entrez l'adresse que vous voulez ajouter aux akicks de %chan $+ .Vous pouvez aussi ajouter la raison de l'akick,Pseudo,Raison de l'akick)
        tokenize 1 %newaxx 
        netcmd %serv 1 cs akick %chan add $1 $2
      }
      elseif ($did == 1687) {
        var %axx = $$inputdialog(Entrez l'adresse que vous voulez enlever de la liste d'akicks:)
        netcmd %serv 1 cs akick %chan del %axx
      }
      elseif ($did == 1688) {
        var %infos = $$formdialog(Vous êtes sur le point d'enregistrer le canal %chan sur le serveur %serv . Veuillez renseigner un mot de passe ainsi qu'une description du canal enregistré.,Mot de passe,Description,%pass)
        tokenize 1 %infos
        if ($0 == 2) { netcmd %serv 1 cs register %chan $1 $2 }
      }
      elseif ($did == 1689) { 
        cserv.del | loadServiceInfo chan
        netcmd %serv 1 cs drop %chan 
      }
      elseif ($did == 1690) { netcmd %Serv 1 cs sendpass %chan }
      elseif ($did == 1691) { 
        var %newpass = $$inputdialog(Entrez le nouveau password du canal %chan .Notez que cette commande change le mot de passe spécifié au dessus sans prendre en compte la réponse du serveur. Soyez donc vigilants et assurez-vous que les informations entrées sont exactes.)
        netcmd %Serv 1 cs set %chan password %newpass
        did -ra $dname 1668,1669 %newpass 
      }
      elseif ($did == 1692) {
        var %newlang = $$inputdialog(Entrez le nouveau topic à assigner au canal %chan :)
        netcmd %serv 1 topic %chan %newlang
      }
      elseif ($did == 1693) {
        var %newmail = $$inputdialog(Entrez la nouvelle description du canal %chan :)
        netcmd %serv 1 cs set %chan desc %newmail
      }
    }
    ;Services: Botserv
    elseif ($did == 1712) { loadServiceInfo bot }
    elseif ($did == 1713) { bserv.add | loadServiceInfo bot }
    elseif ($did == 1714) { bserv.del | loadServiceInfo bot }
    elseif ($did == 1716) { 
      var %serv = $did(1712).seltext, %chan = $did($did).seltext
      loadServiceSubInfo bot $ri(services,$buildtok(46,bot,%serv,%chan))
    }
    elseif ($did == 1719) { 
      var %serv = $did(1712).seltext, %chan = $did(1716).seltext, %bot = $did(1718)
      netcmd %serv 1 bs assign %chan %bot
    }
    elseif ($did >= 1721) && ($did <= 1723) { writeServiceInfo bot }
    elseif ($did >= 1732) && ($did <= 1736) { 
      var %serv = $did(1712).seltext, %chan = $did(1716).seltext, %bot = $did(1718)
      if ($did == 1732) { netcmd %serv 1 bs badwords %chan list }
      elseif ($did == 1733) { 
        var %bw = $$inputdialog(Entrez un nouveau badword à ajouter à la liste des badwords gérés par le bot %bot sur %chan :)
        netcmd %serv 1 bs badwords %chan add %bw single 
      }
      elseif ($did == 1734) {
        var %bw = $$inputdialog(Entrez le badword que vous voulez enlever de la liste de badwords gérés par le bot %bot sur %chan :)
        netcmd %serv 1 bs badwords %chan del %bw
      }
      elseif ($did == 1735) {
        if ($$yndialog(Êtes-vous sûr de vouloir désassigner le bot %bot du canal %chan ?)) {
          netcmd %serv 1 bs unassign %chan
        }
      }
      elseif ($did == 1736) {
        set -e %serv.serv %serv
        set -e %serv.chan %chan
        opendialog -mh serv.protections
      }
    }
    ;Toolbar
    elseif ($did == 1811) { 
      did $iif($did($did).state == 1,-e,-b) $dname 1820-1830
      if ($did($did).state == 1) { changeToolbar }
      else { toolbar -r }
      if ($did(1820).enabled) {
        if ($did(1820).lines <= 1) { did -b $dname 1823-1827,1830 }
        else { did -b $dname 1823-1824,1826-1827 }
      }
      wi toolbar use $did($did).state 
    }
    elseif ($did == 1820) {
      if ($did(1820).enabled) {
        if ($did($did).sel) { did -e $dname 1823-1824,1826-1827 }
        else { did -b $dname 1823-1824,1826-1827 }
        if (Separateur isin $did($did).seltext) { did -b $dname 1823 }
        if ($did($did).sel == $did($did).lines) { did -b $dname 1827 }
        if ($did($did).sel == 2) { did -b $dname 1826 }
      }
    }
    elseif ($did == 1821) { toolbar.add }
    elseif ($did == 1822) { toolbar.addsep }
    elseif ($did == 1823) { toolbar.edit }
    elseif ($did == 1824) { toolbar.del }
    elseif ($did == 1825) { toolbar.clear }
    elseif ($did == 1826) { toolbar.move up }
    elseif ($did == 1827) { toolbar.move down }
    elseif ($did == 1828) { 
      newpopup presetmenu
      newmenu presetmenu 1 $chr(9) + 1 0 &Défaut
      if ($findfile(images/bars/HeartGold/,*.ico,1)) { newmenu presetmenu 2 $chr(9) + 2 0 &HeartGold }
      if ($findfile(images/bars/buttons/green/,*.ico,1)) { newmenu presetmenu 3 $chr(9) + 3 0 &Buttons }
      if ($findfile(images/bars/jaffa/,*.ico,1)) { newmenu presetmenu 4 $chr(9) + 4 0 &Jaffa }
      if ($findfile(images/bars/nnscript/,*.ico,1)) { newmenu presetmenu 5 $chr(9) + 5 0 &NNscript }
      if ($findfile(images/bars/phoenity/,*.ico,1)) { newmenu presetmenu 6 $chr(9) + 6 0 &Phoenity }
      if ($findfile(images/bars/moonshine/,*.ico,1)) { newmenu presetmenu 7 $chr(9) + 7 0 &Moonshine }
      if ($findfile(images/bars/classic/,*.ico,1)) { newmenu presetmenu 8 $chr(9) + 8 0 mIRC &Classic }
      if ($findfile(images/bars/modern/,*.ico,1)) { newmenu presetmenu 9 $chr(9) + 9 0 mIRC M&odern }
      if ($findfile(images/bars/megapack/,*.ico,1)) { newmenu presetmenu 10 $chr(9) + 10 0 Megapack &1 }
      displaypopup presetmenu
    }
    elseif ($did == 1829) { toolbar.import }
    elseif ($did == 1830) { toolbar.save }
    ;Mail
    elseif ($did == 2011) {
      did $iif($did($did).state == 1,-e,-b) $dname 2012-2021
      wi mails use $did($did).state 
      .timermailcheck $iif($did($did).state,0 $calc($did(2013) * 60) checkMail,off)
    }
    elseif ($did == 2015) { wi mails infobox $did($did).state }
    elseif ($did >= 2017) && ($did <= 2020) { wi mails notify $mailEvents }
    elseif ($did == 2021) { 
      if ($did($did).state) { 
        var %snd = $iif($sfile($mircdir,Choix d'un son personnalisé),$ifmatch,0)
        wi mails sound %snd
        if (%snd != 0) { did -ra $dname 2022 %snd }
        else { did -r $dname 2022 | did -u $dname 2021 }
      }
      else { wi mails sound 0 | did -r $dname 2022 }
    }
    elseif ($did == 2025) {
      var %client = $$sfile("C:\Program Files\*.exe",Sélectionnez le programme correspondant à votre client de messagerie)
      did -ra $dname 2024 $nopath(%client)
      wi mails client $did(2024)
    }
    elseif ($did == 2032) { loadMailInfo }
    elseif ($did == 2033) { mail.add | loadMailInfo }
    elseif ($did == 2034) { mail.del | loadMailInfo }
    elseif ($did == 2036) || ($did == 2037) || ($did == 2040) { writeMailInfo }
    elseif ($did == 2046) { did -h $dname 2044,2046 | did -v $dname 2045,2047 }
    elseif ($did == 2047) { did -h $dname 2045,2047 | did -v $dname 2044,2046 }
    ; Correction
    elseif ($did == 2112) || ($did == 2113) { wi replace filter $iif($did(2112).state,c) $+ $iif($did(2113).state,q) }
    elseif ($did == 2120) { 
      did $iif($did($did).sel,-e,-b) $dname 2122-2123
    }
    elseif ($did == 2121) { replace.add }
    elseif ($did == 2122) { replace.edit }
    elseif ($did == 2123) { replace.del }
    elseif ($did == 2124) { replace.clear }    
    ; Themes
    elseif ($did == 2212) {
      if ($did($did).seltext != $ri(themes,theme)) {
        var %sel = $did($did).sel, %f = $did(2216,%sel)
        loadTheme %f
        theme.loadThemes
      }
    }
    elseif ($did == 2214) {
      if ($did($did).seltext != $ri(themes,scheme)) {
        loadScheme $iif($calc($did($did).sel - 1) != 0,$v1)
      }
    }
    elseif ($did == 2220) { did $iif($did($did).sel,-e,-b) $dname 2222-2223 }
    elseif ($did == 2221) { folder.add }
    elseif ($did == 2222) { folder.edit }
    elseif ($did == 2223) { folder.del }
    elseif ($did == 2224) { folder.clear }
    elseif ($did >= 2226) && ($did <= 2238) { themeoptions }
    elseif ($did == 2241) { 
      if ($did($did).state == 1) {
        var %newf = $dcx(FontDialog,default + ansi 9 $did(2242))
        if (%newf) { 
          tokenize 32 %newf
          var %fff = $buildtok(44,$5-,$4,$2)
          did -ra $dname 2242 %fff | wi themes font %fff
        }
        else { did -u $dname $did | halt }
      }
      else { did -ra $dname 2242 | remi themes font }
      wi themes fontrep $did($did).state 
      refreshTheme
    }
    elseif ($did == 2243) { wi themes colors $did($did).state }
    elseif ($did == 2244) { wi themes echo $did($did).state }
    ;Copypasta
    elseif ($did == 2311) { 
      did -b $dname 2313-2320
      wi copypasta paste no 
    }
    elseif ($did == 2312) { 
      did -e $dname 2313-2320
      did $iif($did(2315).state == 1,-e,-b) $dname 2316-2319
      wi copypasta paste delay
    }
    elseif ($did == 2315) { 
      did $iif($did(2315).state == 1,-e,-b) $dname 2316-2319
      wi copypasta limitlines $did($did).state
    }
    elseif ($did == 2320) { wi copypasta notify $did($did).state }
    elseif ($did == 2321) { 
      did -b $dname 2313-2320
      wi copypasta paste default
    }
    elseif ($did == 2331) {
      did $iif($did(2331).state == 1,-e,-b) $dname 2332
      wi copypasta crop $did($did).state
    }
    elseif ($did == 2334) { 
      did $iif($did(2334).state == 1,-e,-b) $dname 2335
      wi copypasta strip $did($did).state
    }
    elseif ($did == 2335) { wi copypasta strip.cmode $did($did).state }
    elseif ($did == 2336) { wi copypasta editbox $did($did).state }
    ;Query
    elseif ($did == 2411) { 
      did $iif($did($did).state == 1,-e,-b) $dname 2412
      wi query autocloseuse $did($did).state 
      .timerautoclose -i $iif($did($did).state == 1,0 30 checkAutoClose,off)
    }
    elseif ($did == 2414) { wi query stats $did($did).state } 
    elseif ($did == 2415) { 
      did $iif($did($did).state == 1,-e,-b) $dname 2416-2423
      wi query eventsmp $did($did).state 
    }
    elseif ($did isin 2416/2417/2418/2419/2420/2421/2422/2423) {
      wi query events $queryEvents
    }
    elseif ($did == 2431) {
      did $iif($did($did).state == 1,-e,-b) $dname 2440,2441,2444
      did $iif($did(2440).lines > 0,-e,-b) $dname 2444
      wi query openuse $did($did).state
    }
    elseif ($did == 2440) {
      did $iif($did($did).sel,-e,-b) $dname 2442-2443
    }
    elseif ($did == 2441) { qnick.add }
    elseif ($did == 2442) { qnick.edit }
    elseif ($did == 2443) { qnick.del }
    elseif ($did == 2444) { qnick.clear }
    ; tabcomp
    elseif ($did == 2511) { 
      did $iif($did($did).state == 1,-e,-b) $dname 2512-2516
      wi tabcomp use $did($did).state 
    }
    elseif ($did == 2517) { wi tabcomp bsundo $did($did).state }
    ; Blacklist/Whitelist
    elseif ($did == 2712) { bwlist.reflist b }
    elseif ($did == 2713) { bwlist.addchan b }
    elseif ($did == 2714) { bwlist.delchan b }
    elseif ($did == 2720) { did $iif($did(2720).sel,-e,-b) $dname 2722-2723 }
    elseif ($did == 2721) { bwlist.add b }
    elseif ($did == 2722) { bwlist.edit b }
    elseif ($did == 2723) { bwlist.del b }
    elseif ($did == 2724) { bwlist.clear b }
    elseif ($did == 2762) { bwlist.reflist w }
    elseif ($did == 2763) { bwlist.addchan w }
    elseif ($did == 2764) { bwlist.delchan w }
    elseif ($did == 2770) { did $iif($did(2770).sel,-e,-b) $dname 2772-2773 }
    elseif ($did == 2771) { bwlist.add w }
    elseif ($did == 2772) { bwlist.edit w }
    elseif ($did == 2773) { bwlist.del w }
    elseif ($did == 2774) { bwlist.clear w }
    ; Autocomp
    elseif ($did == 2811) { 
      did $iif($did($did).state == 1,-e,-b) $dname 2812-2820
      did $iif($did(2817).state == 1,-e,-b) $dname 2818,2819
      wi autocomp use $did($did).state
      .timer_acopen $iif($did($did).state == 1,-mio 0 $ri(autocomp,refresh) acOpen,off)
      .timer_aclimit $iif($did($did).state == 1,0 60 acLimit,off)
    }
    elseif ($did == 2815) { wi autocomp save $did($did).state }
    elseif ($did == 2816) { wi autocomp learn $did($did).state }
    elseif ($did == 2817) { 
      did $iif($did($did).state == 1,-e,-b) $dname 2818,2819
      wi autocomp limit $did($did).state 
      .timer_aclimit $iif($did($did).state == 1,0 60 acLimit,off)
    }
    elseif ($did == 2820) { wi autocomp enter $did($did).state }
    elseif ($did == 2860) { did $iif($did($did).sel,-e,-b) $dname 2862,2863 }
    elseif ($did == 2861) { ac.add }
    elseif ($did == 2862) { ac.edit }
    elseif ($did == 2863) { ac.del }
    elseif ($did == 2864) { ac.clear }
    elseif ($did == 2870) { opendialog -mh ac_list }
  }
  elseif ($devent == edit) {
    ;Away Misc
    if ($did == 416) || ($did == 418) {
      var %server = $iif($did(412).seltext == Défaut,def,$ifmatch)
      wi nicks nicks. $+ %server $did(416).text $+  $+ $did(418).text 
    }
    elseif ($did == 424) { if ($colorBadNumber($dname,$did)) { wi awaymisc autoaway $did($did) } }
    ;Titlebar
    elseif ($did == 613) { if ($colorBadNumber($dname,$did)) { wi titlebar refresh $did($did) | .timertitlebar -io 0 $did($did) refreshTitlebar } }
    elseif ($did == 616) { wi titlebar format $did($did) | refreshTitlebar }
    ;Generales
    elseif ($did == 714) { 
      if ($timer(antiidle)) && ($did($did) isnum) && ($did($did) > 0) { .timerantiidle -i 0 $did($did) resetidle }
      if ($colorBadNumber($dname,$did)) { wi misc antiidle $did($did) }
    }
    elseif ($did == 731) {
      wi misc amsg $did($did)
      prevbmp $dname 732 10 own 0 $replace($did($did),<text>,Bonjour tout le monde!)
    }
    ; Statusbar
    elseif ($did == 1013) { 
      if ($timer(sbar)) && ($did($did) isnum) && ($did($did) > 0) { .timersbar -io 0 $did($did) refreshStatusbar }
      if ($colorBadNumber($dname,$did)) { wi statusbar refresh $did($did) } 
    }
    ; Serveurs
    elseif ($did >= 1162 && $did <= 1167) { writeServerInfo }
    ; Services
    elseif ($did == 1618) { 
      did -ra $dname 1619 $did($did)
      writeServiceInfo nick
    }
    elseif ($did == 1619) {
      did -ra $dname 1618 $did($did)
      writeServiceInfo nick
    }
    elseif ($did == 1626) { 
      writeServiceInfo nick
      prevbmp $dname 1628 12 notice 0 $did($did)
    }
    elseif ($did == 1668) { 
      did -ra $dname 1669 $did($did)
      writeServiceInfo chan
    }
    elseif ($did == 1669) {
      did -ra $dname 1668 $did($did)
      writeServiceInfo chan
    }
    elseif ($did == 1676) { 
      writeServiceInfo chan
      prevbmp $dname 1678 12 notice 0 $did($did)
    }
    elseif ($did == 1718) { 
      writeServiceInfo bot
    }
    elseif ($did == 1724) {
      writeServiceInfo bot
      prevbmp $dname 1726 12 notice 0 $did($did)
    }
    ; Mail
    elseif ($did == 2013) { if ($colorBadNumber($dname,$did)) { wi mails time $did($did) | .timermailcheck 0 $calc($did($did) * 60) checkMail } }
    elseif ($did == 2039) || ($did == 2042) { writeMailInfo }
    elseif ($did == 2044) { did -ra $dname 2045 $did($did) | writeMailInfo }
    elseif ($did == 2045) { did -ra $dname 2044 $did($did) | writeMailInfo }
    ; Copypasta
    elseif ($did == 2313) { if ($colorBadNumber($dname,$did)) { wi copypasta delay $did($did) } }
    elseif ($did == 2316) { if ($colorBadNumber($dname,$did)) { wi copypasta lines $did($did) } }
    elseif ($did == 2318) { if ($colorBadNumber($dname,$did)) { wi copypasta bytes $did($did) } }
    elseif ($did == 2332) { if ($colorBadNumber($dname,$did)) { wi copypasta cropbytes $did($did) } }
    ; Query
    elseif ($did == 2412) { if ($colorBadNumber($dname,$did)) { wi query autoclose $did($did) } }
    ; tabcomp
    elseif ($did == 2513) { wi tabcomp character $did($did) }
    elseif ($did == 2515) {
      wi tabcomp format $did($did)
      prevbmp $dname 2516 11 own 0 $replace($did($did) salut ca va?,<nick>,$me)
    }
    ; autocomp
    elseif ($did == 2813) { if ($colorBadNumber($dname,$did)) { wi autocomp refresh $did($did) | .timer_acopen -mio 0 $ri(autocomp,refresh) acOpen  } }
    elseif ($did == 2818) { if ($colorBadNumber($dname,$did)) { wi autocomp limit $did($did) } }
  }
}

; ––––––––––––––––––––––––––––––––––––––––
; Fin de fichier
; ––––––––––––––––––––––––––––––––––––––––
