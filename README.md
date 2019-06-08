# What is this?

It is Apache2 with Subversion's MOD_DAV_SVN Apache module and a Java process adding a merkle tree all in one Docker 
image (*). The key piece is that Java process that overlays the Subversion directories with extra meta-information 
resources giving Subversion a full merkle tree capability. That's [SvnMerkleizer](https://github.com/paul-hammant/SvnMerkleizer), 
and it obeys Subversion's user/group permissions, so the Merkle tree could differ per user, as you would want.

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

Next you need the SvnMerkleizer fat jar

```
# In a new terminal window .....
$ git clone git@github.com:paul-hammant/SvnMerkleizer.git
$ cd SvnMerkleizer
$ mvn clean install -DskipTests  
```

Then copy that into the checkout from #1

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

# Simple using of it

Navigate to http://localhost:8098/svn/root/.merkle.txt **using your browser** to see the root of the Merkle tree. You'll have to 
authenticate: the user is `admin` and password is `adminpw`. 

From the command line, using curl, to see the same thing:

```
curl -u admin:adminpw http://localhost:8098/svn/root/.merkle.txt

```

Lastly, you can do a regular Subversion checkout `svn co --username admin http://localhost:8098/svn/root/`, but with that the `.merkle.*` resources are **not** in the local checkout. That is because the Subversion client does not know about the those resources.


# Testing it

Using Subversion, make some changes/additions (directories and files) and commit them back to the repo. Usin the curl command above, look at the changing `.merkle.txt` files after you've done each commit.

Be aware that you also have `.merkle.csv`, `.merkle.json`, `.merkle.xml` and `.merkle.html` too.

# TODO

1. Allow a parameterized admin password in the docker image
2. Allow a parameterized volume for the Subversion file system storage.
3. Upgrade past Alpine 3.7.1 & Java 8.

# Credits

Thanks to 'Pika Do' for pikado/alpine-svn for getting me started with Subversion via WebDAV inside a Docker image.
