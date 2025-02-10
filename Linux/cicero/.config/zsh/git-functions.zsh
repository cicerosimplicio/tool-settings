# File content
# function sf { param($fileName, $input) $dir = fd -t d "" C:\ | fzf -e; if ($dir ]]; then Set-Content -Path "$dir\$fileName" -Value $input -Encoding UTF8 } }

# fetch ----------------------------------------------------------------------------------------------------------------
# Fetches updates from a remote branch.
function git_fetch_origin {
    # Gets the local branch.
    branch=$(_fzf_git_branches)

    if [[ -z $branch ]]; then
        echo 'Fetch from all remote branches.'

        # If no branch is selected, fetch from all remote branches.
        git fetch origin
    fi

    git fetch origin $branch
}

# Delete a remote branch.
function git_push_origin_delete {
    # Gets the branch.
    branch=$(_fzf_git_branches)

    if [[ -z $branch ]]; then
        echo 'Branch not selected.' >&2
        return 1
    fi

    git push origin --delete $branch
}
# push -----------------------------------------------------------------------------------------------------------------
# Pushes a local branch to the remote repository.
function git_push_origin_set_upstream {
    # Gets the local branch.
    branch=$(_fzf_git_branches)

    if [[ -z $branch ]]; then
        echo 'Branch not selected.' >&2
        return 1
    fi

    git push --set-upstream origin $branch
}
# diff -----------------------------------------------------------------------------------------------------------------
# Displays unstaged differences in a file.
function git_diff_file {
    # Gets the file.
    file=$(_fzf_git_files)
    
    if [[ -z $file ]]; then
        echo 'File not selected.' >&2
        return 1
    fi

    git diff $file
}

# Displays staged differences in a file.
function git_diff_staged_file {
    # Gets the file.
    file=$(_fzf_git_files)
    
    if [[ -z $file ]]; then
        echo 'File not selected.' >&2
        return 1
    fi

    git diff --staged $file
}

# Displays commit differences.
function git_diff_hash {
    # Gets the hash.
    hash=$(_fzf_git_hashes)
    
    if [[ -z $hash ]]; then
        echo 'Hash not selected.' >&2
        return 1
    fi

    git diff $hash
}

# Displays differences between two files in different branches.
git_diff_branch_file() {
    # Gets the first branch.
    branch1=$(_fzf_git_branches)

    if [[ -z $branch1 ]]; then
        echo 'The first branch was not selected.' >&2
        return 1
    fi

    # Gets the second branch.
    branch2=$(_fzf_git_branches)

    if [[ -z $branch2 ]]; then
        echo 'The second branch was not selected.' >&2
        return 1
    fi

    # Gets the file to be compared.
    file=$(_fzf_git_files)

    if [[ -z $file ]]; then
        echo 'File not selected.' >&2
        return 1
    fi

    git diff "$branch1:$file" "$branch2:$file"
}
# Displays differences between two branches.
function git_diff_branches {
    # Gets the first branch.
    branch1=$(_fzf_git_branches)

    if [[ -z $branch1 ]]; then
        echo 'The first branch was not selected.' >&2
        return 1
    fi

    # Gets the second branch.
    branch2=$(_fzf_git_branches)

    if [[ -z $branch2 ]]; then
        echo 'The second branch was not selected.' >&2
        return 1
    fi

    git diff $branch1 $branch2
}

# show -----------------------------------------------------------------------------------------------------------------
# Displays changes from a branch's latest commit.
function git_show_branch {
    # Gets the branch.
    branch=$(_fzf_git_branches)

    if [[ -z $branch ]]; then
        echo 'Branch not selected.' >&2
        return 1
    fi

    git show $branch
}

# Displays status and filenames from a branch's latest commit.
function git_show_branch_name_status {
    # Gets the branch.
    branch=$(_fzf_git_branches)

    if [[ -z $branch ]]; then
        echo 'Branch not selected.' >&2
        return 1
    fi

    git show --name-status $branch
}

# Displays filenames from a branch's lastest commit.
function git_show_name_only_branch {
    # Gets the branch.
    branch=$(_fzf_git_branches)

    if [[ -z $branch ]]; then
        echo 'Branch not selected.' >&2
        return 1
    fi

    git show --name-only $branch
}

