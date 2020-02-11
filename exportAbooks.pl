#!/usr/local/cpanel/3rdparty/bin/perl
package ExportSquirrel;

use 5.010;

use strict;
use warnings;

use IO::Handle;
use Data::Dumper;
use Time::Piece;
use POSIX qw(strftime);
use Text::CSV;
use File::Spec::Functions;
use File::Path qw(make_path);

use Getopt::Long qw(GetOptionsFromArray);

use lib '/usr/local/cpanel';
use Cpanel::Domain::Owner;
use Cpanel::PwCache ();

exit main(@ARGV) unless caller;

## Global Vars
sub main {
    my @args = @_;
    my $epoch = time();
    my $exportDestPrefix = "/root/cpanel-squirrelmail-exports";

    my (@domains, @emails, @accts, $do_all_accounts, $export_dest, $logFile, $toCSV, $silent, $help, $noHeader);
    GetOptionsFromArray(\@args,
        'mostly-silent'        => \$silent,
        'domain=s@'            => \@domains,
        'email-acct=s@'        => \@emails,
        'cpanel-acct=s@'       => \@accts,
        'all'                  => \$do_all_accounts,
        'export-dest=s@'       => \$export_dest,
        'to-csv'               => \$toCSV,
        'no-header'            => \$noHeader,
        'help'                 => \$help,
        'log-path=s'           => \$logFile,
    );

    $silent //= 0;
    $toCSV //= 1; # Setting this to true by default for now since this is just a placeholder till other export methods are added.
    $logFile //= "/root/cpanel-squirrelmail-export.log";
    $export_dest //= "$exportDestPrefix/csv-export-$epoch";

    return help(0) if $help;
    return help(2, "This script must be run as the root user.") if $> != 0;
    return help(1, "Invalid log path") if !validateLogPath($logFile, $silent);

    my $difference = abs(scalar(@domains) - scalar(@emails) - scalar(@accts) - int($do_all_accounts));
    my $sum        = scalar(@domains) + scalar(@emails) + scalar(@accts) + int($do_all_accounts);
    return help(3, "You must use only one of the following options: --domain --email-acct --cpanel-acct --all") if $difference != $sum;
    return help(4, "You must use one of the following options: --domain --email-acct --cpanel-acct --all") unless $sum;

    exportToCSV(\@domains, \@emails, \@accts, $do_all_accounts, $export_dest, $logFile, $toCSV, $silent, $help, $noHeader) if $toCSV;

    message("INFO: You may review the above output at the following log file: $logFile", 1, 0, 0, $silent);
    return 0;
}
## Subs

sub help {
    my ($code,$msg) =@_;
    message("ERROR: $msg", 1, 0, 1) if $msg;
	(my $message = qq{
            Usage:
            $0 [ --domain | --email-acct | --cpanel-acct | --all ] subject

            This script will convert the squirrellmail address books associated with the subject to csv format.
            The subject can be one of:
                - A cPanel account username
                - A domain name
                - An individual email address

            If using the --all option, you will not provide a subject. The script will locate all addressbooks found within the /home directory and convert them.

            This script is designed to be a non-destructive script. This means that it does not delete data, move data, or overwrite existing data.

            The default location for the exported data is /root/cpanel-squirrelmail-exports/csv-export-epoch/

            Options:
            --all ----------- REQUIRED - Converts all addressbooks found within the /home directory. Mutually exclusive with --cpanel-acct --domain and --email-acct.

            --cpanel-acct --- REQUIRED - Specify a cPanel account for which you would like to export all of the squirrelmail addressbooks. Mutually exclusive with --domain --all  and --email-acct.

            --email-acct ---- REQUIRED - Specify an individual email account that you would like to export the squirrelmail addressbook for. Mutually exclusive with --domain --all and --cpanel-acct.

            --domain -------- REQUIRED - Specify a domain for which you would like to export all of the squirrelmail addressbooks. Mutually exclusive with --email-acct --all and --cpanel-acct.

            --to-csv -------- OPTIONAL - Does nothing right now. It is a placeholder for when other exporting methods are added.

            --export-dest --- OPTIONAL - Allows you to specify a custom export destination. The default desitnation is: /root/cpanel-squirrelmail-exports

            --log-path ------ OPTIONAL - Allows you to specify a custom log file location. An absolute path is required. The file does not need pre exist. The default log file is: /root/cpanel-squirrelmail-export.log

            --mostly-silent - OPTIONAL - This was supposed to be silent, but I could only manage mostly silent before I gave up and decided it was more important to ship than to fiddle with it.

            --no-header ----- OPTIONAL - Prevents the creation of the header row when creating the CSV files.

            I welcome any improvements, bug reports, commentary, etc in the form of issues and pull requests at the following github page:
            https://github.com/loweryaustin/cpanel-squirrelmail-exporter

            This software was not created by and is not supported by cPanel. It has been created by Austin Lowery as a fun project in my spare time and is relased under the MIT license.

            }) =~ s/^ {12}//mg;
	print $message;
    return $code;
}


