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

./hjc exercise_push --on test exo.aka
./hjc exercise_questions --on test      
./hjc exercise_answer --on test q1 "choose:1"
sleep 2
./hjc exercise_evaluation_state --on test q1 

./hjc machinist_create debian
./hjc machinist_upload debian key1 id_rsa
./hjc machinist_set_logins debian test key1
./hjc machinist_set_addresses debian 127.0.0.1 22

./hjc exercise_subscribe --on test
./hjc exercise_upload grader.sh grader.sh  
./hjc answers_upload --on test hello.java hello.java
./hjc exercise_answer --on test q2 "file:hello.java"
sleep 3
./hjc exercise_evaluation_state --on test q2      
