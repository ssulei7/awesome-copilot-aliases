#!/usr/bin/env bash
# Awesome Copilot CLI Aliases Installer
# Auto-detects shell and installs appropriate aliases and completions

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo -e "${BLUE}🤖 Awesome Copilot CLI Aliases Installer${NC}\n"

# Check if copilot CLI is installed
if ! command -v copilot &> /dev/null; then
    echo -e "${YELLOW}⚠️  Warning: GitHub Copilot CLI not found${NC}"
    echo -e "Install it with: ${GREEN}npm install -g @github/copilot${NC}\n"
fi

# Detect shell
detect_shell() {
    # Multi-layered detection strategy for maximum compatibility:
    # 1. Check if running interactively in a specific shell (version variables)
    # 2. Check user's login shell ($SHELL)
    # 3. Check parent process
    # 4. Fall back to sensible default based on OS
    
    # Layer 1: If we're actually running IN zsh/fish (interactive), prefer that
    # This handles: source install.sh, zsh install.sh, etc.
    if [ -n "$ZSH_VERSION" ]; then
        echo "zsh"
        return
    elif [ -n "$FISH_VERSION" ]; then
        echo "fish"
        return
    fi
    
    # Layer 2: Check $SHELL (user's configured login shell)
    # This is the most reliable for non-interactive execution
    if [ -n "$SHELL" ]; then
        case "$SHELL" in
            */zsh)
                echo "zsh"
                return
                ;;
            */fish)
                echo "fish"
                return
                ;;
            */bash)
                echo "bash"
                return
                ;;
            */pwsh|*/powershell)
                echo "powershell"
                return
                ;;
        esac
    fi
    
    # Layer 3: Check parent process (useful when $SHELL is not set)
    if command -v ps &> /dev/null; then
        local parent_process
        parent_process=$(ps -p $$ -o comm= 2>/dev/null || ps -p $$ -o args= 2>/dev/null | awk '{print $1}')
        case "$parent_process" in
            *zsh*)
                echo "zsh"
                return
                ;;
            *fish*)
                echo "fish"
                return
                ;;
            *bash*)
                echo "bash"
                return
                ;;
        esac
    fi
    
    # Layer 4: OS-based defaults as last resort
    # macOS default changed to zsh in Catalina (10.15)
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS - default to zsh (standard since 2019)
        echo "zsh"
        return
    elif [ -n "$BASH_VERSION" ]; then
        # We're running in bash and couldn't determine anything else
        echo "bash"
        return
    fi
    
    echo "unknown"
}

# Install for Bash
install_bash() {
    local config_file="$HOME/.bashrc"
    local aliases_path="$SCRIPT_DIR/shells/bash/copilot-aliases.bash"
    local completions_path="$SCRIPT_DIR/shells/bash/completions.bash"
    
    echo -e "${BLUE}Installing for Bash...${NC}"
    
    # Check if already installed
    if grep -q "copilot-aliases.bash" "$config_file" 2>/dev/null; then
        echo -e "${YELLOW}Already installed in $config_file${NC}"
        return
    fi
    
    # Backup config file
    cp "$config_file" "$config_file.backup.$(date +%Y%m%d_%H%M%S)" 2>/dev/null || true
    
    # Add to config
    cat >> "$config_file" << EOF

# Awesome Copilot CLI Aliases
if [ -f "$aliases_path" ]; then
    source "$aliases_path"
fi
if [ -f "$completions_path" ]; then
    source "$completions_path"
fi
EOF
    
    echo -e "${GREEN}✓ Installed to $config_file${NC}"
    echo -e "${YELLOW}Run: source ~/.bashrc${NC}\n"
}

# Install for Zsh
install_zsh() {
    local config_file="$HOME/.zshrc"
    local aliases_path="$SCRIPT_DIR/shells/zsh/copilot-aliases.zsh"
    local completions_dir="$SCRIPT_DIR/shells/zsh"
    
    echo -e "${BLUE}Installing for Zsh...${NC}"
    
    # Check if already installed
    if grep -q "copilot-aliases.zsh" "$config_file" 2>/dev/null; then
        echo -e "${YELLOW}Already installed in $config_file${NC}"
        return
    fi
    
    # Backup config file
    cp "$config_file" "$config_file.backup.$(date +%Y%m%d_%H%M%S)" 2>/dev/null || true
    
    # Add to config
    cat >> "$config_file" << EOF

# Awesome Copilot CLI Aliases
if [ -f "$aliases_path" ]; then
    source "$aliases_path"
fi

# Add completions to fpath
fpath=($completions_dir \$fpath)

# Initialize completions if not already done
autoload -Uz compinit
compinit
EOF
    
    echo -e "${GREEN}✓ Installed to $config_file${NC}"
    echo -e "${YELLOW}Run: source ~/.zshrc${NC}\n"
}

