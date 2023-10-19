#!/usr/bin/bash
# Replace `last_modified_date` timestamp with current time
# https://mademistakes.com/notes/adding-last-modified-timestamps-with-git/#mention-5

for b in $(find ./ -type d \( -path ./vendor -o -path ./node_modules \) -prune -o -name '*.md'); do
    if [ -d "${b}" ]; then
        continue
    fi

    if [ "$b" = "./.vale/write-good/README.md" ] || [ "$b" = "./README.md" ]; then
        continue
    fi

    if [ $(cat ${b} | head -n 1 | grep -E '\-\-\-') ]; then
        echo "already have meta"
    else
        cat ${b} | sed '1s/^/---\n---\n/' >tmp
        mv tmp ${b}
    fi

    if grep -q last_modified_date ${b}; then
        echo "no change"
    else
        cat ${b} | sed '1 {/---.*/,/---.*/{0,/---/{s/---/---\nlast_modified_date:/}}}' >tmp
        mv tmp ${b}
    fi

    cat ${b} | sed "/---.*/,/---.*/s/^last_modified_date:.*$/last_modified_date: $(git log -1 --pretty="format:%ci" ${b})/" >tmp
    mv tmp ${b}
done

rm -rf we work.md
