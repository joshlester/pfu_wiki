
## Development

### Links
https://webscraping.ai/faq/headless_chrome-rust/how-do-i-execute-custom-javascript-on-a-page-with-headless_chrome-rust-in-rust
<br>

```Kick-off dev```
```sh
podman compose -f /home/josh/projects/bytenaut/lotta_list_scrapper/container/docker-compose.yml --profile dev run --entrypoint sh --rm dev
```
```Build prod```
```sh
podman build -f ./container/prod/Dockerfile -t listlong:prod-1 .
```
```Kick-off prod```
```sh
podman compose -f /home/josh/projects/bytenaut/lotta_list_scrapper/container/docker-compose.yml --profile prod run --rm prod
```

### Add new product

1. Add scrap script ```e.g. assets/scripts/scrap_amazon_earbuds_script.js```
1. Add platform product ```e.g. src/domains/amazon/data/earbuds.rs```
1. Add lotta product ```e.g. src/domains/product/data/product_earbuds.rs```
1. Add repository ```e.g. src/domains/product/repository/product_earbuds_repository.rs``` <--
1. Add action ```e.g. src/domains/amazon/actions/amazon_scrap_earbuds_action.rs```