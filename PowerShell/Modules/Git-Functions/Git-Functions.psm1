# fetch ----------------------------------------------------------------------------------------------------------------
function GitFetchOrigin {
    # Get the branch.
    $branch = git branch --format="%(refname:short)" | fzf --exact --border-label "Fetch branch"

    if (-not $branch) {
        Write-Host "Fetch all remotes." -ForegroundColor Blue

        # If no branch is selected, fetch from the remote.
        git fetch origin
    }

    git fetch origin $branch
}

# status ---------------------------------------------------------------------------------------------------------------
function GitStatus {
    git status
}

function GitStatusShort {
    # Displays only the status and filenames.
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
    # Get the branch.
    $branch = git branch --remotes --format="%(refname:short)" | fzf --exact --border-label "Delete remote branch"

    if (-not $branch) {
        Write-Host "Branch not selected." -ForegroundColor Red
        return
    }

    # Remove a remote branch.
    git push origin --delete $branch
}

function GitPushForce {
    git push --force-with-lease
}

function GitPushOriginSetUpstream {
    # Get the branch.
    $branch = git branch --format="%(refname:short)" | fzf --exact --border-label "Push branch to remote"

    if (-not $branch) {
        Write-Host "Branch not selected." -ForegroundColor Red
        return
    }

    # Pushes a local branch to the remote.
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
    # Displays the differences of the current changes.
    git diff
}

function GitDiffFile {
    # Get the file..
    $file = git diff --name-only | fzf --exact --border-label "Diff file"
    
    if (-not $file) {
        Write-Host "File not selected." -ForegroundColor Red
        return
    }

    # Displays file differences.
    git diff $file
}

function GitDiffHash {
    # Get the hash.
    $hash = Invoke-PsFzfGitHashes
    
    if (-not $hash) {
        Write-Host "Hash not selected." -ForegroundColor Red
        return
    }

    # Displays commit differences.
    git diff $hash
}

function GitDiffBranchFile {
    # Get the first branch.
    $branch1 = git branch --all --format="%(refname:short)" | fzf --exact --border-label "First branch"

    if (-not $branch1) {
        Write-Host "The first branch was not selected." -ForegroundColor Red
        return
    }

    # Get the second branch.
    $branch2 = git branch --all --format="%(refname:short)" | fzf --exact --border-label "Second branch"

    if (-not $branch2) {
        Write-Host "The second branch was not selected." -ForegroundColor Red
        return
    }

    # Gets the file to be compared.
    $file = git ls-tree -r --name-only $branch1 | fzf --exact --border-label "File for comparison"

    if (-not $file) {
        Write-Host "File not selected." -ForegroundColor Red
        return
    }

    # Displays the differences between two files.
    git diff "$branch1`:$file" "$branch2`:$file"
}

function GitDiffBranches {
    # Get the first branch.
    $branch1 = git branch --all --list --format="%(refname:short)" | fzf --exact --border-label "First branch"

    if (-not $branch1) {
        Write-Host "The first branch was not selected." -ForegroundColor Red
        return
    }

    # Get the second branch.
    $branch2 = git branch --all --list --format="%(refname:short)" | fzf --exact --border-label "Second branch"

    if (-not $branch2) {
        Write-Host "The second branch was not selected." -ForegroundColor Red
        return
    }

    # Displays the differences between two branches.
    git diff $branch1 $branch2
}

# show -----------------------------------------------------------------------------------------------------------------
function GitShow {
    git show
}

function GitShowNameStatus {
    # Displays the status and filenames from the latest commit on the current branch.
    git show --name-status
}

function GitShowNameOnly {
    # Displays the filenames from the latest commit on the current branch.
    git show --name-only
}

function GitShowBranch {
    # Get the branch.
    $branch = $(Invoke-PsFzfGitBranches)

    if (-not $branch) {
        Write-Host "Branch not selected." -ForegroundColor Red
        return
    }

    # Displays the changes from the latest commit in a branch.
    git show $branch
}