sub exportToCSV {
    my ( $domains, $emails, $accts, $do_all_accounts, $exportDestDir, $logFile, $toCSV, $silent, $help, $noHeader) = @_;
	make_path $exportDestDir;

    foreach my $email (@$emails) {
		my @emailParts = split(/@/, $email);
		my $domain = $emailParts[1];
		my $cpanelAcct = Cpanel::Domain::Owner::get_owner_or_die($domain);
		my $sqMailData = getSqMailData($cpanelAcct, $email, $silent);
		my $abookPath = "$sqMailData/$email.abook";
		abookToCSV ($abookPath, $exportDestDir, $noHeader, $silent, $logFile);
    }
    foreach my $domain (@$domains) {
		my $cpanelAcct = Cpanel::Domain::Owner::get_owner_or_die($domain);
		my $sqMailData = getSqMailData($cpanelAcct, $domain, $silent);

		opendir(DIR, $sqMailData);
		my @files = grep(/$domain\.abook$/,readdir(DIR)); # Only work on abook files for the subject domain
		closedir(DIR);

		if (scalar @files < 1) { message("NOTICE: No SquirrelMail address books found for the $domain domain in the $sqMailData directory.", 1, 0, 1, $silent) }

		foreach my $file (@files) {
			my $abookPath = "$sqMailData/$file";
			abookToCSV($abookPath, $exportDestDir,$noHeader, $silent,$logFile);
		}
    }
    foreach my $acct (@$accts) {
		my $sqMailData = getSqMailData($acct, $acct, $silent);
		opendir(DIR, $sqMailData);
		my @files = grep(/\.abook$/,readdir(DIR));
		closedir(DIR);

		message("NOTICE: No SquirrelMail address books found for the $acct cPanel account in the $sqMailData directory.", 1, 0, 1, $silent) unless @files;

		foreach my $file (@files) {
			my $abookPath = "$sqMailData/$file";
			abookToCSV($abookPath, $exportDestDir, $noHeader, $silent, $logFile);
		}
    }

	return unless $do_all_accounts;
    my @files = `find /home/*/.sqmaildata/ -name "*.abook"`;
    foreach my $file (@files) {
        chomp $file;
        abookToCSV($file, $exportDestDir, $noHeader,$silent, $logFile);
    }
    return;
}


sub abookToCSV {
	my ($abookPath, $exportDestDir, $noHeader, $silent, $log) = @_;
	my $ABOOK;
	my $reader = Text::CSV->new({ sep_char => '|', binary => 1});
	my $writer = Text::CSV->new({ eol => "\r\n", binary => 1 });

	my ($volume,$directories,$file) = File::Spec->splitpath($abookPath);
	unless (open $ABOOK,"<", $abookPath) {
		message("ERROR: Unable to open $abookPath for reading.", 1, $log, 0, $silent);
		return 0;
	}
	
	my $csvAddressBook = '"Nickname","First Name","Last Name","Email","Notes"'."\r\n";
	if ($noHeader) { $csvAddressBook = ""; };

	while (my $row = $reader->getline($ABOOK)) {
		if($writer->combine(@{$row})){
			$csvAddressBook .= $writer->string();
		}else{
			message("ERROR: Unable combine row.", 1, $log, 0, $silent);
		}
	}

	close $ABOOK;

	my $csvDestination = "$exportDestDir/$file.csv"; # Ends up being /path/to/csv/export/dir/someone@domain.tld.abook.csv
	write_file ($csvDestination, $csvAddressBook);
	message("INFO: Converted $abookPath -> $csvDestination", 1, $log, 0, $silent);
return;
}

sub getSqMailData {
	my ($cpanelAcct,$subject,$silent) = @_;
	my $homeDir = Cpanel::PwCache::gethomedir($cpanelAcct);
	if (not $homeDir) { message("ERROR: There was a problem locating the home directory of the $cpanelAcct username. Are you sure this a valid cPanel user?", 1, 0, 1, $silent) }
	my $sqMailData = "$homeDir/.sqmaildata";
	if (not -d $sqMailData) { message("NOTICE: $sqMailData does not exist. It seems that there are no SquirrelMail users for $subject .", 1, 0, 1, $silent) }
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
    my ($message, $stdOut, $log, $die, $silent ) = @_;
	chomp($message);
	$message = "$message\n";

	if ($log) { writeLog($message, $log) }
	if ($die and not $silent) {
		die $message;
	} elsif ($die and $silent and $log) {
		writeLog ($message, $log);
		exit;
	} elsif ($die and $silent and not $log) {
		# Even if the original intention was to not log, we're going to override this so that the script never dies without saying *something*
		writeLog($message, $log);
		exit;
	}
	if ($stdOut and not $silent) { print $message }
return;
}

sub writeLog {
	my ($message,$logFile) = @_;
	
	my $timeStamp = strftime "%D %T", localtime;
	
	open (my $fh, '>>', $logFile) or die "Could not open $logFile for writing";
	print $fh "$timeStamp $message";
	close $fh;
return;
}

sub validateLogPath {
	my ($logFile, $silent) = @_;
	
	if (not File::Spec->file_name_is_absolute( $logFile )) { die "ERROR: The --log-path option only accepts absolute paths. $logFile is not an absolute path.\n" }
	if (-f $logFile and -w $logFile) {
		if (-z $logFile) { message("INFO: Initiating custom log at $logFile", 1, $logFile, 0,$silent) }
		return 1;
	} elsif (-d $logFile) {
		die ("ERROR: The --log-path option does not accept paths to directories. Please provide the path to a file instead. NOTE: The file does not necesarily have to already exist.\n");
	} elsif (not -e $logFile) { 
		my ($volume,$directories,$file) = File::Spec->splitpath($logFile);
		make_path $directories;
		message ("INFO: Initiating custom log at $logFile", 1, $logFile, 0, $silent);
		return 1;
	}
}
