# VCL file optimized for plone.app.caching.  See vcl(7) for details

# This is an example of a split view caching setup with another proxy
# like Apache in front of Varnish to rewrite urls into the VHM style.

# Also assumes a single backend behind Varnish (which could be a single
# zope instance or a load balancer serving multiple zeo clients).
# To change this to support multiple backends, see the vcl man pages
# for instructions.


backend default {
    .host = "127.0.0.1";
    .port = "8030";
    .connect_timeout = 0.4s;
    .first_byte_timeout = 300s;
    .between_bytes_timeout = 60s;
}

acl purge {
    "localhost";
    "127.0.0.1";
    "58.137.137.8";
}

sub vcl_recv {
    set req.grace = 120s;
    set req.backend = default;
    
    if (req.request == "PURGE") {
        if (!client.ip ~ purge) {
                error 405 "Not allowed.";
        }
        ban_url(req.url);
        error 200 "Purged";
    }
    if (req.request != "GET" && req.request != "HEAD") {
        # We only deal with GET and HEAD by default
        return(pass);
    }

    call clear_analytics_cookies;
    call normalize_accept_encoding;
    call annotate_request;
    return(lookup);
}

sub vcl_fetch {


    if (!beresp.ttl > 0s) {
        set beresp.http.X-Varnish-Action = "FETCH (pass - not cacheable)";
        call rewrite_s_maxage;
        return(hit_for_pass);
    }

    if (beresp.http.X-Theme-Disabled) {
        set beresp.http.X-Varnish-Action = "FETCH (pass - not cacheable, X-Theme-Disabled)";
        call rewrite_s_maxage;
        return(hit_for_pass);
    }

    if (beresp.http.Set-Cookie) {
        set beresp.http.X-Varnish-Action = "FETCH (pass - response sets cookie)";
        call rewrite_s_maxage;
        return(hit_for_pass);
    }
    if (!beresp.http.Cache-Control ~ "s-maxage=[1-9]" && beresp.http.Cache-Control ~ "(private|no-cache|no-store)") {
        set beresp.http.X-Varnish-Action = "FETCH (pass - response sets private/no-cache/no-store token)";
        call rewrite_s_maxage;
        return(hit_for_pass);
    }
    if (req.http.Authorization && !beresp.http.Cache-Control ~ "public") {
        set beresp.http.X-Varnish-Action = "FETCH (pass - authorized and no public cache control)";
        call rewrite_s_maxage;
        return(hit_for_pass);
    }
    if (req.http.X-Anonymous && !beresp.http.Cache-Control) {
        set beresp.ttl = 600s;
        call rewrite_s_maxage;
        set beresp.http.X-Varnish-Action = "FETCH (override - backend not setting cache control)";
    }
    call rewrite_s_maxage;
    return(deliver);
}

sub vcl_deliver {
}


##########################
#  Helper Subroutines
##########################

# Optimize the Accept-Encoding variant caching
sub normalize_accept_encoding {
    if (req.http.Accept-Encoding) {
        if (req.url ~ "\.(jpe?g|png|gif|swf|pdf|gz|tgz|bz2|tbz|zip)$" || req.url ~ "/image_[^/]*$") {
            remove req.http.Accept-Encoding;
        } elsif (req.http.Accept-Encoding ~ "gzip") {
            set req.http.Accept-Encoding = "gzip";
        } else {
            remove req.http.Accept-Encoding;
        }
    }
}

sub clear_analytics_cookies {
    if (req.http.Cookie) {
        set req.http.Cookie = regsuball(req.http.Cookie, "(^|; ) *__utm.=[^;]+;? *", "\1"); # removes all cookies named __utm? (utma, utmb...) - tracking thing
    
        if (req.http.Cookie == "") {
            remove req.http.Cookie;
        }
    }
}

# Keep auth/anon variants apart if "Vary: X-Anonymous" is in the response
sub annotate_request {
    if (!(req.http.Authorization || req.http.cookie ~ "(^|.*; )__ac=")) {
        set req.http.X-Anonymous = "True";
    }
}

# Rewrite s-maxage to exclude from intermediary proxies
# (to cache *everywhere*, just use 'max-age' token in the response to avoid this override)
sub rewrite_s_maxage {
    if (beresp.http.Cache-Control ~ "s-maxage") {
        set beresp.http.Cache-Control = regsub(beresp.http.Cache-Control, "s-maxage=[0-9]+", "s-maxage=0");
    }
}

