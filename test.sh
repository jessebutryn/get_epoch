#!/usr/bin/env bash
#
#set -x

. ${0%/*}/function

random_date () {
	local rd
	local _rY _rM _rD _rH _rm _rs _rd
	until [[ -n "$rd" ]]; do
		_rY=$(gshuf -i 1970-2100 -n1)
		_rM=$(( (RANDOM%12) + 1 ))
		_rD=$(( (RANDOM%31) + 1 ))
		_rH=$(( (RANDOM%23) + 1 ))
		_rm=$(( (RANDOM%59) + 1 ))
		_rs=$(( (RANDOM%59) + 1 ))
		_rd="${_rY}-${_rM}-${_rD} ${_rH}:${_rm}:${_rs}"
		rd=$(gdate -d "$_rd" '+%F %T' 2>/dev/null)
	done
	awk '{print $1 "T" $2 "Z"}' <<<"$rd"
}

f=0
n=1000

for ((i=1;i<=n;i++)); do
	printf '%s' "${i}/${n}..."
	_d=$(random_date)
	epoch_calc=$(get_epoch "$_d")
	gnu_date=$(gdate -d "$_d" '+%s') || echo "I got $_d"
	if [[ "$gnu_date" -ne "$epoch_calc" ]]; then
		((f++))
		printf '\r%s\n%10s\n%10s\n' \
		"Fail! Epoch times did not match" \
		"GNU Time: $gnu_date" \
		"get_epoch Time: $epoch_calc"
	else
		printf '%s\r' 'Pass'
	fi
done


echo "Number of failures: $f"