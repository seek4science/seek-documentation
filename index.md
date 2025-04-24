---
sidebar: false
layout: instance-specific
title: FAIRDOM-SEEK Documentation
---

![FAIRDOM-SEEK logo]({{ "/images/banner-plain.svg" | relative_url }})

{% assign seek_instance_name = site.seek_instance.name | default: "FAIRDOM-SEEK" %}

<!--Complete the description of your own instance here or delete it.-->
<div>
{% unless seek_instance_name == "FAIRDOM-SEEK" %}
    <h2>
        <i class="fa-solid fa-flask-vial fa-1x"></i> <i class="fa-solid fa-magnifying-glass-chart fa-1x"></i>
        About {{ seek_instance_name }}
    </h2>
    The {{ seek_instance_name }} platform is based on the FAIRDOM-SEEK software.
{% endunless %}
</div>

<h2>
<i class="fa-solid fa-flask-vial fa-1x"></i> <i class="fa-solid fa-magnifying-glass-chart fa-1x"></i>
 About FAIRDOM-SEEK
</h2>

The FAIRDOM-SEEK platform is a web-based resource for sharing heterogeneous scientific research datasets,
models or simulations, processes and research outcomes. More details about SEEK can be found on the [FAIRDOM-SEEK Website](https://seek4science.org).

For an example of FAIRDOM-SEEK please visit our [Demo](https://demo.seek4science.org).

### Get FAIRDOM-SEEK

To find out how to install FAIRDOM-SEEK on your own machine, or install FAIRDOM-SEEK as a Virtual Machine, please go to our [<i class="fa-solid fa-flask-vial fa-1x"></i> <i class="fa-solid fa-magnifying-glass-chart fa-1x"></i> Get FAIRDOM-SEEK page]({{ "/get-seek" | relative_url }}).

---

<h2>
<i class="fa-solid fa-user-group fa-1x"></i> <i class="fa-solid fa-book fa-1x"></i>
 User guide</h2>

### Latest User Guide

General documentation on how to use and administer {{ site.seek_instance.name | default: "FAIRDOM-SEEK" }} can be found in our [<i class="fa-solid fa-user-group fa-1x"></i> <i class="fa-solid fa-book fa-1x"></i> User Guide]({{ "/help/user-guide/" | relative_url }}).

### API documentation

Details on how to get started using the Application Programme Interface (API) can be found in the [API Introduction]({{ "/help/user-guide/api" | relative_url }}) .

### Archived help and guidelines

We also have other information for topics related to {{ site.seek_instance.name | default: "FAIRDOM-SEEK" }}, including Metadata, ISA, and controlled vocabularies, which can be found
in our [archive of help and guidelines]({{ "/help/" | relative_url }}).

---

<h2>
<i class="fa-solid fa-wrench fa-1x"></i> <i class="fa-solid fa-book-atlas fa-1x"></i>
 Technical references</h2>

For more detailed information about installation and upgrading, please see our [<i class="fa-solid fa-wrench fa-1x"></i> <i class="fa-solid fa-book-atlas fa-1x"></i> Technical and Reference documentation]({{ "/tech/" | relative_url }}).

---

<h2>
<i class="fa-solid fa-envelopes-bulk fa-1x"></i> <i class="fa-solid fa-truck-fast fa-1x"></i> Contacting and contributions</h2>

There are [<i class="fa-solid fa-envelopes-bulk fa-1x"></i>  contact details]({{ "/contacting-us" | relative_url }}), should you wish to ask a question or make a suggestion.

We also welcome contributions, so please visit our [<i class="fa-solid fa-truck-fast fa-1x"></i> Contributors Guide]({{ "/tech/contributing" | relative_url }}).

---

<h2>
<i class="fa-solid fa-star fa-1x"></i> Popular pages</h2>

<div class="mt-1 row row-cols-1 row-cols-md-2 row-cols-lg-3 gy-4 navigation-tiles">
    <div class="col d-grid">
        <a role="button" class="btn py-3 fs-4 section-title" href="{{ '/help/user-guide/api' | relative_url }}"><b>API Introduction</b></a>
    </div>
    <div class="col d-grid">
        <a role="button" class="btn py-3 fs-4 section-title" href="{{ '/contacting-us' | relative_url }}"><b>Contacting us</b></a>
    </div>
    <div class="col d-grid">
        <a role="button" class="btn py-3 fs-4 section-title" href="{{ '/tech/contributing' | relative_url }}"><b>Contributing</b></a>
    </div>
    <div class="col d-grid">
        <a role="button" class="btn py-3 fs-4 section-title" href="{{ '/get-seek' | relative_url }}"><b>Get FAIRDOM-SEEK</b></a>
    </div>
    <div class="col d-grid">
        <a role="button" class="btn py-3 fs-4 section-title" href="{{ '/help/user-guide/' | relative_url }}"><b>{{ site.seek_instance.name | default: "FAIRDOM-SEEK" }} User Guide</b></a>
    </div>
    <div class="col d-grid">
        <a role="button" class="btn py-3 fs-4 section-title" href="{{ '/tech/roadmap' | relative_url }}"><b>Roadmap</b></a>
    </div>
    <div class="col d-grid">
        <a role="button" class="btn py-3 fs-4 section-title" href="{{ '/tech/useful-links' | relative_url }}"><b>Useful Links</b></a>
    </div>
</div>
