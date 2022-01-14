# Inception

## Using Docker to create a WordPress service

## Resources

1. [Docker compose python](https://docs.docker.com/compose/gettingstarted/)
2. [Docker compose WordPress](https://docs.docker.com/samples/wordpress/)
3. [Makefile](https://medium.com/freestoneinfotech/simplifying-docker-compose-operations-using-makefile-26d451456d63)
4. [Dockerfiles best practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
5. [Dockerfile naming](https://docs.docker.com/compose/compose-file/compose-file-v3/)
6. [Tutorial](https://medium.com/swlh/wordpress-deployment-with-nginx-php-fpm-and-mariadb-using-docker-compose-55f59e5c1a)
7. [Ref-Hans](https://hub.docker.com/r/hanshazairi/42ools)
8. [Inception resources](https://awesomeopensource.com/project/barimehdi77/inception)

## Idea

**Docker**

1. Create 3 Dockerfiles, one for each service
2. Write a `docker-compose.yml` that `build`s each image to one `container`
3. Also add configurations

**VM**

1. Create 2 physical volumes, one for `MariaDB`, one for `WordPress`
2. The .`yml` file will bind mount these repo to the respective services
3. Do something with `bind mount` or `volume` to store data

## Notes

1. Docker container are `ephemeral`. Hence, data in the docker container are destroyed at the end of the cycle. [article](https://medium.com/@maannniii/why-are-docker-containers-ephemeral-169c99d77455)
2. Mounting current directory as a volume in Docker on Windows 10 (PowerShell)
   - use `${PWD}`. eg: `docker container run --rm -it -v ${PWD}:/tmp hanshazairi/42ools` [source](<https://stackoverflow.com/questions/41485217/mount-current-directory-as-a-volume-in-docker-on-windows-10#:~:text=The%20following%20options%20will%20work%20on%20both%20PowerShell%20and%20on%20Linux%20(at%20least%20Ubuntu)%3A>)
   - However, `docker-compose.yml` still reads it as a string. Hence, using absolute path with docker run, `/c/Users/...` [source](https://stackoverflow.com/questions/40213524/using-absolute-path-with-docker-run-command-not-working#:~:text=docker%20run%20%2D%2Dpublish%3D7474%3A7474%20%2D%2Dvolume%3D/c/Users/USERNAME/neo4j_test/data%3A/data%20neo4j)
3. Simple test whether `NGINX` can run normally on system [How to use the official NGINX DOcker Image](https://www.docker.com/blog/how-to-use-the-official-nginx-docker-image/) _<- also `--name web` to name container, then `docker stop web`_
4. `curl localhost:8080` to check if there's anything being returned by a (server?)
   - Create an HTTP server `python -m http.server 8000`

## Steps

### Installing WordPress

Install _curl_ via `apk add curl` [source](https://www.cyberciti.biz/faq/how-to-install-curl-on-alpine-linux/)

> \> RUN apk --no-cache add curl

Download WordPress via `curl` [via wget/curl](https://www.configserverfirewall.com/linux-tutorials/wget-wordpress-download/)

```
>> curl -O https://wordpress.org/latest.zip
>> sudo mkdir -p /srv/www
>> sudo chown www-data: srv/www
>> curl https://wordpress.org/latest.tar.gz
>> sudo -u www-data tar zx -C /srv/www
```

_`chown` [meaning](https://www.computerhope.com/unix/uchown.htm#:~:text=by%20a%20colon.-,user%3A,owning%20group%20is%20changed%20to%20the%20login%20group%20of%20user.,-%3A)_

### AppA - Setting up mysql directory

Delete existing `mysql` user

```
>> sudo userdel mysql
```

Create another `mysql` with uid of **999**

```
>> sudo useradd -u 999 mysql
```

_The directory `var/lib/mysql` is own by the user `mysql`. The uid of this user in the container is `999`_

Can also check for the existing `mysql` user information with

```
>> id mysql
```

or

```
>> less /etc/passwd
```

And modify the user id

```
>> usermod -u \<num\> mysql
```

[info](https://www.fosslinux.com/39230/what-is-uid-in-linux-and-how-to-find-and-change-it.htm)

Set the owner of the directory `data/mysql` in the host machine.

```
>> sudo mkdir -p data/mysql
>> sudo chown -R mysql:mysql data/mysql
```

_add `'/'` infront of directory to start from root_

\*`chown` [meaning](https://www.computerhope.com/unix/uchown.htm#:~:text=user%3Agroup,no%20spaces%20between.)

_use `ls -l` to display directory's owner_

### AppB - Setting up WordPress directory

In the **WordPress** container, the directory `/var/www/html` is owned by the user `www-data`. The uid of this user in the container is `82`. It is not necessarity the same with the host machine.

Delete any existing user with the user name `www-data` and create a new user with uid `82`

```
$ sudo userdel www-data
$ sudo useradd -u 82 www-data
```

Set the owner of the directory `/data/html/` in the host machine.

```
$ sudo mkdir -p /data/html
$ sudo chown -R www-data:www-data /data/html
```

### NGINX config

Create a directory named `nginx` with a `nginx.conf` file in it.
