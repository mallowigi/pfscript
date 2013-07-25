; ==================================================================================
; Author  : Tw|ster - #mirc-scripts on Undernet
; Function: Scans for unsecure Wingate Proxies  (Port 1080)
; ==================================================================================

menu nicklist {
  Proxy Scan: { _proxyscan $$1 }
}
alias _proxyscan {
  IF ($sock(proxy).status) { 
    echo 4 -s ** Socket Check In progress...
    RETURN
  }
  IF (. isin $1) { sockopen proxy $$1 1080 }
  ELSE { sockopen proxy $gettok($address($1,5),2,64) 1080 }
  echo 4 -s ** Attempting to check $$1 $+ ... 
  .timer 1 120 _closescan
}
alias _sockclose { 
  IF ($sock($$1).status) { 
    sockclose $1
    echo 4 -s ** Connection closed by script. 
  } 
}
alias _closescan { 
  IF ($sock(proxy).status) { 
    _sockclose proxy
    echo 4 -s ** No Responce after 20 seconds. 
  } 
}
on 1:SOCKOPEN:proxy: {
  echo 4 -s ** $sock(proxy).ip Responded to proxy scan. 
  IF ($sockerr > 1) {
    IF ($sock(proxy).wserr == 10061) { echo 4 -s ** Connection Refused }
    ELSE { echo 4 -s ** Unknown error $sock(proxy).wserr }   
    _sockclose proxy
    RETURN
  } 
  echo 4 -s ** Connection was not refused.
  _sockclose proxy 
}
on 1:SOCKCLOSE:proxy: { echo 4 -s ** Connection remotely closed }
on 1:SOCKREAD:proxy: {
  IF ($sockerr > 0) { RETURN }
  :nextread
  sockread %proxy
  IF ($sockbr == 0) { RETURN }
  echo 4 -s ** Proxy: %proxy
  GOTO nextread
}

;-------------------------------
; Fin de fichier
;-------------------------------