# Secrets Management Guide

This guide covers how to manage API keys, tokens, and other secrets without committing them to version control.

## Quick Setup

Create a secrets file that fish will source on startup:

```fish
touch ~/.config/fish/conf.d/secrets.fish
chmod 600 ~/.config/fish/conf.d/secrets.fish
```

Add your secrets:

```fish
# ~/.config/fish/conf.d/secrets.fish
set -gx API_NINJAS_KEY "your-api-key-here"
set -gx GITHUB_TOKEN "ghp_xxxxxxxxxxxx"
set -gx OPENAI_API_KEY "sk-xxxxxxxxxxxx"
```

**Important:** This file is in `conf.d/` which is symlinked from your dotfiles. To keep secrets out of git, either:

1. Add it to `.gitignore`
2. Create it at `~/.secrets.fish` instead (outside the dotfiles repo)

## Option 1: Plain Text File (Simplest)

### Outside Dotfiles Repo

```fish
# Create secrets file outside dotfiles
touch ~/.secrets.fish
chmod 600 ~/.secrets.fish

# Edit with your secrets
nvim ~/.secrets.fish
```

The `config.fish` already sources this file if it exists.

### Inside conf.d with .gitignore

Add to your `.gitignore`:

```
config/.config/fish/conf.d/secrets.fish
```

Then create the file normally.

## Option 2: Using `pass` (Recommended for Security)

[pass](https://www.passwordstore.org/) is a simple, GPG-encrypted password manager.

### Initial Setup

```bash
# Install pass
brew install pass gnupg

# Generate a GPG key if you don't have one
gpg --full-generate-key

# Initialize pass with your GPG key ID
pass init "your-email@example.com"
```

### Store Secrets

```bash
# Store API keys
pass insert api-ninjas/key
pass insert github/token
pass insert openai/api-key
```

### Use in Fish

Add to `~/.config/fish/conf.d/secrets.fish`:

```fish
# Load secrets from pass (requires GPG agent)
if command -q pass
    set -gx API_NINJAS_KEY (pass api-ninjas/key 2>/dev/null)
    set -gx GITHUB_TOKEN (pass github/token 2>/dev/null)
    set -gx OPENAI_API_KEY (pass openai/api-key 2>/dev/null)
end
```

### GPG Agent Configuration

To avoid repeated passphrase prompts, configure gpg-agent:

```bash
mkdir -p ~/.gnupg
cat > ~/.gnupg/gpg-agent.conf << 'EOF'
default-cache-ttl 3600
max-cache-ttl 86400
pinentry-program /opt/homebrew/bin/pinentry-mac
EOF

# Restart gpg-agent
gpgconf --kill gpg-agent
```

Install pinentry-mac for a native macOS passphrase dialog:

```bash
brew install pinentry-mac
```

## Option 3: macOS Keychain

Use the native macOS Keychain for secrets.

### Store a Secret

```bash
security add-generic-password -a "$USER" -s "api-ninjas-key" -w "your-api-key"
```

### Retrieve in Fish

```fish
set -gx API_NINJAS_KEY (security find-generic-password -s "api-ninjas-key" -w 2>/dev/null)
```

### Full Example

```fish
# ~/.config/fish/conf.d/secrets.fish
if test (uname -s) = Darwin
    set -gx API_NINJAS_KEY (security find-generic-password -s "api-ninjas-key" -w 2>/dev/null)
    set -gx GITHUB_TOKEN (security find-generic-password -s "github-token" -w 2>/dev/null)
end
```

## Option 4: 1Password CLI

If you use 1Password, their CLI integrates well with shell environments.

### Setup

```bash
brew install 1password-cli

# Sign in
op signin
```

### Use in Fish

```fish
set -gx API_NINJAS_KEY (op read "op://Private/API Ninjas/credential" 2>/dev/null)
```

## Environment Variables Used in This Repo

| Variable | Used By | Description |
|----------|---------|-------------|
| `API_NINJAS_KEY` | `inspiration/quote-fetch.sh` | API key for api-ninjas.com quotes |

## Security Best Practices

1. **Never commit secrets** - Always check `git diff` before committing
2. **Use restrictive permissions** - `chmod 600` on secret files
3. **Rotate keys regularly** - Especially if you suspect exposure
4. **Use different keys per environment** - Dev vs production
5. **Audit access** - Check which apps/scripts use each secret

## Troubleshooting

### GPG Agent Not Caching

```bash
# Check if agent is running
gpg-connect-agent /bye

# Restart agent
gpgconf --kill gpg-agent
gpg-agent --daemon
```

### Pass Not Finding Keys

```bash
# List all stored passwords
pass ls

# Check GPG key
gpg --list-secret-keys
```

### Keychain Access Denied

```bash
# Re-add with explicit access
security delete-generic-password -s "api-ninjas-key"
security add-generic-password -a "$USER" -s "api-ninjas-key" -w "your-key"
```
