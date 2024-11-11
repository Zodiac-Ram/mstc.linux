#!/bin/bash
#Created by Mason Peckham <mason.peckham03@gmail.com>

groups=('Sales' 'HumanResources' 'TechnicalOperations' 'Helpdesk' 'Research')


BASE=$1

if  [ -z "$BASE" ]; then
 echo
 echo "Creates a department shared folder structure at the specified destination"
 echo
 echo "  Usage $0 <root folder> "
 echo

 exit 1
fi

USER=`whoami`

if [ $USER != "root" ]; then
 echo "Root permission is required."
 exit 1
fi

for group in "${groups[@]}"; do
 if [ ! $(getent group $group) ]; then
  echo "Creating group $group."
  groupadd $group
 fi

 folder="$BASE/$group"
 if [ ! -d "$folder" ]; then
  echo "Creating shared folder at $folder."
  mkdir -p "$folder"
 fi

 echo " - Applying $USER:$group ownership on $folder..."
 chown "$User:$group" "$folder"

 echo " - Applying permissions on $folder... $USER=rwx,$group=rwx,o=---"
 chmod u+rwx,g+rwx,o-rwx "$folder"

 echo " - Granting permission (rx) to Helpdesk on $folder..."
 setfacl --modify=g:Helpdesk:rx "$folder"
done
