## rsync-server

A `rsyncd` server/client in Docker. You know, for moving files.


### quickstart

Start a server

```
$ docker run \
    --name rsync-server \ # Name it
    -p 8000:873 \ # rsyncd port
    -e USERNAME=user \ # rsync username
    -e PASSWORD=pass \ # rsync password
    thann/rsync
```

**Warning** If you are exposing services to the internet be sure to change the default password from `pass` by settings the environmental variable `PASSWORD`.

#### `rsyncd`

Please note that `data` is the `rsync` volume pointing to `/data`. The data
will be at `/data` in the container. Use the `VOLUME` parameter to change the
volume **name** in rsync. Even when changing `VOLUME`, you will still
`rsync` to `/data`. **It is recommended that you always change the default password of `pass` by setting the `PASSWORD` environmental variable, even if you are using key authentication.**

```
$ rsync -av /your/folder/ rsync://user@localhost:8000/data
Password: pass
sending incremental file list
./
foo/
foo/bar/
foo/bar/hi.txt

sent 166 bytes  received 39 bytes  136.67 bytes/sec
total size is 0  speedup is 0.00
```

### Usage

Variable options (on run)

* `USERNAME` - the `rsync` username. defaults to `user`
* `PASSWORD` - the `rsync` password. defaults to `pass`
* `VOLUME`   - the name of the `rsync` module, defaults to `data`.
* `ALLOW`    - space separated list of allowed sources. defaults to `192.168.0.0/16 172.16.0.0/12`.


##### Simple server on port 873

```
$ docker run -p 873:873 thann/rsync
```


##### Use a volume for the default `/data`

```
$ docker run -p 873:873 -v /your/folder:/data thann/rsync
```

##### Set a username and password

```
$ docker run \
    -p 873:873 \
    -v /your/folder:/data \
    -e USERNAME=admin \
    -e PASSWORD=mysecret \
    thann/rsync
```

##### Run on a custom port

```
$ docker run \
    -p 9999:873 \
    -v /your/folder:/data \
    -e USERNAME=admin \
    -e PASSWORD=mysecret \
    thann/rsync
```

```
$ rsync rsync://admin@localhost:9999
volume            /data directory
```


##### Modify the default volume location

```
$ docker run \
    -p 9999:873 \
    -v /your/folder:/myvolume \
    -e USERNAME=admin \
    -e PASSWORD=mysecret \
    -e VOLUME=myvolume \
    thann/rsync
```

```
$ rsync rsync://admin@localhost:9999
volume            /myvolume directory
```

##### Allow additional client IPs

```
$ docker run \
    -p 9999:873 \
    -v /your/folder:/myvolume \
    -e USERNAME=admin \
    -e PASSWORD=mysecret \
    -e VOLUME=/myvolume \
    -e ALLOW=192.168.8.0/24 192.168.24.0/24 172.16.0.0/12 127.0.0.1/32 \
    thann/rsync
```


##### Over SSH

Receiving data over SSH is not supported by this server!
