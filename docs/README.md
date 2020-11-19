# img-builder

`img-builder` is a software for preparing Raspbian OS images. It based on [`img-tool`](https://github.com/urpylka/img-tool). It works by an incremental operations inside an initial image.

## Quick start

1. Fork it
2. Change `build.sh`, `assets` dir (as you want).
3. Run `./build.sh`

### Project name

Project name is used for naming Wi-Fi access point, local hostname.

To set own name of project you should to set `PROJECT` variable before run `./build.sh`. In Github Actions change it in `.github/workflows/makeimage.yml`. Otherwise will be used the name `builder`.
