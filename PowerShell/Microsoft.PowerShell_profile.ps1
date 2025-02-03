# Configurações do PowerShell
$PSReadLineOptions = @{
    EditMode = "Vi"
    Colors = @{
        "Command" = "`e[92m"
    }
}
Set-PSReadLineOption @PSReadLineOptions

$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Configuração para a visualização do modo vim
function OnViModeChange {
    if ($args[0] -eq 'Command') {
        # Set the cursor to a blinking block.
        Write-Host -NoNewLine "`e[1 q"
    } else {
        # Set the cursor to a blinking line.
        Write-Host -NoNewLine "`e[5 q"
    }
}

Set-PSReadLineOption -ViModeIndicator Script -ViModeChangeHandler $Function:OnViModeChange

# oh-my-posh init
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\spaceship.omp.json" | Invoke-Expression

# Instalar o módulo abaixo
# Install-Module -Name PSFzf -Scope CurrentUser -Force

# Importar o módulo PSFzf
Import-Module PSFzf

# Habilita o tab completion do PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

# Habilita o tab expansion
#Set-PsFzfOption -TabExpansion

# Configurações de preview
$env:FZF_DEFAULT_OPTS = "--height 50% --layout=reverse --border --inline-info --bind 'ctrl-/:change-preview-window(hidden|)'"
$env:FZF_CTRL_T_OPTS = "--walker-skip .git,node_modules,target --preview 'bat -n --color=always --line-range :500 {}'"
$env:FZF_ALT_C_OPTS = "--walker-skip .git,node_modules,target --preview 'eza --tree --color=always {}'"

# Configurações adicionais do fzf
$env:FZF_DEFAULT_COMMAND = "fd --hidden --strip-cwd-prefix --exclude .git"

# Essential functions
function sf { param($fileName, $inputString) $dir = fd -t d "" C:\ | fzf -e; if ($dir) { Set-Content -Path "$dir\$fileName" -Value $inputString -Encoding UTF8 } }
function af { param($fileName, $inputString) $dir = fd -t d "" C:\ | fzf -e; if ($dir) { Add-Content -Path "$dir\$fileName" -Value $inputString -Encoding UTF8 } }

# Git Alias ----------------------------------------------------------------
Import-Module Git-Functions
# fetch
Set-Alias -Name gfo -Value GitFetchOrigin
# status
Set-Alias -Name gs -Value GitStatus
Set-Alias -Name gss -Value GitStatusShort
# pull
Set-Alias -Name gpl -Value GitPull
# push
Set-Alias -Name gpsh -Value GitPush
Set-Alias -Name gpsod -Value GitPushOriginDelete
Set-Alias -Name gpsf -Value GitPushForce
Set-Alias -Name gpssu -Value GitPushOriginSetUpstream
# log
Set-Alias -Name glo -Value GitLogOneline
Set-Alias -Name gloda -Value GitLogOnelineDecorateAll
Set-Alias -Name glogda -Value GitLogOnelineGraphDecoreteAll
# diff
Set-Alias -Name gd -Value GitDiff
Set-Alias -Name gdf -Value GitDiffFile
Set-Alias -Name gdbf -Value GitDiffBranchFile
Set-Alias -Name gdh -Value GitDiffHash
Set-Alias -Name gdb -Value GitDiffBranches
# show
Set-Alias -Name gsh -Value GitShow
Set-Alias -Name gshns -Value GitShowNameStatus
Set-Alias -Name gshno -Value GitShowNameOnly
Set-Alias -Name gshb -Value GitShowBranch
Set-Alias -Name gshbns -Value GitShowBranchNameStatus
Set-Alias -Name gshbno -Value GitShowBranchNameOnly
Set-Alias -Name gshstf -Value GitShowStashFile
Set-Alias -Name gshstfc -Value GitShowStashFileContent
Set-Alias -Name gshbf -Value GitShowBranchFile
Set-Alias -Name gshbfc -Value GitShowBranchFileContent
# switch
Set-Alias -Name gswc -Value GitSwitchCreate
Set-Alias -Name gsw -Value GitSwitch
Set-Alias -Name gswt -Value GitSwitchTrack
# branch
Set-Alias -Name gb -Value GitBranches
Set-Alias -Name gbr -Value GitBranchRemotes
Set-Alias -Name gba -Value GitBranchAll
Set-Alias -Name gbm -Value GitBranchMove
Set-Alias -Name gbd -Value GitBranchDelete
Set-Alias -Name gbc -Value GitBranchContains
Set-Alias -Name gbcr -Value GitBranchContainsRemotes
Set-Alias -Name gbca -Value GitBranchContainsAll
Set-Alias -Name gbsu -Value GitBranchSetUpstream
Set-Alias -Name gbuu -Value GitBranchUnsetUpsteam
Set-Alias -Name gbv -Value GitBranchVerbose
# rebase
Set-Alias -Name grb -Value GitRebase
Set-Alias -Name grbi -Value GitRebaseInteractive
# commit
Set-Alias -Name ghs -Value GitHashes
Set-Alias -Name gcc -Value GitCommitMessage
Set-Alias -Name gca -Value GitCommitAmend
Set-Alias -Name gcan -Value GitCommitAmendNoEdit
# remote
Set-Alias -Name grao -Value GitRemoteAddOrigin
# stash
Set-Alias -Name gsts -Value GitStashSave
Set-Alias -Name gstl -Value GitStashList
Set-Alias -Name gstsh -Value GitStashShow
Set-Alias -Name gstshno -Value GitStashShowNameOnly
Set-Alias -Name gstshns -Value GitStashShowNameStatus
Set-Alias -Name gsta -Value GitStashApply
Set-Alias -Name gstp -Value GitStashPop
# cherry-pick
Set-Alias -Name gcp -Value GitCherryPick
# restore
Set-Alias -Name gr -Value GitRestore
# reset
Set-Alias -Name grh -Value GitResetHard
Set-Alias -Name grs -Value GitResetSoft
Set-Alias -Name grm -Value GitResetMixed
# file
Set-Alias -Name gf -Value GitFiles
# add
Set-Alias -Name ga -Value GitAdd
# ------------------------------------------------------------------------------


