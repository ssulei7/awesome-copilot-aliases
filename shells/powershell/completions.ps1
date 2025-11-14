# PowerShell completions for Awesome Copilot CLI Aliases

# Helper function to get PR numbers
function Get-PRNumbers {
    if (Get-Command gh -ErrorAction SilentlyContinue) {
        $prs = gh pr list --json number,title --jq '.[] | "\(.number)\t\(.title)"' 2>$null
        if ($prs) {
            return $prs -split "`n" | ForEach-Object {
                $parts = $_ -split "`t"
                [System.Management.Automation.CompletionResult]::new($parts[0], $parts[0], 'ParameterValue', $parts[1])
            }
        }
    }
    return @()
}

# Helper function to get issue numbers
function Get-IssueNumbers {
    if (Get-Command gh -ErrorAction SilentlyContinue) {
        $issues = gh issue list --json number,title --jq '.[] | "\(.number)\t\(.title)"' 2>$null
        if ($issues) {
            return $issues -split "`n" | ForEach-Object {
                $parts = $_ -split "`t"
                [System.Management.Automation.CompletionResult]::new($parts[0], $parts[0], 'ParameterValue', $parts[1])
            }
        }
    }
    return @()
}

# Helper function to get recent commits
function Get-RecentCommits {
    if (Get-Command git -ErrorAction SilentlyContinue) {
        $commits = git log --oneline -n 20 --format='%h %s' 2>$null
        if ($commits) {
            return $commits -split "`n" | ForEach-Object {
                $parts = $_ -split ' ', 2
                [System.Management.Automation.CompletionResult]::new($parts[0], $parts[0], 'ParameterValue', $parts[1])
            }
        }
    }
    return @([System.Management.Automation.CompletionResult]::new('HEAD', 'HEAD', 'ParameterValue', 'Most recent commit'))
}

# Register argument completers for each function

# Git operations
Register-ArgumentCompleter -CommandName cpcommit -ParameterName message -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    @([System.Management.Automation.CompletionResult]::new('', '', 'ParameterValue', 'AI will generate message'))
}

Register-ArgumentCompleter -CommandName cprevert -ParameterName commit -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    Get-RecentCommits | Where-Object { $_.CompletionText -like "$wordToComplete*" }
}

Register-ArgumentCompleter -CommandName cpbranch -ParameterName name -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    @([System.Management.Automation.CompletionResult]::new('', '', 'ParameterValue', 'AI will suggest name'))
}

# GitHub operations
Register-ArgumentCompleter -CommandName cppr -ParameterName number -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    Get-PRNumbers | Where-Object { $_.CompletionText -like "$wordToComplete*" }
}

Register-ArgumentCompleter -CommandName cpissue -ParameterName number -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    Get-IssueNumbers | Where-Object { $_.CompletionText -like "$wordToComplete*" }
}

Register-ArgumentCompleter -CommandName cpmerge -ParameterName number -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    Get-PRNumbers | Where-Object { $_.CompletionText -like "$wordToComplete*" }
}

Register-ArgumentCompleter -CommandName cpreview -ParameterName number -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    Get-PRNumbers | Where-Object { $_.CompletionText -like "$wordToComplete*" }
}

# Code operations with file completions
Register-ArgumentCompleter -CommandName cptest -ParameterName pattern -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    $testPatterns = @('*.test.*', '*.spec.*', 'test/*', 'tests/*', '__tests__/*')
    $testPatterns | Where-Object { $_ -like "$wordToComplete*" } | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "Test pattern: $_")
    }
}

Register-ArgumentCompleter -CommandName cpfix -ParameterName file -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    Get-ChildItem -File -Recurse -Filter "$wordToComplete*" -ErrorAction SilentlyContinue | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_.FullName, $_.Name, 'ParameterValue', $_.FullName)
    }
}

Register-ArgumentCompleter -CommandName cpexplain -ParameterName target -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    Get-ChildItem -Filter "$wordToComplete*" -ErrorAction SilentlyContinue | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_.FullName, $_.Name, 'ParameterValue', $_.FullName)
    }
}

Register-ArgumentCompleter -CommandName cpdocs -ParameterName file -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    Get-ChildItem -Filter "$wordToComplete*" -ErrorAction SilentlyContinue | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_.FullName, $_.Name, 'ParameterValue', $_.FullName)
    }
}

Register-ArgumentCompleter -CommandName cprefactor -ParameterName file -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    Get-ChildItem -File -Filter "$wordToComplete*" -ErrorAction SilentlyContinue | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_.FullName, $_.Name, 'ParameterValue', $_.FullName)
    }
}

# Complete 'cp' prefix to show all available aliases
Register-ArgumentCompleter -CommandName cp -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    
    $aliases = @(
        @{Name='cpcommit'; Description='Commit with AI or custom message'},
        @{Name='cppush'; Description='Push to remote'},
        @{Name='cppull'; Description='Pull from remote'},
        @{Name='cprevert'; Description='Revert commit'},
        @{Name='cpbranch'; Description='Create new branch'},
        @{Name='cplog'; Description='Show git log with summaries'},
        @{Name='cpstatus'; Description='Summarize git status'},
        @{Name='cppr'; Description='Create or view PR'},
        @{Name='cpprs'; Description='List open PRs'},
        @{Name='cpissue'; Description='Create or view issue'},
        @{Name='cpissues'; Description='List your issues'},
        @{Name='cpmerge'; Description='Merge PR'},
        @{Name='cpreview'; Description='Review PR'},
        @{Name='cptest'; Description='Run tests'},
        @{Name='cpfix'; Description='Fix linting issues'},
        @{Name='cpbuild'; Description='Build project'},
        @{Name='cpexplain'; Description='Explain code'},
        @{Name='cpdocs'; Description='Generate docs'},
        @{Name='cprefactor'; Description='Suggest refactoring'},
        @{Name='cphelp'; Description='Show help'},
        @{Name='cpdebug'; Description='Debug current issue'},
        @{Name='cpoptimize'; Description='Suggest optimizations'}
    )
    
    $aliases | Where-Object { $_.Name -like "$wordToComplete*" } | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_.Name, $_.Name, 'Command', $_.Description)
    }
}

Write-Host "✓ Copilot CLI alias completions loaded" -ForegroundColor Green
