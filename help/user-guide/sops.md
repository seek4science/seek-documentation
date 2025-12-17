---
title: Standard Operating Procedures (SOPs)
description: Create, upload and link Standard Operating Procedures to Studies and Assays to document experimental workflows in FAIRDOM-SEEK.
---

## What are SOPs?

Standard Operating Procedures (SOPs), also known as Protocols, describe the steps required to reproduce an assay or part of an experimental workflow.

SOPs can be uploaded in various formats (Word documents, PDFs, e-lab notebooks, code scripts, annotated spreadsheets, ...) and stored as assets in {{ site.seek_instance.name | default: "FAIRDOM-SEEK" }}. These assets can be linked to Assays (and in ISA-JSON compliant setups also to Studies) to document the procedures applied.

<!-- - In ISA-JSON compliant environments, the `SOP_type` field (e.g. DNA extraction, RNA sequencing, Library prep, Data processing) must be completed. 

Missing SOPs or missing `SOP_type` values may result in incomplete or invalid ISA-JSON exports.-->

## Creating and linking SOPs

### Create a new SOP (Protocol Asset)

1. Go to Create → SOPs
2. Upload the document or link to an external source
3. Provide a title, description, version/date, license, etc.
4. Link the SOP to an existing Project
5. Set sharing permissions
<!-- - 6. Fill in the `SOP_type` field (mandatory for ISA-JSON compliance)-->
6. Click Register

### Link SOPs

- Link SOPs to Studies or Assays via the dropdown menu when creating or editing the Study or Assay.

### Updating SOPs

To update an SOP:

1. Navigate to the SOPs page
2. Use Actions -> Register new version to add the revised file or description
3. Provide version details (e.g. v2.0, date, changelog)
4. Save the new version

{% include callout.html type="note" content="You must have managing rights to update an SOP. If not, ask the asset owner to upload the new version." %}

Older Assays or Samples remain linked to the previous version, preserving provenance. New Studies or Assays can be linked to the updated SOP.