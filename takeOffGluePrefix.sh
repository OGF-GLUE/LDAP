#!/bin/bash

# Script to take off the Glue prefix from all schema and ldif files

cd schema
for file in *.schema; do
  cat $file | sed 's/Glue//g' > $file.new
  mv -f $file.new $file
done

cd ..
cd ldif
for file in *.ldif; do
  cat $file | sed 's/Glue//g' > $file.new
  mv -f $file.new $file
done

