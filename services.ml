open Config
open Utils
open Unix

(* FIXME: A lot of the following code should be generated from the
   FIXME: API description. *)

let general_options = [
  "-v",
  Arg.Set verbose_mode,
  " Set verbose mode."
]

let options o = o @ general_options

let login ?(register=false) ?username ?password () =
  let if_none x f = match x with None -> f () | Some x -> x in
  let username = if_none username (fun () ->
    Printf.printf "login: %!";
    input_line Pervasives.stdin
  )
  in
  let password = if_none password (fun () ->
    Printf.printf "password: %!";
    let s = noecho_input_line () in
    Printf.printf "\n%!";
    s
  )
  in
  call_api (if register then "register" else "login") ~posts:[
    ("login",    username);
    ("password", password)
  ] []

let sign_command register =
  let username = ref None in
  let password = ref None in
  let command_name = if register then "register" else "login" in
  process command_name
    (options [
      "--dojo", Arg.String (Config.set_url), " Specify a Dojo URL.";
      "--username", Arg.String (set_opt username), " Specify a username.";
      "--password", Arg.String (set_opt password), " Specify a password.";
    ])
    ("hjc " ^ command_name)
    (no_extra_arguments (fun () ->
      login ~register ?username:!username ?password:!password ())
    )

let login_command = sign_command false

let register_command = sign_command true

let logout () =
  call_api "logout" ~posts:[] []

let logout_command =
  process "logout"
    (options [])
    "hjc logout"
    (no_extra_arguments logout)

let whoami () =
  call_api "whoami" ~posts:[] []

let whoami_command =
  process "whoami"
    (options [])
    "hjc whoami"
    (no_extra_arguments whoami)

let chroot = function
  | [ path ] ->
    call_api "chroot" ~posts:["path", path] []
  | _ ->
    Printf.eprintf "Invalid usage of chroot command.\n";
    exit 1

let chroot_command =
  process "chroot"
    (options [])
    ("hjc chroot [path]")
    chroot

let get_user_info = function
  | [ cmd ] ->
    call_api "get_user_info" ~posts:["cmd", cmd] []
  | _ ->
    Printf.eprintf "Invalid usage of get_user_info command.\n";
    exit 1

let get_user_info_command =
  process "get_user_info"
    (options [])
    ("hjc get_user_info [cmd]")
    get_user_info

let exercise_create = function
  | [ name ] ->
    call_api "exercise_create" ~posts:["name", name] []
  | _ ->
    Printf.eprintf "Invalid usage of exercise_create command.\n";
    exit 1

let exercise_create_command =
  process "exercise_create"
    (options [])
    ("hjc exercise_create [name]")
    exercise_create

let exercise_focus = function
  | [ exercise ] ->
    let url = "/exercise/" ^ exercise in
    Config.set_focus url;
    Printf.printf "Focus on `%s'.\n" url
  | _ ->
    Printf.eprintf "Invalid usage of focus command.\n";
    exit 1

let exercise_focus_command =
  process "exercise_focus"
    (options [])
    "hjc exercise_focus [identifier]"
    exercise_focus

let submit = function
  | [ question; file ] ->
    failwith "To be implemented"
  | _ ->
    Printf.eprintf "Invalid usage of submit command.\n";
    exit 1

let submit_command =
  process "submit"
    (options [])
    "hjc submit [question] [file]"
    submit

let read file =
  try
    let cin = open_in file in
    let b = Buffer.create 13 in
    let rec read () =
      try
        Buffer.add_string b (input_line cin ^ "\n");
        read ()
      with _ -> ()
    in
    read ();
    close_in cin;
    Buffer.contents b
  with _ ->
    Printf.eprintf "Error while reading input file.\n";
    exit 1

let on_exercise f =
  match Config.get_focus () with
    | None ->
      Printf.eprintf "First, focus on some exercise using `hjc focus'.\n";
      exit 1
    | Some exo ->
      f exo

let update = function
  | [ file ] ->
    on_exercise (fun exo ->
      let postprocess = Printf.sprintf "sed s/this/%s/g" file in
      call_api ~postprocess "update" ~forms:[
        "id", exo;
        "content", "@" ^ file
      ] []
    )
  | _ ->
    Printf.eprintf "Invalid usage of update command.\n";
    exit 1

let update_command =
  process "update"
    (options [])
    "hjc update [description_file]"
    update

let exercise_upload = function
  | [ resource_name; file ] -> begin
    on_exercise (fun exo ->
        call_api "exercise_upload" ~forms:[
          "identifier", exo;
          "resource_name", resource_name;
          "file", "@" ^ file
        ] [])
  end
  | _ ->
    Printf.eprintf "Invalid usage of exercise_upload command.\n";
    exit 1

let exercise_upload_command =
  process "exercise_upload"
    (options [])
    "hjc exercise_upload [ressource_name] [file]"
    exercise_upload

let exercise_download version = function
  | [ name ] ->
    on_exercise (fun exo ->
      call_api "exercise_download" ~posts:[
        "identifier", exo;
        "resource_name", name;
        "version", (version ())
      ] [])
  | _ ->
    Printf.eprintf "Invalid usage of exercise_download command.\n";
    exit 1

let exercise_download_command =
  let version = ref "" in
  process "exercise_download"
    (options [
      "--version", Arg.Set_string version, " Download a specific version."
    ])
    ("hjc exercise_download [resource_name]")
    (exercise_download (fun () -> !version))

let exercise_ls show_all = function
  | [ filter ] ->
    let options = if show_all () then "--all" else "" in
    on_exercise (fun exo ->
      call_api "exercise_ls" ~posts:[
        "identifier", exo;
        "options", options;
        "filter", filter;
      ] [])
  | _ ->
    Printf.eprintf "Invalid usage of exercise_ls command.\n";
    exit 1

let exercise_ls_command =
  let show_all = ref false in
  process "exercise_ls"
    (options [
      "--all", Arg.Set show_all, " Show all versions.";
    ])
    ("hjc exercise_ls filter")
    (exercise_ls (fun () -> !show_all))

let exercise_update = function
  | [] ->
    on_exercise (fun exo ->
      call_api "exercise_update" ~posts:[
        "identifier", exo
      ] [])
  | _ ->
    Printf.eprintf "Invalid usage of exercise_update command.\n";
    exit 1

let exercise_update_command =
  process "exercise_update"
    (options [])
    ("hjc exercise_update")
    exercise_update
