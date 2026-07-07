output "budget_name" {
  description = "Name of the monthly cost budget."
  value       = aws_budgets_budget.monthly_cost.name
}

output "budget_arn" {
  description = "ARN of the monthly cost budget."
  value       = aws_budgets_budget.monthly_cost.arn
}

output "budget_id" {
  description = "ID of the monthly cost budget."
  value       = aws_budgets_budget.monthly_cost.id
}

output "limit_amount" {
  description = "Monthly budget limit amount."
  value       = aws_budgets_budget.monthly_cost.limit_amount
}

output "limit_unit" {
  description = "Unit of measurement for the monthly budget limit."
  value       = aws_budgets_budget.monthly_cost.limit_unit
}
