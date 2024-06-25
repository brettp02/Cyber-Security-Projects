                                         check-medication.sh                                                    #!/bin/bash

echo "Enter the following fields:"

echo "First Name:"
read first_name

echo "Last Name:"
read last_name

echo "Year of birth:"
read birth_year

file_name="/opt/WellingtonClinic/patients/${first_name}${last_name}${birth_year}"

# Check if the file exists
if [ ! -f "$file_name" ]; then
    echo "Patient either doesn't exist, or was entered incorrectly."
    exit 1
fi

# Function to get the actual name of doctors
get_name() {
    username=$1
    if [ -z "$username" ]; then
        return
    fi
    full_name=$(getent passwd "$username" | cut -d ':' -f 5 | cut -d ',' -f 1)
    echo "$full_name"
}

# Get primary and secondary doctors names
primary_doc=$(awk -F, 'NR==1 {gsub("~", "", $5); print $5}' $file_name | tr -d '\r')
primary_doc_name=$(get_name "$primary_doc")

secondary_doc=$(awk -F, 'NR==1 {gsub("#", "", $6); print $6}' $file_name | tr -d '\r')
secondary_doc_name=$(get_name "$secondary_doc")

# Print information in the same format as fig.3
echo -e "Patient\t\t\tPrimary Doctor\t\tSecondary Doctor(s)"
echo -e "${first_name} ${last_name}\t\t${primary_doc_name}\t\t${secondary_doc_name}"

# Display medication records
echo -e "\nDate of Visit\t\tAttended Doctor\t\tMedication\t\t\tDosage"
awk -F, 'NR>1' $file_name | while IFS=, read -r date_of_visit attended_doctor diagnosis medication dosage; do
    attended_doc_name=$(get_name "$attended_doctor")
    printf "%-16s\t%-16s\t%-24s\t%-10s\n" "$date_of_visit" "$attended_doc_name" "$medication" "$dosage"
done

