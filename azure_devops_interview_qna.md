### Azure DevOps Engineer Interview Questions and Answers

#### Microsoft Cloud & Azure-Specific

**1. What is the difference between Azure Policy and Azure Blueprints?**\
Azure Policy enforces rules on Azure resources to ensure compliance (e.g., allowed SKUs, region restrictions). Azure Blueprints bundle policies, role assignments, and ARM templates to deploy a compliant environment in one go.

**2. How do Azure Configuration Policies help in governance?**\
They enforce specific configurations like tagging, VM sizes, and region restrictions, ensuring resources meet organizational standards automatically.

**3. Explain how Azure Desired State Configuration (DSC) works.**\
DSC is a PowerShell-based management platform that ensures the configuration of servers matches a defined state using a declarative syntax. It supports pull and push modes.

**4. How is DSC different from ARM or Terraform?**\
DSC manages the internal configuration of systems (e.g., installed software, file paths), whereas ARM/Terraform focus on infrastructure provisioning.

**5. How do you automate VM creation (Windows and Linux) in Azure using IaC?**\
Use Terraform or Bicep to define VM resources, including network, OS type, disk size, and cloud-init or custom scripts for provisioning.

**6. What’s the process for enforcing DSC on Azure VMs?**\
Enable the DSC extension in the VM resource definition and point it to a configuration file or use Azure Automation State Configuration.

---

#### Infrastructure as Code (IaC) & Scripting

**7. Compare Terraform and ARM/Bicep templates.**\
Terraform is cross-cloud, modular, and has a richer provider ecosystem. Bicep is a simplified syntax over ARM and is Azure-native. Terraform has better state management.

**8. Show how you’d declare an Azure Virtual Network using Terraform.**

```hcl
resource "azurerm_virtual_network" "example" {
  name                = "vnet1"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}
```

**9. Write a PowerShell/Bash script to install IIS or Nginx on a VM.**\
*PowerShell (Windows):*

```powershell
Install-WindowsFeature -name Web-Server -IncludeManagementTools
```

*Bash (Linux):*

```bash
sudo apt update && sudo apt install nginx -y
```

**10. How do you manage sensitive data in Terraform?**\
Use variables with sensitive = true, reference secrets from Azure Key Vault, and store state files securely (e.g., in a secured Azure Blob with RBAC).

**11. What are the best practices for writing reusable Terraform modules?**\
Keep modules small, use input/output variables, version your modules, store in separate repos, and document their usage.

---

#### CI/CD with Azure DevOps or GitHub

**12. Describe a CI/CD pipeline you built using Azure DevOps.**\
Pipeline includes code checkout, build (via MSBuild or Maven), test (e.g., NUnit), security scan (e.g., SonarQube), deployment to dev/test/stage, and release to prod with approval.

**13. How do you handle approvals or gated releases in Azure Pipelines?**\
Use "Environments" with pre-deployment approvals and configure gates like work item checks or query-based triggers.

**14. How would you securely inject secrets into a pipeline?**\
Link Azure Key Vault to the pipeline library and reference secrets using variables (`$(mySecret)`). Ensure access policies are set.

**15. GitHub Actions vs Azure Pipelines – When would you choose one?**\
Use GitHub Actions for GitHub-hosted repos and lightweight workflows. Use Azure Pipelines for advanced workflows, enterprise scale, and centralized governance.

**16. How do you ensure code quality and security in a pipeline?**\
Integrate static code analysis tools (e.g., SonarQube), secrets scanning, linting, and automated tests. Add gates to fail on threshold violations.

---

#### DevOps/SRE Practices

**17. How do you implement monitoring and alerting in a cloud environment?**\
Use Azure Monitor + Application Insights for app-level telemetry, set up metrics/log alerts, and integrate with action groups (email/Teams).

**18. How do you handle incident response in a production system?**\
Set up runbooks, use dashboards, enable alerting, notify stakeholders via automation, and conduct post-incident reviews (PIRs).

**19. What tools do you use for infrastructure monitoring?**\
Azure Monitor, Grafana, Prometheus, App Insights, Log Analytics, and custom dashboards with KQL queries.

**20. How do you ensure high availability in Azure deployments?**\
Use Availability Zones, load balancers, auto-scaling sets, traffic manager, and geo-redundant services.

**21. Describe a blue-green or canary deployment.**\
Blue-green deploys full version to a new slot; swap after validation. Canary slowly rolls out updates to a subset, monitoring impact.

---

#### Soft Skills & Communication

**22. How do you explain a complex technical issue to a non-technical stakeholder?**\
Use analogies, simplify jargon, present impacts over details, and provide visuals or diagrams.

**23. How do you handle resistance when introducing a new DevOps practice?**\
Explain benefits clearly, show small wins, involve stakeholders early, and offer training or documentation.

**24. Have you led any demos or knowledge transfers?**\
Yes, regularly conduct sprint demos and KT sessions. Prepare walkthroughs, slides, and hands-on examples to ensure clarity.

**25. How do you align your work with business goals?**\
Understand business needs from POs/PMs, map DevOps KPIs to business metrics (e.g., release frequency, MTTR), and prioritize features that drive impact.

---

#### Innovation & Growth

**26. Describe a time you introduced a tool or process that improved productivity.**\
Introduced GitHub Copilot and Terraform modules for automation, reducing deployment time by 30%.

**27. What’s the latest DevOps tool you explored?**\
Recently explored OpenTofu and Digger for Terraform automation. Also evaluated Azure Deployment Environments for ephemeral infra.

**28. How do you stay up to date with Azure and DevOps?**\
Follow Azure blogs, DevOps forums, YouTube channels (e.g., Azure Friday), take Microsoft Learn courses, and attend webinars/meetups.

**29. Share a project you’re proud of.**\
Built a self-service AKS deployment pipeline using Terraform, GitHub Actions, and ArgoCD with integrated monitoring, reducing onboarding time by 60%.

---

