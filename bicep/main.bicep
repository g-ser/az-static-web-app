param location string
param vnetName string
param vnetAddressPrefix string

@description('The name of the subnet where the private endpoint of the static web app will be created.')
param subnetNameStaticWebApp string

@description('The name of the subnet where the application gateway will be created.')
param subnetNameApplicationGateway string

param subnetApplicationGatewayAddressPrefix string
param subnetStaticWebAppAddressPrefix string
param appGatewayName string
param appGatewaySku string
param appGatewaySkuTier string
param appGatewayFrontendIPName string
param appGatewayPublicIPAddressName string
param appGatewayPublicIPAddressType string
param appGatewayPublicIPAddressSku string
param appGatewayFrontendPortName string
param appGatewayBackendPoolName string
param appGatewayBackendHTTPSettingsName string
param appGatewayHTTPListenerName string
param appGatewayRuleName string
param staticWebAppName string
param stagingEnvironmentPolicy string
param skuStaticWebApp string
param skuCodeStaticWebApp string
param privateDnsZoneName string
param appGatewayFrontendPort int
param ApplicationGatewayWebApplicationFirewallPolicyName string

var resourceIdStaticWebApp = staticWebApp.id

resource vnet 'Microsoft.Network/virtualNetworks@2023-05-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
  }
}

resource vnetName_subnetNameStaticWebApp 'Microsoft.Network/virtualNetworks/subnets@2023-05-01' = {
  parent: vnet
  name: subnetNameStaticWebApp
  properties: {
    addressPrefix: subnetStaticWebAppAddressPrefix
  }
}

resource vnetName_subnetNameApplicationGateway 'Microsoft.Network/virtualNetworks/subnets@2023-05-01' = {
  parent: vnet
  name: subnetNameApplicationGateway
  properties: {
    addressPrefix: subnetApplicationGatewayAddressPrefix
  }
}

resource staticWebApp 'Microsoft.Web/staticSites@2022-09-01' = {
  name: staticWebAppName
  location: location
  properties: {
    stagingEnvironmentPolicy: stagingEnvironmentPolicy
  }
  sku: {
    tier: skuStaticWebApp
    name: skuCodeStaticWebApp
  }
}

resource staticWebAppName_private_endpoint 'Microsoft.Network/privateEndpoints@2023-05-01' = {
  name: '${staticWebAppName}-private-endpoint'
  location: location
  properties: {
    subnet: {
      id: vnetName_subnetNameStaticWebApp.id
    }
    privateLinkServiceConnections: [
      {
        name: '${staticWebAppName}-private-link-service-connection'
        properties: {
          privateLinkServiceId: staticWebApp.id
          groupIds: [
            'staticSites'
          ]
        }
      }
    ]
  }
}

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateDnsZoneName
  location: 'global'
  properties: {}
  dependsOn: [
    vnet
  ]
}

resource privateDnsZoneName_privateDnsZoneName_link 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: privateDnsZone
  name: '${privateDnsZoneName}-link'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vnet.id
    }
  }
}

resource staticWebAppName_private_endpoint_mydnsgroupname 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-05-01' = {
  parent: staticWebAppName_private_endpoint
  name: 'mydnsgroupname'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'privatelink-4-azurestaticapps-net'
        properties: {
          privateDnsZoneId: privateDnsZone.id
        }
      }
    ]
  }
}

resource appGatewayPublicIPAddress 'Microsoft.Network/publicIPAddresses@2023-05-01' = {
  name: appGatewayPublicIPAddressName
  location: location
  sku: {
    name: appGatewayPublicIPAddressSku
    tier: 'Regional'
  }
  properties: {
    publicIPAllocationMethod: appGatewayPublicIPAddressType
  }
}

