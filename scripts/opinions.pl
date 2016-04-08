#!/usr/bin/perl
# based on sample-rest-client.pl

# Get answers submitted to an "in your opinion" forum

use strict;
use warnings;
use LWP::UserAgent; # web client
use JSON;           # imports encode_json, decode_json, to_json and from_json.
use Data::Dumper;   # to print the result variable
use Template;

my $jsondecoder = JSON->new->allow_nonref;  # --- decode the JSON result,

my $result = ws('local_mobile_mod_forum_get_forums_by_courses', {'courseids[0]' => 14}); # LPM
my $arrayref = $jsondecoder->decode( $result->content );

my($item) = grep {
  $_->{id} == 53
} @$arrayref;

$result = ws('mod_forum_get_forum_discussions_paginated', {'forumid' => 53 }); # IYO:leadership
my $question = $item->{name};

my $tt = Template->new(INCLUDE_PATH => '/home/paul/src/moodlemobile2/scripts');
$tt->process('opinions.tt', { question => $question, json => $result->content } ) || die $tt->error;

sub ws {
    my($function, $params) = @_;

    my $url_ws = "https://moodle.slapp.space/webservice/rest/server.php";
    $params->{wstoken}            = '5fe0ff2308806b115185db34be87f9b5'; # paul's token
    $params->{wsfunction}         = $function,
    $params->{moodlewsrestformat} = 'json'; # Moodle rest server can also return xml
        
    my $ua = LWP::UserAgent->new;        # -- let's create our user agent
    #$ua->ssl_opts(verify_hostname => 0); # be tolerant to self-signed certificates

    my $result = $ua->post( $url_ws, $params );      # --- ..and send the get request

    if ( not $result->is_success ) {
        print $result->status_line, "\n";   # --- it might not work...
        die;
    } else {
        return $result;
    }

=pod


print Dumper($userids);
=cut
}
__END__
