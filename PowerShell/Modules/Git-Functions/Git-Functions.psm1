# fetch ----------------------------------------------------------------------------------------------------------------
function GitFetchOrigin {
    # Obtém a branch.
    $branch = $(Invoke-PsFzfGitBranches)

    if (-not $branch) {
        Write-Host "Fetch em toda a origem." -ForegroundColor Blue
        # Se nenhuma branch for selecionada, faz um fetch de tudo.
        git fetch origin
    }

    git fetch origin $branch
}

# status ---------------------------------------------------------------------------------------------------------------
function GitStatus {
    git status
}

function GitStatusShort {
    # Exibe apenas os status e nome dos arquivos.
    git status --short
}

# pull -----------------------------------------------------------------------------------------------------------------
function GitPull {
    git pull
}

# push -----------------------------------------------------------------------------------------------------------------
function GitPush {
    git push
}

function GitPushOriginDelete {
    # Obtém a branch.
    $branch = $(git branch --remotes | fzf --exact --prompt "Selecione a branch: ")

    if (-not $branch) {
        Write-Host "Branch não selecionada." -ForegroundColor Red
        return
    }

    # Remove a branch do remoto.
    git push origin --delete $branch
}

function GitPushForce {
    git push --force-with-lease
}

function GitPushOriginSetUpstream {
    # Obtém a branch.
    $branch = $(Invoke-PsFzfGitBranches)

    if (-not $branch) {
        Write-Host "Branch não selecionada." -ForegroundColor Red
        return
    }

    # Envia a branch local para o remoto.
    git push --set-upstream origin $branch
}

# log ------------------------------------------------------------------------------------------------------------------

function GitLogOneline {
    git log --oneline
}

function GitLogOnelineDecorateAll {
    git log --oneline --decorate --all
}

function GitLogOnelineGraphDecoreteAll {
    git log --oneline --graph --decorate --all
}

# diff -----------------------------------------------------------------------------------------------------------------

function GitDiff {
    # Exibe as diferenças das alterações atual.
    git diff
}

function GitDiffFile {
    # Obtém o arquivo.
    $file = $(Invoke-PsFzfGitFiles)
    
    if (-not $file) {
        Write-Host "Arquivo não selecionada." -ForegroundColor Red
        return
    }

    # Exibe as diferenças do arquivo.
    git diff $file
}

function GitDiffHash {
    # Obtém o hash.
    $hash = $(Invoke-PsFzfGitHashes)
    
    if (-not $hash) {
        Write-Host "Hash não selecionado." -ForegroundColor Red
        return
    }

    # Exibe as diferenças de um commit
    git diff $hash
}

function GitDiffBranchFile {
    # Obtenha a primeira branch.
    $branch1 = git branch --all --list --format="%(refname:short)" | fzf -e --prompt "Selecione a primeira branch: "

    if (-not $branch1) {
        Write-Host "Branch 1 não selecionada." -ForegroundColor Red
        return
    }

    # Obtenha a segunda branch
    $branch2 = git branch --all --list --format="%(refname:short)" | fzf -e --prompt "Selecione a segunda branch: "

    if (-not $branch2) {
        Write-Host "Branch 2 não selecionada." -ForegroundColor Red
        return
    }

    # Obtenha o arquivo a ser comparado
    $file = git ls-tree -r --name-only $branch1 | fzf -e --prompt "Selecione o arquivo: "

    if (-not $file) {
        Write-Host "Nenhum arquivo selecionado." -ForegroundColor Red
        return
    }

    # Exibir a diferença entre os dois arquivos
    git diff "$branch1`:$file" "$branch2`:$file"
}

function GitDiffBranches {
    # Obtenha a primeira branch.
    $branch1 = git branch --all --list --format="%(refname:short)" | fzf -e --prompt "Selecione a primeira branch: "

    if (-not $branch1) {
        Write-Host "Branch 1 não selecionada." -ForegroundColor Red
        return
    }

    # Obtenha a segunda branch
    $branch2 = git branch --all --list --format="%(refname:short)" | fzf -e --prompt "Selecione a segunda branch: "

    if (-not $branch2) {
        Write-Host "Branch 2 não selecionada." -ForegroundColor Red
        return
    }

    # Exibir a diferença entre as branches.
    git diff $branch1 $branch2
}

