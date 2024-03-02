#!/usr/bin/bash
# Replace `last_modified_date` timestamp with current time
# This script is used to update the `last_modified_date` timestamp in the frontmatter of all Markdown files in the current directory and subdirectories.

# Loop through all Markdown files in the current directory and subdirectories
find . -type f -name "*.md" | while read file; do
    # Check if the file contains a frontmatter block
    if grep -q "^---" "$file"; then
        # Get the last modified timestamp of the file
        last_modified_timestamp=$(stat -c %Y "$file")

        # Convert the last modified timestamp to UTC datetime in YYYY-MM-DD HH:MM:SS format
        last_modified_datetime_utc=$(date -u -d @"$last_modified_timestamp" "+%Y-%m-%d %H:%M:%S")

        # Check if last_modified_date exists in the frontmatter, update it if it does
        if grep -q "^last_modified_date:" "$file"; then
            sed -i "/^last_modified_date:/c\last_modified_date: $last_modified_datetime_utc" "$file"
        else
            # If last_modified_date does not exist, add it after the first frontmatter delimiter
            sed -i "/^---/a last_modified_date: $last_modified_datetime_utc" "$file"
        fi
    fi
done
