---
title: A Complete Example to Create Extended Metadata Types by Uploading a JSON File
layout: page
---

<a href="create-extended-metadata-type-with-json-file.md">back</a>

# A Complete Example


## Step 1: Define Controlled Vocabularies 

Currently `Controlled Vocabularies` can only be created via the SEEK UI.

You can also use the following direct link to create controlled vocabularies: <br>
```HTTP://{HOST_NAME}/sample_controlled_vocabs/new```

Assuming the controlled vocabularies have been created here:
![](/images/user-guide/extended-metadata/cvs-tab.png)

You can view the detailed CV by clicking the corresponding CV ID. 
![](/images/user-guide/extended-metadata/role_name_identifier_scheme_cv.png)

## Step 2: Define Nested Exended Metadata Types

1. Define a metadata type named `role_name_identifiers` with two attributes: `scheme` and `identifier`, and it is assigned ID `158`.

```json
{
  "title": "role_name_identifiers",
  "supported_type": "ExtendedMetadata",
  "enabled": true,
  "attributes": [
    {
      "title": "scheme",
      "type": "Controlled Vocabulary",
      "required": true,
      "ID": 14, // ID of CV "Role Name Identifier Scheme"
      "label": "scheme",
      "description": "scheme"
    },
    {
      "title": "identifier",
      "type": "String",
      "required": false,
      "label": "identifier",
      "description": "identifier"
    }
  ]
}
```

2. Define another metadata type named `role_emt`. As a result, `role_emt` is created with five attributes and assigned ID `159`.

```json
{
  "title": "role_emt",
  "supported_type": "ExtendedMetadata",
  "enabled": true,
  "attributes": [
    {
      "title": "role_name_personal_title",
      "type": "Controlled Vocabulary",
      "required": true,
      "ID": 13, // ID of CV "Role Name Personal Title"
      "label": "personal title",
      "description": "personal title"
    },
    {
      "title": "first_name",
      "type": "String",
      "required": false,
      "label": "first name",
      "description": "first name"
    },
    {
      "title": "last_name",
      "type": "String",
      "required": false,
      "label": "last name",
      "description": "last name"
    },
    {
      "title": "role_type",
      "type": "Controlled Vocabulary",
      "required": true,
      "ID": 12, // ID of CV "Role type"
      "label": "role type",
      "description": "role type"
    },
    {
      "title": "role_name_identifiers",
      "type": "Linked Extended Metadata (multiple)",
      "required": false,
      "ID": 158, // ID of the nested metadata type `role_name_identifiers`
      "label": "role name identifiers",
      "description": "role name identifiers"
    }
  ]
}
```



## Step 3: Define Top Level Extended Metadata Type for Study

```json
{
  "title": "An example with all attribute types",
  "supported_type": "Study",
  "enabled": true,
  "attributes": [
    {
      "title": "title",
      "required": true,
      "type": "String",
      "label": "study title",
      "description": "study title"
    },
    {
      "title": "description",
      "required": true,
      "type": "Text",
      "label": "study description",
      "description": "study description"
    },
    {
      "title": "study_start_date",
      "required": true,
      "type": "Date",
      "label": "study start date",
      "description": "study start date"

    },
    {
      "title": "study_start_time",
      "required": true,
      "type": "Date time",
      "label": "study start time",
      "description": "study start time"
    },
    {
      "title": "study_age",
      "required": true,
      "type": "Integer",
      "label": "study age",
      "description": "study age"
    },
    {
      "title": "cholesterol_level",
      "required": true,
      "type": "Real number",
      "label": "cholesterol level",
      "description": "cholesterol level"
    },
    {
      "title": "resource_use_rights_authors_confirmation",
      "required": true,
      "type": "Boolean",
      "label": "resource use rights authors confirmation",
      "description": "resource use rights authors confirmation"
    },
    {
      "title": "resource_type_general",
      "required": true,
      "type": "Controlled Vocabulary",
      "ID": 16, // ID of CV "resource_type_general"
      "label": "resource type general",
      "description": "resource type general"
    },
    {
      "title": "resource_study_country",
      "type": "Controlled Vocabulary List",
      "required": true,
      "ID": 15, // ID of CV "European Study Country"
      "label": "study country",
      "description": "study country"
    },
    {
      "title": "role",
      "type": "Linked Extended Metadata (multiple)",
      "required": false,
      "ID": 159, // ID of the nested metadata type `role_emt`
      "label": "role",
      "description":"role"
    }
  ]
}
```

You can select to load this extended metadata type on the study creation page.
![](/images/user-guide/extended-metadata/emt-ui.png)


