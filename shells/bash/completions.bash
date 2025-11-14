#!/usr/bin/env bash
# Bash completions for Awesome Copilot CLI Aliases

# Main completion function
_copilot_aliases_completion() {
    local cur prev aliases
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    # List of all aliases
    aliases="cpcommit cppush cppull cprevert cpbranch cplog cpstatus cppr cpprs cpissue cpissues cpmerge cpreview cptest cpfix cpbuild cpexplain cpdocs cprefactor cphelp cpdebug cpoptimize"

    # Complete alias names when typing cp*
    if [[ ${cur} == cp* ]]; then
        COMPREPLY=( $(compgen -W "${aliases}" -- ${cur}) )
        return 0
    fi

    # Context-aware completions for specific aliases
    case "${prev}" in
        cpexplain|cpfix|cpdocs|cprefactor)
            # Complete file paths
            COMPREPLY=( $(compgen -f -- ${cur}) )
            return 0
            ;;
        cptest)
            # Suggest test patterns
            COMPREPLY=( $(compgen -W "*.test.* *.spec.* test/* tests/* __tests__/*" -- ${cur}) )
            return 0
            ;;
        cpmerge|cpreview|cppr|cpissue)
            # Could integrate with gh cli for PR/issue numbers
            # For now, just complete numbers
            if command -v gh &> /dev/null; then
                # Try to get PR numbers from gh cli
                local prs=$(gh pr list --json number --jq '.[].number' 2>/dev/null)
                if [ -n "$prs" ]; then
                    COMPREPLY=( $(compgen -W "$prs" -- ${cur}) )
                fi
            fi
            return 0
            ;;
        cprevert)
            # Complete with git commit refs
            if command -v git &> /dev/null; then
                local commits=$(git log --oneline -n 10 --format="%h" 2>/dev/null)
                COMPREPLY=( $(compgen -W "HEAD ${commits}" -- ${cur}) )
            fi
            return 0
            ;;
        cpbranch)
            # No completion needed - can be any branch name
            return 0
            ;;
    esac
}

# Register completions for all cp* functions
for cmd in cpcommit cppush cppull cprevert cpbranch cplog cpstatus cppr cpprs cpissue cpissues cpmerge cpreview cptest cpfix cpbuild cpexplain cpdocs cprefactor cphelp cpdebug cpoptimize; do
    complete -F _copilot_aliases_completion "$cmd"
done

# Also complete when typing 'cp' to show all available aliases
complete -W "cpcommit cppush cppull cprevert cpbranch cplog cpstatus cppr cpprs cpissue cpissues cpmerge cpreview cptest cpfix cpbuild cpexplain cpdocs cprefactor cphelp cpdebug cpoptimize" cp
