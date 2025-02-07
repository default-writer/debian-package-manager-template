# debian-package-manager-template

## init

```bash
sudo ./bin/deb.sh --setup
```

## help

```bash
./bin/deb.sh --help
```

## build

```bash
sudo ./bin/deb.sh --helloworld --no-update
```

## install

```bash
sudo dpkg -i ./deb/helloworld_0.1_amd64.deb
```

## uninstall

```bash
sudo dpkg -r helloworld
```
