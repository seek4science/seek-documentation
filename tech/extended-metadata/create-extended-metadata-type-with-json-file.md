---
title: Create Extended Metadata Types by Uploading a JSON File
---


This is [JSON schema](extended-metadata-type-schema.json) used to define your JSON file for creating a new extended metadata type via upload.

## Example 1: Define Extended Metadata Type with Simple Extended Meatadata Attribute Types

**What are Simple Attributes?**  <br>

    
Simple attributes are those that are not linked to any other metadata type or controlled vocabulary. <br>
<br>
You can define the attribute using the following types, which can also be viewed on the [Extended Metadata attribute Type](manage-extended-metadata-type/#4-extended-metadata-attribute-types-tab) tab.
<br><br>
`Date time`, `Date`, `Real number`, `Integer`, `Web link`, `Email address`, `Text`,`String`, `ChEBI`,`ECN`,`MetaNetX chemical`,`MetaNetX reaction`,`MetaNetX compartment`,`InChI`,`ENA custom date`,`Boolean`,`URI`,`DOI`, `NCBI ID`,`Registered Strain`,`Registered Data file` 

Here is an example:

```json
{
  "title": "person",
  "supported_type": "ExtendedMetadata",
  "enabled": true,
  "attributes": [
    {
      "title": "first_name",
      "label": "First name",
      "description": null,
      "type": "String",
      "required": false
    },
    {
      "title": "last_name",
      "label": "Last name",
      "description": null,
      "type": "String",
      "required": false
    }
  ]
}
```


## Example 2: Define an Extended Metadata Type with Nested Metadata Attribute Types

Those attributes are linked to other extended metadata types, including `Linked Extended Metadata`,`Linked Extended Metadata (multiple)`

For `Linked Extended Metadata` or `Linked Extended Metadata (Multiple)` attributes, you need to supply the ID of the nested extended metadata. The available nested metadata IDs are located on the [Nest Level](manage-extended-metadata-type/#2-nested-level-tab) tab as a system administrator.

From last example, we haven created a nested level extended metadata type `person`, with `supported_type` of `ExtendeMetadata` with two attributes `first_name` and `last_name`. Now we want to create a new extended metadata type `family` with two attributes `dad` and `mom` which are linked to `person` type. 
In this case, we need to provide the **/ID/**  of the nested extended metadata `person` in the `dad`, `mom`, `child` attributes.

Here is an example:

```json
{
  "title": "family",
  "supported_type": "Investigation",
  "enabled": true,
  "attributes": [
    {
      "title": "dad",
      "label": "Dad",
      "description": null,
      "type": "Linked Extended Metadata",
      "required": false,
      "ID": /ID/  // ID of the nested extended metadata type 'person'
    },
    {
      "title": "mom",
      "label": "Mom",
      "description": null,
      "type": "Linked Extended Metadata",
      "required": false,
      "ID": /ID/ // ID of the nested extended metadata type 'person'
    },
    {
      "title": "child",
      "label": "child",
      "description": null,
      "type": "Linked Extended Metadata (multiple)",
      "required": false,
      "ID": /ID/ // ID of the nested extended metadata type 'person'
    }
  ]
}
```

## Example 3: Defining an Extended Metadata Type with Controlled Vocabulary Attribute Types

When defining a `Controlled Vocabulary` or `Controlled Vocabulary List` attribute, you must provide the ID of the controlled vocabulary. 

The list of existing vocabulary IDs can be found under the [Controlled Vocabulary](manage-extended-metadata-type/#3-controlled-vocabularies-tab) tab as a system administrator. 

You can also create a new controlled vocabulary by clicking the button on the [Controlled Vocabulary](manage-extended-metadata-type/#3-controlled-vocabularies-tab) tab.

Here is an example:

```json
{
  "title": "study metadata demo",
  "supported_type": "Study",
  "enabled": false,
  "attributes": [
    {
      "title": "resource_type_general",
      "description": "resource type general",
      "type": "Controlled Vocabulary",
      "required": true,
      "ID": /ID/ // ID of CV "resource_type_general"
    },
    {
      "title": "resource_study_country",
      "description": "study country",
      "type": "Controlled Vocabulary List",
      "required": true,
      "ID": /ID/ // ID of CV "resource_study_country"
    }
  ]
}
```

Here’s a step-by-step [example](a-complete-example) of how to create a new extended metadata type using all the attribute types mentioned above.