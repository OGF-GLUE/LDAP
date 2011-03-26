#!/bin/bash

################################################################################
#                  GLUE 2.0 LDAP unit testing script
#
# URL:     http://forge.gridforum.org/sf/projects/glue-wg
# Author:  David Horat (david.horat@cern.ch), CERN
# Version: 0.1 (24/03/2009)
# Version: 0.2 (13/10/2010) Changed localhost for `echo $HOSTNAME`
################################################################################

# Basic info
`unalias -a` # Remove all aliases from this new shell
STARTTIME=`date +%s`
VERSION='0.1'

# Parameters (Adapt them to your needs)
INPUTDIR='ldif'
TEARDOWN="$INPUTDIR/99-TearDown.td"
HOST=`echo $HOSTNAME`
PASS='bdiidbpassword' # This should be used just in a testing machine
LOGFILE='test-ldif.log'

# Welcome message, erase the old log file
echo "Welcome to GLUE 2.0 LDAP unit testing script v$VERSION"
date
rm -f $LOGFILE

# Check if needed files and dirs are present
if [ ! -d $INPUTDIR ]; then
  echo "Input dir '$INPUTDIR' does not exist."
  exit 1
fi
if [ ! -f $TEARDOWN ]; then
  echo "Tear down file '$INPUTDIR' does not exist."
  exit 1
fi

# Collect all content of the files from the INPUTDIR and put them into OUTPUTFILE
for file in $INPUTDIR/*.ldif; do
  echo "Testing file $file"
  ldapadd -x -D "o=glue" -w $PASS -h $HOST -v -f $file &> $LOGFILE
  if [ $? -ne 0 ]; then
    echo "Errors when trying to add the file $file"
    RUNTIME=$[`date +%s` - $STARTTIME]
    echo "This script took $RUNTIME second/s to run."
    echo "ERROR! Check the log in $LOGFILE"
    exit 2
  fi
done

# Tear down to recover initial state
echo 'Tearing down'
ldapdelete -x -D "o=glue" -w $PASS -h $HOST -v -f $TEARDOWN &> $LOGFILE
if [ $? -ne 0 ]; then
  echo "Errors when in the tear down process using the file $TEARDOWN"
  RUNTIME=$[`date +%s` - $STARTTIME]
  echo "This script took $RUNTIME second/s to run."
  echo "ERROR! Check the log in $LOGFILE"
  exit 3
fi

# Calculate runtime and bye messages
RUNTIME=$[`date +%s` - $STARTTIME]
echo "This script took $RUNTIME second/s to run."
echo 'All OK!'
