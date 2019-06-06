# What is this?

It is Apache2 with Subversion's MOD_DAV_SVN Apache module and a Java process all in one Docker image (*). The Java process overlays the 
Subversion directories with extra meta-information files giving 
Subversion a full merkle tree capability. It obeys Subversion's user/group permissions, so the Merkle tree could 
differ per user, as you would want.

* two docker images would be more normal for this, as this is more than one dissimilar process. This single Docker 
container design is to reduce I/O distance between the pieces as the whole thing is very chatty, and latency can be 
high at times.

# Building it and running (no version on Dockerhub yet)

## 1. Clone this repo
  
```
$ git clone git@github.com:paul-hammant-fork/svnmerkleizer-allinone.git
$ cd svnmerkleizer-allinone
```

## 2. Getting the SvnMerkleizer fat jar dependency

First we need the SvnMerkleizer fat jar

### 2.1 if you are NOT going to build it yourself

```
$ mvn dependency:get -Dartifact=com.paulhammant.svnmerkleizer:svnmerkleizer:1.0-SNAPSHOT
```

### 2.2 If you want to build it yourself:

```
$ git clone git@github.com:paul-hammant/SvnMerkleizer.git
$ cd SvnMerkleizer
$ mvn clean install -DskipTests  
```

### 2.3 Copying it into this checkout

```
cp ~/.m2/repository/com/paulhammant/svnmerkleizer/svnmerkleizer-service/1.0-SNAPSHOT/svnmerkleizer-service-1.0-SNAPSHOT.jar .
```

## 3. Building the Docker image

```
$ docker build -t paulhammant/svnmerkleizer-allinone .
```

## 4. Running it (no version on Dockerhub yet)

```
$ docker run -d -p 8098:80 -P paulhammant/svnmerkleizer-allinone
```

^ The container starts with a default superuser account: admin (password: adminpw) and a repository at http://localhost:8098/svn/root/

# Using it

Navigate to http://localhost:8098/svn/root/.merkle.txt using your browser to see the root of the Merkle tree. You'll have to 
authenticate - the user is `admin` and password is `adminpw`. 

Or you can do a checkout `svn co --username admin http://localhost:8098/svn/root/` to use it as a normal Subversion 
server.


# TODO

1. Allow a parameterized admin password
2. Specify a volume for the Subversion FS storage.

# Credits

Thanks to 'Pika Do' for pikado/alpine-svn for getting me started with Alpine Linux, Docker and Subversion over WebDAV.
