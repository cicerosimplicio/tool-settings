# Save file
save_file() {
    if [[ -z "$1" ]]; then
        echo 'Filename not provided.' >&2
        return 1
    fi

    if [[ -z "$2" ]]; then
        echo 'Content not provided.' >&2
        return 1
    fi

    fileName=$1
    content=$2

    dir=$(fd . --type d $HOME | fzf --exact)

    if [[ -z $dir ]]; then
        echo "Directory not provided." >&2
        return 1
    fi

    echo $content > "${dir}${fileName}"
    echo "File directory: ${dir}${fileName}"
}

# Append file
append_file() {
    if [[ -z "$1" ]]; then
        echo 'Filename not provided.' >&2
        return 1
    fi

    if [[ -z "$2" ]]; then
        echo 'Content not provided.' >&2
        return 1
    fi

    fileName=$1
    content=$2

    dir=$(fd . --type d $HOME | fzf --exact)

    if [[ -z $dir ]]; then
        echo "Directory not provided." >&2
        return 1
    fi

    echo "\n$content" >> "${dir}${fileName}"
    echo "File directory: ${dir}${fileName}"
}