---
title: Contributing to these pages
description: this page is about something lovely and useful, recommend 110-160 characters
redirect_from: /contributing-to-pages
---


If you find a mistake or wish to make an improvement to these pages, you can do so. For a small mistake, just let us know by [contacting us](https://fair-dom.org/contact). For other changes you can also access and edit the pages themself.

{% include callout.html type="important" content="
Note that FAIRDOM-SEEK instances are highly customisable.
This set of documentation pages can be customised for your local instance.
For example, they can be served at the root level or from within a directory.
Please contact your local instance admin for more information.
" %}

## Editing and adding pages

These pages can be found in GitHub at [https://github.com/seek4science/seek-documentation](https://github.com/seek4science/seek-documentation). Pages are in [Markdown](https://help.github.com/articles/markdown-basics/) format, with a _.md_ extension, but get converted into HTML for you.
New pages require a formatter at the top, that looks like:
```yaml
---
title: my lovely page
description: this page is about something lovely and useful, recommend 110-160 characters
---
```

For example, this page can be found at [https://raw.githubusercontent.com/seek4science/seek-documentation/main/tech/contributing-to-pages.md](https://raw.githubusercontent.com/seek4science/seek-documentation/main/tech/contributing-to-pages.md).

The `title` will be used as the page title, in the HTML head `<title>` and body `<h1>` tags. The `description` will be used in the page metadata, visible as a preview when sharing a link to that page. 
If you omit the `description`, one will be generated for you from the first 30 words on the page. 
Note, if the page contains any Jekyll/Liquid code in the first 30 words, the code will not be processed, instead you will see the raw code as part of the description text.

The **home, user guide, and technical guide pages** use a remote theme called [ELIXIR Toolkit Theme](https://elixir-belgium.github.io/elixir-toolkit-theme/) (ETT). The ETT theme provides additional support for styling and navigation, including the sidebar menus. The _title_ metadata is used to create a first-level heading at the top of the page. Do not include it again. Instead, use `##` and `###` for subheadings (second- and third-level, respectively).

The site can be served from a root domain/sub-domain (for example, `docs.site.com`) or from a directory (for example, `site.com/docs`). To support sites that are served from a directory, all links to pages within the site must be given as relative paths, not absolute paths. We use a [Jekyll filter](https://jekyllrb.com/docs/liquid/filters/) to achieve this, for example:
```
{% raw %}Please visit our [Contributors guide]({{ "/tech/contributing" | relative_url }}).{% endraw %}
```

All links to images within the site must also be given as relative paths (with alt description), for example:
```
{% raw %}![Registration 1]({{ "/images/user-guide/register_1.png" | relative_url }}){:.screenshot}{% endraw %}
```

To add your new page to the sidebar, add a line to the data file:
`_data` &#9658; `sidebars` &#9658; `user_guide.yml` or `technical_guide.yml`.
More details are available from the [ETT theme documentation](https://elixir-belgium.github.io/elixir-toolkit-theme/navigation_structures).


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
