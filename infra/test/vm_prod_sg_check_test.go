package terratest

import (
	"context"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/yandex-cloud/go-genproto/yandex/cloud/compute/v1"
	"github.com/yandex-cloud/go-genproto/yandex/cloud/vpc/v1"
	ycsdk "github.com/yandex-cloud/go-sdk"
	"github.com/yandex-cloud/go-sdk/iamkey"
)

func TestProdVMSecurityGroup(t *testing.T) {
	// Опции Terraform
	terraformOptions := &terraform.Options{
		TerraformDir: "..",
	}

	// Инициализация и применение Terraform
	terraform.InitAndApply(t, terraformOptions)

	// Получение выходных данных
	vmProdName := terraform.Output(t, terraformOptions, "vm_prod_name")
	securityGroupName := terraform.Output(t, terraformOptions, "security_group_name")
	securityGroupId := terraform.Output(t, terraformOptions, "security_group_id")

	// Проверка имени Security Group
	assert.Equal(t, "infra-security-group", securityGroupName, "Security Group name does not match")

	// Проверка, что Security Group ID не пустой
	assert.NotEmpty(t, securityGroupId, "Security Group ID should not be empty")

	// Инициализация Yandex Cloud SDK для проверки Security Group
	ctx := context.Background()
	yc, err := ycsdk.Build(ctx, ycsdk.Config{
		Credentials: getYCToken(t),
	})
	if err != nil {
		t.Fatalf("Failed to initialize Yandex Cloud SDK: %v", err)
	}

	// Проверка существования Security Group
	vpcService := yc.VPC().SecurityGroup()
	securityGroups, err := vpcService.List(ctx, &vpc.ListSecurityGroupsRequest{
		FolderId: "***", // Укажите ваш Folder ID
	})
	if err != nil {
		t.Fatalf("Failed to list security groups: %v", err)
	}

	securityGroupFound := false
	for _, sg := range securityGroups.SecurityGroups {
		if sg.Name == securityGroupName {
			securityGroupFound = true
			// Проверяем, что Security Group имеет правильные правила
			assert.NotEmpty(t, sg.Rules, "Security Group should have rules")

			// Проверяем наличие SSH правила (порт 22)
			sshRuleFound := false
			httpRuleFound := false
			for _, rule := range sg.Rules {
				if rule.Direction == vpc.SecurityGroupRule_DIRECTION_INGRESS {
					if rule.PortRange != nil && rule.PortRange.From == 22 && rule.PortRange.To == 22 {
						sshRuleFound = true
					}
					if rule.PortRange != nil && rule.PortRange.From == 8200 && rule.PortRange.To == 8200 {
						httpRuleFound = true
					}
				}
			}
			assert.True(t, sshRuleFound, "SSH rule (port 22) not found in Security Group")
			assert.True(t, httpRuleFound, "HTTP rule (port 8200) not found in Security Group")
		}
	}
	assert.True(t, securityGroupFound, "Security Group not found in Yandex Cloud")

	// Проверка, что prod VM имеет Security Group
	computeService := yc.Compute().Instance()
	instances, err := computeService.List(ctx, &compute.ListInstancesRequest{
		FolderId: "***", // Укажите ваш Folder ID
	})
	if err != nil {
		t.Fatalf("Failed to list instances: %v", err)
	}

	prodVMSecurityGroupFound := false
	for _, instance := range instances.Instances {
		if instance.Name == vmProdName {
			for _, networkInterface := range instance.NetworkInterfaces {
				for _, securityGroupId := range networkInterface.SecurityGroupIds {
					if securityGroupId == securityGroupId {
						prodVMSecurityGroupFound = true
						break
					}
				}
			}
		}
	}
	assert.True(t, prodVMSecurityGroupFound, "Prod VM does not have the required Security Group assigned")
}

// Функция для получения OAuth-токена
func getYCToken(t *testing.T) ycsdk.Credentials {
	key, err := iamkey.ReadFromJSONFile("../authorized_key.json")
	if err != nil {
		t.Fatalf("Failed to read authorized_key.json: %v", err)
	}

	credentials, err := ycsdk.ServiceAccountKey(key)
	if err != nil {
		t.Fatalf("Failed to get credentials: %v", err)
	}
	return credentials
}
