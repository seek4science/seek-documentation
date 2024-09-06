---
title: contributing to pages
layout: page
---

# Contributing to these pages

If you find a mistake or wish to make an improvement to these pages, you can do so. For a small mistake, just let us know by [contacting us](contacting-us.html). For other changes you can also access and edit the pages themself.

## Editing and adding pages

These pages can be found in Github at [https://github.com/seek4science/seek-documentation](https://github.com/seek4science/seek-documentation). Pages are in [Markdown](https://help.github.com/articles/markdown-basics/) format, with a _.md_ extension, but get converted into HTML for you.
New pages require a formatter at the top, that looks like:

    ---
    title: my lovely page
    layout: page
    ---

For example, this page can be found at [https://raw.githubusercontent.com/seek4science/seek-documentation/main/contributing-to-pages.md](https://raw.githubusercontent.com/seek4science/seek-documentation/main/contributing-to-pages.md).

The **user guide pages** use a remote theme called [ELIXIR Toolkit Theme](https://elixir-belgium.github.io/elixir-toolkit-theme/) (ETT). The ETT theme provides additional support for styling and navigation, including the sidebar menus. New user guide pages require a slightly different formatter at the top, that looks like:

    ---
    title: my lovely userguide page
    layout: page-ett
    ---

To add your new page to the sidebar, add a line to the data file:
 `_data` &#9658; `sidebars` &#9658; `userguide.yml`. 
 More details are available from the [ETT theme documentation](https://elixir-belgium.github.io/elixir-toolkit-theme/navigation_structures).

## Viewing your changes locally

If you want to view your changes as you edit them, with Ruby installed you can install and run Jekyll with:

    gem install bundler
    bundle install
    bundle exec jekyll serve

and then goto [localhost:4000](http://localhost:4000). For more information please see [Using Jekyll with Pages](https://help.github.com/articles/using-jekyll-with-pages/).

## Committing your changes

You can make a change by forking and issuing a pull request. If contributing through GitHub is unfamiliar to you, please read [Contributing to Open Source on GitHub](https://guides.github.com/activities/contributing-to-open-source/).