# Install for Fish
install_fish() {
    local config_file="$HOME/.config/fish/config.fish"
    local aliases_path="$SCRIPT_DIR/shells/fish/copilot-aliases.fish"
    local completions_path="$SCRIPT_DIR/shells/fish/completions.fish"
    
    echo -e "${BLUE}Installing for Fish...${NC}"
    
    # Create config directory if it doesn't exist
    mkdir -p "$HOME/.config/fish"
    
    # Check if already installed
    if grep -q "copilot-aliases.fish" "$config_file" 2>/dev/null; then
        echo -e "${YELLOW}Already installed in $config_file${NC}"
        return
    fi
    
    # Backup config file
    [ -f "$config_file" ] && cp "$config_file" "$config_file.backup.$(date +%Y%m%d_%H%M%S)"
    
    # Add to config
    cat >> "$config_file" << EOF

# Awesome Copilot CLI Aliases
if test -f $aliases_path
    source $aliases_path
end
if test -f $completions_path
    source $completions_path
end
EOF
    
    echo -e "${GREEN}✓ Installed to $config_file${NC}"
    echo -e "${YELLOW}Run: source ~/.config/fish/config.fish${NC}\n"
}

# Install for PowerShell
install_powershell() {
    echo -e "${BLUE}Installing for PowerShell...${NC}"
    echo -e "${YELLOW}Please run the following command in PowerShell:${NC}\n"
    
    cat << 'EOF'
# Add to PowerShell profile
$profilePath = $PROFILE
$installPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$aliasesPath = Join-Path $installPath "shells/powershell/copilot-aliases.ps1"
$completionsPath = Join-Path $installPath "shells/powershell/completions.ps1"

# Create profile if it doesn't exist
if (!(Test-Path $profilePath)) {
    New-Item -Path $profilePath -ItemType File -Force
}

# Add to profile
Add-Content $profilePath "`n# Awesome Copilot CLI Aliases"
Add-Content $profilePath "if (Test-Path '$aliasesPath') { . '$aliasesPath' }"
Add-Content $profilePath "if (Test-Path '$completionsPath') { . '$completionsPath' }"

Write-Host "Installed to $profilePath" -ForegroundColor Green
Write-Host "Run: . `$PROFILE" -ForegroundColor Yellow
EOF
}

