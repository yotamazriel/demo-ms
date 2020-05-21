# Tensorleap infra docs

## Running the docs

```sh
npm i docsify -g
# from repo root
docsify serve ./docs
```

which should yield something like the following:

```sh

Serving /Users/<username>/<path-to-project>/infra/docs now.
Listening at http://localhost:3000
```

## Project setup (WIP)

Each top level folder has a corresponding docs folder.
Main README.md file is related as each module / service index file.

```yaml
./docs/
    ├── README.md
    ├── _sidebar.md
    ├── cloud-operations
    │   ├── gcp-tf-bootstrap.md
    │   └── index.md
    ├── continuous-deployment
    │   └── index.md
    ├── continuous-integration
    │   └── index.md
    ├── index.html
    ├── kubernetes-resources
    │   └── index.md
    └── usage.md
```

### Adding a new page to doc

* Create the new sub file/folder in the ./docs dir e.g `architecture` or add a corresponding `md` file.

### Adding a new service doc

* repeat the same process above but store a symbolic-link from the project top level dir e.g `infra/README.md` is a link to `./docs/infra/README.md`

### deploying docs - TBD (github pages / other)
