
# Composer

Composer require will update the required property (section) in composer.json
and then run an update to install the new dependency.

| Option | Description |
| --- | --- |
| --ignore-platform-reqs | Ignores the platform requirement e.g. PHP 7 that the author (dev) placed on the library. This option was required below as facebook/graph-sdk had a requirement of PHP 5.7 | 7 whilst this dependency was being install on a host machine with PHP 8 installed.

```
composer require --ignore-platform-reqs league/iso3166:4.1.0 facebook/graph-sdk:5.7.0
```

## Composer Update
Composer update will install the specified dependency and updated the composer.lock file however it will **not** update composer.json. Versioning in the composer.lock always references a specific version e.g. 5.7.0 vs the semantic versioning in the composer.json file e.g. ^5.7.0
