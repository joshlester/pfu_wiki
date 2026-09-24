job "pfu-wiki" {
  datacenters = ["bytenaut"]

  group "pfu-wiki" {
    count = 1

    shutdown_delay = "10s"

    network {
      mode = "host"
      port "pfu-wiki" {
        static = 9010
      }
    }

    task "pfu-wiki" {
      driver = "podman"

      config {
        image        = "docker.io/redimp/otterwiki:2"
        network_mode = "host"
        # Persist the wiki content (git repo OtterWiki serves + commits to).
        # OtterWiki's stock entrypoint hardcodes an extra "listen 8080" (host
        # port 8080 is signal-cli), so we swap in a wrapper entrypoint that
        # binds 9010 only. Caddy will proxy wiki.pfu.gg -> 127.0.0.1:9010.
        volumes      = [
          "/var/lib/containers/storage/volumes/pfu_wiki_otterwiki_data/_data:/app-data",
          "/opt/hashicorp/nomad/jobs/pfu-wiki/entrypoint.sh:/entrypoint.sh:ro",
        ]
        force_pull   = false
      }

      resources {
        cpu    = 300
        memory = 512
      }

      restart {
        attempts = 5
        interval = "10m"
        delay    = "5s"
        mode     = "fail"
      }

      service {
        name = "pfu-wiki"
        tags = ["http"]
        port = "pfu-wiki"
        check {
          type     = "tcp"
          port     = "pfu-wiki"
          interval = "10s"
          timeout  = "3s"
        }
      }
    }
  }
}