package terratest

import (
	"testing"

	terratest_terraform "github.com/gruntwork-io/terratest/modules/terraform"
)

func TestNetworkingPlanOnly(t *testing.T) {
	t := t
	terraformOptions := &terratest_terraform.Options{
		TerraformDir: "../../environments/staging",
		NoColor:      true,
		Vars: map[string]interface{}{
			"environment":        "staging",
			"vpc_cidr":          "10.1.0.0/16",
			"availability_zones": []string{"us-east-1a", "us-east-1b"},
		},
	}
	defer terratest_terraform.DestroyE(t, terraformOptions)
	terratest_terraform.InitE(t, terraformOptions)
	terratest_terraform.PlanE(t, terraformOptions)
}
