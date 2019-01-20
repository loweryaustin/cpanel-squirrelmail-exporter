# cpanel-squirrelmail-exporter

## Usage:
`./exportAbooks.pl [ --domain | --email-acct | --cpanel-acct | --all ] subject`

This script will convert the squirrellmail address books associated with the subject to csv format.
The subject can be one of:
- A cPanel account username
- A domain name
- An individual email address

If using the `--all` option, you will not provide a subject. The script will locate all addressbooks found within the /home directory and convert them.

This script is designed to be a non-destructive script. This means that it does not delete data, move data, or overwrite existing data.

The default location for the exported data is /root/cpanel-squirrelmail-exports/csv-export-epoch/

## Options:
`--all` ----------- REQUIRED - Converts all addressbooks found within the /home directory. Mutually exclusive with `--cpanel-acct` `--domain` and `--email-acct`.

`--cpanel-acct` --- REQUIRED - Specify a cPanel account for which you would like to export all of the squirrelmail addressbooks. Mutually exclusive with `--all` `--domain` and `--email-acct`.

`--email-acct` ---- REQUIRED - Specify an individual email account that you would like to export the squirrelmail addressbook for. Mutually exclusive with `--all` `--domain` and `--cpanel-acct`.

`--domain` -------- REQUIRED - Specify a domain for which you would like to export all of the squirrelmail addressbooks. Mutually exclusive with `--all` `--email-acct` and `--cpanel-acct`.

`--to-csv` -------- OPTIONAL - Does nothing right now. It is a placeholder for when other exporting methods are added.

`--export-dest` --- OPTIONAL - Allows you to specify a custom export destination. The default desitnation is: /root/cpanel-squirrelmail-exports

`--log-path` ------ OPTIONAL - Allows you to specify a custom log file location. An absolute path is required. The file does not need pre exist. The default log file is: /root/cpanel-squirrelmail-export.log

`--mostly-silent` - OPTIONAL - This was supposed to be silent, but I could only manage mostly silent before I gave up and decided it was more important to ship than to fiddle with it.

`--no-header` ----- OPTIONAL - Prevents the creation of the header row when creating the CSV files.


I welcome any improvements, bug reports, commentary, etc in the form of issues and pull requests at the following github page:
https://github.com/loweryaustin/cpanel-squirrelmail-exporter

This software was not created by and is not supported by cPanel. It has been created by Austin Lowery as a fun project in my spare time and is relased under the MIT license.

## Examples
Export all addressbooks found within the /home directory:

`perl <(curl -s https://raw.githubusercontent.com/loweryaustin/cpanel-squirrelmail-exporter/master/exportAbooks.pl) --all`