# show -----------------------------------------------------------------------------------------------------------------
function GitShow {
    git show
}

function GitShowNameStatus {
    # Exibe o status e nome dos arquivos do último commit da branch atual.
    git show --name-status
}

function GitShowNameOnly {
    # Exibe o nome dos arquivos do último commit da branch atual.
    git show --name-only
}

function GitShowBranch {
    # Obtém a branch.
    $branch = $(Invoke-PsFzfGitBranches)

    if (-not $branch) {
        Write-Host "Branch não selecionada." -ForegroundColor Red
        return
    }

    # Exibe as alterações do último commit da branch.
    git show $branch
}

function GitShowBranchNameStatus {
    # Obtém a branch.
    $branch = $(Invoke-PsFzfGitBranches)

    if (-not $branch) {
        Write-Host "Branch não selecionada." -ForegroundColor Red
        return
    }

    # Exibe o status e nome dos arquivos do último commit da branch.
    git show --name-status $branch
}

function GitShowBranchNameOnly {
    # Obtém a branch.
    $branch = $(Invoke-PsFzfGitBranches)

    if (-not $branch) {
        Write-Host "Branch não selecionada." -ForegroundColor Red
        return
    }

    # Exibe o nome dos arquivos do último commit da branch.
    git show --name-only $branch
}

function GitShowStashFile {
    # Obtém o stash.
    $stash = $(Invoke-PsFzfGitStashes)

    if (-not $stash) {
        Write-Host "Stash não selecionado." -ForegroundColor Red
        return
    }

    # Obtém os arquivos do stash.
    $files = git show --name-only --oneline $stash | Select-Object -Skip 2

    # Obtém o arquivo.
    $selectedFile = $files | fzf -e

    if (-not $selectedFile) {
        Write-Host "Arquivo não selecionado." -ForegroundColor Red
        return
    }

    # Exibe as alterações do arquivo no stash.
    git show $stash $selectedFile
}

function GitShowStashFileContent {
    # Obtém o stash.
    $stash = $(Invoke-PsFzfGitStashes)

    if (-not $stash) {
        Write-Host "Stash não selecionado." -ForegroundColor Red
        return
    }

    # Obtém os arquivos do stash.
    $files = git show --name-only --oneline $stash | Select-Object -Skip 2

    # Obtém o arquivo.
    $selectedFile = $files | fzf -e

    if (-not $selectedFile) {
        Write-Host "Arquivo não selecionado." -ForegroundColor Red
        return
    }

    # Exibe todo o conteúdo do arquivo do stash.
    git show "$stash`:$selectedFile"
}

function GitShowBranchFile {
    # Obtém a branch
    $branch = $(Invoke-PsFzfGitBranches)

    if (-not $branch) {
        Write-Host "Branch não selecionada." -ForegroundColor Red
        return
    }

    # Obtém os arquivos da branch.
    $files = git show --name-only --oneline $branch | Select-Object -Skip 1

    # Obtém o arquivo.
    $selectedFile = $files | fzf -e
    
    if (-not $selectedFile) {
        Write-Host "Arquivo não selecionado." -ForegroundColor Red
        return
    }

    # Exibe as alterações do arquivo da branch.
    git show $branch $selectedFile
}

function GitShowBranchFileContent {
    # Obtém a branch.
    $branch = $(Invoke-PsFzfGitBranches)

    if (-not $branch) {
        Write-Host "Branch não selecionada." -ForegroundColor Red
        return
    }

    # Obtém os arquivos.
    $files = git ls-tree -r --name-only $branch

    # Obtém o arquivo.
    $selectedFile = $files | fzf -e

    if (-not $selectedFile) {
        Write-Host "Arquivo não selecionado." -ForegroundColor Red
        return
    }

    # Exibe o conteúdo do arquivo da branch.
    git show "$branch`:$selectedFile"
}
# switch ---------------------------------------------------------------------------------------------------------------
function GitSwitchCreate {
    param($branchName)

    if (-not $branchName) {
        Write-Host "Branch não informada." -ForegroundColor Red
        return
    }

    # Cria uma branch local.
    git switch --create "$branchName"
}

