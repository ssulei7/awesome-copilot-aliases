# 🤖 Awesome Copilot CLI Aliases

A curated collection of useful, safe GitHub Copilot CLI aliases with auto-approval, parameter support, and tab-completion for common workflows.

**Supports:** Bash, Zsh, Fish, and PowerShell

## ⚠️ Security Notice

This repository provides aliases with **auto-approval flags** (`--allow-tool`) for convenience. While carefully scoped to specific safe operations, you should:

- ⚠️ **Review what each alias does** before using it
- 🔒 **Never use `--allow-all-tools`** (not included in any default alias)
- 🛡️ **Understand permission scopes** (e.g., `--allow-tool 'shell(git)'` allows all git commands)
- 📂 **Use in trusted directories** (Copilot requires directory trust confirmation)
- 🚫 **Dangerous commands blocked** (e.g., `rm`, `git push -f` are explicitly denied in relevant aliases)

## 🚀 Quick Start

### Installation

```bash
# Clone the repository
git clone https://github.com/ssulei7/awesome-copilot-aliases.git
cd awesome-copilot-aliases

# Run the installer (auto-detects your shell)
./install.sh
```

### Manual Installation

<details>
<summary><b>Bash</b></summary>

```bash
# Add to ~/.bashrc
echo 'source ~/awesome-copilot-aliases/shells/bash/copilot-aliases.bash' >> ~/.bashrc
echo 'source ~/awesome-copilot-aliases/shells/bash/completions.bash' >> ~/.bashrc
source ~/.bashrc
```
</details>

<details>
<summary><b>Zsh</b></summary>

```zsh
# Add to ~/.zshrc
echo 'source ~/awesome-copilot-aliases/shells/zsh/copilot-aliases.zsh' >> ~/.zshrc
echo 'fpath=(~/awesome-copilot-aliases/shells/zsh $fpath)' >> ~/.zshrc
echo 'autoload -Uz compinit && compinit' >> ~/.zshrc
source ~/.zshrc
```
</details>

<details>
<summary><b>Fish</b></summary>

```fish
# Add to ~/.config/fish/config.fish
echo 'source ~/awesome-copilot-aliases/shells/fish/copilot-aliases.fish' >> ~/.config/fish/config.fish
echo 'source ~/awesome-copilot-aliases/shells/fish/completions.fish' >> ~/.config/fish/config.fish
source ~/.config/fish/config.fish
```
</details>

<details>
<summary><b>PowerShell</b></summary>

```powershell
# Add to PowerShell profile
Add-Content $PROFILE ". $HOME/awesome-copilot-aliases/shells/powershell/copilot-aliases.ps1"
Add-Content $PROFILE ". $HOME/awesome-copilot-aliases/shells/powershell/completions.ps1"
. $PROFILE
```
</details>

## 📋 Alias Reference

All aliases use the `cp` prefix and support **tab-completion** (`cp<TAB>` shows all available aliases).

### Git Operations

| Alias | Parameters | Description | Auto-Approved Tools |
|-------|-----------|-------------|---------------------|
| `cpcommit` | `[message]` | Commit changes with AI-generated message (or custom message) | `shell(git)` (except `git push -f`) |
| `cppush` | - | Push changes to remote (prompts for confirmation) | `shell(git)` (except `git push -f`) |
| `cppull` | - | Pull latest changes with conflict resolution help | `shell(git)` |
| `cprevert` | `[commit]` | Revert specified commit or last commit | `shell(git)` |
| `cpbranch` | `[name]` | Create and switch to new branch (AI-generated name or custom) | `shell(git)` |
| `cplog` | - | Show git log with AI summaries | `shell(git log)` |
| `cpstatus` | - | Summarize current git status | `shell(git status)` |

### GitHub Operations

| Alias | Parameters | Description | Auto-Approved Tools |
|-------|-----------|-------------|---------------------|
| `cppr` | `[number]` | Create PR or view/check specific PR | GitHub MCP |
| `cpprs` | - | List open PRs in current repo | GitHub MCP |
| `cpissue` | `[number]` | Create issue or view specific issue | GitHub MCP |
| `cpissues` | - | List issues assigned to you | GitHub MCP |
| `cpmerge` | `[number]` | Merge specified PR | GitHub MCP |
| `cpreview` | `[number]` | Review code changes in PR | GitHub MCP |

