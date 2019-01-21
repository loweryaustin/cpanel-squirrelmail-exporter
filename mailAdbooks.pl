use strict;
use warnings;
use lib '/usr/local/cpanel';
use Cpanel::Email::Send;


sub sendMessage {

	my @to ($_[0]);
	
	my %opts;

	$opts{'to'}        = \@to;
	$opts{'subject'}   =  $_[1];
	$opts{'text_body'} = \$_[2];
	$opts{'from'}      =  $_[3];

	Cpanel::Email::Send::email_message( \%opts );
}
