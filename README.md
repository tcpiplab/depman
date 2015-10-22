# depman.pl

A command line perl script for displaying the current managers of the
departments in MySQL's well known [Employees Sample Database](http://dev.mysql.com/doc/employee/en/), which can be downloaded from [github](https://github.com/datacharmer/test_db) or [Launchpad](https://launchpad.net/test-db/).


## Motivation

This is just a proof of concept script showing how to use Perl to connect
to a MySQL database.

## Requirements

* Perl 5, with the `Getopt::Long` and `DBI` modules.
* MySQL 5.5.
* Download and install the test database per [these](http://dev.mysql.com/doc/employee/en/employees-installation.html) instructions.
* The database user is hardcoded in the script.
* Save your database password outside the Perl script. Create a file outside the directory that contains the source code and database. For now it is specified in the script as `"../secrets/depman.secrets.txt"`. That way you run less of a risk of putting the password file up on github.

## Running the script

Run the script:

     perl depman.pl

Resulting output will be something like this:

    -----------------------------------------
    Current Department Managers
    -----------------------------------------
    Department          First Name Last Name  
    -----------------------------------------
    Customer Service    Yuchang    Weedman    
    Development         Leon       DasSarma   
    Finance             Isamu      Legleitner
    Human Resources     Karsten    Sigstam    
    Marketing           Vishwani   Minakawa   
    Production          Oscar      Ghazalie   
    Quality Management  Dung       Pesch      
    Research            Hilary     Kambil     
    Sales               Hauke      Zhang      
    -----------------------------------------

  Specifying the `-d` or `--date` option with the date argument as YYYY-MM-DD shows the managers for that date:

    perl depman.pl --date 2012-01-01
    -----------------------------------------
    Department Managers as of 2012-01-01
    -----------------------------------------
    Department          First Name Last Name  
    -----------------------------------------
    Customer Service    Yuchang    Weedman    
    Development         Leon       DasSarma   
    Finance             Isamu      Legleitner
    Human Resources     Karsten    Sigstam    
    Marketing           Vishwani   Minakawa   
    Production          Oscar      Ghazalie   
    Quality Management  Dung       Pesch      
    Research            Hilary     Kambil     
    Sales               Hauke      Zhang      
    -----------------------------------------


## Authorship and License

I wrote the Perl, which you can use under an MIT License.

The excellent test database was provided by MySQL under the [Creative Commons Attribution-Share Alike 3.0 Unported License](http://creativecommons.org/licenses/by-sa/3.0/).
