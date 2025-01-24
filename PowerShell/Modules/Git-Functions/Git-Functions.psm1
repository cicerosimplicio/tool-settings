# fetch ----------------------------------------------------------------------------------------------------------------
# Fetches updates from a remote branch.
function GitFetchOrigin {
    # Get the branch.
    $branch = git branch --format="%(refname:short)" | fzf --exact --border-label "Branch to fetch"

    if (-not $branch) {
        Write-Host "Fetch from all remote branches." -ForegroundColor Blue

        # If no branch is selected, fetch from all remote branches.
        git fetch origin
    }

    git fetch origin $branch
}

# status ---------------------------------------------------------------------------------------------------------------
function GitStatus {
    git status
}

# Displays only the status and filenames.
function GitStatusShort {
    git status --short
}

# pull -----------------------------------------------------------------------------------------------------------------
function GitPull {
    git pull
}

# push -----------------------------------------------------------------------------------------------------------------
# Pushes changes to the remote.
function GitPush {
    git push
}

# Delete a remote branch.
function GitPushOriginDelete {
    # Get the branch.
    $branch = git branch --remotes --format="%(refname:short)" | fzf --exact --border-label "Branch to delete"

    if (-not $branch) {
        Write-Host "Branch not selected." -ForegroundColor Red
        return
    }

    git push origin --delete $branch
}

# Force pushes changes to the remote.
function GitPushForce {
    git push --force-with-lease
}

# Pushes a local branch to the remote.
function GitPushOriginSetUpstream {
    # Get the branch.
    $branch = git branch --format="%(refname:short)" | fzf --exact --border-label "Branch to push"

    if (-not $branch) {
        Write-Host "Branch not selected." -ForegroundColor Red
        return
    }

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
# Displays the current differences.
function GitDiff {
    git diff
}

# Displays file differences.
function GitDiffFile {
    # Get the file.
    $file = git diff --name-only | fzf --exact --border-label "File to display differences"
    
    if (-not $file) {
        Write-Host "File not selected." -ForegroundColor Red
        return
    }

    git diff $file
}

# Displays commit differences.
function GitDiffHash {
    # Get the hash.
    $hash = Invoke-PsFzfGitHashes
    
    if (-not $hash) {
        Write-Host "Hash not selected." -ForegroundColor Red
        return
    }

    git diff $hash
}

# Displays differences between two files in different branches.
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

    git diff "$branch1`:$file" "$branch2`:$file"
}

# Displays differences between two branches.
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

    git diff $branch1 $branch2
}

# show -----------------------------------------------------------------------------------------------------------------
function GitShow {
    git show
}

# Displays status and filenames from the latest commit on the current branch.
function GitShowNameStatus {
    git show --name-status
}

# Displays filenames from the latest commit on the current branch.
function GitShowNameOnly {
    git show --name-only
}

# Displays changes from a branch's latest commit.
function GitShowBranch {
    # Get the branch.
    $branch = $(Invoke-PsFzfGitBranches)

    if (-not $branch) {
        Write-Host "Branch not selected." -ForegroundColor Red
        return
    }

    git show $branch
}

# Displays status and filenames from a branch's latest commit.
function GitShowBranchNameStatus {
    # Get the branch.
    $branch = $(Invoke-PsFzfGitBranches)

    if (-not $branch) {
        Write-Host "Branch not selected." -ForegroundColor Red
        return
    }

    git show --name-status $branch
}

# Displays filenames from a branch's lastest commit.
function GitShowBranchNameOnly {
    # Get the branch.
    $branch = $(Invoke-PsFzfGitBranches)

    if (-not $branch) {
        Write-Host "Branch not selected." -ForegroundColor Red
        return
    }

    git show --name-only $branch
}

# Displays changes from a stash file.
function GitShowStashFile {
    # Get the stash.
    $stash = $(Invoke-PsFzfGitStashes)

    if (-not $stash) {
        Write-Host "Stash not selected." -ForegroundColor Red
        return
    }

    # Get the name of changed files from the stash.
    $files = git show --name-only --oneline $stash | Select-Object -Skip 2

    # Get the file.
    $selectedFile = $files | fzf -e

    if (-not $selectedFile) {
        Write-Host "File not selected." -ForegroundColor Red
        return
    }

    git show $stash $selectedFile
}

# Displays the entire file content from a stash.
function GitShowStashFileContent {
    # Get the stash.
    $stash = $(Invoke-PsFzfGitStashes)

    if (-not $stash) {
        Write-Host "Stash not selected." -ForegroundColor Red
        return
    }

    # Get the name of changed files from the stash.
    $files = git show --name-only --oneline $stash | Select-Object -Skip 2

    # Get the file.
    $selectedFile = $files | fzf -e

    if (-not $selectedFile) {
        Write-Host "File not selected." -ForegroundColor Red
        return
    }

    git show "$stash`:$selectedFile"
}

# Displays changes from a branch file.
function GitShowBranchFile {
    # Get the branch.
    $branch = $(Invoke-PsFzfGitBranches)

    if (-not $branch) {
        Write-Host "Branch not selected." -ForegroundColor Red
        return
    }

    # Get the name of changed files from the branch.
    $files = git show --name-only --oneline $branch | Select-Object -Skip 1

    # Get the file.
    $selectedFile = $files | fzf -e
    
    if (-not $selectedFile) {
        Write-Host "File not selected." -ForegroundColor Red
        return
    }

    git show $branch $selectedFile
}

# Displays the entire file content from a branch.
function GitShowBranchFileContent {
    # Get the branch.
    $branch = $(Invoke-PsFzfGitBranches)

    if (-not $branch) {
        Write-Host "Branch not selected." -ForegroundColor Red
        return
    }

    # Get all filenames from the branch.
    $files = git ls-tree -r --name-only $branch

    # Get the file.
    $selectedFile = $files | fzf -e

    if (-not $selectedFile) {
        Write-Host "File not selected." -ForegroundColor Red
        return
    }

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

    # Get the branch. local.
    $branch = git branch --format="%(refname:short)" | fzf --header "Local branches"

    if (-not $branch) {
        Write-Host "Branch not selected." -ForegroundColor Red
        return
    }

    # Altera o nome da branch.
    git branch --move --force $branch $novoNome
}

function GitBranchDelete {
    # Get the branch. local.
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