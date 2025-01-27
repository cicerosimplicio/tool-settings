# fetch ----------------------------------------------------------------------------------------------------------------
# Fetches updates from a remote branch.
function GitFetchOrigin {
    # Gets the local branch.
    $branch = git branch --format="%(refname:short)" | fzf --exact --border-label "Fetch branch"

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
# Pushes changes to the remote branch.
function GitPush {
    git push
}

# Delete a remote branch.
function GitPushOriginDelete {
    # Gets the remote branch.
    $branch = git branch --remotes --format="%(refname:short)" | fzf --exact --border-label "Delete branch"

    if (-not $branch) {
        Write-Host "Branch not selected." -ForegroundColor Red
        return
    }

    git push origin --delete $branch
}

# Force pushes changes to the remote branch.
function GitPushForce {
    git push --force-with-lease
}

# Pushes a local branch to the remote repository.
function GitPushOriginSetUpstream {
    # Gets the local branch.
    $branch = git branch --format="%(refname:short)" | fzf --exact --border-label "Push branch"

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
    # Gets the file.
    $file = git diff --name-only | fzf --exact --border-label "Diff file"
    
    if (-not $file) {
        Write-Host "File not selected." -ForegroundColor Red
        return
    }

    git diff $file
}

# Displays commit differences.
function GitDiffHash {
    # Gets the hash.
    $hash = Invoke-PsFzfGitHashes
    
    if (-not $hash) {
        Write-Host "Hash not selected." -ForegroundColor Red
        return
    }

    git diff $hash
}

# Displays differences between two files in different branches.
function GitDiffBranchFile {
    # Gets the first branch.
    $branch1 = git branch --all --format="%(refname:short)" | fzf --exact --border-label "First branch"

    if (-not $branch1) {
        Write-Host "The first branch was not selected." -ForegroundColor Red
        return
    }

    # Gets the second branch.
    $branch2 = git branch --all --format="%(refname:short)" | fzf --exact --border-label "Second branch"

    if (-not $branch2) {
        Write-Host "The second branch was not selected." -ForegroundColor Red
        return
    }

    # Gets the file to be compared.
    $file = git ls-tree -r --name-only $branch1 | fzf --exact --border-label "Diff file"

    if (-not $file) {
        Write-Host "File not selected." -ForegroundColor Red
        return
    }

    git diff "$branch1`:$file" "$branch2`:$file"
}

# Displays differences between two branches.
function GitDiffBranches {
    # Gets the first branch.
    $branch1 = git branch --all --list --format="%(refname:short)" | fzf --exact --border-label "First branch"

    if (-not $branch1) {
        Write-Host "The first branch was not selected." -ForegroundColor Red
        return
    }

    # Gets the second branch.
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
    # Gets the branch.
    $branch = Invoke-PsFzfGitBranches

    if (-not $branch) {
        Write-Host "Branch not selected." -ForegroundColor Red
        return
    }

    git show $branch
}

# Displays status and filenames from a branch's latest commit.
function GitShowBranchNameStatus {
    # Gets the branch.
    $branch = Invoke-PsFzfGitBranches

    if (-not $branch) {
        Write-Host "Branch not selected." -ForegroundColor Red
        return
    }

    git show --name-status $branch
}

# Displays filenames from a branch's lastest commit.
function GitShowBranchNameOnly {
    # Gets the branch.
    $branch = Invoke-PsFzfGitBranches

    if (-not $branch) {
        Write-Host "Branch not selected." -ForegroundColor Red
        return
    }

    git show --name-only $branch
}

# Displays changes from a stash file.
function GitShowStashFile {
    # Gets the stash.
    $stash = Invoke-PsFzfGitStashes

    if (-not $stash) {
        Write-Host "Stash not selected." -ForegroundColor Red
        return
    }

    # Gets the name of changed files from the stash.
    $files = git show --name-only --oneline $stash | Select-Object -Skip 2

    # Gets the file.
    $selectedFile = $files | fzf --exact --border-label "Show file"

    if (-not $selectedFile) {
        Write-Host "File not selected." -ForegroundColor Red
        return
    }

    git show $stash $selectedFile
}

# Displays the entire file content from a stash.
function GitShowStashFileContent {
    # Gets the stash.
    $stash = Invoke-PsFzfGitStashes

    if (-not $stash) {
        Write-Host "Stash not selected." -ForegroundColor Red
        return
    }

    # Gets the name of changed files from the stash.
    $files = git show --name-only --oneline $stash | Select-Object -Skip 2

    # Gets the file.
    $selectedFile = $files | fzf --exact --border-label "Show file content"

    if (-not $selectedFile) {
        Write-Host "File not selected." -ForegroundColor Red
        return
    }

    git show "$stash`:$selectedFile"
}

# Displays changes from a branch file.
function GitShowBranchFile {
    # Gets the branch.
    $branch = Invoke-PsFzfGitBranches

    if (-not $branch) {
        Write-Host "Branch not selected." -ForegroundColor Red
        return
    }

    # Gets the name of changed files from the branch.
    $files = git show --name-only --oneline $branch | Select-Object -Skip 1

    # Gets the file.
    $selectedFile = $files | fzf --exact --border-label "Show file"
    
    if (-not $selectedFile) {
        Write-Host "File not selected." -ForegroundColor Red
        return
    }

    git show $branch $selectedFile
}

# Displays the entire file content from a branch.
function GitShowBranchFileContent {
    # Gets the branch.
    $branch = Invoke-PsFzfGitBranches

    if (-not $branch) {
        Write-Host "Branch not selected." -ForegroundColor Red
        return
    }

    # Gets all filenames from the branch.
    $files = git ls-tree -r --name-only $branch

    # Gets the file.
    $selectedFile = $files | fzf --exact --border-label "Show file content"

    if (-not $selectedFile) {
        Write-Host "File not selected." -ForegroundColor Red
        return
    }

    git show "$branch`:$selectedFile"
}
# switch ---------------------------------------------------------------------------------------------------------------
# Creates a local branch.
function GitSwitchCreate {
    param($branchName)

    if (-not $branchName) {
        Write-Host "Branch not selected." -ForegroundColor Red
        return
    }

    git switch --create "$branchName"
}

# Switches to a local branch.
function GitSwitch {
    # Gets the local branch.
    $branch = Invoke-PsFzfGitBranches

    if (-not $branch) {
        Write-Host "Branch not selected." -ForegroundColor Red
        return
    }

    git switch $branch
}

# Creates and tracks a local branch.
function GitSwitchTrack {
    # Gets the remote branch.
    $branch = Invoke-PsFzfGitBranches

    if (-not $branch) {
        Write-Host "Branch not selected." -ForegroundColor Red
        return
    }

    git switch --track $branch
}
# branch ---------------------------------------------------------------------------------------------------------------
# Displays all branches from a remote repository.
function GitBranches {
    Invoke-PsFzfGitBranches
}

# Displays all remote branches.
function GitBranchRemotes {
    git branch --remotes --format="%(refname:short)" | fzf --exact --border-label "Remote branches"
}

# Displays all local branches.
function GitBranchAll {
    git branch --all --format="%(refname:short)" | fzf --exact --border-label "All branches"
}

# Changes the name of a local branch.
function GitBranchMove {
    param (
        $newName
    )

    # Gets the local branch.
    $branch = git branch --format="%(refname:short)" | fzf --exact --border-label "Move branch"

    if (-not $branch) {
        Write-Host "Branch not selected." -ForegroundColor Red
        return
    }

    git branch --move --force $branch $newName
}

# Remove a local branch.
function GitBranchDelete {
    # Gets the local branch.
    $branch = git branch --format="%(refname:short)" | fzf --exact --border-label "Delete branch"

    if (-not $branch) {
        Write-Host "Branch not selected." -ForegroundColor Red
        return
    }

    git branch --delete --force $branch
}

# Returns the local branches that contain a hash.
function GitBranchContains {
    # Gets the hash.
    $hash = Invoke-PsFzfGitHashes

    if (-not $hash) {
        Write-Host "Hash not selected." -ForegroundColor Red
        return
    }

    git branch --contains $hash
}

# Returns the remote branches that contain a hash.
function GitBranchContainsRemotes {
    # Gets the hash.
    $hash = Invoke-PsFzfGitHashes

    if (-not $hash) {
        Write-Host "Hash not selected." -ForegroundColor Red
        return
    }

    git branch --contains --remotes
}

# Returns all branches that contain a hash.
function GitBranchContainsAll {
    # Gets the hash.
    $hash = Invoke-PsFzfGitHashes

    if (-not $hash) {
        Write-Host "Hash not selected." -ForegroundColor Red
        return
    }

    git branch --contains --all
}

# Associates the local branch with a remote branch.
function GitBranchSetUpstream {
    # Gets the remote branch.
    $branch = git branch --remotes --format="%(refname:short)" | fzf --exact --border-label "Set-upstream branch"

    if (-not $branch) {
        Write-Host "Branch not selected." -ForegroundColor Red
        return
    }

    git branch --set-upstream $branch
}

# Dissociates the local branch from the remote branch.
function GitBranchUnsetUpsteam {
    git branch --unset-upstream
}

# Checks the tracking.
function GitBranchVerbose {
    git branch -vv
}

# rebase ---------------------------------------------------------------------------------------------------------------
# Updates the local branch based on a remote branch.
function GitRebase {
    # Gets the remote branch.
    $branch = git branch --remotes --format="%(refname:short)" | fzf --exact --border-label "Rebase branch"

    if (-not $branch) {
        Write-Host "Branch not selected." -ForegroundColor Red
        return
    }

    git rebase $branch
}

function GitRebaseInteractive {
    # Gets the hash.
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