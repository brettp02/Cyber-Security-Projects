#!/bin/bash

# save the patient directory as a variable
patient_dir="/opt/WellingtonClinic/patients"

# Make sure the script is run by someone in the doctors group
if ! id -nG "$USER" | grep -qw "doctors"; then
    echo "Error: Only doctors can register new patients."
    exit 1
fi

echo "Enter the following information about the patient"
echo "First name:"
read first_name

echo "Last name:"
read last_name

echo "Year of birth:"
read birth_year

# file name
file_n="${first_name}${last_name}${birth_year}"
full_path="${patient_dir}/${file_n}"

# Create patient file
touch "$full_path"

# Get the username of the primary doctor
primary_doctor=$USER

# Automatically get the current date in DD/MM/YYYY format
date_registration=$(date "+%d/%m/%Y")

echo -n "If there are secondary doctors, type their usernames (comma-separated, no spaces):"
read secondary_doc

secondary_doctors=""
if [ -n "$secondary_doc" ]; then
    IFS=',' read -ra ADDR <<< "$secondary_doc"
    for i in "${ADDR[@]}"; do
        secondary_doctors+="#$i,"
    done
    secondary_doctors=${secondary_doctors%,} 
fi

# Write patient information into the file
echo "${first_name},${last_name},${birth_year},${date_registration},~${primary_doctor},${secondary_doctors}" > "$full_path"

# Change ownership
chown ${primary_doctor}:doctors "$full_path"
chmod 600 "$full_path"

