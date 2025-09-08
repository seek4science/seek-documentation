---
title: Edit an existing Sample Type
---

To edit a Sample Type, the user must have Edit or Manage permissions. For details on assigning permissions, see the [Sample Type Permissions](sample-type-permissions) page.

Steps to edit:

1. Navigate to Browse → Sample Types
2. Select the Sample Type to edit
3. Click Actions → Edit Sample Type in the top-right corner.

> {% include callout.html type="note" content="Users are not notified of changes made to the Sample Type — inform collaborators as needed." %}


## Changing Sample Type properties

Users with appropriate permissions may modify the following properties:

- Title: The name used to identify the Sample Type
- Description: A summary describing the purpose or scope
- Associated Projects: Determines visibility and access for project members
- Tags: Labels used for categorization and filtering.

Changes are applied immediately upon saving and do not affect existing samples or their (meta)data.

## Changing Sample Type attributes

Each Sample Type consists of a list of attributes that define the metadata fields for its samples.

### Adding an attribute
1. Click the green 'Add new attribute' button at the bottom of the attributes table
2. Provide the following:
   - Name (must be unique)
   - Required (toggle on/off)
   - Title (toggle on/off)
   - Attribute Type (e.g., Text, Number, Date, Controlled Vocabulary)
   - Description, PID, Unit (optional)
3. Click 'Update' to apply changes.

Attributes can be added even after samples exist, except when the Sample Type was created via file-upload import. Any Sample Type that was populated via a file‐upload import carries an association back to the Data File, and that import record prevents further attribute additions. The idea is to preserve the 1:1 mapping between the columns in the Data File and the attributes on the Sample Type. Consequently, attributes cannot be added.

It is not possible to create a new mandatory attribute from scratch if the Sample Type already has associated samples. In that case, the existing samples would have empty values for the mandatory attribute. Instead, create the new attribute as optional and add the relevant metadata to the associated Samples. Once all Samples have non-empty values for the attribute, it is possible to make the attribute mandatory. 

### Removing an attribute

An attribute can be deleted only if no existing samples contain a value for it. If values exist, the 'Remove' button will not be shown. To proceed, delete the metadata values from all associated samples first.

### Modifying an attribute

The following rules apply when modifying attributes:

- Name, Description, and Unit can be changed at any time
- Title status can be toggled only if all samples contain a value for that attribute
- Attribute type can be changed only if no samples have a value for that attribute
- 'Required?' flag:
  - Changing from mandatory to optional is always allowed
  - Changing from optional to mandatory is allowed only if all samples already contain a non-empty value.

## Validation & best practices

- Each Sample Type must have exactly one attribute marked as the title
- Attribute titles must be unique within the Sample Type
- The title attribute cannot be of type 'Registered Sample Multi'
- The Sample Type must not be locked.

## Deleting a Sample Type

To delete a Sample Type:

1. Navigate to Browse → Sample Types
2. Select the Sample Type
3. Click Actions → Delete Sample Type in the top-right corner.

Deletion is only permitted if:

- The user has Manage permissions
- The Sample Type has no associated samples
- The Sample Type is not referenced by another Sample Type, Study or Assay.

If these conditions are not met, the 'Delete Sample Type' option will not be available.


## Troubleshooting & tips

- Missing “Remove” button next to an attribute?  
  → Ensure no samples contain a value for that attribute.

- “Add new attribute” button is missing
  → Check whether the Sample Type was populated via file‑upload import. SEEK locks the schema to preserve column‑to‑attribute mappings. 

- Cannot rename or change type/unit of an attribute  
  → Verify that no samples have populated values for that field.

- Toggling “Title” status is greyed out**  
  → You can only switch the title flag if **every** existing sample has a non‑empty value for the new title attribute.

- Toggling “Required?” status is greyed out**  
  → You can only switch the required flag if **no** existing sample has a non‑empty value for the attribute.

- “Delete Sample Type” action missing**  
  → Confirm that:  
  1. You have 'Manage' permissions
  2. No samples exist for that type
  3. It isn’t referenced by any other Sample Type, Study or Assay.