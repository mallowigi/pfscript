; ---------------------------------
; RSS Feeds
; ---------------------------------

ON *:START:{
  splash_text 3 Chargement du script $nopath($script) ...
}

; Load rss feeds
alias rss.loadfeeds {
  window -h @reflist
  var %i = 1
  .fopen rss data/rss.txt ;FIXME $ri(paths,rss)
  did -r settings 1720
  while (!$feof) {
    tokenize 1 $fread(rss)
    if ($1- != $null) {
        echo @reflist 1 + 0 0 $1 $2 $+ 	+ 0 0 0 $3
        inc %i
    }
  }
  if (%i == 1) {
    ; Desactiver bouton Vider si rien a vider
	did -b $dname 1724
  }

  .fclose rss
  filter -cwo @reflist settings 1720 *
  close -@ @reflist
}


; ––––––––––––––––––––––––––––––––––––––––
; Fin de fichier
; ––––––––––––––––––––––––––––––––––––––––
