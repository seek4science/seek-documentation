---
title: Manage Extended Metadata Type
layout: page
---

# How To Create and Manage Extended Metadata Type as a System Administrator

## Introduction

As a SEEK instance Administrator, you have the ability to create, manage (enable, disable), and delete extended metadata types. You can navigate to the relevant section by clicking on the "Manage Extended Metadata Types" link in the Admin area. This guide explains how to perform these actions efficiently.

![](/images/user-guide/extended-metadata/emt-management.png)
{:.screenshot}

On the "Manage Extended Metadata Types" page, you will see a list of existing extended metadata types and resources that are useful when creating a new extended metadata type.

The page is organized into four tabs:

- **Top level**: This tab displays a list of top-level extended metadata types. A top-level metadata type is associated with specific resource types in SEEK. <br> It can currently be applied to such as  `Investigation`, `Study`, `Assay`, `Collection`, `DataFile`, `Document`, `Event`, `Model`, `Presentation`, `Sop`, and `Project`.



- **Nested level**: This tab lists all extended metadata types that have the `supported_type` "ExtendedMetadata". Nested-level extended metadata types are primarily used when defining the attribute types "Linked Extended Metadata" or "Linked Extended Metadata (multiple)". These attributes enable a nested relationship between metadata types, enhancing flexibility and depth in data entry and management.


- **Controlled vocabularies**: This tab lists all the existing controlled vocabularies (CV) within SEEK. CVs can be used of definition of both sample types and extended metadata types. Administrators can create new CVs directly from this page by clicking the "Create Controlled Vocabulary" button.


- **Extended attribute types**: This tab provides a list of all supported extended attribute types. Each attribute type's "Title" is crucial, as it will be used when defining a custom JSON file to create a new extended metadata type.


## Manage Extended Metadata Types

### top level


![](/images/user-guide/extended-metadata/emt-top-level-tab.png)
{:.screenshot}

<img src="/images/user-guide/extended-metadata/emt-top-level-tab.png" alt="emt-top-level-tab" width="300">


* **Internal ID:** A unique identifier assigned to each extended metadata type within the SEEK system.


* **Title:** The name of the extended metadata type, displayed in the dropdown list when creating a new resource.


* **Supported Type:** The SEEK [top level resource types](#top-level) associated with this extended metadata type. 


* **Number of Times Used**: The number of times metadata has been created based on this extended metadata type.


* **Status:** Indicates whether the extended metadata type is active (enabled) or inactive (disabled). Disabling a type prevents it from appearing as an option in the UI, but it won’t delete the metadata or affect where it’s been used. Disabled types will not appear for viewing items they are associated with, but editing existing metadata remains possible. Disabled types can be re-enabled at any time.


* **Disable/Enable:**  A button to disable or enable the extended metadata type.


* **Delete:**  A button to delete the extended metadata type, available only if the type has not been used to create any metadata.