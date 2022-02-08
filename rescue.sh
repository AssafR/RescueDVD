#/bin/bash
#ddrescue -d -r1 --timeout=5m /dev/sr0 SNL_Portman.iso SNL_Portman.log

#ddrescue=ddrescue-dvd
ddrescue=ddrescue

function print_execute {
    echo $1
    eval $1
    return $?
}


if [ "$1" != "" ]; then
#    ddrescue -d -r1 --timeout=5m /dev/sr0 $1.iso $1.log
    target_dir="/mnt/Q/DVDs/$1"
    syn_dir="/volume4/Drive3/DVDs/$1"

    mkdir -p "$target_dir"
    print_execute "$ddrescue -b2048 -n -N -d -r0 --timeout=5m /dev/sr0  $target_dir/$1.iso  $target_dir/$1.log"
    print_execute "$ddrescue -b2048 -d -r1 --timeout=15m /dev/sr0  $target_dir/$1.iso  $target_dir/$1.log"
    print_execute "$ddrescue -b2048 -r1 --timeout=5m /dev/sr0  $target_dir/$1.iso  $target_dir/$1.log"
    result=$?
    if [ $result -eq 0 ]
    then
	echo Extracting ISO file
        if ! ssh -p 40 admin@diskstation.local 7z x "$syn_dir"/$1.iso -o"$syn_dir"; then
		echo "ISO extraction failed"
        else
		echo "ISO extraction success"
        fi
    else
	echo "Rescue Failed"
    fi


#    sudo mount -o loop $1.iso /media/iso/
#    rsync -arvz  --rsync-path=/bin/rsync  --rsh="ssh -p 40" --progress /media/iso/*  admin@diskstation.local:/volume4/Drive3/DVDs/$1/
#    retVal=$?
#    if [ $retVal -ne 0 ]; then
#        sudo umount /media/iso
#        rm $1.iso
#    else
#        echo "Rsync failed"
#    fi
else
    echo "No parameter"
fi
