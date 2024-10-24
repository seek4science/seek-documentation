---
title: Extended Metadata Technical Overview
layout: page
---

# Extended Metadata Technical Overview

## Introduction

Extended Metadata is a feature added to SEEK as part of [version 1.11](/tech/releases/#version-1110), originally to support
MIAPPE but designed for future use.
It provides the ability to define additional metadata attributes for a particular type, to support a particular standard (i.e MIAPPE).

<div class="alert alert-warning" markdown="1">
It was originally referred to as 'Custom Metadata' but recently renamed to avoid confusion, as the metadata can only be extended but not entirely customised. 
You may sometimes hear or read it referred to as Custom Metadata, and they are the same thing.
</div>

It is not a feature a user would directly see, other than revealed through extensions that are made available:


<img src="/images/user-guide/extended-metadata/extended-metadata-select.png" alt="extended-metadata-select" width="400">
<br>

... will reveal new fields below:

<img src="/images/user-guide/extended-metadata/extended-metadata-fields.png" alt="extended-metadata-fields" width="400">

The attributes can be associated with a particular attribute type, and marked as optional or mandatory, and will be validated against. This is very similar to Samples.

Extended metadata will only be shown if defined within the database, which is currently the only way of configuring it.

<br>

## How it works

Extended Metadata works in a very similar way to Samples, and shares a lot of the same code. Extended Metadata Types are defined, that describe a set of attributes with names
and point to a SampleAttributeType to define the attribute type.

The Extended Metadata Type is linked to a particular resource type in SEEK. Currently, it can be incorporated into the following resource types:
ISA items (`Investigation`, `Study`, `Assay`), `Collection`, `DataFile`, `Document`, `Event`, `Model`,`Presentation`,`Sop`, `Project`.

You can define the supported resource type as shown below:

```
ExtendedMetadataType.new(title: 'person', supported_type: 'YOUR_TYPE_NAME')
```

Extended Metadata Type is conceptually similar to a Sample Type, as it inherits the same attribute structure. However, while Sample Types are used to create standalone Samples, Extended Metadata Types are used to augment or extend the metadata of other types (e.g., Investigations, Studies, or Assays). 
Instead of existing independently, extended metadata is embedded within another object, enriching its descriptive details.

This is explained in the following high level representation. 

![](/images/user-guide/extended-metadata/high-level-arch.png)

In this diagram: 

**Sample Type:**

* Represents a blueprint used to define and create individual Samples.
* Contains attributes that describe the properties of a sample (e.g., Version, Start, Gender).
* Samples created from a Sample Type exist as standalone entities.

**Extended Metadata Type:**

* Inherits the same attribute structure as the Sample Type.
* Unlike a Sample Type, it does not create standalone entities.
* Its purpose is to extend the metadata of other entities (e.g., Investigations, Studies, Assays).
* Embedded within another entity, it adds additional descriptive details to that entity without being independent.

**Entity (e.g., Investigation):**

* Represents the object (such as an Investigation, Study, or Assay) that holds the extended metadata.
* The Extended Metadata Type is embedded within this entity, enriching its existing metadata.

**Relationship:**

* The Sample Type is used to generate independent Samples.
* The Extended Metadata Type shares a similar structure but is embedded in another entity to add more detailed metadata.



## Administrative Rights for Creating and Managing Extended Metadata Types

As a SEEK instance administrator, you have the ability to create, manage (enable, disable), and delete extended metadata types. This guide will walk you through how to perform these actions efficiently by navigating to the "Manage Extended Metadata Types" section in the Admin area.

<img src="/images/user-guide/extended-metadata/emt-management.png" alt="emt-top-level-tab" width="400">



* #### [Manage Extended Metadata Types](manage-extended-metadata-type.md)
* #### [Create Extended Metadata Types](create-extended-metadata-type.md)

