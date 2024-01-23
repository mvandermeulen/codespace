#!/bin/bash

# parameter 1: values-file path or values-string - string
function source_values() {
	if [ -f "$1" ]; then
		raw_values=$(cat $1)
	else
		raw_values=$1
	fi

	while IFS= read -r line; do
		if [[ ! -z "$line" && "$line" != "#"* ]]; then
			local raw_var_name=$(echo "$line" | cut -d'=' -f1)
			local var_name=$(echo "$raw_var_name" | tr '[:upper:]' '[:lower:]')

			local raw_var_value=$(echo "$line" | cut -d'=' -f2-)
			local var_value=$(eval "echo $raw_var_value")

			declare -g "$var_name=$var_value"
		fi
	done <<< "$raw_values"
}
