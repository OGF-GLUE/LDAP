#!/bin/bash

################################################################################
#                  GLUE 2.0 LDAP schema compilation script
#
# URL:       http://forge.gridforum.org/sf/projects/glue-wg
# Author:    David Horat (david.horat@cern.ch), CERN
# Version:   0.2
# Changelog: 0.1 (24/03/2009) - First version
#            0.2 (13/07/2009) - Added copyright notice
################################################################################

# Basic info
`unalias -a` # Remove all aliases from this new shell
STARTTIME=`date +%s`
VERSION='0.2'
COPYRIGHT='LICENSE'

# Parameters (Adapt them to your needs)
INPUTDIR='schema'
OUTPUTFILE='GLUE20.schema'

# Welcome message
echo "Welcome to GLUE 2.0 LDAP schema compilation script v$VERSION"
date

# Check if needed files and dirs are present
if [ ! -d $INPUTDIR ]; then
  echo "Input dir '$INPUTDIR' does not exist."
  exit 1
fi

# If OUTPUTFILE exist, make a backup and delete it
if [ -f $OUTPUTFILE ]; then
  mv -f $OUTPUTFILE $OUTPUTFILE.'bak'
fi

# Add the copyright notice to the new file
cat $COPYRIGHT > $OUTPUTFILE

# Collect all content of the files from the INPUTDIR and put them into OUTPUTFILE
for file in $INPUTDIR/*.schema; do 
  echo '# File:   ' $file >> $OUTPUTFILE
  cat $file >> $OUTPUTFILE
  echo '' >> $OUTPUTFILE
done

# Calculate runtime and bye messages
RUNTIME=$[`date +%s` - $STARTTIME]
echo "This script took $RUNTIME seconds to run."
echo "$OUTPUTFILE file is ready!"
