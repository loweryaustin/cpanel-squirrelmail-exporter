# cpanel-squirrelmail-exporter

## Usage:
`./exportAbooks.pl [ --domain | --email-acct | --cpanel-acct | --all ] subject`

This script will convert the squirrellmail address books associated with the subject to csv format.
The subject can be one of:
- A cPanel account username
- A domain name
- An individual email address

This script is designed to be a non-destructive script. This means that it does not delete data, move data, or overwrite existing data.

The default location for the exported data is /root/cpanel-squirrelmail-exports/csv-export-epoch/

## Options:
`--all` ----------- REQUIRED - Converts all addressbooks found within the /home directory. Mutually exclusive with --cpanel-acct --domain and --email-acct.

`--cpanel-acct` --- REQUIRED - Specify a cPanel account for which you would like to export all of the squirrelmail addressbooks. Mutually exclusive with --domain and --email-acct.

`--email-acct` ---- REQUIRED - Specify an individual email account that you would like to export the squirrelmail addressbook for. Mutually exclusive with --domain and --cpanel-acct.

`--domain` -------- REQUIRED - Specify a domain for which you would like to export all of the squirrelmail addressbooks. Mutually exclusive with --email-acct and --cpanel-acct.

`--to-csv` -------- OPTIONAL - Does nothing right now. It is a placeholder for when other exporting methods are added.

`--export-dest` --- OPTIONAL - Allows you to specify a custom export destination. The default desitnation is: /root/cpanel-squirrelmail-exports

`--log-path` ------ OPTIONAL - Allows you to specify a custom log file location. An absolute path is required. The file does not need pre exist. The default log file is: /root/cpanel-squirrelmail-export.log

`--mostly-silent` - OPTIONAL - This was supposed to be silent, but I could only manage mostly silent before I gave up and decided it was more important to ship than to fiddle with it.

I welcome any improvements, bug reports, commentary, etc in the form of issues and pull requests at the following github page:
https://github.com/loweryaustin/cpanel-squirrelmail-exporter

This software was not created by and is not supported by cPanel. It has been created by Austin Lowery as a fun project in my spare time and is relased under the MIT license.

## Examples
Export all addressbooks found within the /home directory:

`./exportAbooks.pl --all`

Export the addressbook for a single email account:

`./exportAbooks.pl --email-acct user@domain.tld`

Export all addressbooks found within a cPanel account:

`./exportAbooks.pl --cpanel-acct cpanelusername`

Export all addressbooks for a domain:

`./exportAbooks.pl --domain domain.tld`

Export all addressbooks on the server by domain (Will find abooks on all home directories):

`for domain in $( cut -d":" -f1 /etc/userdomains );do ./exportAbooks.pl --domain $domain ;done`

Export all addressboks on the server by cpanel username (same result as above):

`for user in $(cut -d":" -f1 /etc/trueuserowners);do ./exportAbooks.pl --cpanel-acct $user ;done`

## Importing Into Roundcube

- Login to the RoundCube webmail client
- Click on the Contacts button in the upper right corner
- Click on the Import button on the upper left corner
- Upload the csv file from your computer

## Importing Into Horde Mail

- Login to the Horde Mail webmail client
- Click on Address Book in the horizontal menu
- Click on Import/Export in the upper left area
- Upload the csv file from your computer
