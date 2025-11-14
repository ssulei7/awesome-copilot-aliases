#!/usr/bin/env fish
# Awesome Copilot CLI Aliases for Fish
# Source this file in your ~/.config/fish/config.fish

# ============================================================================
# GIT OPERATIONS
# ============================================================================

# Commit changes with AI-generated or custom message
function cpcommit
    set -l message (test -n "$argv[1]"; and echo "$argv[1]"; or echo "commit these changes with a descriptive message")
    copilot -p "$message" \
        --allow-tool 'shell(git)' \
        --deny-tool 'shell(git push -f)' \
        --deny-tool 'shell(git push --force)'
end

# Push changes to remote
function cppush
    copilot -p "push my changes to the remote repository" \
        --allow-tool 'shell(git)' \
        --deny-tool 'shell(git push -f)' \
        --deny-tool 'shell(git push --force)'
end

# Pull latest changes
function cppull
    copilot -p "pull the latest changes from remote and help resolve conflicts if any" \
        --allow-tool 'shell(git)'
end

# Revert commit
function cprevert
    set -l commit (test -n "$argv[1]"; and echo "$argv[1]"; or echo "HEAD")
    copilot -p "revert commit $commit" \
        --allow-tool 'shell(git)'
end

# Create and switch to new branch
function cpbranch
    set -l name (test -n "$argv[1]"; and echo "$argv[1]"; or echo "suggest a branch name based on recent changes")
    copilot -p "create and switch to a new branch: $name" \
        --allow-tool 'shell(git)'
end

# Show git log with summaries
function cplog
    copilot -p "show recent git commits with AI summaries" \
        --allow-tool 'shell(git log)' \
        --allow-tool 'shell(git show)'
end

# Summarize git status
function cpstatus
    copilot -p "summarize the current git status and suggest next actions" \
        --allow-tool 'shell(git status)' \
        --allow-tool 'shell(git diff)'
end

# ============================================================================
# GITHUB OPERATIONS
# ============================================================================

# Create or view PR
function cppr
    if test -n "$argv[1]"
        copilot -p "show me details and review PR #$argv[1]" --allow-tool 'github'
    else
        copilot -p "create a pull request for my current changes" --allow-tool 'github'
    end
end

# List open PRs
function cpprs
    copilot -p "list all open pull requests in this repository" --allow-tool 'github'
end

# Create or view issue
function cpissue
    if test -n "$argv[1]"
        copilot -p "show me details of issue #$argv[1]" --allow-tool 'github'
    else
        copilot -p "create a new issue in this repository" --allow-tool 'github'
    end
end

# List issues assigned to me
function cpissues
    copilot -p "list issues assigned to me in this repository" --allow-tool 'github'
end

# Merge PR
function cpmerge
    if test -z "$argv[1]"
        echo "Usage: cpmerge <PR_NUMBER>"
        return 1
    end
    copilot -p "merge pull request #$argv[1]" --allow-tool 'github'
end

# Review PR
function cpreview
    if test -z "$argv[1]"
        echo "Usage: cpreview <PR_NUMBER>"
        return 1
    end
    copilot -p "review the code changes in pull request #$argv[1] and provide feedback" --allow-tool 'github'
end

# ============================================================================
# CODE OPERATIONS
# ============================================================================

# Run tests
function cptest
    set -l pattern (test -n "$argv[1]"; and echo "$argv[1]"; or echo "all tests")
    copilot -p "run tests matching: $pattern" \
        --allow-tool 'shell(npm)' \
        --allow-tool 'shell(yarn)' \
        --allow-tool 'shell(pytest)' \
        --allow-tool 'shell(jest)' \
        --allow-tool 'shell(mocha)'
end

# Fix linting/formatting issues
function cpfix
    set -l file (test -n "$argv[1]"; and echo "$argv[1]"; or echo "all files")
    copilot -p "fix linting and formatting issues in: $file" \
        --allow-tool 'write' \
        --allow-tool 'shell(npm)' \
        --allow-tool 'shell(yarn)' \
        --allow-tool 'shell(eslint)' \
        --allow-tool 'shell(prettier)'
end

# Build project
function cpbuild
    copilot -p "build this project" \
        --allow-tool 'shell(npm)' \
        --allow-tool 'shell(yarn)' \
        --allow-tool 'shell(make)' \
        --allow-tool 'shell(cargo)' \
        --allow-tool 'shell(go)'
end

# Explain code
function cpexplain
    set -l target (test -n "$argv[1]"; and echo "$argv[1]"; or echo ".")
    copilot -p "explain the code in: $target"
end

# Generate documentation
function cpdocs
    set -l file (test -n "$argv[1]"; and echo "$argv[1]"; or echo "current codebase")
    copilot -p "generate documentation for: $file" \
        --allow-tool 'write'
end

# Suggest refactoring
function cprefactor
    set -l file (test -n "$argv[1]"; and echo "$argv[1]"; or echo "current file")
    copilot -p "suggest refactoring improvements for: $file"
end

# ============================================================================
# UTILITY OPERATIONS
# ============================================================================

# Show help
function cphelp
    echo '🤖 Awesome Copilot CLI Aliases

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

Use tab-completion: cp<TAB>'
end

# Debug help
function cpdebug
    copilot -p "help me debug the current error or issue I'm facing"
end

# Optimization suggestions
function cpoptimize
    copilot -p "analyze the code and suggest performance optimizations"
end