# Displays changes from a stash.
function git_show_stash {
    # Gets the stash.
    stash=$(_fzf_git_stashes)

    if [[ -z $stash ]]; then
        echo 'Stash not selected.' >&2
        return 1
    fi

    git show $stash
}

# Displays changes from a stash file.
function git_show_stash_file {
    # Gets the stash.
    stash=$(_fzf_git_stashes)

    if [[ -z $stash ]]; then
        echo 'Stash not selected.' >&2
        return 1
    fi

    # Gets the name of changed files from the stash.
    files=$(git stash show --name-only --pretty='' $stash)

    # Gets the file.
    selectedFile=$(echo $files | fzf --exact --border-label 'Show file')

    if [[ -z $selectedFile ]]; then
        echo 'File not selected.' >&2
        return 1
    fi

    git show $stash $selectedFile
}

# Displays the entire file content from a stash.
function git_show_stash_file_content {
    # Gets the stash.
    stash=$(_fzf_git_stashes)

    if [[ -z $stash ]]; then
        echo 'Stash not selected.' >&2
        return 1
    fi

    # Gets the name of changed files from the stash.
    files=$(git stash show --name-only --pretty="" $stash)

    # Gets the file.
    selectedFile=$(echo $files | fzf --exact --border-label 'Show file content')

    if [[ -z $selectedFile ]]; then
        echo 'File not selected.' >&2
        return 1
    fi

    git show "$stash:$selectedFile"
}

# Displays changes from a branch file.
function git_show_branch_file {
    # Gets the branch.
    branch=$(_fzf_git_branches)

    if [[ -z $branch ]]; then
        echo 'Branch not selected.' >&2
        return 1
    fi

    # Gets the name of changed files from the branch.
    files=$(git show --name-only --pretty="" $branch)

    # Gets the file.
    selectedFile=$(echo $files | fzf --exact --border-label 'Show file')
    
    if [[ -z $selectedFile ]]; then
        echo 'File not selected.' >&2
        return 1
    fi

    git show $branch $selectedFile
}

# Displays the entire file content from a branch.
function git_show_branch_file_content {
    # Gets the branch.
    branch=$(_fzf_git_branches)

    if [[ -z $branch ]]; then
        echo 'Branch not selected.' >&2
        return 1
    fi

    # Gets all filenames from the branch.
    files=$(git ls-tree -r --name-only $branch)

    # Gets the file.
    selectedFile=$(echo $files | fzf --exact --border-label 'Show file content')

    if [[ -z $selectedFile ]]; then
        echo 'File not selected.' >&2
        return 1
    fi

    git show "$branch:$selectedFile"
}

# Displays changes from a hash.
function git_show_hash {
    # Gets the hash.
    hash=$(_fzf_git_hashes)

    if [[ -z $hash ]]; then
        echo 'Hash not selected.' >&2
        return 1
    fi

    git show $hash
}
# switch ---------------------------------------------------------------------------------------------------------------
# Switches to a local branch.
function git_switch {
    # Gets the local branch.
    branch=$(_fzf_git_branches)

    if [[ -z $branch ]]; then
        echo 'Branch not selected.' >&2
        return 1
    fi

    git switch $branch
}

# Creates and tracks a local branch.
function git_switch_track {
    # Gets the branch.
    branch=$(_fzf_git_branches)

    if [[ -z $branch ]]; then
        echo 'Branch not selected.' >&2
        return 1
    fi

    git switch --track $branch
}
# branch ---------------------------------------------------------------------------------------------------------------
# Changes the name of a local branch.
function git_branch_move {
    if [[ -z "$1" ]]; then
        echo 'Branch name not provided.' >&2
        return 1
    fi

    newName=$1

    # Gets the local branch.
    branch=$(_fzf_git_branches)

    if [[ -z $branch ]]; then
        echo 'Branch not selected.' >&2
        return 1
    fi

    git branch --move --force $branch $newName
}

# Remove a local branch.
function git_branch_delete {
    # Gets the local branch.
    branch=$(_fzf_git_branches)

    if [[ -z $branch ]]; then
        echo 'Branch not selected.' >&2
        return 1
    fi

    git branch --delete --force $branch
}

