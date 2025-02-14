# Configurações do PowerShell
$PSReadLineOptions = @{
    EditMode = "Vi"
    Colors = @{
        "Command" = "`e[92m"
    }
}
Set-PSReadLineOption @PSReadLineOptions

# Configurações de saída no terminal
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

# Configuração do modo VIM no terminal
Set-PSReadLineOption -ViModeIndicator Script -ViModeChangeHandler $Function:OnViModeChange

# oh-my-posh init
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\spaceship.omp.json" | Invoke-Expression

# Instalar o módulo abaixo
# Install-Module -Name PSFzf -Scope CurrentUser -Force

# Modules import
Import-Module PSFzf
Import-Module Git-Functions
Import-Module Docker-Functions
Import-Module Dotnet-Functions

# Enable PSFzf tab completion
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

# Enable PSFzf tab expansion
#Set-PsFzfOption -TabExpansion

# Preview settings
$env:FZF_DEFAULT_OPTS = "--height 50% --layout=reverse --border --inline-info --bind 'ctrl-/:change-preview-window(hidden|)'"
$env:FZF_CTRL_T_OPTS = "--walker-skip .git,node_modules,target --preview 'bat -n --color=always --line-range :500 {}'"
$env:FZF_ALT_C_OPTS = "--walker-skip .git,node_modules,target --preview 'eza --tree --color=always {}'"

# Configurações adicionais do fzf
$env:FZF_DEFAULT_COMMAND = "fd --hidden --strip-cwd-prefix --exclude .git"

# Essential functions
function sf { param($fileName, $inputString) $dir = fd -t d "" C:\ | fzf -e; if ($dir) { Set-Content -Path "$dir\$fileName" -Value $inputString -Encoding UTF8 } }
function af { param($fileName, $inputString) $dir = fd -t d "" C:\ | fzf -e; if ($dir) { Add-Content -Path "$dir\$fileName" -Value $inputString -Encoding UTF8 } }