# http://blog.thelinuxkid.com/2013/06/automatically-start-tmux-on-ssh.html
# This should always be run last either in .bashrc or as a script in .bashrc.d
if [[ -n "$SSH_CLIENT" ]]; then
	if [[ -z "$TMUX" ]]; then
		tmux has-session &> /dev/null
		if [ $? -eq 1 ]; then
			exec tmux new "cat /var/run/motd.dynamic; $SHELL -l";
			exit;
		else
			exec tmux attach;
			exit;
		fi;
	fi;
fi;
