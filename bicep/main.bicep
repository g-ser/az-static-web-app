param location string

param staticWebAppName string
param stagingEnvironmentPolicy string
param skuStaticWebApp string
param skuCodeStaticWebApp string

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

output staticWebAppName string = staticWebApp.name
