connection: "looker_partner_demo"

# Auto-streams all views, refinements, and explores from Project A
include: "//project_a/views/**/*.view.lkml"


datagroup: project_b_default_datagroup {
  sql_trigger: SELECT CURRENT_DATE() ;;
  max_cache_age: "24 hours"
}

persist_with: project_b_default_datagroup
