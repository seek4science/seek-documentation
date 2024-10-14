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

The Extended Metadata type is linked to a particular resource type in SEEK. Currently, it can be incorporated into the following types:
ISA items (`Investigation`, `Study`, `Assay`), `Collection`, `DataFile`, `Document`, `Event`, `Model`,`Presentation`,`Sop`, `Project`.

You can define the supported resource type as shown below:

```
ExtendedMetadataType.new(title: 'person', supported_type: 'YOUR_TYPE_NAME')
```

You can think of Extended Metadata being a Sample, but instead of standing alone is embedded within another type to extend it's metadata.
This is explained in the following high level representation.

![](/images/user-guide/extended-metadata/high-level-arch.png)
<br>


## Administrative Rights for Creating and Managing Extended Metadata Types

As a SEEK instance administrator, you have the ability to create, manage (enable, disable), and delete extended metadata types. This guide will walk you through how to perform these actions efficiently by navigating to the "Manage Extended Metadata Types" section in the Admin area.

<img src="/images/user-guide/extended-metadata/emt-management.png" alt="emt-top-level-tab" width="400">



* #### [Manage Extended Metadata Types](manage-extended-metadata-type.md)
* #### [Create Extended Metadata Types](create-extended-metadata-type.md)

