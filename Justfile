# Template System Justfile
# Created by Matthew Green

home_dir := env_var('HOME')
bashrc_file := home_dir / ".bashrc"

template_dir := home_dir / ".template"
install_file := template_dir / "install.bash"

source := "source ~/.template/install.bash"

_default: help

# Show available commands
@help:
    just --list

# Install the template system
install:
    #!/usr/bin/env bash
    set -euo pipefail
    
    # Check if already installed
    if grep -Fq "{{source}}" "{{bashrc_file}}" 2>/dev/null; then
        echo "template is already installed"
        exit 0
    fi
    
    # Add installation comment and source line
    echo "{{source}}" >> "{{bashrc_file}}"
    
    echo "template installed!"
    echo "Run: source {{bashrc_file}} or restart your terminal"

# Uninstall the template system
uninstall:
    #!/usr/bin/env bash
    set -euo pipefail
    
    if [ ! -f "{{bashrc_file}}" ]; then
        echo "No bashrc found"
        exit 0
    fi
    
    # Check if not installed
    if ! grep -Fq "{{source}}" "{{bashrc_file}}" 2>/dev/null; then
        echo "template installation could not be found"
        exit 0
    fi
    
    # Remove the exact source content
    sed -i '\|{{source}}|d' "{{bashrc_file}}"
    
    echo "Template system uninstalled!"
    echo "Restart your terminal to apply changes"
