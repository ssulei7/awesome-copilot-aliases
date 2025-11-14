# Contributing to Awesome Copilot CLI Aliases

Thank you for your interest in contributing! This project thrives on community input.

## How to Contribute

### Reporting Issues

- **Check existing issues** before creating a new one
- **Include details**: shell version, OS, Copilot CLI version
- **Provide examples**: commands that failed, expected vs actual behavior

### Suggesting New Aliases

1. **Describe the use case** - What problem does it solve?
2. **Propose the command** - What would the alias do?
3. **Consider security** - What tools should be auto-approved?
4. **Check for duplicates** - Does a similar alias exist?

### Submitting Code

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/new-alias`
3. **Make your changes** to the appropriate shell files:
   - `shells/bash/copilot-aliases.bash`
   - `shells/zsh/copilot-aliases.zsh`
   - `shells/fish/copilot-aliases.fish`
   - `shells/powershell/copilot-aliases.ps1`
4. **Add completions** in corresponding `completions.*` files
5. **Test thoroughly** in your shell
6. **Update README.md** with alias documentation
7. **Commit with clear messages**: `git commit -m "feat: add cpmyalias for X"`
8. **Push and create PR**: `git push origin feature/new-alias`

### Alias Design Guidelines

✅ **DO:**
- Use the `cp` prefix for consistency
- Include parameter support where useful
- Specify explicit `--allow-tool` permissions
- Add `--deny-tool` for dangerous operations
- Provide clear, actionable prompts
- Support all four shells (Bash, Zsh, Fish, PowerShell)
- Document with examples in README

❌ **DON'T:**
- Use `--allow-all-tools` (security risk)
- Create aliases that modify files without review
- Allow destructive git operations (force push, hard reset)
- Duplicate existing alias functionality
- Use obscure abbreviations

### Testing Your Changes

```bash
# Test in your shell
source shells/bash/copilot-aliases.bash  # or your shell's file
cpmyalias "test prompt"

# Test tab completion
cpmy<TAB>

# Test with different parameters
cpmyalias
cpmyalias "custom prompt"
```

### Code Style

- **Bash/Zsh**: Follow existing function structure
- **Fish**: Use Fish idioms (`test` vs `[`, etc.)
- **PowerShell**: Use approved verbs and PascalCase for functions
- **Comments**: Explain complex logic, not obvious code
- **Formatting**: Match existing indentation (4 spaces)

### Security Review

All PRs with new aliases will be reviewed for:
- Appropriate tool permissions
- Dangerous command denial
- Clear user prompts
- Unexpected side effects

### Questions?

Open an issue with the `question` label or start a discussion.

## Code of Conduct

- Be respectful and inclusive
- Focus on constructive feedback
- Help others learn and grow
- No spam, self-promotion, or off-topic content

---

**Thank you for making this project better!** 🚀
