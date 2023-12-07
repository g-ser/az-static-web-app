using './main.bicep'
param staticWebAppNameProduction = 'stapp-prod'
param staticWebAppNameStaging = 'stapp-staging'
param location = 'westeurope'
param skuStaticWebApp = 'Standard'
param skuCodeStaticWebApp = 'Standard'
param vnetAddressPrefix = '10.0.0.0/16'
param subnetApplicationGatewayAddressPrefix = '10.0.1.0/24'
param subnetStaticWebAppAddressPrefix = '10.0.0.0/24'
param stagingEnvironmentPolicy = 'Disabled'
param subnetNameStaticWebApp = 'snet-staticapp'
param vnetName = 'vnet-agw-test'
param privateDnsZoneName = 'privatelink.4.azurestaticapps.net'

// App GATEWAY CONFIGURATION PARAMETERS

// App Gateway Name
param appGatewayName = 'agw-test'
// General configuration parameters for application gateway
param subnetNameApplicationGateway = 'snet-agw'
param appGatewayPublicIPAddressSku = 'Standard'
param appGatewayPublicIPAddressType = 'Static'
param appGatewayFrontendIPName = 'appGatewayFrontendIP'
param appGatewayPublicIPAddressName = 'appGatewayPublicIPAddress'
param appGatewayFrontendPortName = 'appGatewayFrontendPort'
param appGatewayFrontendPort = 80
// Backend Pools
param staticWebAppStagingBackendPool = 'staticWebAppStagingBackendPool'
param staticWebAppProductionBackendPool = 'staticWebAppProductionBackendPool'
// Backend HTTP Settings
param appGatewayBackendHTTPSettingsToHostname = 'forwardToHost'
param appGatewayBackendHTTPSettingsToPath = 'forwardToPath'
// Rules
param appGatewayProductionRuleName = 'appGatewayProductionRule'
param appGatewayStagingRuleName = 'appGatewayStagingRule'
param appGatewaySubDomainRuleName = 'proteinRule'
// Listeners
param stagingListenerName = 'stagingListener'
param subDomainListenerName = 'proteinListener'
param productionListenerName = 'productionListener'
// root domain
param rootDomain = 'randompro.info'
// Tier for Application Gateway
param appGatewaySku = 'WAF_v2'
param appGatewaySkuTier = 'WAF_v2'
// WAF Policy
param ApplicationGatewayWebApplicationFirewallPolicyName = 'testwaf'