function GitSwitch {
    # Obtém a branch.
    $branch = $(Invoke-PsFzfGitBranches)

    if (-not $branch) {
        Write-Host "Branch não selecionada." -ForegroundColor Red
        return
    }

    # Alterna para a branch.
    git switch $branch
}

function GitSwitchTrack {
    # Obtém a branch.
    $branch = $(Invoke-PsFzfGitBranches)

    if (-not $branch) {
        Write-Host "Branch não selecionada." -ForegroundColor Red
        return
    }

    # Cria ou alterna para uma branch remota.
    git switch --track $(Invoke-PsFzfGitBranches)
}
# branch ---------------------------------------------------------------------------------------------------------------
function GitBranches {
    Invoke-PsFzfGitBranches
}

function GitBranchRemotes {
    git branch --remotes --format="%(refname:short)"
}

function GitBranchAll {
    git branch --all --format="%(refname:short)"
}

function GitBranchMove {
    param($inputString) git branch --move --force $(Invoke-PsFzfGitBranches) "$inputString"
}

function GitBranchDelete {
    git branch --delete --force $(Invoke-PsFzfGitBranches)
}

function GitBranchContains {
    git branch --contains
}

function GitBranchContainsRemotes {
    git branch --contains --remotes
}

function GitBranchContainsAll {
    git branch --contains --all
}

function GitBranchSetUpstream {
    git branch --set-upstream $(git branch --remotes --format="%(refname:short)" | fzf -e)
}

function GitBranchUnsetUpsteam {
    git branch --unset-upstream
}

function GitBranchVerbose {
    git branch -vv
}

# rebase ---------------------------------------------------------------------------------------------------------------
function GitRebase {
    git rebase $(Invoke-PsFzfGitBranches)
}

function GitRebaseInteractive {
    git rebase --interactive $(Invoke-PsFzfGitHashes)
}

# commit ---------------------------------------------------------------------------------------------------------------
function GitHashes {
    Invoke-PsFzfGitHashes
}

function GitCommitMessage {
    param($inputString) git commit --message "$inputString"
}

function GitCommitAmend {
    git commit --amend
}

function GitCommitAmendNoEdit {
    git commit --amend --no-edit
}

# remote ---------------------------------------------------------------------------------------------------------------
function GitRemoteAddOrigin {
    param($inputString) git remote add origin "$inputString"
}

# stash ----------------------------------------------------------------------------------------------------------------
function GitStashSave {
    param($inputString) git stash save "$inputString"
}

function GitStashList {
    Invoke-PsFzfGitStashes
}

function GitStashShow {
    git stash show $(Invoke-PsFzfGitStashes)
}

function GitStashShowNameOnly {
    git stash show --name-only $(Invoke-PsFzfGitStashes)
}

function GitStashShowNameStatus {
    git stash show --name-status $(Invoke-PsFzfGitStashes)
}

function GitStashApply {
    git stash apply $(Invoke-PsFzfGitStashes)
}

function GitStashPop {
    git stash pop $(Invoke-PsFzfGitStashes)
}

# cherry-pick ----------------------------------------------------------------------------------------------------------
function GitCherryPick {
    git cherry-pick $(Invoke-PsFzfGitHashes)
}

# restore --------------------------------------------------------------------------------------------------------------
function GitRestore {
    git restore $(Invoke-PsFzfGitFiles)
}

# reset ----------------------------------------------------------------------------------------------------------------
function GitResetHard {
    git reset --hard $(Invoke-PsFzfGitHashes)
}

function GitResetSoft {
    git reset --soft $(Invoke-PsFzfGitHashes)
}

function GitResetMixed {
    git reset --mixed $(Invoke-PsFzfGitHashes)
}

# file -----------------------------------------------------------------------------------------------------------------
function GitFiles {
    Invoke-PsFzfGitFiles
}

# add ------------------------------------------------------------------------------------------------------------------
function GitAdd {
    git add $(Invoke-PsFzfGitFiles)
}