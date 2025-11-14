#!/usr/bin/env fish
# Fish completions for Awesome Copilot CLI Aliases

# Helper function to get PR numbers
function __copilot_get_prs
    if command -v gh >/dev/null 2>&1
        gh pr list --json number,title --jq '.[] | "\(.number)\t\(.title)"' 2>/dev/null
    end
end

# Helper function to get issue numbers
function __copilot_get_issues
    if command -v gh >/dev/null 2>&1
        gh issue list --json number,title --jq '.[] | "\(.number)\t\(.title)"' 2>/dev/null
    end
end

# Helper function to get recent commits
function __copilot_get_commits
    if command -v git >/dev/null 2>&1
        git log --oneline -n 20 --format='%h\t%s' 2>/dev/null
    end
end

# Git operations
complete -c cpcommit -d "Commit with AI or custom message" -x
complete -c cppush -d "Push to remote"
complete -c cppull -d "Pull from remote"
complete -c cprevert -d "Revert commit" -xa "HEAD (__copilot_get_commits)"
complete -c cpbranch -d "Create new branch" -x
complete -c cplog -d "Show git log with summaries"
complete -c cpstatus -d "Summarize git status"

# GitHub operations
complete -c cppr -d "Create or view PR" -xa "(__copilot_get_prs)"
complete -c cpprs -d "List open PRs"
complete -c cpissue -d "Create or view issue" -xa "(__copilot_get_issues)"
complete -c cpissues -d "List your issues"
complete -c cpmerge -d "Merge PR" -xa "(__copilot_get_prs)" -r
complete -c cpreview -d "Review PR" -xa "(__copilot_get_prs)" -r

# Code operations
complete -c cptest -d "Run tests" -x -a "*.test.* *.spec.*"
complete -c cpfix -d "Fix linting issues" -F
complete -c cpbuild -d "Build project"
complete -c cpexplain -d "Explain code" -F
complete -c cpdocs -d "Generate docs" -F
complete -c cprefactor -d "Suggest refactoring" -F

# Utility operations
complete -c cphelp -d "Show help"
complete -c cpdebug -d "Debug current issue"
complete -c cpoptimize -d "Suggest optimizations"

# Complete 'cp' to show all aliases
complete -c cp -xa "cpcommit cppush cppull cprevert cpbranch cplog cpstatus cppr cpprs cpissue cpissues cpmerge cpreview cptest cpfix cpbuild cpexplain cpdocs cprefactor cphelp cpdebug cpoptimize"
