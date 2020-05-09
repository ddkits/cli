# Chef Server

## Volumes

`/var/opt/opscode` directory, that holds all Chef server data, is a
volume. Directories `/var/log/opscode` and `/etc/opscode` are linked
there as, respectively, `log` and `etc`.

If there is a file `etc/chef-server-local.rb` in this volume, it will
be read at the end of `chef-server.rb` and it can be used to customize
Chef Server's settings.

## Signals

- `docker kill -s HUP $CONTAINER_ID` will run `chef-server-ctl reconfigure`
- `docker kill -s USR1 $CONTAINER_ID` will run `chef-server-ctl status`

## Usage

### Prerequisites and first start

First start will automatically run `chef-server-ctl reconfigure`. Subsequent starts will not run `reconfigure`, unless
file `/var/opt/opscode/bootstrapped` has been deleted or hostname has
changed (i.e. on upgrade). You can run `reconfigure` (e.g. after
editing `etc/chef-server.rb`) using `docker-enter` or by sending
SIGHUP to the container: `docker kill -HUP $CONTAINER_ID`.

### Upgrading

Just kill the old container and start a new one using the same data
volume. The image will automatically run `chef-server-ctl upgrade`
when version of `chef-server-core` package changes. You will need to
run `chef-server-ctl cleanup` afterwards.

If the repository is lagging, to build a new image with new Chef
Server version, all you need to do is update the variables on top of
the [`install.sh`](install.sh) script.

### Maintenance commands

Chef Server's design makes it impossible to wrap it cleanly in
a container - it will always be necessary to run custom
commands. While some of the management commands may work with linked
containers with varying amount of ugly hacks, it is simpler to have
one way of interacting with the software that is closest to
interacting with a Chef Server installed directly on host (and thus
closest to supported usage).

This means you need Docker 1.3+ with `docker exec` feature, and run
`chef-server-ctl` commands like:

    docker exec $CONTAINER_ID chef-server-ctl status
    docker exec $CONTAINER_ID chef-server-ctl user-create …
    docker exec $CONTAINER_ID chef-server-ctl org-create …
    docker exec $CONTAINER_ID chef-server-ctl …

If you have Docker older than 1.3 and can't upgrade, you should be
able to get by with `nsenter` utility and
[`docker-enter`](https://github.com/jpetazzo/nsenter) script by
[Jérôme Petazzoni](https://github.com/jpetazzo) on your Docker
host. The easiest way to install it is to run the installer Docker
image:

    docker run --rm -v /usr/local/bin:/target jpetazzo/nsenter

Then, you can use the `docker-enter` script to run `chef-server-ctl`
commands:

    docker-enter $CONTAINER_ID chef-server-ctl …
