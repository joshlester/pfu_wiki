
## URL Search Query Params

When requesting paginated data from the server the client will pass up the following search query params:
 - page: The page index (1-based)
 - per_page: The number of items on each page
 
## Conversion

Reasons for conversion:
 - It is a good web design practise to consider the URL as part of the UI.
 As such search parameters name should be clear, self explanatory and expressed in 
 non-technical language.
 
 - Users refer to the first page as page 1 not as page 0.
<br> 
 
### Client-side
The client logic will convert the search query params pagination data as follows:
 - page -> ```pageIndex``` (0-based)
 - per_page -> ```pageSize```
 
### Server-side
The server logic will convert the search query params pagination data as follows:
 - page -> ```pageIndex``` (0-based)
 - per_page -> ```pageSize```