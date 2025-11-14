#!/usr/bin/env zsh
# Awesome Copilot CLI Aliases for Zsh
# Source this file in your ~/.zshrc

# ============================================================================
# GIT OPERATIONS
# ============================================================================

# Commit changes with AI-generated or custom message
cpcommit() {
    local message="${1:-commit these changes with a descriptive message}"
    copilot -p "$message" \
        --allow-tool 'shell(git)' \
        --deny-tool 'shell(git push -f)' \
        --deny-tool 'shell(git push --force)'
}

# Push changes to remote
cppush() {
    copilot -p "push my changes to the remote repository" \
        --allow-tool 'shell(git)' \
        --deny-tool 'shell(git push -f)' \
        --deny-tool 'shell(git push --force)'
}

# Pull latest changes
cppull() {
    copilot -p "pull the latest changes from remote and help resolve conflicts if any" \
        --allow-tool 'shell(git)'
}

# Revert commit
cprevert() {
    local commit="${1:-HEAD}"
    copilot -p "revert commit $commit" \
        --allow-tool 'shell(git)'
}

# Create and switch to new branch
cpbranch() {
    local name="${1:-suggest a branch name based on recent changes}"
    copilot -p "create and switch to a new branch: $name" \
        --allow-tool 'shell(git)'
}

# Show git log with summaries
cplog() {
    copilot -p "show recent git commits with AI summaries" \
        --allow-tool 'shell(git log)' \
        --allow-tool 'shell(git show)'
}

# Summarize git status
cpstatus() {
    copilot -p "summarize the current git status and suggest next actions" \
        --allow-tool 'shell(git status)' \
        --allow-tool 'shell(git diff)'
}

# ============================================================================
# GITHUB OPERATIONS
# ============================================================================

# Create or view PR
cppr() {
    if [ -n "$1" ]; then
        copilot -p "show me details and review PR #$1" --allow-tool 'github'
    else
        copilot -p "create a pull request for my current changes" --allow-tool 'github'
    fi
}

# List open PRs
cpprs() {
    copilot -p "list all open pull requests in this repository" --allow-tool 'github'
}

# Create or view issue
cpissue() {
    if [ -n "$1" ]; then
        copilot -p "show me details of issue #$1" --allow-tool 'github'
    else
        copilot -p "create a new issue in this repository" --allow-tool 'github'
    fi
}

# List issues assigned to me
cpissues() {
    copilot -p "list issues assigned to me in this repository" --allow-tool 'github'
}

# Merge PR
cpmerge() {
    if [ -z "$1" ]; then
        echo "Usage: cpmerge <PR_NUMBER>"
        return 1
    fi
    copilot -p "merge pull request #$1" --allow-tool 'github'
}

# Review PR
cpreview() {
    if [ -z "$1" ]; then
        echo "Usage: cpreview <PR_NUMBER>"
        return 1
    fi
    copilot -p "review the code changes in pull request #$1 and provide feedback" --allow-tool 'github'
}

# ============================================================================
# CODE OPERATIONS
# ============================================================================

# Run tests
cptest() {
    local pattern="${1:-all tests}"
    copilot -p "run tests matching: $pattern" \
        --allow-tool 'shell(npm)' \
        --allow-tool 'shell(yarn)' \
        --allow-tool 'shell(pytest)' \
        --allow-tool 'shell(jest)' \
        --allow-tool 'shell(mocha)'
}

# Fix linting/formatting issues
cpfix() {
    local file="${1:-all files}"
    copilot -p "fix linting and formatting issues in: $file" \
        --allow-tool 'write' \
        --allow-tool 'shell(npm)' \
        --allow-tool 'shell(yarn)' \
        --allow-tool 'shell(eslint)' \
        --allow-tool 'shell(prettier)'
}

# Build project
cpbuild() {
    copilot -p "build this project" \
        --allow-tool 'shell(npm)' \
        --allow-tool 'shell(yarn)' \
        --allow-tool 'shell(make)' \
        --allow-tool 'shell(cargo)' \
        --allow-tool 'shell(go)'
}

# Explain code
cpexplain() {
    local target="${1:-.}"
    copilot -p "explain the code in: $target"
}

# Generate documentation
cpdocs() {
    local file="${1:-current codebase}"
    copilot -p "generate documentation for: $file" \
        --allow-tool 'write'
}

# Suggest refactoring
cprefactor() {
    local file="${1:-current file}"
    copilot -p "suggest refactoring improvements for: $file"
}

# ============================================================================
# UTILITY OPERATIONS
# ============================================================================

# Show help
cphelp() {
    cat << 'EOF'
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
EOF
}

# Debug help
cpdebug() {
    copilot -p "help me debug the current error or issue I'm facing"
}

# Optimization suggestions
cpoptimize() {
    copilot -p "analyze the code and suggest performance optimizations"
}
