---
title: Adding admin items
---

These are items that cannot be created by a general user, but can be created by a {{ site.seek_instance.name | default: "FAIRDOM-SEEK" }} administrator, [Project Administrator](roles#project-administrator), or [Programme Administrator](roles.html#programme-administrator)

## Creating organisms

To create an organism, choose Organism from the Create menu at the top of the page.

An Organism can just have a title, but preferably also include the NCBI taxonomy URI. To make this easier there is an option to search for the organism, and then click the result to automatically add the name and taxonomy URI.

{% include callout.html type="note" content="
  If you are running your own installation of FAIRDOM-SEEK, the search is only available if you have [registered with BioPortal](https://bioportal.bioontology.org/accounts/new) and created an API key. The API key needs to be set under the Server Admin area - under Site configuration, Additional settings.
" %}

## Creating profiles

It is possible to create profiles for people that have not registered with {{ site.seek_instance.name | default: "SEEK" }}. This is useful if you want to describe and credit members of your Project who are not yet {{ site.seek_instance.name | default: "SEEK" }} users. They can adopt their profile later during [Registering](registering).

To create a profile, choose Profile from the Create menu at the top of the page. The first and last name are required, and also the email address. The email address must be unique to {{ site.seek_instance.name | default: "SEEK" }}.

## Creating institutions

To create an Institution, choose Institution from the Create menu at the top of the page.

The title and country are required, and the title must be unique to {{ site.seek_instance.name | default: "SEEK" }}. It is recommended that you provide as much detail as you can. Once created you can also provide a logo or picture by clicking Change Picture under the picture on the right of the Institution page.
You can also add a department to an institution.

### Linking an institution to the Research Organization Registry (ROR)

Institutions can also be linked to the [Research Organization Registry (ROR)](https://ror.org/). ROR is a global, community-led registry of open persistent identifiers for research and funding organizations. If you include the ROR for an institution in SEEK, it will improve research tracking, boost interoperability, and enable better collaboration, making it clear which university, lab, or funder is involved in research, essential for publishers, repositories, and funders to connect researchers to their work accurately.

There are three ways to add an institution or ROR in {{ site.seek_instance.name | default: "SEEK" }}:

One. **Use the name search field when creating a new institution.**  
   Search for the organization and select the correct match to automatically populate its basic details and store its ROR identifier.

![Institution name search]({{ "/images/user-guide/ror/ror_institution_name.png" | relative_url }}){:.screenshot}


Two. **Enter a known ROR ID directly.**  
   If you already know the institution’s ROR ID, you can enter it to automatically retrieve and fill in the associated details.

  ![Institution id search]({{ "/images/user-guide/ror/ror_institution_id.png" | relative_url }}){:.screenshot}


Three. **Add an institution without a ROR entry.**  
   If the organization does not appear in ROR (and therefore has no ROR ID), simply leave the ROR field blank and complete the standard manual fields.

