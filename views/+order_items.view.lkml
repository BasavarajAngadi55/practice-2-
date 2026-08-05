# ------------------------------------------------------------------
# MUST INCLUDE THE BASE VIEW FILE FIRST
# Adjust path to match your folder structure (e.g., "/views/order_items.view.lkml")
# ------------------------------------------------------------------
include: "**/order_items.view.lkml"

view: +order_items {

  # Re-assert primary key for validator recognition
  dimension: id {
    primary_key: yes
  }

  # ------------------------------------------------------------------
  # 1. DASHBOARD DATE FILTER
  # ------------------------------------------------------------------
  filter: select_date {
    type: date
    label: "Select Reference Date"
    description: "Anchor date used to dynamically calculate Today, Yesterday, MTD, QTD, and YTD sales."
  }

  # ------------------------------------------------------------------
  # 2. HELPER DIMENSIONS (BigQuery SQL)
  # ------------------------------------------------------------------
  dimension: selected_anchor_date {
    type: date
    hidden: yes
    sql: DATE({% date_start select_date %}) ;;
  }

  dimension: is_today {
    type: yesno
    hidden: yes
    sql: ${created_date} = ${selected_anchor_date} ;;
  }

  dimension: is_yesterday {
    type: yesno
    hidden: yes
    sql: ${created_date} = DATE_SUB(${selected_anchor_date}, INTERVAL 1 DAY) ;;
  }

  dimension: is_mtd {
    type: yesno
    hidden: yes
    sql: ${created_date} >= DATE_TRUNC(${selected_anchor_date}, MONTH)
      AND ${created_date} <= ${selected_anchor_date} ;;
  }

  dimension: is_previous_mtd {
    type: yesno
    hidden: yes
    sql: ${created_date} >= DATE_TRUNC(DATE_SUB(${selected_anchor_date}, INTERVAL 1 MONTH), MONTH)
      AND ${created_date} <= DATE_SUB(${selected_anchor_date}, INTERVAL 1 MONTH) ;;
  }

  dimension: is_qtd {
    type: yesno
    hidden: yes
    sql: ${created_date} >= DATE_TRUNC(${selected_anchor_date}, QUARTER)
      AND ${created_date} <= ${selected_anchor_date} ;;
  }

  dimension: is_previous_qtd {
    type: yesno
    hidden: yes
    sql: ${created_date} >= DATE_TRUNC(DATE_SUB(${selected_anchor_date}, INTERVAL 1 QUARTER), QUARTER)
      AND ${created_date} <= DATE_SUB(${selected_anchor_date}, INTERVAL 1 QUARTER) ;;
  }

  dimension: is_ytd {
    type: yesno
    hidden: yes
    sql: ${created_date} >= DATE_TRUNC(${selected_anchor_date}, YEAR)
      AND ${created_date} <= ${selected_anchor_date} ;;
  }

  dimension: is_previous_ytd {
    type: yesno
    hidden: yes
    sql: ${created_date} >= DATE_TRUNC(DATE_SUB(${selected_anchor_date}, INTERVAL 1 YEAR), YEAR)
      AND ${created_date} <= DATE_SUB(${selected_anchor_date}, INTERVAL 1 YEAR) ;;
  }

  # ------------------------------------------------------------------
  # 3. DYNAMIC KPI MEASURES
  # ------------------------------------------------------------------
  measure: sales_today {
    label: "Today's Sales"
    type: sum
    sql: ${sale_price} ;;
    filters: [is_today: "yes"]
    value_format_name: usd
  }

  measure: sales_yesterday {
    label: "Yesterday's Sales"
    type: sum
    sql: ${sale_price} ;;
    filters: [is_yesterday: "yes"]
    value_format_name: usd
  }

  measure: sales_mtd {
    label: "MTD Sales"
    type: sum
    sql: ${sale_price} ;;
    filters: [is_mtd: "yes"]
    value_format_name: usd
  }

  measure: sales_previous_mtd {
    label: "Previous MTD Sales"
    type: sum
    sql: ${sale_price} ;;
    filters: [is_previous_mtd: "yes"]
    value_format_name: usd
  }

  measure: sales_qtd {
    label: "QTD Sales"
    type: sum
    sql: ${sale_price} ;;
    filters: [is_qtd: "yes"]
    value_format_name: usd
  }

  measure: sales_previous_qtd {
    label: "Previous QTD Sales"
    type: sum
    sql: ${sale_price} ;;
    filters: [is_previous_qtd: "yes"]
    value_format_name: usd
  }

  measure: sales_ytd {
    label: "YTD Sales"
    type: sum
    sql: ${sale_price} ;;
    filters: [is_ytd: "yes"]
    value_format_name: usd
  }

  measure: sales_previous_ytd {
    label: "Previous YTD Sales"
    type: sum
    sql: ${sale_price} ;;
    filters: [is_previous_ytd: "yes"]
    value_format_name: usd
  }
}
