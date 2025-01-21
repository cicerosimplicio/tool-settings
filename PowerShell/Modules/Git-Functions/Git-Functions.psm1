# fetch ----------------------------------------------------------------------------------------------------------------
function GitFetchOrigin {
    # Obtém a branch.
    $branch = git branch --remotes --format="%(refname:short)" | fzf --exact --border-label "Fetch branch"

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
    $branch = git branch --remotes --format="%(refname:short)" | fzf --exact --border-label "Delete remote branch"

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
    $branch = git branch --format="%(refname:short)" | fzf --exact --border-label "Push branch to remote"

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
    $file = git diff --name-only | fzf --exact --border-label "Diff file"
    
    if (-not $file) {
        Write-Host "Arquivo não selecionado." -ForegroundColor Red
        return
    }

    # Exibe as diferenças do arquivo.
    git diff $file
}

function GitDiffHash {
    # Obtém o hash.
    $hash = Invoke-PsFzfGitHashes
    
    if (-not $hash) {
        Write-Host "Hash não selecionado." -ForegroundColor Red
        return
    }

    # Exibe as diferenças de um commit
    git diff $hash
}

function GitDiffBranchFile {
    # Obtém a primeira branch.
    $branch1 = git branch --all --list --format="%(refname:short)" | fzf --exact --border-label "Branch 1"

    if (-not $branch1) {
        Write-Host "Branch 1 não selecionada." -ForegroundColor Red
        return
    }

    # Obtém a segunda branch.
    $branch2 = git branch --all --list --format="%(refname:short)" | fzf --exact --border-label "Branch 2"

    if (-not $branch2) {
        Write-Host "Branch 2 não selecionada." -ForegroundColor Red
        return
    }

    # Obtém o arquivo a ser comparado.
    $file = git ls-tree -r --name-only $branch1 | fzf --exact --border-label "Arquivo para comparação"

    if (-not $file) {
        Write-Host "Arquivo não selecionado." -ForegroundColor Red
        return
    }

    # Exibe a diferença entre os dois arquivos.
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
    # Exibe as branches remotas.
    git branch --remotes --format="%(refname:short)" | fzf --header "Remote branches"
}

function GitBranchAll {
    # Exibe todas as branchs.
    git branch --all --format="%(refname:short)" | fzf --header "All branches"
}

function GitBranchMove {
    param (
        $novoNome
    )

    # Obtém a branch local.
    $branch = git branch --format="%(refname:short)" | fzf --header "Local branches"

    if (-not $branch) {
        Write-Host "Branch não selecionada." -ForegroundColor Red
        return
    }

    # Altera o nome da branch.
    git branch --move --force $branch $novoNome
}

function GitBranchDelete {
    # Obtém a branch local.
    $branch = git branch --format="%(refname:short)" | fzf --header "Local branches"

    if (-not $branch) {
        Write-Host "Branch não selecionada." -ForegroundColor Red
        return
    }
    # Remove uma branch local.

    git branch --delete --force $branch
}

function GitBranchContains {
    # Obtém o hash.
    $hash = Invoke-PsFzfGitHashes

    if (-not $hash) {
        Write-Host "Hash não selecionado." -ForegroundColor Red
        return
    }

    # Retorna as branches local que contém o hash.
    git branch --contains $hash
}

function GitBranchContainsRemotes {
    # Obtém o hash.
    $hash = Invoke-PsFzfGitHashes

    if (-not $hash) {
        Write-Host "Hash não selecionado." -ForegroundColor Red
        return
    }

    # Retorna as branches remotas que contém o hash.
    git branch --contains --remotes
}

function GitBranchContainsAll {
    # Obtém o hash.
    $hash = Invoke-PsFzfGitHashes

    if (-not $hash) {
        Write-Host "Hash não selecionado." -ForegroundColor Red
        return
    }

    # Retorna todas as branches que contém o hash.
    git branch --contains --all
}

function GitBranchSetUpstream {
    # Associa a branch local a remota.
    git branch --set-upstream $(git branch --remotes --format="%(refname:short)" | fzf -e)
}

function GitBranchUnsetUpsteam {
    # Desassocia a branch local do remoto.
    git branch --unset-upstream
}

function GitBranchVerbose {
    # Verifica o rastreamento.
    git branch -vv
}

# rebase ---------------------------------------------------------------------------------------------------------------
function GitRebase {
    # Obtém a branch.
    $branch = Invoke-PsFzfGitBranches

    if (-not $branch) {
        Write-Host "Branch não selecionada." -ForegroundColor Red
        return
    }

    # Atualiza a branch local sem perder os commits atuais.
    git rebase $branch
}

function GitRebaseInteractive {
    # Obtém o hash.
    $hash = Invoke-PsFzfGitHashes

    if (-not $hash) {
        Write-Host "Hash não selecionado." -ForegroundColor Red
        return
    }

    # Permite editar o histórico a partir do hash.
    git rebase --interactive $hash
}

# commit ---------------------------------------------------------------------------------------------------------------
function GitHashes {
    Invoke-PsFzfGitHashes
}

function GitCommitMessage {
    param (
        $message
    )
    
    # Cria um commit.
    git commit --message "$message"
}

function GitCommitAmend {
    # Edita o último commit, permitindo alterar a mensagem.
    git commit --amend
}

function GitCommitAmendNoEdit {
    # Edita o último commit, mantendo a mensagem anterior.
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