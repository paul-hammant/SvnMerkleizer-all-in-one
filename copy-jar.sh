#!/bin/sh

cp ~/.m2/repository/com/paulhammant/svnmerkleizer/svnmerkleizer/1.0-SNAPSHOT/svnmerkleizer-1.0-SNAPSHOT.jar .
zip -d svnmerkleizer-1.0-SNAPSHOT.jar "application.conf"
zip -ur svnmerkleizer-1.0-SNAPSHOT.jar "application.conf"