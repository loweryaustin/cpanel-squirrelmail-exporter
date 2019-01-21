use strict;
use warnings;
use Data::Dumper;
use lib '/usr/local/cpanel';
use Cpanel::Email::Send;
use Getopt::Long qw(GetOptions);
Getopt::Long::Configure qw(gnu_getopt);
use Sys::Hostname;
#Global Vars
my $sourceDir;
my $help;
my $emailTemplate;
my $host = hostname;

GetOptions(
    'source=s'  => \$sourceDir,
    'help'    => \$help,
) or die "Use --help";

if ($help) { die "No help for you!\n" }

($emailTemplate = qq{
    Hello,

    Your SquirrelMail addressbook has been exported and attacthed to this email.

    You may import the attached file to RoundCube and Horde with the following instructions:

    First, download the attached CSV file to your computer.

    RoundCube:
     - Login to the RoundCube webmail client
     - Click on the Contacts button in the upper right corner
     - Click on the Import button on the upper left corner
     - Upload the csv file from your computer

    Horde:
     - Login to the Horde webmail client
     - Click on Address Book in the horizontal menu
     - Click on Import/Export in the upper left area
     - Upload the csv file from your computer

}) =~ s/^ {4}//mg;


if (-d $sourceDir) {
	chdir $sourceDir;
	my @files = glob("*.abook.csv");
	foreach my $file (@files) {
	 	open( my $fh, "<", $file) or die "Can't open < $file: $!";
		my %attachment;
		$attachment{'content'} = $fh;
		$attachment{'name'} = $file;
		my @attachments = (\%attachment);
		my @to = ($file); 
		$to[0] =~ s/.abook.csv//ig;
		sendMessage(\@to, "Your SquirrelMail AddressBook", $emailTemplate, "root\@$host", \@attachments);
	}
} else {
	die "--source is not a directory. Use --help\n";
}

sub sendMessage {
	
	my %opts;

	$opts{'to'}           =  $_[0];
	$opts{'subject'}      =  $_[1];
	$opts{'text_body'}    = \$_[2];
	$opts{'from'}         =  $_[3];
	$opts{'attachments'}  =  $_[4];

	Cpanel::Email::Send::email_message( \%opts );
}


