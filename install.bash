# Custom completion function for template command
_template() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local recipes

    # Get recipes from the template justfile
    recipes=$(just --justfile ~/.template/Justfile --summary 2>/dev/null)

    # Generate completions
    COMPREPLY=( $(compgen -W "$recipes" -- "$cur") )
}

alias template='just --justfile ~/.template/Justfile'
complete -F _template template