resource appGateway 'Microsoft.Network/applicationGateways@2023-05-01' = {
  name: appGatewayName
  location: location
  properties: {
    sku: {
      name: appGatewaySku
      tier: appGatewaySkuTier
    }
    gatewayIPConfigurations: [
      {
        name: appGatewayFrontendIPName
        properties: {
          subnet: {
            id: '${vnet.id}/subnets/${subnetNameApplicationGateway}'
          }
        }
      }
    ]
    sslCertificates: []
    trustedRootCertificates: []
    trustedClientCertificates: []
    sslProfiles: []
    frontendIPConfigurations: [
      {
        name: 'appGwPublicFrontendIpIPv4'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: concat(appGatewayPublicIPAddress.id)
          }
        }
      }
    ]
    frontendPorts: [
      {
        name: appGatewayFrontendPortName
        properties: {
          port: appGatewayFrontendPort
        }
      }
    ]
    backendAddressPools: [
      {
        name: appGatewayBackendPoolName
        properties: {
          backendAddresses: [
            {
              fqdn: reference(resourceIdStaticWebApp).defaultHostname
            }
          ]
        }
      }
    ]
    loadDistributionPolicies: []
    backendHttpSettingsCollection: [
      {
        name: appGatewayBackendHTTPSettingsName
        properties: {
          port: 443
          protocol: 'Https'
          cookieBasedAffinity: 'Disabled'
          pickHostNameFromBackendAddress: true
          requestTimeout: 20
        }
      }
    ]
    backendSettingsCollection: []
    httpListeners: [
      {
        name: appGatewayHTTPListenerName
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations', appGatewayName, 'appGwPublicFrontendIpIPv4')
          }
          frontendPort: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendPorts', appGatewayName, appGatewayFrontendPortName)
          }
          protocol: 'Http'
          sslCertificate: null
          requireServerNameIndication: false
          hostName: null
          customErrorConfigurations: null
        }
      }
    ]
    listeners: []
    urlPathMaps: []
    requestRoutingRules: [
      {
        name: appGatewayRuleName
        properties: {
          ruleType: 'Basic'
          httpListener: {
            id: resourceId('Microsoft.Network/applicationGateways/httpListeners', appGatewayName, appGatewayHTTPListenerName)
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', appGatewayName, appGatewayBackendPoolName)
          }
          backendHttpSettings: {
            id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', appGatewayName, appGatewayBackendHTTPSettingsName)
          }
          urlPathMap: null
          redirectConfiguration: null
          rewriteRuleSet: null
          priority: 1
        }
      }
    ]
    routingRules: []
    probes: []
    rewriteRuleSets: []
    redirectConfigurations: []
    privateLinkConfigurations: []
    enableHttp2: true
    autoscaleConfiguration: {
      minCapacity: 0
      maxCapacity: 10
    }
    firewallPolicy: {
      id: concat(ApplicationGatewayWebApplicationFirewallPolicy.id)
    }
  }
  dependsOn: [
    vnetName_subnetNameApplicationGateway
  ]
}

resource ApplicationGatewayWebApplicationFirewallPolicy 'Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies@2023-05-01' = {
  name: ApplicationGatewayWebApplicationFirewallPolicyName
  location: location
  properties: {
    customRules: []
    policySettings: {
      requestBodyCheck: true
      maxRequestBodySizeInKb: 128
      fileUploadLimitInMb: 100
      state: 'Enabled'
      mode: 'Detection'
      requestBodyInspectLimitInKB: 128
      fileUploadEnforcement: true
      requestBodyEnforcement: true
    }
    managedRules: {
      managedRuleSets: [
        {
          ruleSetType: 'OWASP'
          ruleSetVersion: '3.2'
          ruleGroupOverrides: []
        }
        {
          ruleSetType: 'Microsoft_BotManagerRuleSet'
          ruleSetVersion: '0.1'
          ruleGroupOverrides: []
        }
      ]
      exclusions: []
    }
  }
}

output deploymentToken string = listSecrets(resourceIdStaticWebApp, '2019-08-01').properties.apiKey
