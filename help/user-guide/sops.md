---
title: Standard Operating Procedures (SOPs)
---

## What are SOPs?

Standard Operating Procedures (SOPs), also known as Protocols, describe the steps required to reproduce an assay or part of an experimental workflow.

SOPs can be uploaded in various formats (Word documents, PDFs, e-lab notebooks, code scripts, annotated spreadsheets, etc.) and stored as assets in SEEK. These assets can be linked to Assays and, in ISA-JSON compliant setups, also to Study Samples and Assay Samples to document the procedures applied.

SEEK can be used in two modes:
- As a general-purpose FAIR data management platform
- As an ISA-JSON compliant system

While SOP creation and management are largely the same in both modes, ISA-JSON compliance introduces one key requirement: the `SOP_type` field must be filled in to ensure valid exports.

## SOPs in SEEK

Regardless of the mode:

- SOPs are treated as assets, similar to Data Files or Models.
- They can be created, uploaded, versioned, and linked to Assays to document experimental methods.

In ISA-JSON compliant environments, SOPs play a formal role in the experimental lineage:

- Each transformation step (e.g. Study Source → Study Sample → Assay Sample) must reference a protocol.
- SOPs are mandatory for valid ISA-JSON exports.
- The `SOP_type` field (e.g. DNA extraction, RNA sequencing, Library prep, Data processing) must be completed.

Missing SOPs or missing `SOP_type` values may result in incomplete or invalid ISA-JSON exports.

## Creating and Linking SOPs

### Create a New SOP (Protocol Asset)

1. Go to Create → SOPs
2. Upload the document or link to an external source
3. Provide a title, description, version/date, license, etc.
4. Link the SOP to an existing Project
5. Set sharing permissions
6. Fill in the `SOP_type` field (mandatory for ISA-JSON compliance)
7. Click Register

### Link SOPs

- In SEEK: link SOPs to Studies or Assays via the dropdown menu when creating or editing the Study or Assay.

### Updating SOPs

To update an SOP:

1. Navigate to the SOP’s page
2. Use Actions -> Register new version to add the revised file or description
3. Provide version details (e.g. v2.0, date, changelog)
4. Save the new version

Note: You must have managing rights to update an SOP. If not, ask the asset owner to upload the new version.

Older Assays or Samples remain linked to the previous version, preserving provenance. New Studies or Assays can be linked to the updated SOP.