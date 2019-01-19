#!/usr/bin/perl
use 5.010;
use strict;
use warnings;
use IO::Handle;
use Time::Piece;
use POSIX qw(strftime);
use File::Spec::Functions;
use File::Path qw(make_path);
use Getopt::Long qw(GetOptions);
Getopt::Long::Configure qw(gnu_getopt);

use lib '/usr/local/cpanel';
use Cpanel::Domain::Owner;
use Cpanel::PwCache ();

## Global Vars
my $toCSV = 1; # Setting this to true by default for now since this is just a placeholder till other export methods are added.
my $logFile = "/root/cpanel-squirrelmail-export.log";
my $silent = 0;
my $epoch = time();
my $exportDestPrefix = "/root/cpanel-squirrelmail-exports";
my $subjectType;
my $subject;
my $optName;
my $optValue; 
my @exclusiveOptNames;

GetOptions(
    'mostly-silent'               => \$silent,
    'domain=s'             => sub {  ($optName, $optValue) = @_; push @exclusiveOptNames,$optName; $subject = $optValue; },
    'email-acct=s'         => sub {  ($optName, $optValue) = @_; push @exclusiveOptNames,$optName; $subject = $optValue; },
    'cpanel-acct=s'        => sub {  ($optName, $optValue) = @_; push @exclusiveOptNames,$optName; $subject = $optValue; },
    'export-dest=s'        => sub {  ($optName, $optValue) = @_; $exportDestPrefix = $optValue; $exportDestPrefix =~ s/\/$//ig; },
    'to-csv'               => \$toCSV,
    'log-path=s'           => sub { my ($optName, $optValue) = @_; if (validateLogPath($optValue)) { $logFile = $optValue }}
) or message("INFO: No help built in. You're on your own for now.", 1, 0, 1);

if ($> != 0) { message("ERROR: This script must be run as the root user.", 1, 0, 1) }

if (scalar @exclusiveOptNames > 1) { 
	message("ERROR: You must use only one of the following options: --domain --email-acct --cpanel-acct", 1, 0, 1); 
} elsif (defined $exclusiveOptNames[0] and length $exclusiveOptNames[0]) {
	$subjectType = $exclusiveOptNames[0];
} else {
	message("ERROR: You must use one of the following options: --domain --email-acct --cpanel-acct", 1, 0, 1);
}

if ($toCSV){
	exportToCSV();
} else {
	message("ERROR: You must use the --to-csv option.", 1, 0, 1);
}
## TODO: Allow for exporting to other fomats such as vcard, or directly into horde or roundcube

## Subs

sub exportToCSV {
	message("INFO: Export of $subject to CSV started.", 1, 1, 0);
	my $exportDestDir = "$exportDestPrefix/csv-export-$epoch";
	make_path $exportDestDir;
		
	if ($subjectType eq 'email-acct'){
		my @emailParts = split(/@/, $subject);
		my $domain = $emailParts[1];
		my $cpanelAcct = Cpanel::Domain::Owner::get_owner_or_die($domain);
		my $sqMailData = getSqMailData($cpanelAcct); 
		my $abookPath = "$sqMailData/$subject.abook";
		abookToCSV ($abookPath, $exportDestDir);
	} elsif ($subjectType eq 'domain') {
		my $cpanelAcct = Cpanel::Domain::Owner::get_owner_or_die($subject);
		my $sqMailData = getSqMailData($cpanelAcct);
	
		opendir(DIR, $sqMailData);
		my @files = grep(/$subject\.abook$/,readdir(DIR)); # Only work on abook files for the subject domain
		closedir(DIR);

		if (scalar @files < 1) { message("NOTICE: No SquirrelMail address books found for the $subject domain in the $sqMailData directory.", 1, 0, 1) }

		foreach my $file (@files) {
			my $abookPath = "$sqMailData/$file";
			abookToCSV($abookPath, $exportDestDir);
		} 
	} elsif ($subjectType eq 'cpanel-acct') {	
		my $sqMailData = getSqMailData($subject);
		
		opendir(DIR, $sqMailData);
		my @files = grep(/\.abook$/,readdir(DIR));
		closedir(DIR);

		if (scalar @files < 1) { message("NOTICE: No SquirrelMail address books found for the $subject cPanel account in the $sqMailData directory.", 1, 0, 1) }

		foreach my $file (@files) {
			my $abookPath = "$sqMailData/$file";
			abookToCSV($abookPath, $exportDestDir);
		}
	} else {
		message("ERROR: Unexpected subjectType of: $subjectType.", 1, 0, 1);
	}
	message("INFO: Export of $subject to CSV completed.", 1, 1, 0);
}


sub abookToCSV {
	my $abookPath     = $_[0];
	my $exportDestDir = $_[1];
	
	my ($volume,$directories,$file) = File::Spec->splitpath($abookPath);
	unless (open ABOOK, $abookPath) { 
		message("ERROR: Unable to open $abookPath for reading.", 1, 1, 0); 
		return 0; 
	}
	my $csvAddressBook = "";
	while (my $row = <ABOOK>) {
		my @cols = split(/\|/, $row);
		my $newRow;
		foreach my $column (@cols) {
			chomp $column;
			$column =~ s/\"/\"\"/ig;  # Escape double quotes as per RFC-4180
			$column = "\"$column\","; # Enclose fields in double quotes to escape all other unexpected chars
			$newRow = "$newRow$column";
		}
		$newRow =~ s/,$//ig; # Remove trailing commas
		$csvAddressBook = "$csvAddressBook$newRow\r\n"; # Append each new row to the address book
	}
	my $csvDestination = "$exportDestDir/$file.csv"; # Ends up being /path/to/csv/export/dir/someone@domain.tld.abook.csv
	write_file ($csvDestination, $csvAddressBook);
	message("INFO: Converted $abookPath -> $csvDestination", 1, 1, 0);

}

sub getSqMailData {
	my $cpanelAcct = $_[0];
	my $homeDir = Cpanel::PwCache::gethomedir($cpanelAcct);
	my $sqMailData = "$homeDir/.sqmaildata";
	if (not -d $sqMailData) { message("NOTICE: $sqMailData does not exist. It seems that there are no SquirrelMail users for $subject .", 1, 0, 1) }
	return $sqMailData;
}

sub write_file {
    my ($filename, $content) = @_;
    open my $out, '>:encoding(UTF-8)', $filename or message("Could not open $filename for writing $!", 1, 0, 1);
    print $out $content;
    close $out;
    return 1;
}

sub message {
	my $message = $_[0];
	my $stdOut  = $_[1];
	my $log     = $_[2];
	my $die     = $_[3];
	
	chomp($message);
	$message = "$message\n";

	if ($log) { writeLog($message) }
	if ($die and not $silent) { 
		die $message;
	} elsif ($die and $silent and $log) {
		writeLog ($message);
		exit;
	} elsif ($die and $silent and not $log) {
		# Even if the original intention was to not log, we're going to override this so that the script never dies without saying *something*
		writeLog($message);
		exit;
	}
	if ($stdOut and not $silent) { print $message }
}

sub writeLog {
	my $message = $_[0];
	
	my $timeStamp = strftime "%D %T", localtime;
	
	open (my $fh, '>>', $logFile) or die "Could not open $logFile for writing";
	print $fh "$timeStamp $message";
	close $fh;
}

sub validateLogPath {
	$logFile = $_[0];
	
	if (not File::Spec->file_name_is_absolute( $logFile )) { die "ERROR: The --log-path option only accepts absolute paths. $logFile is not an absolute path." }
	if (-f $logFile and -w $logFile) {
		if (-z $logFile) { message("Initiating custom log at $logFile", 1, 1, 0) }
		return 1;
	} elsif (-d $logFile) {
		die ("ERROR: The --log-path option does not accept paths to directories. Please provide the path to a file instead. NOTE: The file does not necesarily have to already exist.");
	} elsif (not -e $logFile) { 
		my ($volume,$directories,$file) = File::Spec->splitpath($logFile);
		make_path $directories;
		message ("NOTICE: Initiating custom log at $logFile", 1, 1, 0);
		return 1;
	}
}
