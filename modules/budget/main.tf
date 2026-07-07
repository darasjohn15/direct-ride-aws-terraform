locals {
  budget_name = coalesce(var.budget_name, "${var.name_prefix}-budget")
}

# The Terraform execution role/user must have AWS Budgets permissions such as
# budgets:CreateBudget, budgets:ModifyBudget, budgets:DeleteBudget,
# budgets:DescribeBudget, budgets:DescribeBudgets, budgets:CreateNotification,
# budgets:UpdateNotification, and budgets:DeleteNotification.
resource "aws_budgets_budget" "monthly_cost" {
  name         = local.budget_name
  budget_type  = "COST"
  limit_amount = tostring(var.limit_amount)
  limit_unit   = var.limit_unit
  time_unit    = var.time_unit

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = var.warning_threshold_percentage
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [var.notification_email]
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = var.critical_threshold_percentage
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [var.notification_email]
  }

  tags = merge(var.tags, {
    Name = local.budget_name
  })
}
