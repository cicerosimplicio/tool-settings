# build
function DockerBuildTag {
    param (
        $tag
    )

    docker build --tag $tag .
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
function DockerRunDetachPublish {
    param (
        $port,
        $image
    )

    docker run --rm --detach --publish $port $image
}

function DockerRunInteractiveTty {
    param (
        $image
    )

    docker run --rm --interactive --tty $image /bin/sh
}

function DockerRunNameDetatch {
    param (
        $name,
        $image
    )

    docker run --rm --name $name --detach $image
}

function DockerRunNameDetatchVolume {
    param (
        $name,
        $source,
        $target,
        $image
    )

    docker run --rm --name $name --detach --volume "$source`:$target" $image
}
# exec
function DockerExec {
    param (
        $name,
        $command
    )

    docker exec $name sh -c $command
}

function DockerExecInteractiveTty {
    param (
        $name
    )

    docker exec --interactive --tty $name /bin/sh
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
function DockerRunPostgres {
    docker run --rm --name pg-docker -e POSTGRES_PASSWORD=docker -d -p 5432:5432 -v pg-vol:/var/lib/postgresql/data postgres
}
# mssql
function DockerRunMsSql {
    docker run --rm --name mssql-docker -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=1q2w3e4r@#$" -d -p 1433:1433 -v mssql-vol:/var/opt/mssql/data mcr.microsoft.com/mssql/server
}

# build
Set-Alias -Name dbt -Value DockerBuildTag
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
Set-Alias -Name drnd -Value DockerRunNameDetatch
Set-Alias -Name drndv -Value DockerRunNameDetatchVolume
Set-Alias -Name drdp -Value DockerRunDetachPublish
Set-Alias -Name drit -Value DockerRunInteractiveTty
# exec
Set-Alias -Name de -Value DockerExec
Set-Alias -Name deit -Value DockerExecInteractiveTty
# volume
Set-Alias -Name dvl -Value DockerVolumeList
Set-Alias -Name dvp -Value DockerVolumePrune
# compose
Set-Alias -Name dcw -Value DockerComposeWatch
Set-Alias -Name dcs -Value DockerComposeStop
# database
Set-Alias -Name drpg -Value DockerRunPostgres
Set-Alias -Name drms -Value DockerRunMsSql