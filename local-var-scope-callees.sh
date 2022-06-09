#!/usr/bin/env zsh
#   vim: set tabstop=4 modeline modelines=10:
#   vim: set foldlevel=2 foldcolumn=2 foldmethod=marker:
#	{{{2

var1=1

func_A() {
	local IFS=$'\n'

	local var1=2
	#	Function called directly shares scope of caller
	func_B
	echo "var1=($var1)"

	local var1=2
	#	Function called in subshell has copy of caller scope
	echo "$( func_B )"
	echo "var1=($var1)"
}

func_B() {
	echo "$IFS" | xxd
	echo "var1=($var1)"
	var1=3
}

func_A
echo "var1=($var1)"

