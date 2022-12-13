#!/bin/bash

#  ______            _____ ____________       _____ 
#  | ___ \          /  __ \| ___ \ ___ \     |  ___|
#  | |_/ /   _ _ __ | /  \/| |_/ / |_/ /_   _|___ \ 
#  |    / | | | '_ \| |    |  __/|  __/\ \ / /   \ \
#  | |\ \ |_| | | | | \__/\| |   | |    \ V //\__/ /
#  \_| \_\__,_|_| |_|\____/\_|   \_|     \_/ \____/ 
#                                                                                                 


############ USAGE ############

# ./RunCPPv5.bash dev = compile with all compiler warnings
# ./RunCPPv5.bash deb = compile with support for debuggers and profilers (gprof, gdb, valgrind, etc.)
# ./RunCPPv5.bash rel = compile for best performance
# ./RunCPPv5.bash     = standart compilation

# "rec" can be added to force recompilation

######## CONFIGURATION ########

mainFile="main.cpp"
executableName="compiled"
checksumFilePath="/tmp/"

###############################

clear

projectFolder=`basename "$PWD"`
outputChecksumName="${projectFolder}Checksum"

currentCodeChecksum=`find "./" -type f -print0 -not -name ${executableName} | xargs -0 sha1sum | sha1sum`

touch ${checksumFilePath}${outputChecksumName}
previousCodeChecksum=`cat ${checksumFilePath}${outputChecksumName}`

touch ${executableName}
chmod +x ${executableName}

if [[ "$currentCodeChecksum" == "$previousCodeChecksum" && $2 != "rec" && $1 != "rec" ]]; then
    ./${executableName}
else

    if [[ $1 == "dev" ]]; then
    # development build
    g++ ${mainFile} -pedantic -Wall -Wextra -Wcast-align -Wcast-qual -Wctor-dtor-privacy -Wdisabled-optimization -Wformat=2 -Winit-self -Wlogical-op -Wmissing-declarations -Wmissing-include-dirs -Wnoexcept -Wold-style-cast -Woverloaded-virtual -Wredundant-decls -Wshadow -Wsign-conversion -Wsign-promo -Wstrict-null-sentinel -Wstrict-overflow=5 -Wswitch-default -Wundef -Wno-unused -o ${executableName}

    elif [[ $1 == "deb" ]]; then
    # debug build
    g++ ${mainFile} -pg -o ${executableName}

    elif [[ $1 == "rel" ]] then
    # release build
    g++ ${mainFile} -O3 -o ${executableName}

    else
    g++ ${mainFile} -o ${executableName}
    fi

    echo "$currentCodeChecksum" > /tmp/${outputChecksumName}

    ./${executableName}
fi