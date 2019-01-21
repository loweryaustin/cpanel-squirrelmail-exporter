# cpanel-squirrelmail-exporter

## TL;DR
These two scripts make transitioning from SquirrelMail AddressBooks to RoundCube and Horde a two command process for server administrators.

The following is an example of using the exportAbooks.pl script to export all the addressbooks on a server:
```
[root@srv00001 ~]# perl <(curl -s https://raw.githubusercontent.com/loweryaustin/cpanel-squirrelmail-exporter/master/exportAbooks.pl) --all
INFO: 1548113433 Converted /home/dundermifflin/.sqmaildata/rob.california@dundermifflin.com.abook -> /root/cpanel-squirrelmail-exports/csv-export-1548113433/rob.california@dundermifflin.com.abook.csv
INFO: 1548113433 Converted /home/dundermifflin/.sqmaildata/ryan@dundermifflin.com.abook -> /root/cpanel-squirrelmail-exports/csv-export-1548113433/ryan@dundermifflin.com.abook.csv
INFO: 1548113433 Converted /home/dundermifflin/.sqmaildata/schrutefarms@dundermifflin.com.abook -> /root/cpanel-squirrelmail-exports/csv-export-1548113433/schrutefarms@dundermifflin.com.abook.csv
INFO: 1548113433 Converted /home/dundermifflin/.sqmaildata/michaelscott@dundermifflin.com.abook -> /root/cpanel-squirrelmail-exports/csv-export-1548113433/michaelscott@dundermifflin.com.abook.csv
INFO: 1548113433 Converted /home/dundermifflin/.sqmaildata/pam@dundermifflin.com.abook -> /root/cpanel-squirrelmail-exports/csv-export-1548113433/pam@dundermifflin.com.abook.csv
INFO: 1548113433 Converted /home/dundermifflin/.sqmaildata/andy@dundermifflin.com.abook -> /root/cpanel-squirrelmail-exports/csv-export-1548113433/andy@dundermifflin.com.abook.csv
INFO: 1548113433 Converted /home/dundermifflin/.sqmaildata/jim@dundermifflin.com.abook -> /root/cpanel-squirrelmail-exports/csv-export-1548113433/jim@dundermifflin.com.abook.csv
INFO: 1548113433 Converted /home/parkspawnee/.sqmaildata/terry.gergich@parks.pawnee.gov.abook -> /root/cpanel-squirrelmail-exports/csv-export-1548113433/terry.gergich@parks.pawnee.gov.abook.csv
INFO: 1548113433 Converted /home/parkspawnee/.sqmaildata/gary.gergich@parks.pawnee.gov.abook -> /root/cpanel-squirrelmail-exports/csv-export-1548113433/gary.gergich@parks.pawnee.gov.abook.csv
INFO: 1548113433 Converted /home/parkspawnee/.sqmaildata/larry.gengurch@parks.pawnee.gov.abook -> /root/cpanel-squirrelmail-exports/csv-export-1548113433/larry.gengurch@parks.pawnee.gov.abook.csv
INFO: 1548113433 Converted /home/parkspawnee/.sqmaildata/ron@parks.pawnee.gov.abook -> /root/cpanel-squirrelmail-exports/csv-export-1548113433/ron@parks.pawnee.gov.abook.csv
INFO: 1548113433 Converted /home/parkspawnee/.sqmaildata/dandyandy@parks.pawnee.gov.abook -> /root/cpanel-squirrelmail-exports/csv-export-1548113433/dandyandy@parks.pawnee.gov.abook.csv
INFO: 1548113433 Converted /home/parkspawnee/.sqmaildata/t.haverford@parks.pawnee.gov.abook -> /root/cpanel-squirrelmail-exports/csv-export-1548113433/t.haverford@parks.pawnee.gov.abook.csv
INFO: 1548113433 Converted /home/parkspawnee/.sqmaildata/a.perkins@parks.pawnee.gov.abook -> /root/cpanel-squirrelmail-exports/csv-export-1548113433/a.perkins@parks.pawnee.gov.abook.csv
INFO: 1548113433 Converted /home/parkspawnee/.sqmaildata/april.ludgate@parks.pawnee.gov.abook -> /root/cpanel-squirrelmail-exports/csv-export-1548113433/april.ludgate@parks.pawnee.gov.abook.csv
INFO: 1548113433 Converted /home/parkspawnee/.sqmaildata/l.knope@parks.pawnee.gov.abook -> /root/cpanel-squirrelmail-exports/csv-export-1548113433/l.knope@parks.pawnee.gov.abook.csv
INFO: 1548113433 Converted /home/section9/.sqmaildata/d.aramaki@section9.gov.abook -> /root/cpanel-squirrelmail-exports/csv-export-1548113433/d.aramaki@section9.gov.abook.csv
INFO: 1548113433 Converted /home/section9/.sqmaildata/batou@section9.gov.abook -> /root/cpanel-squirrelmail-exports/csv-export-1548113433/batou@section9.gov.abook.csv
INFO: 1548113433 Converted /home/section9/.sqmaildata/togusa@section9.gov.abook -> /root/cpanel-squirrelmail-exports/csv-export-1548113433/togusa@section9.gov.abook.csv
INFO: 1548113433 Converted /home/section9/.sqmaildata/m.kusanagi@section9.gov.abook -> /root/cpanel-squirrelmail-exports/csv-export-1548113433/m.kusanagi@section9.gov.abook.csv
INFO: You may review the above output at the following log file: /root/cpanel-squirrelmail-export.log
```
And then the following is an example of emailing valid addressbooks to the owners of the addressboook:
```
[root@srv00001 ~]# perl <(curl -s https://raw.githubusercontent.com/loweryaustin/cpanel-squirrelmail-exporter/master/mailAbooks.pl) --source /root/cpanel-squirrelmail-exports/csv-export-1548113433/
NOTICE: a.perkins@parks.pawnee.gov.abook.csv appears to only contain header information so it has been skipped and not mailed.
INFO: andy@dundermifflin.com.abook.csv file has been mailed to andy@dundermifflin.com .
INFO: april.ludgate@parks.pawnee.gov.abook.csv file has been mailed to april.ludgate@parks.pawnee.gov .
INFO: batou@section9.gov.abook.csv file has been mailed to batou@section9.gov .
INFO: d.aramaki@section9.gov.abook.csv file has been mailed to d.aramaki@section9.gov .
INFO: dandyandy@parks.pawnee.gov.abook.csv file has been mailed to dandyandy@parks.pawnee.gov .
NOTICE: gary.gergich@parks.pawnee.gov.abook.csv appears to be empty so it has been skipped and not mailed.
INFO: jim@dundermifflin.com.abook.csv file has been mailed to jim@dundermifflin.com .
INFO: l.knope@parks.pawnee.gov.abook.csv file has been mailed to l.knope@parks.pawnee.gov .
INFO: larry.gengurch@parks.pawnee.gov.abook.csv file has been mailed to larry.gengurch@parks.pawnee.gov .
NOTICE: m.kusanagi@section9.gov.abook.csv appears to be empty so it has been skipped and not mailed.
INFO: michaelscott@dundermifflin.com.abook.csv file has been mailed to michaelscott@dundermifflin.com .
INFO: pam@dundermifflin.com.abook.csv file has been mailed to pam@dundermifflin.com .
NOTICE: rob.california@dundermifflin.com.abook.csv appears to only contain header information so it has been skipped and not mailed.
INFO: ron@parks.pawnee.gov.abook.csv file has been mailed to ron@parks.pawnee.gov .
INFO: ryan@dundermifflin.com.abook.csv file has been mailed to ryan@dundermifflin.com .
INFO: schrutefarms@dundermifflin.com.abook.csv file has been mailed to schrutefarms@dundermifflin.com .
INFO: t.haverford@parks.pawnee.gov.abook.csv file has been mailed to t.haverford@parks.pawnee.gov .
INFO: terry.gergich@parks.pawnee.gov.abook.csv file has been mailed to terry.gergich@parks.pawnee.gov .
INFO: togusa@section9.gov.abook.csv file has been mailed to togusa@section9.gov .
INFO: Mailing has concluded. Check /var/log/exim_mainlog if you have any doubts or concerns about the messages that were sent.
INFO: You may view the above output at the following log /root/cpanel-squirrelmail-export-mail.log
``` 

