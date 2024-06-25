#!/bin/bash

# Make Sure script is being run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

chmod 700 /opt/setup-clinic.sh

# Setup users and groups
groupadd doctors
groupadd nurses

useradd -m -s /bin/bash -G doctors -c "Dr Lou Ngevity" drloun
passwd -d drloun
useradd -m -s /bin/bash -G doctors -c "Dr Stethos Cope" drstethosc
passwd -d drstethosc
useradd -m -s /bin/bash -G nurses -c "Dr Bea Shure" drbeas
passwd -d drbeas
useradd -m -s /bin/bash -G nurses -c "Phil Paine" philp
passwd -d philp

# Create directories
mkdir -p /opt/WellingtonClinic/patients
chown root:doctors /opt/WellingtonClinic
chown root:doctors /opt/WellingtonClinic/patients
chmod 770 /opt/WellingtonClinic/patients
setfacl -m g:nurses:rx /opt/WellingtonClinic/patients

#allow nurses to execute check-medication
echo "%nurses ALL=(ALL) NOPASSWD: /opt/check-medication.sh" > /etc/sudoers.d/nurses
chmod 0440 /etc/sudoers.d/nurses  # Secure the sudoers file 

chmod 770 /opt/check-medication.sh


#register patient
chown root:doctors /opt/register-patient.sh
chmod 770 /opt/register-patient.sh
