# setup_dev_environment

* This is My experience with so many fields.
* Feel free to fork My notes. :)
* Prepare my dev-enviroment on a Linux machine(Could be a physical or virtual machine) and use vscode with ssh plugin to connect this.
* mkdocs-material to render *.md files to static web site files

## Prerequisites

* Python >= 3.11
* [pyenv + poetry](https://github.com/hong539/setup_dev_environment/blob/main/docs/computer%20languages/programming_languages/python/python.md#usage-with-pyenvpoetry)
* [mkdocs-material](https://github.com/squidfunk/mkdocs-material)

## Quick start

* [roadmaps](https://roadmap.sh/roadmaps)

```shell
poetry shell

mkdocs new [dir-name]
mkdocs serve
mkdocs build
mkdocs -h

#manually execute
docker build . -t docker.io/focal1119/setup_dev_environment:prod
docker build . -t docker.io/focal1119/setup_dev_environment:test -f Dockerfile.ci
docker run -d --name setup_dev_environment -p 8000:80 docker.io/focal1119/setup_dev_environment:prod

#github actions
#CI
docker build . -t docker.io/focal1119/setup_dev_environment:latest -f Dockerfile.ci
#CD
docker run -d --name setup_dev_environment -p 8000:80 docker.io/focal1119/setup_dev_environment:latest

#git comment
[skip ci] update ci.yml
[skip actions] update docs
```