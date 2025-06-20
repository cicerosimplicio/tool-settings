# fetch ----------------------------------------------------------------------------------------------------------------
# Fetches updates from a remote branch.
function GitFetchOrigin {
    # Gets the branch.
    $branch = Invoke-PsFzfGitBranches

    if (-not $branch) {
        Write-Error 'Fetch from all remote branches.' -ForegroundColor Blue

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
    # Gets the branch.
    $branch = Invoke-PsFzfGitBranches

    if (-not $branch) {
        Write-Error 'Branch not selected.'
        return
    }

    git push origin --delete $branch
}

# Force pushes changes to the remote branch.
function GitPushForce {
    git push --force-with-lease
}

# Pushes a local branch to the remote repository.
function GitPushSetUpstreamOrigin {
    # Gets the branch.
    $branch = Invoke-PsFzfGitBranches

    if (-not $branch) {
        Write-Error 'Branch not selected.'
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
# Displays the current unstaged differences.
function GitDiff {
    git diff
}

# Displays the current staged differences.
function GitDiffStaged {
    git diff --staged
}

# Displays unstaged differences in a file.
function GitDiffFile {
    # Gets the file.
    $file = Invoke-PsFzfGitFiles
    
    if (-not $file) {
        Write-Error 'File not selected.'
        return
    }

    git diff $file
}

# Displays staged differences in a file.
function GitDiffStagedFile {
    # Gets the file.
    $file = Invoke-PsFzfGitFiles
    
    if (-not $file) {
        Write-Error 'File not selected.'
        return
    }

    git diff --staged $file
}

# Displays commit differences.
function GitDiffHash {
    # Gets the hash.
    $hash = Invoke-PsFzfGitHashes
    
    if (-not $hash) {
        Write-Error 'Hash not selected.'
        return
    }

    git diff $hash
}

# Displays differences between two files in different branches.
function GitDiffBranchFile {
    # Gets the first branch.
    $branch1 = git branch --all --format='%(refname:short)' | fzf --exact --border-label 'First branch'

    if (-not $branch1) {
        Write-Error 'The first branch was not selected.'
        return
    }

    # Gets the second branch.
    $branch2 = git branch --all --format='%(refname:short)' | fzf --exact --border-label 'Second branch'

    if (-not $branch2) {
        Write-Error 'The second branch was not selected.'
        return
    }

    # Gets the file to be compared.
    $file = git ls-tree -r --name-only $branch1 | fzf --exact --border-label 'Diff file'

    if (-not $file) {
        Write-Error 'File not selected.'
        return
    }

    git diff "$branch1`:$file" "$branch2`:$file"
}

# Displays differences between two branches.
function GitDiffBranches {
    # Gets the first branch.
    $branch1 = git branch --all --list --format='%(refname:short)' | fzf --exact --border-label 'First branch'

    if (-not $branch1) {
        Write-Error 'The first branch was not selected.'
        return
    }

    # Gets the second branch.
    $branch2 = git branch --all --list --format='%(refname:short)' | fzf --exact --border-label 'Second branch'

    if (-not $branch2) {
        Write-Error 'The second branch was not selected.'
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
        Write-Error 'Branch not selected.'
        return
    }

    git show $branch
}

# Displays status and filenames from a branch's latest commit.
function GitShowBranchNameStatus {
    # Gets the branch.
    $branch = Invoke-PsFzfGitBranches

    if (-not $branch) {
        Write-Error 'Branch not selected.'
        return
    }

    git show --name-status $branch
}

# Displays filenames from a branch's lastest commit.
function GitShowBranchNameOnly {
    # Gets the branch.
    $branch = Invoke-PsFzfGitBranches

    if (-not $branch) {
        Write-Error 'Branch not selected.'
        return
    }

    git show --name-only $branch
}

# Displays changes from a stash.
function GitShowStash {
    # Gets the stash.
    $stash = Invoke-PsFzfGitStashes

    if (-not $stash) {
        Write-Error 'Stash not selected.'
        return
    }

    git show $stash
}

# Displays changes from a stash file.
function GitShowStashFile {
    # Gets the stash.
    $stash = Invoke-PsFzfGitStashes

    if (-not $stash) {
        Write-Error 'Stash not selected.'
        return
    }

    # Gets the name of changed files from the stash.
    $files = git stash show --name-only $stash

    # Gets the file.
    $selectedFile = $files | fzf --exact --border-label 'Show file'

    if (-not $selectedFile) {
        Write-Error 'File not selected.'
        return
    }

    git show $stash $selectedFile
}

# Displays the entire file content from a stash.
function GitShowStashFileContent {
    # Gets the stash.
    $stash = Invoke-PsFzfGitStashes

    if (-not $stash) {
        Write-Error 'Stash not selected.'
        return
    }

    # Gets the name of changed files from the stash.
    $files = git stash show --name-only $stash

    # Gets the file.
    $selectedFile = $files | fzf --exact --border-label 'Show file content'

    if (-not $selectedFile) {
        Write-Error 'File not selected.'
        return
    }

    git show "$stash`:$selectedFile"
}

# Displays changes from a branch file.
function GitShowBranchFile {
    # Gets the branch.
    $branch = Invoke-PsFzfGitBranches

    if (-not $branch) {
        Write-Error 'Branch not selected.'
        return
    }

    # Gets the name of changed files from the branch.
    $files = git show --name-only --pretty='' $branch

    # Gets the file.
    $selectedFile = $files | fzf --exact --border-label 'Show file'
    
    if (-not $selectedFile) {
        Write-Error 'File not selected.'
        return
    }

    git show $branch $selectedFile
}

# Displays the entire file content from a branch.
function GitShowBranchFileContent {
    # Gets the branch.
    $branch = Invoke-PsFzfGitBranches

    if (-not $branch) {
        Write-Error 'Branch not selected.'
        return
    }

    # Gets all filenames from the branch.
    $files = git ls-tree -r --name-only $branch

    # Gets the file.
    $selectedFile = $files | fzf --exact --border-label 'Show file content'

    if (-not $selectedFile) {
        Write-Error 'File not selected.'
        return
    }

    git show "$branch`:$selectedFile"
}

# Displays changes from a hash.
function GitShowHash {
    # Gets the hash.
    $hash = Invoke-PsFzfGitHashes

    if (-not $hash) {
        Write-Error 'Hash not selected.'
        return
    }

    git show $hash
}

# Displays changes from a file's hash.
function GitShowHashFile {
    # Gets the hash.
    $hash = Invoke-PsFzfGitHashes

    if (-not $hash) {
        Write-Error 'Hash not selected.'
        return
    }

    # Gets all changed files from the hash.
    $files = git show --name-only --pretty='' $hash
    
    # Gets the file.
    $selectedFile = $files | fzf --exact --border-label 'Show file changes'

    if (-not $selectedFile) {
        Write-Error 'File not selected.'
        return
    }

    git show $hash $selectedFile
}
# switch ---------------------------------------------------------------------------------------------------------------
# Creates a local branch.
function GitSwitchCreate {
    param (
        $branchName
    )

    if (-not $branchName) {
        Write-Error 'Branch not selected.'
        return
    }

    git switch --create $branchName
}

# Switches to a local branch.
function GitSwitch {
    # Gets the branch.
    $branch = Invoke-PsFzfGitBranches

    if (-not $branch) {
        Write-Error 'Branch not selected.'
        return
    }

    git switch $branch
}

# Creates and tracks a local branch.
function GitSwitchTrack {
    # Gets the branch.
    $branch = Invoke-PsFzfGitBranches

    if (-not $branch) {
        Write-Error 'Branch not selected.'
        return
    }

    git switch --track $branch
}
# branch ---------------------------------------------------------------------------------------------------------------
# Displays all branches from a remote repository.
function GitBranches {
    Invoke-PsFzfGitBranches
}

# Changes the name of a local branch.
function GitBranchMove {
    param (
        $newName
    )

    # Gets the branch.
    $branch = Invoke-PsFzfGitBranches

    if (-not $branch) {
        Write-Error 'Branch not selected.'
        return
    }

    git branch --move --force $branch $newName
}

# Remove a local branch.
function GitBranchDelete {
    # Gets the branch.
    $branch = Invoke-PsFzfGitBranches

    if (-not $branch) {
        Write-Error 'Branch not selected.'
        return
    }

    git branch --delete --force $branch
}

# Returns all branches that contain a hash.
function GitBranchAllContains {
    # Gets the hash.
    $hash = Invoke-PsFzfGitHashes

    if (-not $hash) {
        Write-Error 'Hash not selected.'
        return
    }

    git branch --contains --all $hash
}

# Associates the local branch with a remote branch.
function GitBranchSetUpstream {
    # Gets the branch.
    $branch = Invoke-PsFzfGitBranches

    if (-not $branch) {
        Write-Error 'Branch not selected.'
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
    # Gets the branch.
    $branch = Invoke-PsFzfGitBranches

    if (-not $branch) {
        Write-Error 'Branch not selected.'
        return
    }

    git rebase $branch
}

# Allows editing the history from a hash.
function GitRebaseInteractive {
    # Gets the hash.
    $hash = Invoke-PsFzfGitHashes

    if (-not $hash) {
        Write-Error 'Hash not selected.'
        return
    }

    git rebase --interactive $hash
}

# commit ---------------------------------------------------------------------------------------------------------------
function GitHashes {
    Invoke-PsFzfGitHashes
}

# Creates a commit with a message.
function GitCommitMessage {
    param (
        $message
    )
    
    git commit --message "$message"
}

# Edits the last commit, allowing the message to be changed.
function GitCommitAmend {
    git commit --amend
}

# Edits the last commit, keeping the previous message.
function GitCommitAmendNoEdit {
    git commit --amend --no-edit
}

# remote ---------------------------------------------------------------------------------------------------------------
# Adds a remote repository to the project.
function GitRemoteAddOrigin {
    param (
        $remoteUrl
    )

    git remote add origin $remoteUrl
}

# stash ----------------------------------------------------------------------------------------------------------------
# Creates a stash.
function GitStashSave {
    param (
        $stashName
    )
    
    git stash save $stashName
}

# Lists all stashes.
function GitStashList {
    Invoke-PsFzfGitStashes
}

# Displays filenames from a stash.
function GitStashShowNameOnly {
    # Gets the stash.
    $stash = Invoke-PsFzfGitStashes

    if (-not $stash) {
        Write-Error 'Stash not selected.'
        return
    }

    git stash show --name-only $stash
}

# Displays status and filenames from a stash.
function GitStashShowNameStatus {
    # Gets the stash.
    $stash = Invoke-PsFzfGitStashes

    if (-not $stash) {
        Write-Error 'Stash not selected.'
        return
    }

    git stash show --name-status $stash
}

# Applies a stash.
function GitStashApply {
    # Gets the stash.
    $stash = Invoke-PsFzfGitStashes

    if (-not $stash) {
        Write-Error 'Stash not selected.'
        return
    }

    git stash apply $stash
}

# Applies and remove a stash.
function GitStashPop {
    # Gets the stash.
    $stash = Invoke-PsFzfGitStashes

    if (-not $stash) {
        Write-Error 'Stash not selected.'
        return
    }

    git stash pop $stash
}

# cherry-pick ----------------------------------------------------------------------------------------------------------
# Includes in the history the commit from another branch.
function GitCherryPick {
    # Gets the hash.
    $hash = Invoke-PsFzfGitHashes

    if (-not $hash) {
        Write-Error 'Hash not selected.'
        return
    }
    
    git cherry-pick $hash
}

# restore --------------------------------------------------------------------------------------------------------------
# Restores unstaged files.
function GitRestore {
    # Gets the files.
    $files = Invoke-PsFzfGitFiles

    if (-not $files) {
        Write-Error 'Files not selected.'
    }

    git restore $files
}

# Restore staged files.
function GitRestoreStaged {
    # Gets the files.
    $files = Invoke-PsFzfGitFiles

    if (-not $files) {
        Write-Error 'Files not selected.'
    }

    git restore --staged $files
}

# reset ----------------------------------------------------------------------------------------------------------------
# Removes commits and all file changes.
function GitResetHard {
    # Gets the hash.
    $hash = Invoke-PsFzfGitStashes

    if (-not $hash) {
        Write-Error 'Hash not selected.'
        return
    }

    git reset --hard $hash
}

# Removes commits, but keeps all file changes in the staged area.
function GitResetSoft {
    # Gets the hash.
    $hash = Invoke-PsFzfGitStashes

    if (-not $hash) {
        Write-Error 'Hash not selected.'
        return
    }

    git reset --soft $hash
}

# Removes commits, but keeps all file changes in the unstaged area.
function GitResetMixed {
    # Gets the hash.
    $hash = Invoke-PsFzfGitStashes

    if (-not $hash) {
        Write-Error 'Hash not selected.'
        return
    }

    git reset --mixed $hash
}

# file -----------------------------------------------------------------------------------------------------------------
function GitFiles {
    Invoke-PsFzfGitFiles
}

# Discard local commits and reset branch to match remote.
function GitResetHardBranch {
    # Gets the branch.
    $branch = Invoke-PsFzfGitBranches

    if (-not $branch) {
        Write-Error 'Branch not selected.'
        return
    }

    git reset --hard $branch
}

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
Set-Alias -Name gpssuo -Value GitPushSetUpstreamOrigin
# log
Set-Alias -Name glo -Value GitLogOneline
Set-Alias -Name gloda -Value GitLogOnelineDecorateAll
Set-Alias -Name glogda -Value GitLogOnelineGraphDecoreteAll
# diff
Set-Alias -Name gd -Value GitDiff
Set-Alias -Name gds -Value GitDiffStaged
Set-Alias -Name gdsf -Value GitDiffStagedFile
Set-Alias -Name gdf -Value GitDiffFile
Set-Alias -Name gdb -Value GitDiffBranches
Set-Alias -Name gdbf -Value GitDiffBranchFile
Set-Alias -Name gdh -Value GitDiffHash
# show
Set-Alias -Name gsh -Value GitShow
Set-Alias -Name gshns -Value GitShowNameStatus
Set-Alias -Name gshno -Value GitShowNameOnly
Set-Alias -Name gshb -Value GitShowBranch
Set-Alias -Name gshbf -Value GitShowBranchFile
Set-Alias -Name gshbfc -Value GitShowBranchFileContent
Set-Alias -Name gshnsb -Value GitShowBranchNameStatus
Set-Alias -Name gshnob -Value GitShowBranchNameOnly
Set-Alias -Name gshh -Value GitShowHash
Set-Alias -Name gshh -Value GitShowHashFile
Set-Alias -Name gshst -Value GitShowStash
Set-Alias -Name gshstf -Value GitShowStashFile
Set-Alias -Name gshstfc -Value GitShowStashFileContent
# switch
Set-Alias -Name gswc -Value GitSwitchCreate
Set-Alias -Name gsw -Value GitSwitch
Set-Alias -Name gswt -Value GitSwitchTrack
# branch
Set-Alias -Name gb -Value GitBranches
Set-Alias -Name gbm -Value GitBranchMove
Set-Alias -Name gbd -Value GitBranchDelete
Set-Alias -Name gbca -Value GitBranchAllContains
Set-Alias -Name gbsu -Value GitBranchSetUpstream
Set-Alias -Name gbuu -Value GitBranchUnsetUpsteam
Set-Alias -Name gbv -Value GitBranchVerbose
# rebase
Set-Alias -Name grb -Value GitRebase
Set-Alias -Name grbi -Value GitRebaseInteractive
# commit
Set-Alias -Name ghs -Value GitHashes
Set-Alias -Name gcmm -Value GitCommitMessage
Set-Alias -Name gca -Value GitCommitAmend
Set-Alias -Name gcan -Value GitCommitAmendNoEdit
# remote
Set-Alias -Name grao -Value GitRemoteAddOrigin
# stash
Set-Alias -Name gsts -Value GitStashSave
Set-Alias -Name gstl -Value GitStashList
Set-Alias -Name gstshno -Value GitStashShowNameOnly
Set-Alias -Name gstshns -Value GitStashShowNameStatus
Set-Alias -Name gsta -Value GitStashApply
Set-Alias -Name gstp -Value GitStashPop
# cherry-pick
Set-Alias -Name gcp -Value GitCherryPick
# restore
Set-Alias -Name gr -Value GitRestore
Set-Alias -Name grst -Value GitRestoreStaged
# reset
Set-Alias -Name grh -Value GitResetHard
Set-Alias -Name grs -Value GitResetSoft
Set-Alias -Name grm -Value GitResetMixed
# file
Set-Alias -Name gf -Value GitFiles