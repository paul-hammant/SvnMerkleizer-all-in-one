# Building it and running (no version on Dockerhub yet)
  
  ```
  $ git clone git@github.com:paul-hammant-fork/svnmerkleizer-allinone.git
  $ cd svnmerkleizer-allinone
  ```

## Getting the SvnMerkleizer fat jar dependency

First we need the SvnMerkleizer fat jar (if you did not build it yourself)

```
mvn dependency:get -Dartifact=com.paulhammant.svnmerkleizer:svnmerkleizer:1.0-SNAPSHOT
```

Then we need copy it into this clone/checkout directory then modify its `application.conf` file.

```
./copy-jar.sh
```

# Building the Docker image and running (no version on Dockerhub yet)

```
$ git clone git@github.com:paul-hammant-fork/svnmerkleizer-allinone.git
$ cd svnmerkleizer-allinone
$ docker build -t paulhammant/svnmerkleizer-allinone .
$ docker run -d -p 8098:80 -P paulhammant/svnmerkleizer-allinone
```

^ The container starts with a default superuser account: admin (password: adminpw) and a repository at http://localhost:8098/svn/root/

# Using it

Navigate to http://localhost:8098/svn/root/.merkle.txt using your browser to see the root of the Merkle tree. You'll have to 
authenticate - the user is admin and password is adminpw. 

Or you can do a checkout `svn co --username admin http://localhost:8098/svn/root/` to use it as a normal Subversion 
server.

# Credits

Thanks to 'Pika Do' for pikado/alpine-svn for getting me started with Alpine Linux, Docker and Subversion over WebDAV.
