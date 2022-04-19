/*
 * gauche_json.c
 */

#include "gauche_json.h"
#include <json.h>
#include <json_visit.h>
#include <stddef.h>

static int create_scm_obj(json_object *jso, int flags, json_object *parent_jso, const char *jso_key, size_t *jso_index, void *userarg)
{
  /* printf("flags: 0x%x, key: %s, index: %ld, value: %s\n", flags, */
  /*	 (jso_key ? jso_key : "(null)"), (jso_index ? (long)*jso_index : -1L), */
  /*	 json_object_to_json_string(jso)); */

  ScmObj** arg = ((ScmObj**) userarg);
  ScmObj* sp = *arg;

  int val_type = json_object_get_type(jso);
  int parent_type = json_object_get_type(parent_jso);
  if(flags & JSON_C_VISIT_SECOND) {
    if (val_type == json_type_object) {
      sp[-1] = Scm_ReverseX(sp[-1]);
      if(parent_type == json_type_array) {
	long idx = (long)*jso_index;
	Scm_VectorSet(SCM_VECTOR(sp[-2]), idx, sp[-1]);
      } else if (parent_type == json_type_object) {
	sp[-2] = Scm_Acons(SCM_MAKE_STR_COPYING(jso_key), sp[-1], sp[-2]);
      }
    }

    *arg = sp-1;
    return JSON_C_VISIT_RETURN_CONTINUE;
  }

  switch (val_type) {
  case json_type_null:
    *sp = SCM_INTERN("null");
    break;
  case json_type_boolean:
    *sp = SCM_MAKE_BOOL(json_object_get_boolean(jso));
    break;
  case json_type_double:
    *sp = Scm_MakeFlonum(json_object_get_double(jso));
    break;
  case json_type_int:
    *sp = SCM_MAKE_INT(json_object_get_int64(jso));
    break;
  case json_type_string:
    *sp= SCM_MAKE_STR_COPYING(json_object_get_string(jso));
    break;
  case json_type_object:
    *sp = SCM_NIL;
    *arg = sp+1;
    return JSON_C_VISIT_RETURN_CONTINUE;
  case json_type_array:
    *sp = Scm_MakeVector(json_object_array_length(jso), SCM_MAKE_INT(0));
    *arg = sp+1;
    break;
  default:
    *sp = SCM_NIL;
    break;
  }

  if(parent_type == json_type_array) {
    long idx = (long)*jso_index;
    Scm_VectorSet(SCM_VECTOR(sp[-1]), idx, *sp);
  } else if (parent_type == json_type_object) {
    sp[-1] = Scm_Acons(SCM_MAKE_STR_COPYING(jso_key), *sp, sp[-1]);
  }

  return JSON_C_VISIT_RETURN_CONTINUE;
}

ScmObj parse_json_string(ScmObj o)
{
  enum json_tokener_error error;
  struct json_object *jobj = json_tokener_parse_verbose(SCM_STRING_START(o), &error);
  if(error != json_tokener_success) { // parse error -> throw error
    return Scm_RaiseCondition(SCM_SYMBOL_VALUE("rfc.json", "<json-parse-error>"), SCM_RAISE_CONDITION_MESSAGE, "expecting one of (\"false\" \"true\" \"null\" { } [ ])");
  }
  ScmObj* out = SCM_NEW2(ScmObj*, sizeof(ScmObj)*128);
  json_c_visit(jobj, 0, create_scm_obj, &out);
  json_object_put(jobj);
  return *out;
}

/*
 * Module initialization function.
 */
extern void Scm_Init_gauche_jsonlib(ScmModule*);

void Scm_Init_gauche_json(void)
{
  ScmModule *mod;

  /* Register this DSO to Gauche */
  SCM_INIT_EXTENSION(gauche_json);

  /* Create the module if it doesn't exist yet. */
  mod = SCM_MODULE(SCM_FIND_MODULE("json-c", TRUE));

  /* Register stub-generated procedures */
  Scm_Init_gauche_jsonlib(mod);
}
