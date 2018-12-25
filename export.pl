#!/usr/bin/perl
use 5.010;
use strict;
use warnings;
use IO::Handle;
use Time::Piece;
use Data::Dumper;
use Fcntl ':mode';
use File::Copy qw(cp);
use POSIX qw(strftime);
use File::Copy qw(move);
use File::Spec::Functions;
use File::Path qw(make_path);
use Getopt::Long qw(GetOptions);
use Digest::MD5 qw(md5 md5_hex);
Getopt::Long::Configure qw(gnu_getopt);

use lib '/usr/local/cpanel';

use Cpanel::PwCache                      ();
use Cpanel::Domain::Owner

## Options
my $domain;
my $emailAcct;
my $cpanelAcct;
my $toCSV;

GetOptions(
    'domain=s' => \$domain,
    'email-acct=s' => \$emailAcct,
    'cpanel-acct=s' => \$cpanelAcct,
    'to-csv' => \$toCSV,
) or die "No help built in. You're on your own for now.\n";

if ( scalar grep($_, $domain, $emailAcct, $cpanelAcct) > 1 ) { die ("The --domain, --email-acct, and --cpanel-acct options are mutually exclusive. Re-read the documentation and try again.\n"); };

if (! $emailAcct eq ''){
	my @emailParts = split /@/,$emailAcct;
	my $emailUser = $emailParts[0];
	my $emailDomain = $emailParts[1];
	my $cpanelAcct = Cpanel::Domain::Owner::get_owner_or_die($emailDomain);
        my $homedir = Cpanel::PwCache::gethomedir($cpanelAcct);

}
	
