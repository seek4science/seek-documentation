---
title: ISA-JSON Compliant Sample Permissions
---

ISA-JSON compliant Samples (referred to as *ISA-JSON Samples*) are created within an [Assay](assays) or [Study](studies) using an [Experiment Sample Template](isajson-templates). These samples are defined by metadata attributes, units, and validation rules specified in the template.



## Permission levels

| **Permission level** | **View** | **Edit** | **Manage** | **Description** |
|----------------------|:--------:|:--------:|:----------:|------------------|
| **No access**        | ❌       | ❌       | ❌         | The sample is completely hidden. |
| **View**             | ✅       | ❌       | ❌         | The sample is visible but cannot be modified. |
| **Edit**             | ✅       | ✅       | ❌         | The sample metadata can be updated. |
| **Manage**           | ✅       | ✅       | ✅         | Full control: edit, delete, and change permissions. |

Each permission level defines what actions a user can perform on an ISA-JSON Sample:

- **No access**: The sample is entirely hidden from the user
- **View**: The user can view the sample and its metadata but cannot make changes
- **Edit**: The user can update metadata fields but cannot delete the sample or modify its sharing policy
- Manage: The user has full control, including editing, deleting, and changing permissions.

## Inheritance and sharing behavior
Each ISA-JSON has an associated sharing policy that determines which users or groups can view, edit, or manage it. Though alligned by default, these permissions can be set independently of those assigned to the parent Assay or Study, which may have their own sharing settings.

> {% include callout.html type="note" content="When both an Assay/Study and its ISA‑JSON Samples have policies, SEEK enforces the most restrictive. Even if you can view an Assay, an individual Sample with 'No access' will remain hidden." %}

## Who can create ISA-JSON Samples?

> {% include callout.html type="note" content="Upgrading from a lower to higher policy at the level of the Assay or Study does **not** automatically grant ISA-JSON Sample‑creation rights." %}

To create ISA-JSON Samples, a user must:

- Be a member of **at least one** project (not necessarily the one linked to the Assay or Study)
- Have at least 'View' access to the parent Assay or Study.

For instructions on creating ISA-JSON Samples, refer to the [Samples in ISA-JSON Compliant Experiments](create-sample-isajson-compliant#create-assay-samples) page.

## Setting ISA-JSON Sample permissions
### Via the Sample browser

- Navigate to Browse → Samples
- Use the filters to locate the desired ISA-JSON Sample
- Click Actions → Manage Sample to update its permissions.

### From the Assay or Study experiment view

- Open the [experiment view](viewing-project-in-single-page) of the relevant Assay or Study
- Select one or more ISA-JSON Samples using the checkboxes
- Click Batch sharing permissions at the bottom of the Dynamic Table.

### From the User profile

- Go to 'My profile';
- Use the [batch permission tools](bulk-change-sharing-permission) to manage access across multiple assets, including ISA-JSON Samples;
- Tip: Click **Sort by ISA** to group assets by Investigation → Study → Assay → Sample.

> {% include callout.html type="note" content="Batch sharing will **overwrite** all existing custom sharing policies for the selected Samples. Use with caution." %}
