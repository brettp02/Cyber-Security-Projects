#!/bin/bash

#setup.sh is owned by root and therefore should belong to root user only (least privellege)
chown root:root /opt/setup.sh
chmod 700 /opt/setup.sh

groupadd lecturer
groupadd tutor
groupadd student

#make cybr371 directors 
mkdir /opt/cybr371
chown root:lecturer /opt/cybr371
chmod 774 /opt/cybr371



#add lecturers
for lect in arman mohammad; do
    useradd -m -G lecturer -s /bin/bash $lect
    passwd -d $lect
done

#add tutors
for tut in  ilona ether immaculata; do
    useradd -m -G tutor -s /bin/bash $tut
    passwd -d $tut
done

#add students
for i in {000..093}; do
    useradd -m -G student -s /bin/bash student$i
    passwd -d student$i
done


#for each assessment (ass) of the required assessments do the following
for ass in lab{1..5} assignment{1..2} midterm final; do
    
    #make directories for each of the assessments, making lecuters as the group/owner
    #change facl to rwx rwx --- only root and lecturers can rwx in the folders      
    mkdir /opt/cybr371/$ass
    chown root:lecturer /opt/cybr371/$ass
    chmod 774 /opt/cybr371/$ass

    #create questions/solutions files adn change ownership / rights
    touch /opt/cybr371/$ass/questions.pdf
    touch /opt/cybr371/$ass/solutions.pdf
    chown root:lecturer /opt/cybr371/$ass/*.pdf
    chmod 660 /opt/cybr371/$ass/solutions.pdf
    chmod 664 /opt/cybr371/$ass/questions.pdf
    setfacl -m  g:tutor:r /opt/cybr371/$ass/*.pdf

    for i in {000..093}; do
        mkdir /opt/cybr371/$ass/student$i
        chown student$i:student /opt/cybr371/$ass/student$i
        chmod 700 /opt/cybr371/$ass/student$i
        touch /opt/cybr371/$ass/student$i/answers.docx
        chown student$i:student /opt/cybr371/$ass/student$i/answers.docx
        chmod 700 /opt/cybr371/$ass/student$i/answers.docx

        #allow lecturers and tutors to read the answer files
        setfacl -m g:lecturer:r /opt/cybr371/$ass/student$i/answers.docx
        setfacl -m g:tutor:r /opt/cybr371/$ass/student$i/answers.docx
    done
done

touch /opt/cybr371/grades.xlsx
chown root:lecturer /opt/cybr371/grades.xlsx
chmod 660 /opt/cybr371/grades.xlsx
setfacl -m g:tutor:rw /opt/cybr371/grades.xlsx 
