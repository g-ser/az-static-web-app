# AZ-Static-Web-App

## Repo Content<a name="repo_content"></a>

The main element of the current repository is a GitHub action [workflow](/.github/workflows/deploy-AppGw-StaticWebApp.yaml). When the workflow is triggered, it creates an Azure Static Web App and an Application Gateway in front of the Static Web App. The other important element is the ARM [template](/arm-templates/template.json) which is invoked by the GitHub action and is responsible for the actual deployment of the resources defined in it (i.e., Azure Static Web App, Application Gateway, VNet etc.). 

<!-- Please note that the GitHub action workflow of the current repo creates the Azure Static Web App **without** deploying any code on top of it. Once the Static Web App is created, Azure generates a deployment token which can be used (e.g.) -->

## Prerequisites for working with the repo<a name="prerequisites"></a>

Some resources need to pre-exist in Azure in order for the [workflow](/.github/workflows/deploy-AppGw-StaticWebApp.yaml) to be able to provision the infrastructure described in the ARM [template](/arm-templates/template.json). First of all the resource group where the resources will be provisioned needs to be there. In addition, the integration between GitHub Actions and Azure needs to be in place.

### Creation of Resource Group

A resource group named ```rg-static-web-app``` was created in Azure. The name of the resource group is stored as variable in GitHub settings as in the picture below:

![Adding Variables](/assets/images/AddVariableOnGitHub.png){: width="50%"}

Note that the Azure ARM deploy action in the [workflow](/.github/workflows/deploy-AppGw-StaticWebApp.yaml) uses the variable ```RESOURCE_GROUP```

### Integration between GitHub Actions and Azure

> [!NOTE] 
> For details about integrating GitHub Actions with Azure using managed identities together with Federated Credentials check the article: [Use GitHub Actions with User-Assigned Managed Identity](https://yourazurecoach.com/2022/12/29/use-github-actions-with-user-assigned-managed-identity/)

Since the purpose of this repo is to create the needed resources on Azure (e.g., Static Web App, Azure Application Gateway, Azure Virtual Network etc.) using a GitHub action workflow, there is the need for GitHub to authenticate against Azure. This happens thanks to Azure managed identities. One managed identity called ```id-githubactions``` was pre-created. The ```id-githubactions``` is assigned the Contributor role on the pre-created ```rg-static-web-app``` resource group. The ```id-githubactions``` managed identity, uses federated credentials which were created from the Azure portal as in the picture below.

![Adding Federated Credential](/assets/images/AddFederatedCredential.png){: width="50%"}

The ```AZURE_CLIENT_ID```, ```AZURE_SUBSCRIPTION_ID``` and ```AZURE_TENANT_ID``` of ```id-githubactions``` were configured in GitHub settings as in the picture below:

![Adding Secrets on GitHub](/assets/images/AddSecretsOnGitHub.png =250x250)

Note that the Azure login action in the [workflow](/.github/workflows/deploy-AppGw-StaticWebApp.yaml) uses the secrets ```AZURE_CLIENT_ID```, ```AZURE_SUBSCRIPTION_ID``` and ```AZURE_TENANT_ID``` to authenticate with OpenID Connect.

## Provisioning the Static Web App and the Application Gateway by running the GitHub Action Workflow<a name="provisioning_a_static_web_app"></a>

The name of the static web app are hardcoded in [parameters](/arm-templates/parameters.json) file. 