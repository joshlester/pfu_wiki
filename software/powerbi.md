
# Issues
## Row-Level Security (RLS)

### Traps
- The UseRelationship() and CrossFilter() functions may not be used when querying '<oii>production_product_eom_reserve</oii>' because it is constrained by row-level security.

Issue
Error event (viewable in Event Viewer under Windows Logs -> Application) MSOLAP$AnalysisServicesWorkspace... cannot be found. Either the component that raises this event is not installed on oyur local computer or thje installation is corrupted.

Solution 
Install the Analysis Services client libraries
https://learn.microsoft.com/en-us/analysis-services/client-libraries?view=asallproducts-allversions
