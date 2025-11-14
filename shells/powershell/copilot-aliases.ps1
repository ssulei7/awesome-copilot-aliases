# Awesome Copilot CLI Aliases for PowerShell
# Add to your PowerShell profile: notepad $PROFILE

# ============================================================================
# GIT OPERATIONS
# ============================================================================

# Commit changes with AI-generated or custom message
function cpcommit {
    param([string]$message = "commit these changes with a descriptive message")
    copilot -p $message `
        --allow-tool 'shell(git)' `
        --deny-tool 'shell(git push -f)' `
        --deny-tool 'shell(git push --force)'
}

# Push changes to remote
function cppush {
    copilot -p "push my changes to the remote repository" `
        --allow-tool 'shell(git)' `
        --deny-tool 'shell(git push -f)' `
        --deny-tool 'shell(git push --force)'
}

# Pull latest changes
function cppull {
    copilot -p "pull the latest changes from remote and help resolve conflicts if any" `
        --allow-tool 'shell(git)'
}

# Revert commit
function cprevert {
    param([string]$commit = "HEAD")
    copilot -p "revert commit $commit" `
        --allow-tool 'shell(git)'
}

# Create and switch to new branch
function cpbranch {
    param([string]$name = "suggest a branch name based on recent changes")
    copilot -p "create and switch to a new branch: $name" `
        --allow-tool 'shell(git)'
}

# Show git log with summaries
function cplog {
    copilot -p "show recent git commits with AI summaries" `
        --allow-tool 'shell(git log)' `
        --allow-tool 'shell(git show)'
}

# Summarize git status
function cpstatus {
    copilot -p "summarize the current git status and suggest next actions" `
        --allow-tool 'shell(git status)' `
        --allow-tool 'shell(git diff)'
}

# ============================================================================
# GITHUB OPERATIONS
# ============================================================================

# Create or view PR
function cppr {
    param([string]$number = "")
    if ($number) {
        copilot -p "show me details and review PR #$number" --allow-tool 'github'
    } else {
        copilot -p "create a pull request for my current changes" --allow-tool 'github'
    }
}

# List open PRs
function cpprs {
    copilot -p "list all open pull requests in this repository" --allow-tool 'github'
}

# Create or view issue
function cpissue {
    param([string]$number = "")
    if ($number) {
        copilot -p "show me details of issue #$number" --allow-tool 'github'
    } else {
        copilot -p "create a new issue in this repository" --allow-tool 'github'
    }
}

# List issues assigned to me
function cpissues {
    copilot -p "list issues assigned to me in this repository" --allow-tool 'github'
}

# Merge PR
function cpmerge {
    param([Parameter(Mandatory=$true)][string]$number)
    copilot -p "merge pull request #$number" --allow-tool 'github'
}

# Review PR
function cpreview {
    param([Parameter(Mandatory=$true)][string]$number)
    copilot -p "review the code changes in pull request #$number and provide feedback" --allow-tool 'github'
}

# ============================================================================
# CODE OPERATIONS
# ============================================================================

# Run tests
function cptest {
    param([string]$pattern = "all tests")
    copilot -p "run tests matching: $pattern" `
        --allow-tool 'shell(npm)' `
        --allow-tool 'shell(yarn)' `
        --allow-tool 'shell(pytest)' `
        --allow-tool 'shell(jest)' `
        --allow-tool 'shell(mocha)'
}

# Fix linting/formatting issues
function cpfix {
    param([string]$file = "all files")
    copilot -p "fix linting and formatting issues in: $file" `
        --allow-tool 'write' `
        --allow-tool 'shell(npm)' `
        --allow-tool 'shell(yarn)' `
        --allow-tool 'shell(eslint)' `
        --allow-tool 'shell(prettier)'
}

# Build project
function cpbuild {
    copilot -p "build this project" `
        --allow-tool 'shell(npm)' `
        --allow-tool 'shell(yarn)' `
        --allow-tool 'shell(make)' `
        --allow-tool 'shell(cargo)' `
        --allow-tool 'shell(go)'
}

# Explain code
function cpexplain {
    param([string]$target = ".")
    copilot -p "explain the code in: $target"
}

# Generate documentation
function cpdocs {
    param([string]$file = "current codebase")
    copilot -p "generate documentation for: $file" `
        --allow-tool 'write'
}

# Suggest refactoring
function cprefactor {
    param([string]$file = "current file")
    copilot -p "suggest refactoring improvements for: $file"
}

# ============================================================================
# UTILITY OPERATIONS
# ============================================================================

# Show help
function cphelp {
    Write-Host @"
🤖 Awesome Copilot CLI Aliases

Git Operations:
  cpcommit [message]   - Commit with AI or custom message
  cppush              - Push to remote
  cppull              - Pull from remote
  cprevert [commit]   - Revert commit
  cpbranch [name]     - Create new branch
  cplog               - Show git log with summaries
  cpstatus            - Summarize git status

GitHub Operations:
  cppr [number]       - Create or view PR
  cpprs               - List open PRs
  cpissue [number]    - Create or view issue
  cpissues            - List your issues
  cpmerge <number>    - Merge PR
  cpreview <number>   - Review PR

Code Operations:
  cptest [pattern]    - Run tests
  cpfix [file]        - Fix linting issues
  cpbuild             - Build project
  cpexplain [file]    - Explain code
  cpdocs [file]       - Generate docs
  cprefactor [file]   - Suggest refactoring

Utility:
  cphelp              - Show this help
  cpdebug             - Debug current issue
  cpoptimize          - Suggest optimizations

Use tab-completion: cp<TAB>
"@
}

# Debug help
function cpdebug {
    copilot -p "help me debug the current error or issue I'm facing"
}

# Optimization suggestions
function cpoptimize {
    copilot -p "analyze the code and suggest performance optimizations"
}

# Export functions
Export-ModuleMember -Function @(
    'cpcommit', 'cppush', 'cppull', 'cprevert', 'cpbranch', 'cplog', 'cpstatus',
    'cppr', 'cpprs', 'cpissue', 'cpissues', 'cpmerge', 'cpreview',
    'cptest', 'cpfix', 'cpbuild', 'cpexplain', 'cpdocs', 'cprefactor',
    'cphelp', 'cpdebug', 'cpoptimize'
)
