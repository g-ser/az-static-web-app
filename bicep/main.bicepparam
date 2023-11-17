using './main.bicep'
param staticWebAppName = 'stapp-test'
param location = 'westeurope'
param skuStaticWebApp = 'Standard'
param skuCodeStaticWebApp = 'Standard'
param vnetAddressPrefix = '10.0.0.0/16'
param subnetApplicationGatewayAddressPrefix = '10.0.1.0/24'
param subnetStaticWebAppAddressPrefix = '10.0.0.0/24'
param stagingEnvironmentPolicy = 'Disabled'
param subnetNameStaticWebApp = 'snet-staticapp'
param vnetName = 'vnet-agw-test'
param subnetNameApplicationGateway = 'snet-agw'
param appGatewayPublicIPAddressSku = 'Standard'
param appGatewayPublicIPAddressType = 'Static'
param appGatewayBackendPoolName = 'appGatewayBackendPool'
param appGatewayName = 'agw-test'
param appGatewaySku = 'WAF_v2'
param appGatewaySkuTier = 'WAF_v2'
param appGatewayFrontendIPName = 'appGatewayFrontendIP'
param appGatewayPublicIPAddressName = 'appGatewayPublicIPAddress'
param appGatewayFrontendPortName = 'appGatewayFrontendPort'
param appGatewayFrontendPort = 80
param appGatewayBackendHTTPSettingsName = 'appGatewayBackendHTTPSettings'
param appGatewayHTTPListenerName = 'appGatewayHTTPListener'
param appGatewayRuleName = 'appGatewayRule'
param privateDnsZoneName = 'privatelink.4.azurestaticapps.net'
param ApplicationGatewayWebApplicationFirewallPolicyName = 'testwaf'