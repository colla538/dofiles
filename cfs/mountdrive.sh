T#!/bin/bash
	echo

echo "["DRIVEMOUNTER 9000: THE SEQUEL"]"

	echo

# Ask if user wants to mount or unmount
echo "Wanna mount or unmount?"
echo "1) Yes, I'd like to mount"
echo "2) No, I want to unmount"
read -p "Selection: " ACTION_CHOICE

if [[ "$ACTION_CHOICE" == "1" ]]; then
    # Ask how to mount
    echo "How would you like to mount da partition?"
    echo "1) (FOR MPD) Mount with user permissions ffs"
    echo "2) Nah, mount normally instead"
    read -p "Selection: " MOUNT_MODE
    
    # If mounting with permissions, ask for UID and GID
    if [[ "$MOUNT_MODE" == "1" ]]; then
        read -p "Enter UID (default: $USER): " USER_UID
        USER_UID=${USER_UID:-$(id -u)}
        read -p "Enter GID (default: $USER): " USER_GID
        USER_GID=${USER_GID:-$(id -g)}
    fi
    
    # Ask for mount point
    echo "Where to mount, vro? (leave blank for /media/danish/USB_Music/):"
    read -r MOUNT_DIR
    MOUNT_DIR=${MOUNT_DIR:-/media/danish/USB_Music/}

    # List available partitions instead of whole disks
    echo "PARTITIONS:"
    PARTITIONS=($(lsblk -rpno NAME,SIZE,FSTYPE | grep -E "ntfs|ext4|vfat|btrfs" | awk '{print $1}'))
    FILESYSTEMS=($(lsblk -rpno NAME,SIZE,FSTYPE | grep -E "ntfs|ext4|vfat|btrfs" | awk '{print $3}'))

    # Display partitions with numbering
    echo -e "\nSelect a partition, God-Damnit!:"
    for i in "${!PARTITIONS[@]}"; do
        echo "$((i+1)). ${PARTITIONS[$i]} (${FILESYSTEMS[$i]})"
    done

    read -p "Selection: " SELECTION

    # Validate input
    if [[ ! "$SELECTION" =~ ^[0-9]+$ ]] || (( SELECTION < 1 || SELECTION > ${#PARTITIONS[@]} )); then
        echo "Nope, wrong Partition mate!"
        exit 1
    fi

    SELECTED_PARTITION=${PARTITIONS[$((SELECTION-1))]}
    SELECTED_FS=${FILESYSTEMS[$((SELECTION-1))]}

    # Ask user to confirm or change the filesystem type
    echo "Detected fs: $SELECTED_FS"
    echo "1) Use ($SELECTED_FS)"
    echo "2) Emmanuelly specify"
    read -p "Selection: " FS_CHOICE

    if [[ "$FS_CHOICE" == "2" ]]; then
        echo "Select fs type:"
        echo "1) ntfs"
        echo "2) vfat"
        echo "3) ext4"
        echo "4) btrfs"
        read -p "Selection: " FS_SELECTION
        case $FS_SELECTION in
            1) SELECTED_FS="ntfs" ;;
            2) SELECTED_FS="vfat" ;;
            3) SELECTED_FS="ext4" ;;
            4) SELECTED_FS="btrfs" ;;
            *) echo "Invalid choice, using detected filesystem." ;;
        esac
    fi

    # Create mount directory if not exists
    sudo mkdir -p "$MOUNT_DIR"

    if [[ "$MOUNT_MODE" == "1" ]]; then
        sudo mount -o uid=$USER_UID,gid=$USER_GID,fmask=0111,dmask=0000 -t "$SELECTED_FS" "$SELECTED_PARTITION" "$MOUNT_DIR"
    else
        sudo mount -t "$SELECTED_FS" "$SELECTED_PARTITION" "$MOUNT_DIR"
    fi

    # Confirm success
    if [[ $? -eq 0 ]]; then
        echo "Partition mounted, Aye! [$MOUNT_DIR using $SELECTED_FS]"
    else
        echo  "nah vro that shi failed"
    fi

elif [[ "$ACTION_CHOICE" == "2" ]]; then
    # List mounted partitions
    echo "Mounted partitions:"
    MOUNTED_PARTITIONS=($(lsblk -rpno NAME,MOUNTPOINT | awk '$2!="" {print $1}'))

    if [[ ${#MOUNTED_PARTITIONS[@]} -eq 0 ]]; then
        echo "No partitions currently mounted."
        exit 0
    fi

    # Display partitions with numbering
    echo -e "\nWhere would you like to unmount, mate?:"
    for i in "${!MOUNTED_PARTITIONS[@]}"; do
        echo "$((i+1)). ${MOUNTED_PARTITIONS[$i]}"
    done

    read -p "Selection: " UNMOUNT_SELECTION

    # Validate input
    if [[ ! "$UNMOUNT_SELECTION" =~ ^[0-9]+$ ]] || (( UNMOUNT_SELECTION < 1 || UNMOUNT_SELECTION > ${#MOUNTED_PARTITIONS[@]} )); then
        echo "Invalid selection!"
        exit 1
    fi

    SELECTED_UNMOUNT_PARTITION=${MOUNTED_PARTITIONS[$((UNMOUNT_SELECTION-1))]}
    
    # Unmount the partition
    sudo umount "$SELECTED_UNMOUNT_PARTITION"
    
    if [[ $? -eq 0 ]]; then
        echo "that shi unmounted for good vro, calm down nawh."
    else
        echo "nope"
    fi
else
    echo "You did not fullfill this script's oath. Thou may exile from society!"
    exit 1
fi
