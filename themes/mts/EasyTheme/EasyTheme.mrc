# ------------------------------------------ #
# Name: EasyTheme, EasyTheme.mrc
# Author: iD - iD@uNkn0wn.eu
# Greetings to: #help.script & #ircscript.help
# ------------------------------------------ #

Alias EasyTheme.load { 
  clear -a
  var %:echo = $iif(aline !isin %:echo,$remove(%:echo,t),%:echo)
  %:echo 5— Easy Theme ————————————————————————
  %:echo 5 ›15 EasyTheme v1.5 by iD - iD@uNkn0wn.eu loaded!
  %:echo 5 ›15 Visit me at http://uNkn0wn.eu/ - irc.uNkn0wn.eu 5›15 #uNkn0wn.
  %:echo 5————— nevah heard of us? now you have! —————————
}

Alias Whois.addr { 
  var %:echo = $iif(aline !isin %:echo,$remove(%:echo,t),%:echo)
  %:echo 5 —-—----—--—----—--—----—--—----—--—----—--—----—--—---—--—---—--—-  
  %:echo 5 ›0 %::nick 14is 5(0 $+ %::address $+ 5)0 * %::realname
}

Alias Whois.stop {
  var %:echo = $iif(aline !isin %:echo,$remove(%:echo,t),%:echo)
  %:echo 5 —-—----—--—----—--—----—--—----—--—----—--—----—--—---—--—---—--—- 
}

Alias Whois.modes {
  var %:echo = $iif(aline !isin %:echo,$remove(%:echo,t),%:echo)
  %:echo 5 ›0 %::nick 14 %::text
}

Alias Whois.connect {
  var %:echo = $iif(aline !isin %:echo,$remove(%:echo,t),%:echo)
  %:echo 5 ›0 %::nick 14 %::text
}

Alias Whois.reg {
  var %:echo = $iif(aline !isin %:echo,$remove(%:echo,t),%:echo)
  %:echo 5 ›0 %::nick 14is a registered nick
}

Alias Whois.chan {
  var %:echo = $iif(aline !isin %:echo,$remove(%:echo,t),%:echo)
  %:echo 5 ›0 %::nick 14is on0 %::chan 
}

Alias Whois.using {
  var %:echo = $iif(aline !isin %:echo,$remove(%:echo,t),%:echo)
  %:echo 5 ›0 %::nick 14is using0 %::fromserver - %::serverinfo 
}

Alias Etaway {
  var %:echo = $iif(aline !isin %:echo,$remove(%:echo,t),%:echo)
  %:echo 5 ›0 %::nick 14is away0 %::away
}

Alias Whois.authed {
  var %:echo = $iif(aline !isin %:echo,$remove(%:echo,t),%:echo)
  %:echo 5 ›0 %::nick 14is authed as0 $$2
}

Alias Whois.idle {
  var %:echo = $iif(aline !isin %:echo,$remove(%:echo,t),%:echo)
  %:echo 5 ›0 %::nick 14idle:0 $duration(%::idletime) - 14signon:0 %::signontime 
}

Alias Whois.ircop { 
  var %:echo = $iif(aline !isin %:echo,$remove(%:echo,t),%:echo)
  %:echo 5 ›0 %::nick 14is an 0IRC Operator14 
}

Alias Whois.administrator { 
  var %:echo = $iif(aline !isin %:echo,$remove(%:echo,t),%:echo)
  %:echo 5 ›0 %::nick 14is an 0Network Administrator14 
}

Alias Whois.helper { 
  var %:echo = $iif(aline !isin %:echo,$remove(%:echo,t),%:echo)
  %:echo 5 ›0 %::nick 14is available for help. 
}

Alias Whois.ssl { 
  var %:echo = $iif(aline !isin %:echo,$remove(%:echo,t),%:echo)
  %:echo 5 ›0 %::nick 14is using a Secure Connection
}
