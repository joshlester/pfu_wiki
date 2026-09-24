
# Commands
```sh
sudo podman build -t 3dviz/rendivo_job_balancer:v1.2 -f container/Dockerfile .
```
```
sudo podman run --rm --name ren_job_balancer -p 3001:3000 --entrypoint /bin/bash -it 3dviz/rendivo_job_balancer:v1.2
```

```sh
sudo podman run --rm --name ren_job_balancer -p 3001:3000 3dviz/rendivo_job_balancer:v1.2 --db-clear --profile --config /rendivo_job_balancer/job_balancer.config.json --import-scaffold /rendivo_job_balancer/job_balancer.scaffold.tests.b.json
```

## Development

1. Start required services e.g. keydb, postgres etc. with the command:
```sh
podman compose -f /home/josh/projects/rendivo/rendivo_job_balancer/container/docker-compose.yml up
```
2. Start Rendivo Job Balancer from source with command:
```sh
cargo watch -x 'run -- --db-clear --config job_balancer.config.json --import-scaffold ./tests/job_balancer.scaffold.no_consumers.json'
```
<br />

### Other Commands

* To start required services and start mock consumers run command:
```podman compose -f /home/josh/projects/rendivo/rendivo_job_balancer/container/docker-compose.dev.yml --profile dev up```

* Clear DB
```sh
cargo watch -x 'run -- --db-clear'
```