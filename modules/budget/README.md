# Budget Module

Creates one AWS monthly cost budget with email notifications.

## Resources

- AWS Budgets cost budget
- Email notification at 50% actual spend
- Email notification at 100% actual spend

## IAM Permissions

The Terraform execution role or user needs AWS Budgets permissions to manage this resource, including:

- `budgets:CreateBudget`
- `budgets:ModifyBudget`
- `budgets:DeleteBudget`
- `budgets:DescribeBudget`
- `budgets:DescribeBudgets`
- `budgets:CreateNotification`
- `budgets:UpdateNotification`
- `budgets:DeleteNotification`

If tags are managed on the budget, the role may also need `budgets:TagResource`, `budgets:UntagResource`, and `budgets:ListTagsForResource`.

## Usage

```hcl
module "budget" {
  source = "../../modules/budget"

  name_prefix        = "direct-ride-dev"
  notification_email = var.notification_email

  tags = {
    Project     = "direct-ride"
    Environment = "dev"
  }
}
```

## Inputs

| Name | Description | Type | Default |
| --- | --- | --- | --- |
| `name_prefix` | Prefix used when naming budget resources. | `string` | n/a |
| `budget_name` | Optional explicit name for the monthly cost budget. | `string` | `null` |
| `limit_amount` | Monthly budget limit amount. | `number` | `20` |
| `limit_unit` | Unit of measurement for the budget limit. | `string` | `"USD"` |
| `time_unit` | Budget reset period. | `string` | `"MONTHLY"` |
| `warning_threshold_percentage` | Actual spend percentage that triggers the warning budget email notification. | `number` | `50` |
| `critical_threshold_percentage` | Actual spend percentage that triggers the critical budget email notification. | `number` | `100` |
| `notification_email` | Email address that receives AWS Budget notifications. | `string` | n/a |
| `tags` | Tags applied to all budget resources. | `map(string)` | `{}` |

## Outputs

| Name | Description |
| --- | --- |
| `budget_name` | Name of the monthly cost budget. |
| `budget_arn` | ARN of the monthly cost budget. |
| `budget_id` | ID of the monthly cost budget. |
| `limit_amount` | Monthly budget limit amount. |
| `limit_unit` | Unit of measurement for the monthly budget limit. |
