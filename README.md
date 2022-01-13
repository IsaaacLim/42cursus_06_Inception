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
