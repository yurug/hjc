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
  focus_command;
  update_command;
  submit_command
]
  "usage: hjc <command> [<args>]\n\
    \n\
    The available commands are:\n\
    \  register    Register\n\
    \  login       Authenticate the user on the hacking dojo\n\
    \  logout      Exit the hacking dojo\n\
    \  whoami      Returns the authenticated user login\n\
    \  chroot      Change the root of the system\n\
    \  focus       Focus on an exercise\n\
    \  update      Update an exercise description (for teacher)\n\
    \  submit      Submit an answer to a question\n\
    \n\
    See 'hj <command> -help' for more information on a specific command.\n\
    "
