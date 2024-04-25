
#!/bin/bash
#use following code if your files named as "Monthdate_event_image###.XXX"  or "Month_date_event_image###.XXX" to sort them into folder name "event_week#".
# Define the original and destination folder paths
src_dir="source_folder"
dest_dir="destination_folder"

remove_underscore() {
    text="$1"
    first_six="${text:0:5}"  
    rest="${text:5}"         
    first_six_no_underscore="${first_six//_/}"  
    no_under="${first_six_no_underscore}${rest}" 
    rm_image="image"
    no_under="${no_under%%$rm_image*}"
    echo "$no_under"
}

# Iterate through files in the source directory
for file in "$src_dir"/*; do
    if [[ -f "$file" ]]; then
        # Extract file name without extension
        file_name=$(basename "$file" | cut -d. -f1)
        file_name=$(remove_underscore "$file_name")

        # Extract month and day from file name
        month_day=$(echo "$file_name" | grep -oE '[a-zA-Z]+[0-9]+')
        month="${month_day:0:3}"
        day="${month_day:3}"

        # Extract category from file name
        category=$(echo "$file_name" | cut -d_ -f2)

        # Extract image number from file name
        image_number=$(echo "$file_name" | grep -oE 'image[0-9]+')
        
        # Determine the week number of the month
        week_number=$((($day - 1) / 7 + 1))
        
        # Create destination directory if it doesn't exist
        dest_category_dir="${dest_dir}/${category}_week${week_number}"
        mkdir -p "$dest_category_dir"
        
        # Copy file to destination directory
        cp "$file" "$dest_category_dir/"
        
        echo "Copied '$file' to '$dest_category_dir'"
    fi
done
