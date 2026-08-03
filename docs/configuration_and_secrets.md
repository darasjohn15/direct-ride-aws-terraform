# Application Configuration and Secrets

## Overview 

The DirectRide backend receives its runtime configuration through a combination of AWS Secrets Manager, Amazon Systems Manager Parameter Store, and Amazon ECS environment variables. Sensitive values are injected as ECS secrets, while non-sensitive configuration is provided through standard environment variables or Parameter Store.

## AWS Secrets Manager

| Secret | Default Name | Created By | Consumer | Purpose |
|---|---|---|---|---|
| JWT secret | `direct-ride-dev/api/jwt` | Terraform `random_password` and Secrets Manager secret | ECS API task | Signs and validates authentication tokens |
| Database master user secret | AWS-managed RDS secret name | RDS with `manage_master_user_password = true` | ECS API task | Provides the PostgreSQL master password |

## Secret Values Passed to ECS

| ECS Secret Name | Value Source | Notes |
|---|---|---|
| `DB_PASSWORD` | RDS master user secret ARN with `:password::` JSON key selector | Injected into the container as a secret, not a plain environment variable |
| `JWT_SECRET` | JWT Secrets Manager secret ARN | Injected into the container as a secret |

## Plain ECS Environment Variables

| Variable | Value Source |
|---|---|
| `DB_HOST` | RDS database address |
| `DB_NAME` | RDS database name |
| `DB_PORT` | RDS database port converted to a string |
| `DB_USER` | RDS database username |

## Systems Manager Parameter Store

| Property | Value |
|---|---|
| Default Path Prefix | `/direct-ride-dev/api/config` |
| Parameter Type | `String` |
| Created From | `app_config_parameters` map |
| Default Parameters | None |

Parameter names are built as:

```text
/<path-prefix>/<parameter-key>
```

For the default path, a key like `example` becomes:

```text
/direct-ride-dev/api/config/example
```

## IAM Access

| Role | Access |
|---|---|
| `direct-ride-dev-api-task-execution-role` | Can read the RDS master user secret and JWT secret during ECS task startup |
| `direct-ride-dev-api-task-role` | Can read the RDS master user secret, JWT secret, and SSM parameters under the app config path |

## Terraform Outputs

- `jwt_secret_arn`
- `jwt_secret_name`
- `app_config_parameter_path_prefix`
- `app_config_parameter_arns`