# Dotnet functions -------------------------------------------------------------
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
# build
function dnbd { param($inputString) if ($inputString) { dotnet build -c Debug -o $inputString } else { dotnet build -c Debug } }
function dnbr { param($inputString) if ($inputString) { dotnet build -c Release -o $inputString } else { dotnet build -c Release } }
# publish
function dnpd { param($inputString) if ($inputString) { dotnet publish -c Debug -o $inputString } else { dotnet publish -c Debug } }
function dnpr { param($inputString) if ($inputString) { dotnet publish -c Release -o $inputString } else { dotnet publish -c Release } }
# clean
function dncd { dotnet clean -c Debug }
function dncr { dotnet clean -c Release }
# run
function dnrd { param($inputString) if ($inputString) { dotnet publish -c Debug -o $inputString } else { dotnet run -c Debug } }
function dnrr { param($inputString) if ($inputString) { dotnet publish -c Debug -o $inputString } else { dotnet run -c Release } }
# ------------------------------------------------------------------------------


# Docker functions
# build
function dbbt { param($tag) docker buildx build --tag $tag . }
# image
function dil { docker image ls }
function dir { param($image) docker image rm $image }
function dira { docker image rm $(docker image ls -q) }
function dip { docker image prune }
# container
function dcl { docker container ls }
function dcr { param($container) docker container rm $container }
function dcra { docker container rm $(docker container ls -q) }
function dcp { docker container prune }
function dcsc { param($container) docker container stop $container }
function dcsa { docker container stop $(docker container ls -q) }
function dcrdp { param($port, $image) docker container run --rm --detach --publish $port $image }
function dcrit { param($image) docker container run --rm --interactive --tty $image /bin/sh }
function dcrnd { param($name, $image) docker container run --rm --name $name --detach $image }
function dcrndv { param($name, $source, $target, $image) docker container run --rm --name $name --detach --volume "$source`:$target" $image }
function dcec { param($name, $command) docker container exec $name sh -c $command}
function dceit { param($name) docker container exec --interactive --tty $name /bin/sh }
# volume
function dvl { docker volume ls }
function dvp { docker volume prune }
# compose
function dcw { docker compose watch }
function dcs { docker compose stop }
# databases
# postgres
function drpg { docker run --rm --name pg-docker -e POSTGRES_PASSWORD=docker -d -p 5432:5432 -v $HOME/docker/volumes/postgres:/var/lib/postgresql/data postgres }
# mssql
function drms { docker run --rm --name mssql-server -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=1q2w3e4r@#$" -d -p 1433:1433 -v $HOME/docker/volumes/mssql:/var/opt/mssql/data mcr.microsoft.com/mssql/server }