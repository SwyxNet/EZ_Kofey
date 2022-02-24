# Auto Kofey

storekey()
{
    if [ $default = 0 ]
    then
        grep Key: log.txt | cut -d ' ' -f 2 | cut -d ']' -f 1 >> keys.txt
        default=1
    fi
    grep "Key found:" log.txt | cut -d ' ' -f 3 >> keys.txt
}


runExploit()
{
    default=0
    if [ -d keys.txt ]
    then
        mv keys.txt bak_keys.txt
    fi

    echo "\n" > keys.txt
    if [ -d log.txt ]
    then
        mv log.txt bak_log.txt
    fi
    echo "\n" > log.txt
    
    echo "running exploit"
    until grep "condition de sortie" log.txt
    do
        ./mfoc/src/mfoc -f keys.txt >> log.txt
        storekey
   done
}

# Arg testing
if [ -z "$1" ]
then
    runExploit
    # ./mfoc -O dd -k 1727a102a015fi
else
    if [ $1 == "-i" ]
    then
        #Installation Block
        sudo apt update
        sudo apt install git binutils make csh g++ sed gawk autoconf automake autotools-dev libglib2.0-dev libnfc-dev liblzma-dev libnfc-bin -y
        git clone https://github.com/vk496/mfoc
        cd mfoc
        git checkout hardnested
        autoreconf -is
        ./configure
        make
        cd ..
        modprobe -r pn533_usb pn533

        #if [ grep "modprobe -r pn533_usb pn533" /etc/modprobe.d/blacklist-libnfc.conf ]
        #	then
        #			echo "blacklist ok"
        #    else
        #			sudo echo "\nmodprobe -r pn533_usb pn533" >> /etc/modprobe.d/blacklist-libnfc.conf
        #	fi
    else
        echo "Unknown parameter, try \"./blufang.sh -h\""
        exit 0
    fi
fi
