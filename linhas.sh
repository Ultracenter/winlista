echo ""

printf "C      : %s\n\n" `cat src/*.c src/*.h 		| grep -v ^$ | wc -l`