```
[root@srv00001 ~]# perl <(curl -s https://raw.githubusercontent.com/loweryaustin/cpanel-squirrelmail-exporter/master/exportAbooks.pl) --all
INFO: 1547989334 Converted /home/dundermifflin/.sqmaildata/rob.california@dundermifflin.com.abook -> /root/cpanel-squirrelmail-exports/csv-export-1547989334/rob.california@dundermifflin.com.abook.csv
INFO: 1547989334 Converted /home/dundermifflin/.sqmaildata/ryan@dundermifflin.com.abook -> /root/cpanel-squirrelmail-exports/csv-export-1547989334/ryan@dundermifflin.com.abook.csv
INFO: 1547989334 Converted /home/dundermifflin/.sqmaildata/schrutefarms@dundermifflin.com.abook -> /root/cpanel-squirrelmail-exports/csv-export-1547989334/schrutefarms@dundermifflin.com.abook.csv
INFO: 1547989334 Converted /home/dundermifflin/.sqmaildata/michaelscott@dundermifflin.com.abook -> /root/cpanel-squirrelmail-exports/csv-export-1547989334/michaelscott@dundermifflin.com.abook.csv
INFO: 1547989334 Converted /home/dundermifflin/.sqmaildata/pam@dundermifflin.com.abook -> /root/cpanel-squirrelmail-exports/csv-export-1547989334/pam@dundermifflin.com.abook.csv
INFO: 1547989334 Converted /home/dundermifflin/.sqmaildata/andy@dundermifflin.com.abook -> /root/cpanel-squirrelmail-exports/csv-export-1547989334/andy@dundermifflin.com.abook.csv
INFO: 1547989334 Converted /home/dundermifflin/.sqmaildata/jim@dundermifflin.com.abook -> /root/cpanel-squirrelmail-exports/csv-export-1547989334/jim@dundermifflin.com.abook.csv
INFO: 1547989334 Converted /home/parkspawnee/.sqmaildata/terry.gergich@parks.pawnee.gov.abook -> /root/cpanel-squirrelmail-exports/csv-export-1547989334/terry.gergich@parks.pawnee.gov.abook.csv
INFO: 1547989334 Converted /home/parkspawnee/.sqmaildata/gary.gergich@parks.pawnee.gov.abook -> /root/cpanel-squirrelmail-exports/csv-export-1547989334/gary.gergich@parks.pawnee.gov.abook.csv
INFO: 1547989334 Converted /home/parkspawnee/.sqmaildata/larry.gengurch@parks.pawnee.gov.abook -> /root/cpanel-squirrelmail-exports/csv-export-1547989334/larry.gengurch@parks.pawnee.gov.abook.csv
INFO: 1547989334 Converted /home/parkspawnee/.sqmaildata/ron@parks.pawnee.gov.abook -> /root/cpanel-squirrelmail-exports/csv-export-1547989334/ron@parks.pawnee.gov.abook.csv
INFO: 1547989334 Converted /home/parkspawnee/.sqmaildata/dandyandy@parks.pawnee.gov.abook -> /root/cpanel-squirrelmail-exports/csv-export-1547989334/dandyandy@parks.pawnee.gov.abook.csv
INFO: 1547989334 Converted /home/parkspawnee/.sqmaildata/t.haverford@parks.pawnee.gov.abook -> /root/cpanel-squirrelmail-exports/csv-export-1547989334/t.haverford@parks.pawnee.gov.abook.csv
INFO: 1547989334 Converted /home/parkspawnee/.sqmaildata/a.perkins@parks.pawnee.gov.abook -> /root/cpanel-squirrelmail-exports/csv-export-1547989334/a.perkins@parks.pawnee.gov.abook.csv
INFO: 1547989334 Converted /home/parkspawnee/.sqmaildata/april.ludgate@parks.pawnee.gov.abook -> /root/cpanel-squirrelmail-exports/csv-export-1547989334/april.ludgate@parks.pawnee.gov.abook.csv
INFO: 1547989334 Converted /home/parkspawnee/.sqmaildata/l.knope@parks.pawnee.gov.abook -> /root/cpanel-squirrelmail-exports/csv-export-1547989334/l.knope@parks.pawnee.gov.abook.csv
INFO: 1547989334 Converted /home/section9/.sqmaildata/d.aramaki@section9.gov.abook -> /root/cpanel-squirrelmail-exports/csv-export-1547989334/d.aramaki@section9.gov.abook.csv
INFO: 1547989334 Converted /home/section9/.sqmaildata/batou@section9.gov.abook -> /root/cpanel-squirrelmail-exports/csv-export-1547989334/batou@section9.gov.abook.csv
INFO: 1547989334 Converted /home/section9/.sqmaildata/togusa@section9.gov.abook -> /root/cpanel-squirrelmail-exports/csv-export-1547989334/togusa@section9.gov.abook.csv
INFO: 1547989334 Converted /home/section9/.sqmaildata/m.kusanagi@section9.gov.abook -> /root/cpanel-squirrelmail-exports/csv-export-1547989334/m.kusanagi@section9.gov.abook.csv
INFO: You may review the above output at the following log file: /root/cpanel-squirrelmail-export.log
```

Export the addressbook for a single email account:

`perl <(curl -s https://raw.githubusercontent.com/loweryaustin/cpanel-squirrelmail-exporter/master/exportAbooks.pl) --email-acct user@domain.tld`

Export all addressbooks found within a cPanel account:

`perl <(curl -s https://raw.githubusercontent.com/loweryaustin/cpanel-squirrelmail-exporter/master/exportAbooks.pl) --cpanel-acct cpanelusername`

Export all addressbooks for a domain:

`perl <(curl -s https://raw.githubusercontent.com/loweryaustin/cpanel-squirrelmail-exporter/master/exportAbooks.pl) --domain domain.tld`

Export all addressbooks on the server by domain (Will find abooks on all home directories):

`for domain in $( cut -d":" -f1 /etc/userdomains );do perl <(curl -s https://raw.githubusercontent.com/loweryaustin/cpanel-squirrelmail-exporter/master/exportAbooks.pl) --domain $domain ;done`

Export all addressboks on the server by cpanel username (same result as above):

`for user in $(cut -d":" -f1 /etc/trueuserowners);do perl <(curl -s https://raw.githubusercontent.com/loweryaustin/cpanel-squirrelmail-exporter/master/exportAbooks.pl) --cpanel-acct $user ;done`

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
