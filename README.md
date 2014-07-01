# WebApp Scaffold

## CLI utilities

- `npm`
- `grunt`
- `bower`

## Preferred tasks

### Related to preprocessors

- `grunt-contrib-coffee`: Serve JS residing in `js/`
- `grunt-contrib-sass`: Serve CSS residing in `css/`
- `grunt-slim`: Slim is better than Jade IMHO

### Assets

- `grunt-bower-install`: inject bower packages into the HTML
```
    /! bower:js
    /! endbower
```
- [`grunt-autoprefixer`](https://github.com/nDmitry/grunt-autoprefixer): Add vendor prefixes to CSS

### Release

- [`grunt-rev`](https://github.com/cbas/grunt-rev): Revisioning assets for cache busting
- `grunt-htmlmin`: Minimizing HTML
- `grunt-contrib-cssmin`: Minimizing CSS
- `grunt-contrib-uglifier`: Minimizing JS
- [`grunt-usemin`](https://github.com/yeoman/grunt-usemin): Replace references to non-optimized scripts or stylesheets
```
    /! build:js js/dist.js
    script src='js/app.js'
    /! endbuild
```

## Prerequisites

Use `grunt` and `bower` to manage frontend assets:

```bash
npm i -g grunt-cli bower
npm i # dependencies (including grunt and several grunt tasks) are listed in package.json
```

Run the following command to store assets into `bower_components/`:

```bash
bower i # package.json
```

It will fetch `jquery`.

## Web server

Build (into `build/`), watch and serve:

```bash
grunt
```

## Release

`build/ -> dist/`:

```bash
grunt dist
```
