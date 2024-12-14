data "aws_iam_policy_document" "tenant_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = var.trusted_principals
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "tenant_role" {
  name               = "${var.tenant}-role"
  assume_role_policy = data.aws_iam_policy_document.tenant_assume_role.json
  tags = {
    Tenant = var.tenant
  }
}

resource "aws_iam_policy" "tenant_policy" {
  name   = "${var.tenant}-policy"
  policy = var.inline_policy_json
}

resource "aws_iam_role_policy_attachment" "tenant_attachment" {
  role       = aws_iam_role.tenant_role.name
  policy_arn = aws_iam_policy.tenant_policy.arn
}

resource "aws_iam_openid_connect_provider" "eks" {
  url             = var.eks_oidc_url
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [var.oidc_thumbprint]
}

data "aws_iam_policy_document" "irsa_trust" {
  statement {
    effect = "Allow"
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(var.eks_oidc_url, "https://", "")}:sub"
      values   = var.irsa_service_accounts
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]
  }
}

resource "aws_iam_role" "irsa_role" {
  count              = length(var.irsa_role_names)
  name               = var.irsa_role_names[count.index]
  assume_role_policy = data.aws_iam_policy_document.irsa_trust.json
}

resource "aws_iam_policy" "irsa_policy" {
  count  = length(var.irsa_role_names)
  name   = "${var.irsa_role_names[count.index]}-policy"
  policy = var.irsa_inline_policy_json
}

resource "aws_iam_role_policy_attachment" "irsa_attachment" {
  count      = length(var.irsa_role_names)
  role       = aws_iam_role.irsa_role[count.index].name
  policy_arn = aws_iam_policy.irsa_policy[count.index].arn
}
