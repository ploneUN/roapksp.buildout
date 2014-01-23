backend cop {
.host = "127.0.0.1";
.port = "8031";
}

acl purge {
    "127.0.0.1";
}



sub vcl_recv {

set req.backend = cop;

#set req.grace = 3m;

    if (req.request != "GET" && req.request != "HEAD") {
        if (req.request == "POST") {
            return(pass);
        }
        if (req.request == "PURGE") {
            if (!client.ip ~ purge) {
                error 405 "Not allowed.";
            }
            return(lookup);
        }
    }

    if (req.http.Cookie && req.http.Cookie ~ "__ac(|_(name|password|persistent))=") {
        # Force lookup of specific urls unlikely to need protection

          if (req.url ~ "(?i)\.(png|gif|jpeg|jpg|ico|swf|css|js|html|htm)(\?[a-z0-9]+)?$") {
            return(lookup); 
  }

        # don't cache authenticated requests
        return(pass);
    }

return(lookup);

}

sub vcl_miss {

return(fetch);

}

sub vcl_hit {

return(deliver);

}

sub vcl_fetch {

#  if (beresp.status == 500) {
#    set beresp.saintmode = 10s;
#    restart;
#  }
#  set beresp.grace = 5m;


# Get the response. Set the cache lifetime of the response to 1 hour.

set beresp.ttl = 1h;


# Indicate that this response is cacheable. This is important.

set beresp.http.X-Cacheable = "YES";

unset beresp.http.Vary;

return(deliver);

}

sub vcl_deliver {

return(deliver);

}
