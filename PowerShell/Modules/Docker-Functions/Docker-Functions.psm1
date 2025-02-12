# build
function DockerBuildxBuildTag {
    param (
        $tag
    )

    docker buildx build --tag $tag .
}
# image
function DockerImageList {
    docker image ls
}

function DockerImageRemove {
    param (
        $image
    )

    docker image rm $image
}

function DockerImageRemoveAll {
    docker image rm $(docker image ls -q)
}

function DockerImagePrune {
    docker image prune
}
# container
function DockerContainerList {
    docker container ls
}

function DockerContainerRemove {
    param (
        $container
    )

    docker container rm $container
}

function DockerContainerRemoveAll {
    docker container rm $(docker container ls -q)
}

function DockerContainerPrune {
    docker container prune
}

function DockerContainerStop {
    param (
        $container
    )

    docker container stop $container
}

function DockerContainerStopAll {
    docker container stop $(docker container ls -q)
}
# run
function DockerContainerRunDetachPublish {
    param (
        $port,
        $image
    )

    docker container run --rm --detach --publish $port $image
}

function DockerContainerRunInteractiveTty {
    param (
        $image
    )

    docker container run --rm --interactive --tty $image /bin/sh
}

function DockerContainerRunNameDetatch {
    param (
        $name,
        $image
    )

    docker container run --rm --name $name --detach $image
}

function DockerContainerRunNameDetatchVolume {
    param (
        $name,
        $source,
        $target,
        $image
    )

    docker container run --rm --name $name --detach --volume "$source`:$target" $image
}
# exec
function DockerContainerExec {
    param (
        $name,
        $command
    )

    docker container exec $name sh -c $command
}

function DockerContainerExecInteractiveTty {
    param (
        $name
    )

    docker container exec --interactive --tty $name /bin/sh
}

# volume
function DockerVolumeList {
    docker volume ls
}

function DockerVolumePrune {
    docker volume prune
}

# compose
function DockerComposeWatch {
    docker compose watch
}

function DockerComposeStop {
    docker compose stop
}
# databases
# postgres
function drpg DockerRunPostgres {
    docker run --rm --name pg-docker -e POSTGRES_PASSWORD=docker -d -p 5432:5432 -v $HOME/docker/volumes/postgres:/var/lib/postgresql/data postgres
}
# mssql
function DockerRunMsSql {
    docker run --rm --name mssql-docker -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=1q2w3e4r@#$" -d -p 1433:1433 -v $HOME/docker/volumes/mssql:/var/opt/mssql/data mcr.microsoft.com/mssql/server
}

# build
Set-Alias -Name dbbt -Value DockerBuildxBuildTag
# image
Set-Alias -Name dil -Value DockerImageList
Set-Alias -Name dirr -Value DockerImageRemove
Set-Alias -Name dira -Value DockerImageRemoveAll
Set-Alias -Name dip -Value DockerImagePrune
# container
Set-Alias -Name dcl -Value DockerContainerList
Set-Alias -Name dcr -Value DockerContainerRemove
Set-Alias -Name dcra -Value DockerContainerRemoveAll
Set-Alias -Name dcs -Value DockerContainerStop
Set-Alias -Name dcsa -Value DockerContainerStopAll
Set-Alias -Name dcp -Value DockerContainerPrune
# run
Set-Alias -Name dcrnd -Value DockerContainerRunNameDetatch
Set-Alias -Name dcrndv -Value DockerContainerRunNameDetatchVolume
Set-Alias -Name dcrdp -Value DockerContainerRunDetachPublish
Set-Alias -Name dcrit -Value DockerContainerRunInteractiveTty
# exec
Set-Alias -Name dce -Value DockerContainerExec
Set-Alias -Name dceit -Value DockerContainerExecInteractiveTty
# volume
Set-Alias -Name dvl -Value DockerVolumeList
Set-Alias -Name dvp -Value DockerVolumePrune
# compose
Set-Alias -Name dcpw -Value DockerComposeWatch
Set-Alias -Name dcps -Value DockerComposeStop
# database
Set-Alias -Name drpg -Value DockerRunPostgres
Set-Alias -Name drms -Value DockerRunMsSql