AC_INIT(hjc, 0.1)

AC_CHECK_PROG(OCAMLC, ocamlc, yes)
if test x"${OCAMLC}" != x"yes" ; then AC_MSG_ERROR([Please install ocaml.]); fi

AC_CHECK_PROG(CURL, curl, yes)
if test x"${CURL}" != x"yes" ; then AC_MSG_ERROR([Please install CURL.]); fi

AC_CONFIG_FILES([
 Makefile
])

AC_OUTPUT
