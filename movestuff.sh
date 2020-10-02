echo "moving stuff into directory $1"


cp ./builder/vm/* $1
cp ./main.c $1
cp ./setupImage.c $1
cp ~/Pharo/images/Fangleureu/generated/classes/*.h $1
cp ~/Pharo/images/Fangleureu/generated/tests/*.h $1
cp ./generated/vm/src/* $1
cp ./generated/vm/include/*.h $1
cp ./tempconversion-64.image $1
cp ./CuTest.* $1
