# new
# dotnet --list-sdks
# dotnet new list
# dotnet new <template> -n NomeDoProjeto -f Framework
# sln
# dotnet sln NomeDaSolucao.sln list
# dotnet sln NomeDaSolucao.sln add caminho/para/Projeto.csproj
# dotnet sln NomeDaSolucao.sln remove caminho/para/Projeto.csproj
# add
# dotnet add caminho/para/Projeto.csproj reference caminho/para/OutroProjeto.csproj
# dotnet add package NomeDoPacote
# restore
# dotnet restore
# build ----------------------------------------------------------------------------------------------------------------
function dnbd {
    param (
        $outputName
    )
    
    if ($outputName) {
        dotnet build -c Debug -o $outputName
    } else {
        dotnet build -c Debug
    }
}

function dnbr {
    param (
        $outputName
    )
    
    if ($outputName) {
        dotnet build -c Release -o $outputName
    } else {
        dotnet build -c Release
    }
}
# publish --------------------------------------------------------------------------------------------------------------
function dnpd {
    param (
        $outputName
    )

    if ($outputName) {
        dotnet publish -c Debug -o $outputName
    } else {
        dotnet publish -c Debug
    }
}

function dnpr {
    param (
        $outputName
    )

    if ($outputName) {
        dotnet publish -c Release -o $outputName
    } else {
        dotnet publish -c Release
    }
}
# clean ----------------------------------------------------------------------------------------------------------------
function dncd {
    dotnet clean -c Debug
}

function dncr {
    dotnet clean -c Release
}
# run ------------------------------------------------------------------------------------------------------------------
function dnrd {
    param (
        $outputName
    )
    
    if ($outputName) {
        dotnet run -c Debug -o $outputName
    } else {
        dotnet run -c Debug
    }
}

function dnrr {
    param (
        $outputName
    )
    
    if ($outputName) {
        dotnet run -c Debug -o $outputName
    } else {
        dotnet run -c Release
    }
}