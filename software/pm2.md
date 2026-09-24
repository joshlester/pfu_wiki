
# PM2



## Commands
View running processes
```
pm2 ps
```
View all processes
```
pm2 ps -a
```

e.g. To update the environment variable NODE_ENV to production
```
NODE_ENV=production pm2 restart {process_id_or_name} --update-env
```

e.g. to reload the PM2 ecosystem.config.js file
```
pm2 reload ecosystem.config.js
```

## Configuration
When watching files in debug run the following to avoid error:
```\ndnsmasq: failed to create inotify: Too many open files\n```

https://github.com/coder/code-server/issues/628
```bash
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf
echo fs.inotify.max_user_instances=524288 | sudo tee -a /etc/sysctl.conf
```