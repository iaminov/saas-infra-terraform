package test

import (
	"testing"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestNetworkingModule(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../../modules/networking",
		Vars: map[string]interface{}{
			"environment": "test",
			"vpc_cidr":   "10.0.0.0/16",
			"azs":        []string{"us-east-1a", "us-east-1b"},
		},
	})

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	vpcId := terraform.Output(t, terraformOptions, "vpc_id")
	assert.NotEmpty(t, vpcId, "VPC ID should not be empty")

	publicSubnetIds := terraform.OutputList(t, terraformOptions, "public_subnet_ids")
	assert.Equal(t, 2, len(publicSubnetIds), "Should have created 2 public subnets")

	privateSubnetIds := terraform.OutputList(t, terraformOptions, "private_subnet_ids")
	assert.Equal(t, 2, len(privateSubnetIds), "Should have created 2 private subnets")
}
