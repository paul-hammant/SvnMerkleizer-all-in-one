#!/bin/sh

echo "Wrapper"

if [ ! -d /var/svn/root ]; then
   svnadmin create /var/svn/root
   htpasswd -bc /etc/apache2/conf.d/davsvn.htpasswd admin adminpw
   mkdir -p rootSvnFldr
   touch rootSvnFldr/hello.txt
   svn import rootSvnFldr file:///var/svn/root -m "dummy commit"
   chgrp -R apache /var/svn/root
   chmod -R 775 /var/svn/root
   echo "Subversion setup"
fi

echo "Starting SvnMerkleizer service (Jooby)"

# Start Jooby SvnMerkleizer
java -cp /usr/share/myservice/svnmerkleizer.jar com.paulhammant.svnmerkleizer.boot.ViaHiddenGetRoutesAndCommandLineArgs http://localhost:80/svn/root/ merkle "" 8080 &
echo "Started Jooby + SvnMerkleizer service"

status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start SvnMerkleizer service process: $status"
  exit $status
fi

echo "Started SvnMerkleizer service"

# Start Apache + Subversion
httpd
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start Apache: $status"
  exit $status
fi

# Naive check runs checks once a minute to see if either of the processes exited.
# This illustrates part of the heavy lifting you need to do if you want to run
# more than one service in a single container. The container will exit with an error
# if it detects that either of the processes has exited.
# Otherwise it will loop forever, waking up every 60 seconds

while /bin/true; do
  ps aux |grep svnmerkleizer |grep -q -v grep
  PROCESS_1_STATUS=$?
  ps aux |grep httpd |grep -q -v grep
  PROCESS_2_STATUS=$?
  # If the greps above find anything, they will exit with 0 status
  # If they are not both 0, then something is wrong
  if [ $PROCESS_1_STATUS -ne 0 -o $PROCESS_2_STATUS -ne 0 ]; then
    echo "One of the processes has already exited."
    exit 10
  fi
  sleep 60
done

