# Shiny Template

This Shiny app template was created to standardize the layout of shiny apps developed to support projects under
Analytics for the Australian Grains Industry (AAGI).

![Example][example]

## Usage

### Structure

```
shiny-template
├╴app.R
└╴src
  ├╴www
  │ ├╴logo-AAGI.jpg
  │ ├╴styles.css
  │ ┆ ...
  ├╴about.R
  ├╴index.R
  ├╴tab1.R
  ├╴tab2.R
  ┆ ...
```

- [`app.R`][app] is the entry point where you can update your port.
- [`src`][src] contains all the scripts for ui and server.
- [`src/www`][www] contains style sheets and static images.

### Customization

**Application Details**

All texts enclosed in `<>` are to be replaced, including `<>`, with the appropriate values. These can be found
in [`src/index.R`][index] and [`src/about.R`][about].

**New Tabs**

New tabs should be added under [`src`][src] following the example of [`src/kmean_cluster.R`][kmean] which has
both ui and server components.

### Running the App

```sh
./app.R
```

<!--internal-->

[app]: ./app.R
[about]: ./src/about.R
[index]: ./src/index.R
[kmean]: ./src/kmean_cluster.R
[src]: ./src
[www]: ./src/www
[example]: ./assets/example.png
