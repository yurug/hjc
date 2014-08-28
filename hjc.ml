open Unix
open Config
open Utils
open Services

(* Command line processing. *)

let _ = run_command [
  register_command;
  login_command;
  logout_command;
  whoami_command;
  chroot_command;
  get_user_info_command;
  exercise_create_command;
  exercise_focus_command;
  exercise_upload_command;
  exercise_download_command;
  exercise_ls_command;
  exercise_update_command;
  exercise_push_command;
  exercise_questions_command;
  update_command;
  submit_command
]
  "usage: hjc <command> [<args>]\n\
    \n\
    The available commands are:\n\
    \  register              Register\n\
    \  login                 Authenticate the user on the hacking dojo\n\
    \  logout                Exit the hacking dojo\n\
    \  whoami                Returns the authenticated user login\n\
    \  chroot                Change the root of the system\n\
    \  get_user_info         Set get_user_info command\n\
    \  exercise_create       Create a fresh exercise\n\
    \  exercise_focus        Focus on an exercise\n\
    \  exercise_upload       Upload a resource for an exercise\n\
    \  exercise_download     Download a resource of an exercise\n\
    \  exercise_ls           List the resources of an exercise\n\
    \  exercise_update       Trigger the update of an exercise code\n\
    \  exercise_push         Upload and update an exercise code\n\
    \  update                Update an exercise description\n\
    \  submit                Submit an answer to a question\n\
    \n\
    See 'hj <command> -help' for more information on a specific command.\n\
    "