### Code Operations

| Alias | Parameters | Description | Auto-Approved Tools |
|-------|-----------|-------------|---------------------|
| `cptest` | `[pattern]` | Run tests (all or matching pattern) | `shell(npm)`, `shell(yarn)`, `shell(pytest)` |
| `cpfix` | `[file]` | Fix linting/formatting issues | `write`, `shell(npm)`, `shell(yarn)` |
| `cpbuild` | - | Build the project | `shell(npm)`, `shell(yarn)`, `shell(make)` |
| `cpexplain` | `[file]` | Explain code (current directory or specific file) | Read-only |
| `cpdocs` | `[file]` | Generate documentation for code | `write` |
| `cprefactor` | `[file]` | Suggest refactoring improvements | Read-only |

### Utility Operations

| Alias | Parameters | Description | Auto-Approved Tools |
|-------|-----------|-------------|---------------------|
| `cphelp` | - | Show this alias reference with examples | None |
| `cpdebug` | - | Help debug current error/issue | Read-only |
| `cpoptimize` | - | Suggest performance optimizations | Read-only |

## 💡 Usage Examples

```bash
# Git Operations
cpcommit                        # AI generates commit message
cpcommit "fix: resolve auth bug"  # Use custom message
cpbranch                        # AI suggests branch name
cpbranch "feature/new-api"      # Use custom branch name
cplog                           # Show recent commits with summaries

# GitHub Operations
cppr                            # Create PR for current branch
cppr 123                        # Check/review PR #123
cpprs                           # List all open PRs
cpissue                         # Create new issue interactively
cpmerge 123                     # Merge PR #123

# Code Operations
cptest                          # Run all tests
cptest "auth*"                  # Run tests matching pattern
cpfix                           # Fix all linting issues
cpfix src/utils/helper.ts       # Fix specific file
cpexplain                       # Explain current directory
cpexplain src/api/handler.ts    # Explain specific file

# Quick Commands
cpbuild                         # Build project
cpdebug                         # Help with current error
cpstatus                        # Git status summary
```

## 🔧 Requirements

- **GitHub Copilot CLI** (new standalone version)
  ```bash
  npm install -g @github/copilot
  ```
- **GitHub Copilot subscription** (Individual, Business, or Enterprise)
- **Shell**: Bash 4.0+, Zsh 5.0+, Fish 3.0+, or PowerShell 7.0+

## 🎨 Customization

### Adding Your Own Aliases

1. Edit the appropriate shell file:
   - Bash: `shells/bash/copilot-aliases.bash`
   - Zsh: `shells/zsh/copilot-aliases.zsh`
   - Fish: `shells/fish/copilot-aliases.fish`
   - PowerShell: `shells/powershell/copilot-aliases.ps1`

2. Add your function:
   ```bash
   # Bash/Zsh example
   cpmyalias() {
       local prompt="$1"
       copilot -p "${prompt:-default prompt here}" \
           --allow-tool 'shell(command)' \
           --deny-tool 'shell(dangerous-command)'
   }
   ```

3. Update completions in the corresponding `completions.*` file

4. **Test thoroughly** before committing!

### Modifying Security Scope

To adjust auto-approval scopes, edit the `--allow-tool` and `--deny-tool` flags in each function. See [Copilot CLI documentation](https://docs.github.com/en/copilot/concepts/agents/about-copilot-cli#allowed-tools) for tool specification syntax.

## 🤝 Contributing
See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## 📜 License

MIT License - see [LICENSE](LICENSE) for details.

## 🙏 Acknowledgments

- **GitHub Copilot CLI** team for the amazing tool
- **Oh My Zsh** community for alias patterns and plugin inspiration
- All contributors who help improve this collection

## 🔗 Related Projects

- [GitHub Copilot CLI](https://github.com/github/copilot-cli) - Official CLI tool
- [Oh My Zsh](https://ohmyz.sh/) - Zsh configuration framework
- [Oh My Bash](https://ohmybash.nntoan.com/) - Bash configuration framework
- [Fisher](https://github.com/jorgebucaran/fisher) - Fish plugin manager

---

**Star ⭐ this repo if you find it useful!**

Found a bug or have a suggestion? [Open an issue](https://github.com/ssulei7/awesome-copilot-aliases/issues)
