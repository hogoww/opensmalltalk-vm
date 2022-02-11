


if [ -f "$1" ];
then
    echo "VMMaker image exists"
else
    cp $2 $1
fi




#BUILD_COMMAND ${VMMAKER_VM} -- --no-default-preferences save VMMaker
