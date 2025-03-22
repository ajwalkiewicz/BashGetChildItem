#!/usr/bin/bash

# Check if an argument is provided
if [ $# -eq 0 ]; then
    # If no argument, use current directory
    path=$(realpath ".")
else
    # Use the provided argument as the directory
    path=$(realpath "$1")
fi

if [ -f "$path" ]; then
    directory=$(dirname "$path")
else
    directory=$path
fi

cmd () {
        ls -vl --quoting-style=literal --group-directories-first --color=auto --time-style="+%m/%d/%Y %H:%M" "$1"
}

echo -e "\n    Directory: $directory\n"
cmd "$path" | awk '
BEGIN {
    BOLD_GREEN="\033[1;32m"
    LIGHT_BLUE_BG="\033[104m"
    BOLD_WHITE="\033[1;37m"
    RESET="\033[0m"
    printf "%sUnixMode         User Group         LastWriteTime         Size Name%s\n", BOLD_GREEN, RESET
    printf "%s--------         ---- -----         -------------         ---- ----%s\n", BOLD_GREEN, RESET
    max_name_length = 30
}

# Skip the "total X" line (if present)
/^total/ { next }

{
    mode = $1
    user = $3
    group = $4
    size = $5
    time = $6 " " $7

    name = ""
    for (i = 8; i <= NF; i++) {
        name = name (i > 8 ? " " : "") $i
    }

    if (name ~ /\//) {                # Check if "/" is in the string
        split(name, parts, "/");      # Split the string by "/"
        name = parts[length(parts)];  # Print the last element
    }

    # Wrap line in the column if it exceeds the max lenght
    if (length(name) > max_name_length) {
        first_line = substr(name, 1, max_name_length)
        second_line = substr(name, max_name_length + 1)

        # Check if the entry is a directory
        if (substr(mode, 1, 1) == "d") {
            printf "%-16s %-4s %-10s %-18s %10s %s%s%s%s\n", mode, user, group, time, size, LIGHT_BLUE_BG, BOLD_WHITE, first_line, RESET
            printf "%-16s %-4s %-10s %-18s %10s %s%s%s%s\n", "", "", "", "", "", LIGHT_BLUE_BG, BOLD_WHITE, second_line, RESET

        # Check if the entry is executable
        } else if (index(mode, "x") > 0) {
            printf "%-16s %-4s %-10s %-18s %10s %s%s%s\n", mode, user, group, time, size, BOLD_GREEN, first_line, RESET
            printf "%-16s %-4s %-10s %-18s %10s %s%s%s\n", "", "", "", "", "", BOLD_GREEN, second_line, RESET

        # All other entries
        } else {
            printf "%-16s %-4s %-10s %-18s %10s %s\n", mode, user, group, time, size, first_line
            printf "%-16s %-4s %-10s %-18s %10s %s\n", "", "", "", "", "", second_line
        }

    # Do not wrap the line if it is below max lenght
    } else {
        # Check if the entry is a directory
        if (substr(mode, 1, 1) == "d") {
            printf "%-16s %-4s %-10s %-18s %10s %s%s%s%s\n", mode, user, group, time, size, LIGHT_BLUE_BG, BOLD_WHITE, name, RESET

        # Check if the entry is executable
        } else if (index(mode, "x") > 0) {
            printf "%-16s %-4s %-10s %-18s %10s %s%s%s\n", mode, user, group, time, size, BOLD_GREEN, name, RESET

        # All other entries
        } else {
            printf "%-16s %-4s %-10s %-18s %10s %s\n", mode, user, group, time, size, name
        }
    }
}'

echo ""
