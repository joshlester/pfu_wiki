
# Azure

## Authentication

### Redirects

Ensure redirect URL are https else they'll be ignored.

Login
To avoid being redirected to the default login complete page:
/.auth/login/complete

include query param
/.auth/login/aad?post_login_redirect_uri=${encodeURIComponent('https://yourapp.com/home')};

Logout
To avoid being redirected to the default logout complete page:
/.auth/logout/complete

include query param
/.auth/logout?post_logout_redirect_uri=${encodeURIComponent('https://yourapp.com/home')};

## Connection

### Connection String
https://github.com/prisma/prisma/discussions/5817#discussioncomment-401691

There are a few options you can use, so you can continue using TLS but don't need a valid certificate:

- ```encrypt``` can be either true or false. The former will encrypt all traffic, the latter only the login details. Nowadays we have fast cpus for TLS, so I'd recommend setting this to true.

 - ```trustServerCertificate``` is a setting that defines do we need a valid cert or not. On Azure SQL and if you have a public domain with a signed cert to the database, this should be false. Otherwise, if self-signing, set this to true and you should be able to connect.
 