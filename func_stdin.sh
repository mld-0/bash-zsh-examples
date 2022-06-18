#!/usr/bin/env sh
#   vim: set tabstop=4 modeline modelines=10:
#   vim: set foldlevel=2 foldcolumn=2 foldmethod=marker:
#	{{{2
#	Ongoings:
#	{{{
#	Ongoing: 2022-06-19T01:49:48AEST bash-zsh-examples/func_stdin, change what is captured from a subshell (stdout being default? stdin being available as 'cat -')
#	Ongoing: 2022-06-19T01:50:49AEST bash-zsh-examples/func_stdin, if capturing stdin is a simple as 'cat -', why <are/have> we used more <extravagant> methods (that have failed (at some point (writing new vimh?), prompting this example))?
#	}}}

main() {
	#	{{{
	local func_name=""
	if [[ -n "${ZSH_VERSION:-}" ]]; then 
		func_name=${funcstack[1]:-}
	elif [[ -n "${BASH_VERSION:-}" ]]; then
		func_name="${FUNCNAME[0]:-}"
	else
		printf "%s\n" "warning, func_name unset, non zsh/bash shell" > /dev/stderr
	fi
	#	}}}
	local pass_str=`seq 0 10 | tr '\n' ' ' | sed 's/\s*$//'`
	result=$( echo "$pass_str" | recieve_stdin )
	echo "$func_name, result=($result)"
}

recieve_stdin() {
	#	{{{
	local func_name=""
	if [[ -n "${ZSH_VERSION:-}" ]]; then 
		func_name=${funcstack[1]:-}
	elif [[ -n "${BASH_VERSION:-}" ]]; then
		func_name="${FUNCNAME[0]:-}"
	else
		printf "%s\n" "warning, func_name unset, non zsh/bash shell" > /dev/stderr
	fi
	#	}}}
	#	Use 'cat -' to make it explicit we are reading from stdin
	local input_str=$( cat - )
	echo "$func_name, input_str=($input_str)" > /dev/stderr

	#	Attempt to read stdin a second time produces nothing
	local input_str_2=$( cat - )
	echo "$func_name, input_str_2=($input_str_2)" > /dev/stderr

	#	Function output
	echo "$input_str" | tac
}

check_sourced=1
#	{{{
if [[ -n "${ZSH_VERSION:-}" ]]; then 
	if [[ ! -n ${(M)zsh_eval_context:#file} ]]; then
		check_sourced=0
	fi
elif [[ -n "${BASH_VERSION:-}" ]]; then
	(return 0 2>/dev/null) && check_sourced=1 || check_sourced=0
else
	echo "error, check_sourced, non-zsh/bash" > /dev/stderr
	exit 2
fi
#	}}}
if [[ "$check_sourced" -eq 0 ]]; then
	main "$@"
fi

