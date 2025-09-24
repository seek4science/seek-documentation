---
title: Sample Type Permissions
---

In FAIRDOM-SEEK, a Sample Type (ST) defines the structure and metadata schema for a group of related samples. It specifies the attributes, units, and validation rules that apply to samples created under it.

Each Sample Type has an associated sharing policy that determines which users or groups can view, edit, or manage it. These permissions are distinct from those of the individual samples, which have their own independent sharing settings.


## What can users do at each permission level?

| **Permission level** | **View ST** | **Edit ST** | **Manage ST** | **What this means** |
|----------------------|:-----------:|:-----------:|:-------------:|----------------------|
| **No access**            | ❌         | ❌          | ❌            | The Sample Type is completely hidden. |
| **View**                 | ✅         | ❌          | ❌            | Users can see the Sample Type, but not change it. |
| **Edit**                 | ✅         | ✅          | ❌            | Users can update fields, attributes, and units. |
| **Manage**               | ✅         | ✅          | ✅            | Full control: delete, change policy, etc. |


In other words:
- **No access**: The Sample Type is completely hidden, the user won’t even know it exists
- **View**: The user can look at the Sample Type and its details, but can’t make any changes
- Edit: The user can make changes to the Sample Type (like updating fields or units), but can’t delete it or change who else can see it
- Manage: The user has full control — they can edit, delete, and change sharing settings.

> {% include callout.html type="note" content="Samples have their own, independent sharing policies that do not default to those of their Sample Type." %}

Permissions assigned to a Sample Type do not automatically apply to the individual samples created under it. Each sample is governed by its own sharing policy, which is configured independently of the Sample Type.
By default, newly created samples are private. 

Note: Samples created within the context of an ISA-compliant Study or Assay **do** inherit the permissions of that ISA Study or Assay by default. 

## Who can create Samples?

> {% include callout.html type="note" content="Upgrading from a lower to higher policy at the level of the Sample Type does **not** automatically grant sample‑creation rights." %}

To create samples, a user must:

- Be a member of **any** project (not necessarily the one linked to the Sample Type)
- Have at least View access to the Sample Type.

## How to set Sample Type permissions

1. Go to 'Browse → Sample Types'
2. Click the Sample Type you want to configure
3. Click 'Actions → Manage Sample Type' in the top right corner
5. Choose a level: No access, View, Edit, or Manage
6. *(Optional)* Use custom sharing to add specific users or groups
7. Click 'Update' — your changes apply immediately.


## Troubleshooting & Tips

- Can't see the “Create Sample” button?  
  → Make sure you have View access and belong to a project.

- Can't edit a Sample Type?  
  → You need Edit or Manage rights and must be in a project.

- Want to hide old Sample Types?  
  → Set their policy to No access.

