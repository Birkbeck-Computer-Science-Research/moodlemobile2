#!/usr/bin/perl
# based on sample-rest-client.pl

# Get answers submitted to an "in your opinion" forum

use strict;
use warnings;
use LWP::UserAgent; # web client
use JSON;           # imports encode_json, decode_json, to_json and from_json.
use Data::Dumper;   # to print the result variable
use Template;
use CGI;

$| = 1;
print "Content-type: text/html\n\n";

my $jsondecoder = JSON->new->allow_nonref;  # --- decode the JSON result,

my $result = ws('local_mobile_mod_forum_get_forums_by_courses', {'courseids[0]' => 14}); # LPM
#die Dumper($jsondecoder->decode($result->content));
my $arrayref = $jsondecoder->decode( $result->content );

my $q       = CGI->new;
my $forumid;

if ($q->param('forumid')) {
    $forumid = $q->param('forumid');
#} else if (count($result2->choices) > 0) { // accessible choices found
} elsif ( 1 ) {
    $forumid = $arrayref->[0]->{id};
} else {
    $forumid = 0; # default
}
my $question;

my $select = "<select name='forumid' onchange='this.form.submit()'>\n";
$select .= "<option value='0'>Select</option>\n";

for my $forum (@$arrayref) {
    $select .= "<option value='" . $forum->{id} . "'";
    if ($forum->{id} == $forumid) {
        $question = $forum->{name};
        $select .= " selected";
    }
    $select .= '>' . $forum->{name} . "</option>\n";
}
$select .= "</select>\n";

# my($item) = grep { $_->{id} == 53 } @$arrayref;
# my $question = $item->{name};

$result = ws('mod_forum_get_forum_discussions_paginated', {'forumid' => $forumid });

my $tt = Template->new(INCLUDE_PATH => '.');
$tt->process('opinions.html', { question => $question, json => $result->content, select => $select, cgi => CGI->new() } )
    || die $tt->error;

sub ws {
    my($function, $params) = @_;

    my $url_ws = "https://moodle.slapp.space/webservice/rest/server.php";
    $params->{wstoken}            = 'b926992720820536bc8e15dceb726311';
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
