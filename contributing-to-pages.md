---
title: Contributing to these pages
sidebar: tech
---


If you find a mistake or wish to make an improvement to these pages, you can do so. For a small mistake, just let us know by [contacting us](contacting-us). For other changes you can also access and edit the pages themself.

## Editing and adding pages

These pages can be found in Github at [https://github.com/seek4science/seek-documentation](https://github.com/seek4science/seek-documentation). Pages are in [Markdown](https://help.github.com/articles/markdown-basics/) format, with a _.md_ extension, but get converted into HTML for you.
New pages require a formatter at the top, that looks like:
```yaml
---
title: my lovely page
---
```

For example, this page can be found at [https://raw.githubusercontent.com/seek4science/seek-documentation/main/contributing-to-pages.md](https://raw.githubusercontent.com/seek4science/seek-documentation/main/contributing-to-pages.md).

The **top level, technical reference, user guide pages** use a remote theme called [ELIXIR Toolkit Theme](https://elixir-belgium.github.io/elixir-toolkit-theme/) (ETT). The ETT theme provides additional support for styling and navigation, including the sidebar menus. The _title_ metadata is used to create a first-level heading at the top of the page. Do not include it again. Instead, use `##` and `###` for subheadings (second- and third-level, respectively).  

To add your new page to the sidebar, add a line to the data file:
 `_data` &#9658; `sidebars` &#9658; `userguide.yml`, `tech.yml` or  `about.yml`. 
 More details are available from the [ETT theme documentation](https://elixir-belgium.github.io/elixir-toolkit-theme/navigation_structures).

The **about pages** (top level) require additional lines at the top to display correctly:
```yaml
---
sidebar: about
---
```
## Viewing your changes locally

If you want to view your changes as you edit them, with Ruby installed you can install and run Jekyll with:

```sh
gem install bundler
bundle install
bundle exec jekyll serve
```
and then goto [localhost:4000](http://localhost:4000). For more information please see [Using Jekyll with Pages](https://help.github.com/articles/using-jekyll-with-pages/).

## Committing your changes

You can make a change by forking and issuing a pull request. If contributing through GitHub is unfamiliar to you, please read [Contributing to Open Source on GitHub](https://guides.github.com/activities/contributing-to-open-source/).
