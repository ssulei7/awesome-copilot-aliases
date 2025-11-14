#!/usr/bin/env bash
# Test script for Awesome Copilot CLI Aliases
# Tests that all aliases are properly defined across all shells

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
FAILED=0
PASSED=0

echo -e "${BLUE}🧪 Testing Awesome Copilot CLI Aliases${NC}\n"

# Expected aliases
EXPECTED_ALIASES=(
    cpcommit cppush cppull cprevert cpbranch cplog cpstatus
    cppr cpprs cpissue cpissues cpmerge cpreview
    cptest cpfix cpbuild cpexplain cpdocs cprefactor
    cphelp cpdebug cpoptimize
)

# Test Bash
test_bash() {
    echo -e "${BLUE}Testing Bash aliases...${NC}"
    
    if ! command -v bash &> /dev/null; then
        echo -e "${YELLOW}⚠ Bash not found, skipping${NC}\n"
        return
    fi
    
    # Source the aliases
    if bash -c "source '$SCRIPT_DIR/../shells/bash/copilot-aliases.bash' 2>/dev/null"; then
        echo -e "${GREEN}✓ Bash aliases loaded${NC}"
        ((PASSED++))
    else
        echo -e "${RED}✗ Failed to load Bash aliases${NC}"
        ((FAILED++))
        return
    fi
    
    # Check each alias exists
    for alias in "${EXPECTED_ALIASES[@]}"; do
        if bash -c "source '$SCRIPT_DIR/../shells/bash/copilot-aliases.bash'; type $alias &>/dev/null"; then
            echo -e "${GREEN}  ✓ $alias${NC}"
            ((PASSED++))
        else
            echo -e "${RED}  ✗ $alias not found${NC}"
            ((FAILED++))
        fi
    done
    
    echo ""
}

# Test Zsh
test_zsh() {
    echo -e "${BLUE}Testing Zsh aliases...${NC}"
    
    if ! command -v zsh &> /dev/null; then
        echo -e "${YELLOW}⚠ Zsh not found, skipping${NC}\n"
        return
    fi
    
    # Source the aliases
    if zsh -c "source '$SCRIPT_DIR/../shells/zsh/copilot-aliases.zsh' 2>/dev/null"; then
        echo -e "${GREEN}✓ Zsh aliases loaded${NC}"
        ((PASSED++))
    else
        echo -e "${RED}✗ Failed to load Zsh aliases${NC}"
        ((FAILED++))
        return
    fi
    
    # Check each alias exists
    for alias in "${EXPECTED_ALIASES[@]}"; do
        if zsh -c "source '$SCRIPT_DIR/../shells/zsh/copilot-aliases.zsh'; type $alias &>/dev/null"; then
            echo -e "${GREEN}  ✓ $alias${NC}"
            ((PASSED++))
        else
            echo -e "${RED}  ✗ $alias not found${NC}"
            ((FAILED++))
        fi
    done
    
    echo ""
}

# Test Fish
test_fish() {
    echo -e "${BLUE}Testing Fish aliases...${NC}"
    
    if ! command -v fish &> /dev/null; then
        echo -e "${YELLOW}⚠ Fish not found, skipping${NC}\n"
        return
    fi
    
    # Source the aliases
    if fish -c "source '$SCRIPT_DIR/../shells/fish/copilot-aliases.fish' 2>/dev/null"; then
        echo -e "${GREEN}✓ Fish aliases loaded${NC}"
        ((PASSED++))
    else
        echo -e "${RED}✗ Failed to load Fish aliases${NC}"
        ((FAILED++))
        return
    fi
    
    # Check each alias exists
    for alias in "${EXPECTED_ALIASES[@]}"; do
        if fish -c "source '$SCRIPT_DIR/../shells/fish/copilot-aliases.fish'; type -q $alias"; then
            echo -e "${GREEN}  ✓ $alias${NC}"
            ((PASSED++))
        else
            echo -e "${RED}  ✗ $alias not found${NC}"
            ((FAILED++))
        fi
    done
    
    echo ""
}

# Test PowerShell
test_powershell() {
    echo -e "${BLUE}Testing PowerShell aliases...${NC}"
    
    if ! command -v pwsh &> /dev/null; then
        echo -e "${YELLOW}⚠ PowerShell not found, skipping${NC}\n"
        return
    fi
    
    # Source the aliases
    if pwsh -NoProfile -Command ". '$SCRIPT_DIR/../shells/powershell/copilot-aliases.ps1'" 2>/dev/null; then
        echo -e "${GREEN}✓ PowerShell aliases loaded${NC}"
        ((PASSED++))
    else
        echo -e "${RED}✗ Failed to load PowerShell aliases${NC}"
        ((FAILED++))
        return
    fi
    
    # Check each alias exists
    for alias in "${EXPECTED_ALIASES[@]}"; do
        if pwsh -NoProfile -Command ". '$SCRIPT_DIR/../shells/powershell/copilot-aliases.ps1'; Get-Command $alias -ErrorAction SilentlyContinue" &>/dev/null; then
            echo -e "${GREEN}  ✓ $alias${NC}"
            ((PASSED++))
        else
            echo -e "${RED}  ✗ $alias not found${NC}"
            ((FAILED++))
        fi
    done
    
    echo ""
}

# Run tests
test_bash
test_zsh
test_fish
test_powershell

# Summary
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}Passed: $PASSED${NC}"
echo -e "${RED}Failed: $FAILED${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}✗ Some tests failed${NC}"
    exit 1
fi