function GitShowBranchNameStatus {
    # Get the branch.
    $branch = $(Invoke-PsFzfGitBranches)

    if (-not $branch) {
        Write-Host "Branch not selected." -ForegroundColor Red
        return
    }

    # Exibe o status e nome dos arquivos do último commit da branch.
    git show --name-status $branch
}

function GitShowBranchNameOnly {
    # Get the branch.
    $branch = $(Invoke-PsFzfGitBranches)

    if (-not $branch) {
        Write-Host "Branch not selected." -ForegroundColor Red
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

    # Get the file..
    $selectedFile = $files | fzf -e

    if (-not $selectedFile) {
        Write-Host "File not selected." -ForegroundColor Red
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

    # Get the file..
    $selectedFile = $files | fzf -e

    if (-not $selectedFile) {
        Write-Host "File not selected." -ForegroundColor Red
        return
    }

    # Exibe todo o conteúdo do arquivo do stash.
    git show "$stash`:$selectedFile"
}

function GitShowBranchFile {
    # Obtém a branch
    $branch = $(Invoke-PsFzfGitBranches)

    if (-not $branch) {
        Write-Host "Branch not selected." -ForegroundColor Red
        return
    }

    # Obtém os arquivos da branch.
    $files = git show --name-only --oneline $branch | Select-Object -Skip 1

    # Get the file..
    $selectedFile = $files | fzf -e
    
    if (-not $selectedFile) {
        Write-Host "File not selected." -ForegroundColor Red
        return
    }

    # Exibe as alterações do arquivo da branch.
    git show $branch $selectedFile
}

function GitShowBranchFileContent {
    # Get the branch.
    $branch = $(Invoke-PsFzfGitBranches)

    if (-not $branch) {
        Write-Host "Branch not selected." -ForegroundColor Red
        return
    }

    # Obtém os arquivos.
    $files = git ls-tree -r --name-only $branch

    # Get the file..
    $selectedFile = $files | fzf -e

    if (-not $selectedFile) {
        Write-Host "File not selected." -ForegroundColor Red
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
    # Get the branch.
    $branch = $(Invoke-PsFzfGitBranches)

    if (-not $branch) {
        Write-Host "Branch not selected." -ForegroundColor Red
        return
    }

    # Alterna para a branch.
    git switch $branch
}

function GitSwitchTrack {
    # Get the branch.
    $branch = $(Invoke-PsFzfGitBranches)

    if (-not $branch) {
        Write-Host "Branch not selected." -ForegroundColor Red
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
        Write-Host "Branch not selected." -ForegroundColor Red
        return
    }

    # Altera o nome da branch.
    git branch --move --force $branch $novoNome
}

function GitBranchDelete {
    # Obtém a branch local.
    $branch = git branch --format="%(refname:short)" | fzf --header "Local branches"

    if (-not $branch) {
        Write-Host "Branch not selected." -ForegroundColor Red
        return
    }
    # Remove uma branch local.

    git branch --delete --force $branch
}

function GitBranchContains {
    # Get the hash.
    $hash = Invoke-PsFzfGitHashes

    if (-not $hash) {
        Write-Host "Hash not selected." -ForegroundColor Red
        return
    }

    # Retorna as branches local que contém o hash.
    git branch --contains $hash
}

function GitBranchContainsRemotes {
    # Get the hash.
    $hash = Invoke-PsFzfGitHashes

    if (-not $hash) {
        Write-Host "Hash not selected." -ForegroundColor Red
        return
    }

    # Retorna as branches remotas que contém o hash.
    git branch --contains --remotes
}

function GitBranchContainsAll {
    # Get the hash.
    $hash = Invoke-PsFzfGitHashes

    if (-not $hash) {
        Write-Host "Hash not selected." -ForegroundColor Red
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
    # Get the branch.
    $branch = Invoke-PsFzfGitBranches

    if (-not $branch) {
        Write-Host "Branch not selected." -ForegroundColor Red
        return
    }

    # Atualiza a branch local sem perder os commits atuais.
    git rebase $branch
}

function GitRebaseInteractive {
    # Get the hash.
    $hash = Invoke-PsFzfGitHashes

    if (-not $hash) {
        Write-Host "Hash not selected." -ForegroundColor Red
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