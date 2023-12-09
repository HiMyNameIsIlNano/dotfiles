source-item() {
	local item_to_source="$1"
	# source-file-if-exist-and-non-zero
	[[ -s ${item_to_source} ]] && source "${item_to_source}"
}

source-plugin() {
	local command_to_source="$1"
	local plugin_to_source="$2"

	# source-file-if-command-exist
	[[ $(command -v "${command_to_source}") ]] && source <(${command_to_source} ${plugin_to_source})
}

[ ! -d ~/.bashrc.d ] && mkdir -p ~/.bashrc.d
[ -f ~/.Xresources ] && xrdb ~/.Xresources

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/dm_exports ~/.bashrc.d/dm_alias; do
		if [ -f "$rc" ]; then
            . "$rc"
		fi
	done
fi

if [ "$TERM" != "linux" ]; then
    [[ -s ${MY_DEV}/pureline/pureline ]] && [[ -s ~/.pureline.conf ]] && . ${MY_DEV}/pureline/pureline ~/.pureline.conf
fi

export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# Bash plugins
source-item "${MY_DEV}/git-autocompletion/contrib/completion/git-completion.bash"
source-item "${MY_DEV}/maven-bash-completion/bash_completion.bash"
source-item "${SDKMAN_DIR}/bin/sdkman-init.sh"

# Load other plugins
source-plugin kubectl 'completion bash'
source-plugin ng 'completion script'

export IDEA_JDK="$SDKMAN_CANDIDATES_DIR/java/current"
