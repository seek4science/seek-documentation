---
title: Edit an Existing Study
---


To edit an existing Study, the user must have Edit or Manage permissions (i.e. policy ≥ Edit).

### Steps to edit

1. Navigate to the Study;
2. Click Actions → Edit ISA Study in the top-right corner.

> {% include callout.html type="note" content="Users are not notified of changes made to the Study — inform collaborators as needed." %}

## Modifying Study properties

Users with appropriate permissions may update the following properties:

- **Title**: The name used to identify the Study;
- **Description**: A summary describing the purpose or scope;
- **Associated Assets**: Including [SOPs](sops), [Publications](publications), and Documents.

Changes are applied immediately upon saving and do not affect existing samples or their metadata.

## Modifying Study attributes

Each Study contains two 'Sample Types', namely a Study Source and a Study Sample. Both consist of a list of metadata attributes used to describe its samples. Attributes may be:

- Inherited from an [Experiment Sample Template](isajson-templates);
- Defined locally within the Study.

The 'Overview' tab of the Study displays the associated Experiment Sample Templates and indicates which attributes are inherited.

### Adding an attribute
1. Click the green 'Add new attribute' button at the bottom of the attributes table;
2. Provide the following:
   - Name (must be unique);
   - Required (toggle on/off);
   - Title (toggle on/off);
   - Attribute Type (e.g., Text, Number, Date, Controlled Vocabulary);
   - Description, PID, Unit (optional);
3. Click 'Update' to apply changes.

> Note: If the Study Source or Study Sample already contains samples, new attributes must be created as optional. Once all samples have non-empty values for the attribute, it can be marked as mandatory.

### Removing an attribute

An attribute can be removed only if:

- No samples contain a value for the attribute;
- The attribute is **not inherited** from an Experiment Sample Template.

If these conditions are not met, the 'Remove' button will not be displayed. To proceed, check the Experiment Sample Template and/or delete the metadata values from all associated samples first.

### Editing an attribute

The following rules apply when modifying attributes:

- Name, Description, and Unit can be changed at any time;
- Title status can be toggled only if all samples contain a value for the attribute;
- Attribute type can be changed only if:
  - No samples contain a value for the attribute;
  - The attribute is not inherited from an Experiment Sample Template;
- Required flag:
  - Changing from **mandatory to optional** is always allowed;
  - Changing from **optional to mandatory** is allowed only if all samples contain a non-empty value;
- ISA Tag*:
  - Cannot be changed for inherited attributes;
  - Can be freely changed for non-inherited attributes if no samples exist;
  - If samples exist, the ISA tag can only be changed if no sample contains a value for the attribute.

> *Note: The ISA tag determines how SEEK labels the attribute when [exporting to ISA‑JSON](exporting-experiments-as-isajson). Setting the correct ISA tag ensures compatibility with downstream ISA-aware tools.

## Validation & best practices

- Each Study Study/Sample must have exactly one attribute marked as the title;
- Attribute titles must be unique within the Study Source/Sample;
- The title attribute cannot be of type Registered Sample Multi;
- The Study must not be locked.

## Troubleshooting & Tips

- Missing “Remove” button next to an attribute?  
  → Check the attributes of the associated Experiment Sample Template and ensure no samples contain a value for that attribute.

- Cannot rename or change type/unit of an attribute?
  → Check the attributes of the associated Experiment Sample Template and verify that no samples have populated values for that field.

- Toggling “Title” status is disabled?
  → All samples must have a non-empty value for the new title attribute.

- Toggling “Required?” status is disabled?
  → You can only switch to mandatory if all samples already contain a value for the attribute.
