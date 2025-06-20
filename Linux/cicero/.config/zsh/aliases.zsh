# Replacement of the "ls" command 
alias ls='eza --icons'

# Substitute find and grep
alias find='fd'
alias grep='rg'

# Substitute cat
alias cat='bat'

# Essential functions
alias sf='save_file'
alias af='append_file'

# Git
# fetch
alias gfo='git_fetch_origin'
# status
alias gs='git status'
alias gss='git status --short'
# pull
alias gpl='git pull'
# push
alias gps='git push'
alias gpsod='git_push_origin_delete'
alias gpsf='git push --force-with-lease'
alias gpsosu='git_push_origin_set_upstream'
# log
alias glo='git log --onelin'
alias gloda='git log --oneline --decorate --all'
alias glogda='git log --oneline --graph --decorate --all'
# diff
alias gd='git diff'
alias gds='git diff --staged'
alias gdf='git_diff_file'
alias gdsf='git_diff_staged_file'
alias gdbf='git_diff_branch_file'
alias gdh='git_diff_hash'
alias gdb='git_diff_branches'
# show
alias gsh='git show'
alias gshns='git show --name-status'
alias gshno='git show --name-only'
alias gshb='git_show_branch'
alias gshbf='git_show_branch_file'
alias gshbfc='git_show_branch_file_content'
alias gshnsb='git_show_name_status_branch'
alias gshnob='git_show_name_only_branch'
alias gshh='git_show_hash'
alias gshhf='git_show_hash_file'
alias gshst='git_show_stash'
alias gshstf='git_show_stash_file'
alias gshstfc='git_show_stash_file_content'
# switch
alias gswc='git switch --create'
alias gsw='git_switch'
alias gswt='git_switch_track'
# branch
alias gb='_fzf_git_branches'
alias gbm='git_branch_move'
alias gbd='git_branch_delete'
alias gbac='git_branch_all_contains'
alias gbsu='git_branch_set_upstream'
alias gbuu='git branch --unset-upstream'
alias gbv='git branch -vv'
# rebase
alias grb='git_rebase'
alias grbi='git_rebase_interactive'
# commit
alias gh='_fzf_git_hashes'
alias gcm='git commit --message'
alias gca='git commit --amend'
alias gcan='git commit --amend --no-edit'
# remote
alias grao='git remote add origin'
# stash
alias gsts='git stash save'
alias gstl='_fzf_git_stashes'
alias gstshno='git_stash_show_name_only'
alias gstshns='git_stash_show_name_status'
alias gsta='git_stash_apply'
alias gstp='git_stash_pop'
# cherry-pick
alias gcp='git_cherry_pick'
# restore
alias gr='git_restore'
alias grs='git_restore_staged'
# reset
alias grh='git_reset_hard'
alias grs='git_reset_soft'
alias grm='git_reset_mixed'
alias grhb='git_reset_hard_branch'
# file
alias gf='_fzf_git_files'