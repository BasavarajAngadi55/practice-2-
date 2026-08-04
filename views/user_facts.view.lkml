view: user_facts {
  derived_table: {
    sql:
      SELECT
        user_id,
        SUM(sale_price) AS period_spend,
        COUNT(DISTINCT order_id) AS period_order_count,
        RANK() OVER (ORDER BY SUM(sale_price) DESC) AS user_rank
      FROM order_items
      -- The Liquid magic: injects whatever date the user selects on the dashboard
      WHERE {% condition select_date %} order_items.created_at {% endcondition %}
      GROUP BY 1 ;;
  }

  # ------------------------------------------------------------------
  # 1. FILTER-ONLY FIELD (This becomes the Dashboard Date Picker)
  # ------------------------------------------------------------------
  filter: select_date {
    type: date
    label: "Select Date Range"
    description: "Use this filter to dynamically change the date range for user calculations."
  }

  # ------------------------------------------------------------------
  # 2. DIMENSIONS & MEASURES
  # ------------------------------------------------------------------
  dimension: user_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: user_rank {
    type: number
    sql: ${TABLE}.user_rank ;;
  }

  measure: total_spend {
    type: sum
    sql: ${TABLE}.period_spend ;;
    value_format_name: usd
  }
}
