vcl 4.0;

backend default {
    .host = "127.0.0.1";
    .port = "80";
}

include "datadome.vcl";

sub vcl_recv {
}

sub vcl_backend_response {
}

sub vcl_deliver {
}
