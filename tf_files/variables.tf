# Defining policy ARNs as list (for siteVisitLambdaRole)

variable "siteVisit_policy_arn" {
  description = "IAM Policy to be attached to role"
  type = list(string)
}    # Var for creating llevi site visit lambda role

variable "cifSending_policy_arn" {
  description = "IAM Policy to be attached to role"
  type = list(string)
}