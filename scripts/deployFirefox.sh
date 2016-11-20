#!/bin/bash

##
## Script to deploy firefox to new location after build
##

DOWNLOAD_DIR=/home/ffdev/dist
DIST_FILE=firefox-53.0a1.en-US.linux-x86_64.tar.bz2
DEST_DIR=/home/ffdev/development
DEST_FOLDER=/home/ffdev/development/firefox
REPO_URL=http://localhost:8081/repository/firefox-builds

function deleteFolder {
   DDIR=$1
   if [ -d $DDIR ]; then
	echo "Delete folder: $DDIR"      
	rm -r $DDIR
   fi
}

function unzipFileToDir {
   DFILE=$1
   DDIR=$2
   if [ -f $DFILE ]; then
	echo "Unzipping [$DFILE]"
	echo "to"
	echo "[$DDIR]"
	tar -xjf $DFILE -C $DDIR
   fi
}

##
## Download the build artifact from the repository
##
echo "Downloading Firefox..."
wget $REPO_URL/$DIST_FILE -P $DOWNLOAD_DIR

##
## Install the firefox runtime
##
echo "Deploying Firefox..."
if [ -f $DOWNLOAD_DIR/$DIST_FILE ]; then
	deleteFolder $DEST_FOLDER
	unzipFileToDir $DOWNLOAD_DIR/$DIST_FILE $DEST_DIR
	echo "Deployment completed successfully!"	
else
   echo "The Firefox build does not exist"
fi
