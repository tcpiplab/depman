#!/usr/bin/perl  -w

# Luke Sheppard
# lshep.usc[(at)]gmail.com
# October 21, 2015
#
# depman - A simple command line client to retrieve current department
# managers, or from a specified date. 
#
# See the included README file for installation instructions for the required
# "employees" database.

use strict;
use Getopt::Long;
use DBI;
my $db="employees";
my $host="localhost";
my $user="root";
# Read the password from a mode 600 file outside the source tree.
my $passwordfile = "../secrets/depman.secrets.txt";
open FILE, $passwordfile or die "Cannot open file: $!\n";
my $password = <FILE>;
chomp $password;
close FILE;

my $dbh   = DBI->connect ("DBI:mysql:database=$db:host=$host",
                           $user,
                           $password) 
                           or die "Can't connect to database: $DBI::errstr\n";

# the non-dated query
my $plainquery = $dbh->prepare("
    SELECT departments.dept_name, employees.first_name, employees.last_name 
    FROM dept_manager 
    JOIN employees 
    ON employees.emp_no = dept_manager.emp_no 
    JOIN departments 
    ON dept_manager.dept_no = departments.dept_no 
    WHERE dept_manager.to_date = '9999-01-01'"
    );

# safe default value
my $thedate = '9999-01-01';

# the dated query
my $datedquery = $dbh->prepare("
    SELECT departments.dept_name, employees.first_name, employees.last_name 
    FROM dept_manager 
    JOIN employees 
    ON employees.emp_no = dept_manager.emp_no 
    JOIN departments 
    ON dept_manager.dept_no = departments.dept_no 
    WHERE \@thedate BETWEEN from_date AND to_date"
    );

# default to non-dated query
my $thequery = $plainquery;

# MAIN
&get_options;
&query;
# end MAIN

sub get_options {
  Getopt::Long::Configure ("bundling");
  my $help;
  my $version;
  GetOptions("d|date=s" => \&date, # required user supplied string w/ date 
             "help|h|?" => \&help,
             );
} # end get_options()

sub date {
  # validate the input  
  if ($_[1] =~ /^\d{4}-\d\d-\d\d$/)
  {
    $thedate = $_[1];
    $thequery = $datedquery;
  }
  else
  {
   print "Please enter dates in YYYY-MM-DD format.\n";
   exit;
  }
} # end date()

sub help {
  print "\n";
  print "Usage:\n";
  print "./depman.pl [-d date]\n";
  print "\n";
  print "-d   --date YYYY-MM-DD      Specify a date for the search.\n";
  print "-h   --help                 This output.\n";
  exit;
} # end help()

sub query {
  # set a mysql var for the date
  $dbh->do("SET \@thedate = '$thedate'");

  # run the query
  $thequery->execute( );

  # vars for binding the columns
  my ($firstname, $lastname, $department);

  # keep the columns in separate vars
  $thequery->bind_columns ( \$department, \$firstname, \$lastname );

  print '-' x 41 . "\n";

  if ($thedate eq '9999-01-01')
  {
    print "Current Department Managers\n";
  }
  else
  {
    print "Department Managers as of $thedate\n";
  }

  print '-' x 41 . "\n";
  printf("%-19s %-10s %-10s \n", "Department", "First Name", "Last Name");
  print '-' x 41 . "\n";

  while ( $thequery->fetch())  
  {      
      printf("%-19s %-10s %-10s \n", $department, $firstname, $lastname);
  }

  print '-' x 41 . "\n";
  
  if ($thequery->err()) 
  {
    warn "Problem in retrieving results", $thequery->errstr(), "\n";
  }

  #disconnect  from database 
  $dbh->disconnect or warn "Disconnection error: $DBI::errstr\n";
  exit;
} # end query()
