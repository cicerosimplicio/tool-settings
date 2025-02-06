# build
function dbbt {
    param (
        $tag
    )

    docker buildx build --tag $tag .
}
# image
function dil {
    docker image ls
}

function dir {
    param (
        $image
    )

    docker image rm $image
}

function dira {
    docker image rm $(docker image ls -q)
}

function dip {
    docker image prune
}
# container
function dcl {
    docker container ls
}

function dcr {
    param (
        $container
    )

    docker container rm $container
}

function dcra {
    docker container rm $(docker container ls -q)
}

function dcp {
    docker container prune
}

function dcsc {
    param (
        $container
    )

    docker container stop $container
}

function dcsa {
    docker container stop $(docker container ls -q)
}

function dcrdp {
    param (
        $port,
        $image
    )

    docker container run --rm --detach --publish $port $image
}

function dcrit {
    param (
        $image
    )

    docker container run --rm --interactive --tty $image /bin/sh
}

function dcrnd {
    param (
        $name,
        $image
    )

    docker container run --rm --name $name --detach $image
}

function dcrndv {
    param (
        $name,
        $source,
        $target,
        $image
    )

    docker container run --rm --name $name --detach --volume "$source`:$target" $image
}

function dcec {
    param (
        $name,
        $command
    )

    docker container exec $name sh -c $command
}

function dceit {
    param (
        $name
    )

    docker container exec --interactive --tty $name /bin/sh
}

# volume
function dvl {
    docker volume ls
}

function dvp {
    docker volume prune
}

# compose
function dcw {
    docker compose watch
}

function dcs {
    docker compose stop
}
# databases
# postgres
function drpg {
    docker run --rm --name pg-docker -e POSTGRES_PASSWORD=docker -d -p 5432:5432 -v $HOME/docker/volumes/postgres:/var/lib/postgresql/data postgres
}
# mssql
function drms {
    docker run --rm --name mssql-docker -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=1q2w3e4r@#$" -d -p 1433:1433 -v $HOME/docker/volumes/mssql:/var/opt/mssql/data mcr.microsoft.com/mssql/server
}