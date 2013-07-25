;------------------------------
; Filtrage
;------------------------------

#features on

ON *:START:{
  if ($hget(groups,filter) == $null) { hadd -m groups filter 1 }
  if ($hget(groups,filter) == 1) { 
    splash_text 3 Chargement du script $nopath($script) ...
    .enable #features.filter
  }
  else { .disable #features.filter }
}


ON *:UNLOAD:{
  if ($hget(groups,filter)) { hadd groups filter 0 }
}
#features end

#features.filter on



#features.filter end


;------------------------------
; Fin de fichier
;------------------------------