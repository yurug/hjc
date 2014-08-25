#!/usr/bin/zsh
rm -fr `pwd`/test
./hjc login --dojo https://localhost:8080 --username admin --password foo
./hjc chroot `pwd`/test
./hjc get_user_info 'case %what in exists) echo 1;; status) echo teacher;; esac'
./hjc register --username yann --password foo
# ./hjc get_user_info 'echo 0'
#./hjc register --username yann --password foo
./hjc login --username yann --password foo

./hjc exercise_create std
./hjc exercise_focus std
./hjc exercise_push std.aka

./hjc exercise_create test
./hjc exercise_focus test
./hjc exercise_upload test2 up.sh
./hjc exercise_ls --all test2
./hjc exercise_upload source.aka source.aka
./hjc exercise_update
