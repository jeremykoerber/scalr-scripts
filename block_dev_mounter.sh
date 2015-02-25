#!/bin/bash

FORMAT="ext4"

echo -e "\n\n#################################"
echo -e "#Starting block device discovery#"
echo -e "#################################\n"

lsblk --nodeps --noheadings --pairs -o fstype,name,mountpoint,size | while read lsblk_line; do
  eval $lsblk_line
  MOUNTAT="/mnt/block-$NAME"
  echo -e "-DEVICE FOUND-\n   FStype = $FSTYPE\n   Name = $NAME\n   Mountpoint = $MOUNTPOINT\n   Size = $SIZE\n"
  if ( [[ ! $MOUNTPOINT ]] && [[ ! $FSTYPE ]] ) ; then
    echo -e "   $NAME will be formatted and mounted at $MOUNTAT"
    echo -e "   Formatting $NAME with $FORMAT\n"
    mkfs.$FORMAT /dev/$NAME
    echo -e "   Making directory for mountpoint: $MOUNTAT"
    mkdir -p $MOUNTAT
    echo -e "   Mounting $NAME at $MOUNTAT"
    sed -i "/$NAME/d" /etc/fstab && sed -i "$ a\/dev\/$NAME     $MOUNTAT  $FORMAT     defaults,nofail        0 2" /etc/fstab
    mount /dev/$NAME
    mount | grep -q "^\/dev\/${NAME}" &&
    echo -e "   SUCCESS!\n\n" ||
    echo -e "   ERROR: Device $name not found in mount output. \n\n"
  elif ( [[ ! $MOUNTPOINT ]] && ( [[ -n $FSTYPE ]] && [[ $FSTYPE != "swap" ]] )) ; then
    echo "   $NAME is already formatted with $FSTYPE. Mounting $NAME at $MOUNTAT"
    echo -e "   Making directory for mountpoint: $MOUNTAT"
    mkdir -p $MOUNTAT
    echo -e "   Mounting $NAME at $MOUNTAT"
    sed -i "/$NAME/d" /etc/fstab && sed -i "$ a\/dev\/$NAME     $MOUNTAT  $FORMAT     defaults,nofail        0 2" /etc/fstab
    mount /dev/$NAME
    mount | grep -q "^\/dev\/${NAME}" &&
    echo -e "   SUCCESS!\n\n" ||
    echo -e "   ERROR: Device $name not found in mount output. \n\n"  
  elif ( [[ -n $MOUNTPOINT ]] && [[ -n $FSTYPE ]] && [[ -n $NAME ]] ) ; then
    echo -e "   $NAME is already formatted with $FSTYPE at $MOUNTPOINT\n   SKIPPING.\n"
  elif [[ $FSTYPE == "swap" ]] ; then
    echo -e "   Found swapfs on $NAME\n   SKIPPING.\n"
  fi;
done
echo -e "Complete!\n"
