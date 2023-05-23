
- [Docker Test Containers in Java Tests](https://www.baeldung.com/docker-test-containers)
- [Testcontainers](https://www.testcontainers.org/)
- [evgeniy-khist/podman-testcontainers](https://github.com/evgeniy-khist/podman-testcontainers)

```shell
echo "alias podman-sock=\"rm -f /tmp/podman.sock && ssh -i ~/.ssh/podman-machine-default -p \$(podman system connection list --format=json | jq '.[0].URI' | sed -E 's|.+://.+@.+:([[:digit:]]+)/.+|\1|') -L'/tmp/podman.sock:/run/user/1000/podman/podman.sock' -N core@localhost\"" >> ~/.zprofile
source ~/.zprofile
podman-sock
```
