use strict;
use warnings;
use lib '/usr/local/cpanel';
use Cpanel::Email::Send;


sub sendMessage {

	my %opts;

	$opts{'to'} = \@to;
	$opts{'subject'} = $subject;
	$opts{'text_body'} = \$textBody;
	$opts{'from'} = $textBody;

	Cpanel::Email::Send::email_message( \%opts );
}
