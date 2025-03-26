# Field Trial Visualiser

This application can visualise field trial data in a format of row and range across the field. It can also
provide a summary of numerical variables as histograms.

![Heat map example][heat-map-example]

![Summary example][summary-example]

## Table of Contents
<!-- vim-markdown-toc GFM -->

* [Usage](#usage)
* [Feedback](#feedback)

<!-- vim-markdown-toc -->

## Usage

Install dependencies,

```sh
R -e 'install.packages(c("shiny", "tidyverse", "janitor", "DT"))'
```

Run the app,

```sh
./app.R
```

## Feedback

For queries, feedback, and bug reports:

<!-- - Open a [GitHub issue][github-issue]. -->
- Email [wasin.pipattungsakul@adelaide.edu.au][email].

<!--internal-->

[heat-map-example]: ./assets/heat_map_example.png
[summary-example]: ./assets/summary_example.png

<!--external-->

[github-issue]: https://github.com/biometryhub/usq2401-002rtx-shiny/issues/new
[email]: mailto:wasin.pipattungsakul@adelaide.edu.au?subject=Field%20Trial%20Visualiser%20Support
