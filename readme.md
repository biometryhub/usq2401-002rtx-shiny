# Shiny Template

This Shiny app template was created to standardize the layout of shiny apps developed to support projects under
Analytics for the Australian Grains Industry (AAGI).

![Example][example]

Table of Contents
<!-- vim-markdown-toc GFM -->

* [Structure](#structure)
* [Customization](#customization)
* [Usage](#usage)
* [Feedback](#feedback)

<!-- vim-markdown-toc -->

## Structure

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

## Customization

**Application Details**

All texts enclosed in `<>` are to be replaced, including `<>`, with the appropriate values. These can be found
in [`src/index.R`][index] and [`src/about.R`][about].

**New Tabs**

New tabs should be added under [`src`][src] following the example of [`src/kmean_cluster.R`][kmean] which has
both ui and server components.

## Usage

Install dependencies,

```sh
R -e 'install.packages("shiny")'
```

Run the app,

```sh
./app.R
```

## Feedback

For queries, feedback, and bug reports:

- Open a [GitHub issue][github-issue].
- Email [wasin.pipattungsakul@adelaide.edu.au][email].

<!--internal-->

[app]: ./app.R
[about]: ./src/about.R
[index]: ./src/index.R
[kmean]: ./src/kmean_cluster.R
[src]: ./src
[www]: ./src/www
[example]: ./assets/example.png

<!--external-->

[github-issue]: https://github.com/AAGI-AUS/shiny-template/issues/new
[email]: mailto:wasin.pipattungsakul@adelaide.edu.au?subject=Shiny%20Template%20Support
