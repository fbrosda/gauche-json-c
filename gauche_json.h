/*
 * gauche_json.h
 */

/* Prologue */
#ifndef GAUCHE_GAUCHE_JSON_H
#define GAUCHE_GAUCHE_JSON_H

#include <gauche.h>
#include <gauche/extend.h>

SCM_DECL_BEGIN

extern ScmObj parse_json_string(ScmObj str);

/* Epilogue */
SCM_DECL_END

#endif  /* GAUCHE_GAUCHE_JSON_H */
