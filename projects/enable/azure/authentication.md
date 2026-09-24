
# Athentication

## Redirect

### Web Redirect URIs
Web redirects are required when logging into the Enable Portal (login button top-right site bar). These URIs are captured by Azure Easy Auth:
https://learn.microsoft.com/en-us/azure/app-service/scenario-secure-app-authentication-app-service?tabs=workforce-configuration

![azure_authentication_web_redirect_uris.png](/projects/eltirus-enable/azure/azure_authentication_web_redirect_uris.png)


### Single-page Application Redirect URIs
Single-page Redirects are required by Microsoft Authentication Library (MSAL):
https://learn.microsoft.com/en-us/entra/identity-platform/msal-overview

When viewing the embedded Power BI report within the Enable Portal the user is prompted to sign into Power BI (a _*Sign in to view Report*_ button is displayed). These URIs e.g. https://enable.eltirus.com are required else the report will not be displayed.

![azure_authentication_single-page_application_redirect_uris.png](/projects/eltirus-enable/azure/azure_authentication_single-page_application_redirect_uris.png)