# Uninstall function
uninstall() {
    echo -e "${BLUE}Uninstalling Awesome Copilot CLI Aliases...${NC}\n"
    
    local shell_type
    shell_type=$(detect_shell)
    local config_file=""
    
    case "$shell_type" in
        bash)
            config_file="$HOME/.bashrc"
            ;;
        zsh)
            config_file="$HOME/.zshrc"
            ;;
        fish)
            config_file="$HOME/.config/fish/config.fish"
            ;;
        *)
            echo -e "${RED}Could not detect shell type${NC}"
            exit 1
            ;;
    esac
    
    if [ -f "$config_file" ]; then
        # Check if installation exists by looking for any of the artifacts
        local found=false
        if grep -q "# Awesome Copilot CLI Aliases" "$config_file" 2>/dev/null || \
           grep -q "copilot-aliases\\.bash\\|copilot-aliases\\.zsh\\|copilot-aliases\\.fish" "$config_file" 2>/dev/null || \
           grep -q "/shells/bash\\|/shells/zsh\\|/shells/fish" "$config_file" 2>/dev/null; then
            found=true
        fi
        
        if [ "$found" = false ]; then
            echo -e "${YELLOW}Aliases not found in $config_file${NC}"
            echo -e "Nothing to uninstall."
            return
        fi
        
        # Backup
        cp "$config_file" "$config_file.backup.$(date +%Y%m%d_%H%M%S)"
        
        # Remove the entire block added by installer
        # Remove lines containing copilot-aliases references and related completion setup
        case "$shell_type" in
            bash)
                # Remove all lines related to copilot-aliases for bash
                grep -v "copilot-aliases\\.bash\\|completions\\.bash\\|# Awesome Copilot CLI Aliases" "$config_file" > "$config_file.new"
                mv "$config_file.new" "$config_file"
                ;;
            zsh)
                # Remove all lines related to copilot-aliases for zsh, including fpath and compinit lines that reference our directory
                awk -v dir="$SCRIPT_DIR" '
                    /# Awesome Copilot CLI Aliases/ { next }
                    /copilot-aliases\.zsh/ { next }
                    /shells\/zsh.*fpath/ { next }
                    /^fpath=\(.*awesome-copilot-aliases/ { next }
                    /^# Add completions to fpath/ { in_block=1; next }
                    in_block && /^fpath=\(/ { next }
                    in_block && /^$/ { next }
                    in_block && /^# Initialize completions/ { next }
                    in_block && /^autoload -Uz compinit/ { next }
                    in_block && /^compinit/ { in_block=0; next }
                    { print }
                ' "$config_file" > "$config_file.new" && mv "$config_file.new" "$config_file"
                ;;
            fish)
                # Remove all lines related to copilot-aliases for fish
                grep -v "copilot-aliases\\.fish\\|completions\\.fish\\|# Awesome Copilot CLI Aliases" "$config_file" > "$config_file.new"
                mv "$config_file.new" "$config_file"
                ;;
        esac
        
        # Clean up any leading blank lines that might have been left
        sed -i.tmp -e :a -e '/^\n*$/{$d;N;ba' -e '}' "$config_file" 2>/dev/null || \
        sed -i '' -e :a -e '/^\n*$/{$d;N;ba' -e '}' "$config_file" 2>/dev/null || true
        
        # Remove temp files
        rm -f "$config_file.tmp" 2>/dev/null || true
        
        echo -e "${GREEN}✓ Uninstalled from $config_file${NC}"
        echo -e "${YELLOW}Backup saved as ${config_file}.backup.*${NC}"
    else
        echo -e "${RED}Config file not found: $config_file${NC}"
        exit 1
    fi
}

# Main installation logic
main() {
    if [ "$1" = "uninstall" ] || [ "$1" = "--uninstall" ]; then
        uninstall
        exit 0
    fi
    
    local shell_type
    shell_type=$(detect_shell)
    
    echo -e "Detected shell: ${GREEN}$shell_type${NC}\n"
    
    case "$shell_type" in
        bash)
            install_bash
            ;;
        zsh)
            install_zsh
            ;;
        fish)
            install_fish
            ;;
        powershell)
            install_powershell
            ;;
        unknown)
            echo -e "${RED}Could not detect shell type${NC}"
            echo -e "Please install manually for your shell:\n"
            echo -e "  Bash:       ./install.sh bash"
            echo -e "  Zsh:        ./install.sh zsh"
            echo -e "  Fish:       ./install.sh fish"
            echo -e "  PowerShell: See README for instructions"
            exit 1
            ;;
    esac
    
    echo -e "${GREEN}✓ Installation complete!${NC}"
    echo -e "\n${BLUE}Next steps:${NC}"
    echo -e "  1. Reload your shell configuration"
    echo -e "  2. Try: ${GREEN}cphelp${NC} to see all available aliases"
    echo -e "  3. Use tab-completion: ${GREEN}cp<TAB>${NC}"
    echo -e "\n${YELLOW}⚠️  Security reminder:${NC}"
    echo -e "  Review the aliases in the README before use"
    echo -e "  Understand what auto-approvals are granted"
}

# Allow manual shell selection
if [ -n "$1" ] && [ "$1" != "uninstall" ] && [ "$1" != "--uninstall" ]; then
    case "$1" in
        bash)
            install_bash
            ;;
        zsh)
            install_zsh
            ;;
        fish)
            install_fish
            ;;
        powershell)
            install_powershell
            ;;
        *)
            echo -e "${RED}Unknown shell: $1${NC}"
            exit 1
            ;;
    esac
else
    main "$@"
fi