# Returns all branches that contain a hash.
function git_branch_all_contains {
    # Gets the hash.
    hash=$(_fzf_git_hashes)

    if [[ -z $hash ]]; then
        echo 'Hash not selected.' >&2
        return 1
    fi

    git branch --all --contains $hash
}

# Associates the local branch with a remote branch.
function git_branch_set_upstream {
    # Gets the branch.
    branch=$(_fzf_git_branches)

    if [[ -z $branch ]]; then
        echo 'Branch not selected.' >&2
        return 1
    fi

    git branch --set-upstream $branch
}
# rebase ---------------------------------------------------------------------------------------------------------------
# Updates the local branch based on a remote branch.
function git_rebase {
    # Gets the branch.
    branch=$(_fzf_git_branches)

    if [[ -z $branch ]]; then
        echo 'Branch not selected.' >&2
        return 1
    fi

    git rebase $branch
}

# Allows editing the history from a hash.
function git_rebase_interactive {
    # Gets the hash.
    hash=$(_fzf_git_hashes)

    if [[ -z $hash ]]; then
        echo 'Hash not selected.' >&2
        return 1
    fi

    git rebase --interactive $hash
}
# stash ----------------------------------------------------------------------------------------------------------------
# Displays filenames from a stash.
function git_stash_show_name_only {
    # Gets the stash.
    stash=$(_fzf_git_stashes)

    if [[ -z $stash ]]; then
        echo 'Stash not selected.' >&2
        return 1
    fi

    git stash show --name-only $stash
}

# Displays status and filenames from a stash.
function git_stash_show_name_status {
    # Gets the stash.
    stash=$(_fzf_git_stashes)

    if [[ -z $stash ]]; then
        echo 'Stash not selected.' >&2
        return 1
    fi

    git stash show --name-status $stash
}

# Applies a stash.
function git_stash_apply {
    # Gets the stash.
    stash=$(_fzf_git_stashes)

    if [[ -z $stash ]]; then
        echo 'Stash not selected.' >&2
        return 1
    fi

    git stash apply $stash
}

# Applies and remove a stash.
function git_stash_pop {
    # Gets the stash.
    stash=$(_fzf_git_stashes)

    if [[ -z $stash ]]; then
        echo 'Stash not selected.' >&2
        return 1
    fi

    git stash pop $stash
}

# cherry-pick ----------------------------------------------------------------------------------------------------------
# Includes in the history the commit from another branch.
function git_cherry_pick {
    # Gets the hash.
    hash=$(_fzf_git_hashes)

    if [[ -z $hash ]]; then
        echo 'Hash not selected.' >&2
        return 1
    fi
    
    git cherry-pick $hash
}

# restore --------------------------------------------------------------------------------------------------------------
# Restores unstaged files.
function git_restore {
    # Gets the files.
    files=$(_fzf_git_files)

    if [[ -z $files ]]; then
        echo 'Files not selected.' >&2
        return 1
    fi

    git restore $files
}

# Restore staged files.
function git_restore_staged {
    # Gets the files.
    files=$(_fzf_git_files)

    if [[ -z $files ]]; then
        echo 'Files not selected.' >&2
        return 1
    fi

    git restore --staged $files
}

# reset ----------------------------------------------------------------------------------------------------------------
# Removes commits and all file changes.
function git_reset_hard {
    # Gets the hash.
    hash=$(_fzf_git_hashes)

    if [[ -z $hash ]]; then
        echo 'Hash not selected.' >&2
        return 1
    fi

    git reset --hard $hash
}

# Removes commits, but keeps all file changes in the staged area.
function git_reset_soft {
    # Gets the hash.
    hash=$(_fzf_git_hashes)

    if [[ -z $hash ]]; then
        echo 'Hash not selected.' >&2
        return 1
    fi

    git reset --soft $hash
}

# Removes commits, but keeps all file changes in the unstaged area.
function git_reset_mixed {
    # Gets the hash.
    hash=$(_fzf_git_hashes)

    if [[ -z $hash ]]; then
        echo 'Hash not selected.' >&2
        return 1
    fi

    git reset --mixed $hash
}

# Discard local commits and reset branch to match remote.
function git_reset_hard_branch {
    # Gets the branch.
    branch=$(_fzf_git_branches)

    if [[ -z $branch ]]; then
        echo 'Branch not selected.' >&2
        return 1
    fi

    git reset --hard $branch
}