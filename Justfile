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

_source:
    #!/usr/bin/env bash
    read -p "Do you want to use your updated ~/.bashrc file now? [y/n]: " -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        source "{{bashrc_file}}"
        echo "Bashrc sourced! The 'template' command is now available."
    else
        echo "No problem! To activate later, run: source {{bashrc_file}}"
        echo "Or restart your terminal."
    fi

# Install the template system
[confirm("Do you want to install the template system? This will modify your ~/.bashrc file. [y/n]:")]
install: && _source
    #!/usr/bin/env bash
    set -euo pipefail
    
    # Check if already installed
    if grep -Fq "{{source}}" "{{bashrc_file}}" 2>/dev/null; then
        echo "template is already installed"
        exit 1
    fi
    
    # Add installation comment and source line
    echo "{{source}}" >> "{{bashrc_file}}"
    
    echo "template installed!"
    echo ""
    echo "To activate the 'template' command, you can either:"
    echo "  1. Let the next prompt source it for you"
    echo "  2. Manually run: source {{bashrc_file}}"
    echo "  3. Restart your terminal"

# Uninstall the template system
[confirm("Do you want to uninstall the template system? This will remove the entry from your ~/.bashrc file. [y/n]:")]
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