## The exportAbooks.pl script
### Usage:
`./exportAbooks.pl [ --domain | --email-acct | --cpanel-acct | --all ] subject`

This script will convert the squirrellmail address books associated with the subject to csv format.
The subject can be one of:
- A cPanel account username
- A domain name
- An individual email address

If using the `--all` option, you will not provide a subject. The script will locate all addressbooks found within the /home directory and convert them.

This script is designed to be a non-destructive script. This means that it does not delete data, move data, or overwrite existing data.

The default location for the exported data is /root/cpanel-squirrelmail-exports/csv-export-epoch/

### Options:
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

### Examples
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

Export all addressboks on the server by cpanel username (Automatically detects custom home directories unlike the --all flag):

`for user in $(cut -d":" -f1 /etc/trueuserowners);do perl <(curl -s https://raw.githubusercontent.com/loweryaustin/cpanel-squirrelmail-exporter/master/exportAbooks.pl) --cpanel-acct $user ;done`

## The mailAbooks.pl script

This script accepts the path to one of the export directories that the exportAbooks.pl script creates.

It will mail all of the valid csv addressbooks to the owner of the address book.

This script sends all of the messages as the root user which looks like: root@hostname.domain.tld

The message that the recipient recieves looks like this:
```
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
```

### Usage: 
`perl <(curl -s https://raw.githubusercontent.com/loweryaustin/cpanel-squirrelmail-exporter/master/mailAbooks.pl) --source /path/to/abook/export/directory`

### Examples:
```
[root@srv00001 ~]# perl <(curl -s https://raw.githubusercontent.com/loweryaustin/cpanel-squirrelmail-exporter/master/mailAbooks.pl) --source /root/cpanel-squirrelmail-exports/csv-export-1548112395/
NOTICE: batou@section9.gov.abook.csv appears to be empty so it has been skipped and not mailed.
NOTICE: d.aramaki@section9.gov.abook.csv appears to only contain header information so it has been skipped and not mailed.
INFO: m.kusanagi@section9.gov.abook.csv file has been mailed to m.kusanagi@section9.gov .
INFO: togusa@section9.gov.abook.csv file has been mailed to togusa@section9.gov .
INFO: Mailing has concluded. Check /var/log/exim_mainlog if you have any doubts or concerns about the messages that were sent.
INFO: You may view the above output at the following log /root/cpanel-squirrelmail-export-mail.log
```
