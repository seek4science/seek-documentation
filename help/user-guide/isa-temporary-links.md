---
title: ISA temporary links
description: ISA temporary links allow you to share private Investigations, Studies, and Assays with external collaborators or reviewers by creating time-limited access links. These links enable viewing and downloading without requiring user accounts in SEEK.
---

## Overview

ISA temporary links allow you to share private Investigations, Studies, and Assays with external collaborators or reviewers by creating time-limited access links. These links enable viewing and downloading without requiring user accounts in {{ site.seek_instance.name | default: "FAIRDOM-SEEK" }}.

## Features of ISA temporary links

### Hierarchical access
- **Investigation Link**: Grants access to the Investigation and ALL Studies, Assays, and associated assets within it
- **Study Link**: Grants access to the Study and ALL Assays and associated assets within it
- **Assay Link**: Grants access to the Assay and ALL associated assets (DataFiles, Models, SOPs, Documents, etc.)

### Key characteristics
-  **Downward propagation**: Parent codes grant access to all children
-  **No upward propagation**: Child codes do NOT grant access to parents
-  **Time-limited**: Each link has an expiration date
-  **Secure**: Uses cryptographically secure random codes
-  **Works with private children**: Public items can create temporary links to grant access to their private children

### Public items with private children

You can create temporary links for **public** Investigations or Studies that have private children. This is useful when:
- Your study design is public but raw data is private;
- You want to selectively share private data without making it publicly accessible.

**Example**: Public Study with Private Assays

```
Public Study ← Create temporary link here
  ├─ Private Assay 1
  │   └─ Private DataFile
  └─ Private Assay 2
```

**Expected Behavior with temporary link**:
1. Create a temporary link for the **public Study**: `/studies/123?code=STU_CODE`
2. Anyone with the link can access:
   - ✅ The Study itself (accessible anyway since it's public)
   - ✅ Private Assay 1 (accessible via code)
   - ✅ Private Assay 2 (accessible via code)
   - ✅ Private DataFile (accessible via code through Assay)

---

## Creating a temporary link

### Step 1: Navigate to the Manage page
1. Go to your Investigation, Study, or Assay.
2. Click the **'Manage'** button (requires manage permissions).

### Step 2: Configure the temporary link
In the 'Temporary Links' section:
1. Click **'Create temporary link'**.
2. Set an **expiration date** (when the link should stop working).
3. Click **'Update'** to save.

### Step 3: Share the link
After creating the link:
1. The temporary link appears on the show page (visible only to managers).
2. Click the **copy icon** to copy the full URL.
3. Share this URL with your collaborators.

**Example link**:
```
https://your-seek-instance.org/investigations/123?code=ABC123XYZ789...
```

---

## Using a temporary link

### For recipients
1. Click the link or paste it into your browser.
2. You will see the Investigation/Study/Assay **without logging in**.
3. You can navigate to all accessible child items.
4. You can download associated files.

### What you can access

#### With an Investigation link
```
Investigation ← Your link points here
  ├─ Study 1 ✅ Accessible
  │   ├─ Assay 1 ✅ Accessible
  │   │   └─ DataFile ✅ Downloadable
  │   └─ Assay 2 ✅ Accessible
  └─ Study 2 ✅ Accessible
      └─ Assay 3 ✅ Accessible
```

#### With a Study link
```
Investigation ❌ NOT accessible (parent)
  └─ Study ← Your link points here
      ├─ Assay 1 ✅ Accessible
      │   └─ DataFile ✅ Downloadable
      └─ Assay 2 ✅ Accessible
```

#### With an Assay link
```
Investigation ❌ NOT accessible (grandparent)
  └─ Study ❌ NOT accessible (parent)
      └─ Assay ← Your link points here
          ├─ DataFile ✅ Downloadable
          ├─ SOP ✅ Accessible
          └─ Model ✅ Accessible
```

---

## Managing temporary links

### Viewing existing links
1. Navigate to your Investigation/Study/Assay.
2. If you have manage permissions, you'll see active links on the show page.
3. The expiration date is displayed.

### Revoking a link
To immediately revoke access:
1. Go to the **Manage** page.
2. In the 'Temporary Links' section, check **'Remove'** next to the code.
3. Click **'Update'**.

**OR** set the expiration date to a past date:
1. Edit the expiration date to yesterday
2. Click **"Update"**

The link will immediately stop working.

### Extending a link
To extend an expiring link:
1. Go to the **Manage** page.
2. Update the **expiration date** to a future date.
3. Click **'Update'**.

The same URL continues to work with the new expiration.

---

## Use cases

### 1. Peer review
**Scenario**: Your manuscript is under review, and reviewers need to see your private data.

**Solution**:
1. Create an Investigation temporary link.
2. Set expiration for 3 months (typical review period).
3. Share the link in your manuscript submission.

**Result**: Reviewers can access all data without {{ site.seek_instance.name | default: "FAIRDOM-SEEK" }} accounts.



### 2. Collaboration preview
**Scenario**: A potential collaborator wants to see your unpublished work before committing.

**Solution**:
1. Create a Study temporary link for the relevant study.
2. Set expiration for 2 weeks.
3. Share via email.

**Result**: They can review the study and its assays, but not other studies in the investigation.



### 3. Data embargo with selective sharing
**Scenario**: Your study design is public, but raw data is embargoed. You want to share with specific people.

**Solution**:
1. Make the Study **public**.
2. Keep Assays and DataFiles **private**.
3. Create a Study temporary link (e.g., `/studies/123?code=STU_CODE`).
4. Share selectively with reviewers or collaborators.

**Result**: 
- **General public** (visiting without code): Sees the study design only
- **Link recipients** (using the code): See everything including private Assays and DataFiles

This leverages the ability of public items to create temporary links that grant access to their private children.



### 4. Conference presentation
**Scenario**: You're presenting preliminary results and want to share detailed data with attendees.

**Solution**:
1. Create an Assay temporary link.
2. Set expiration for 1 week after conference.
3. Display QR code on your final slide.

**Result**: Attendees can access the specific dataset, not your entire investigation.



### 5. External validator
**Scenario**: An external service needs to validate your data format.

**Solution**:
1. Create an Assay temporary link.
2. Set expiration for 24 hours.
3. Provide to the validation service.

**Result**: Limited time access to just what they need to validate.

---


## Technical details

### Link format
```
https://your-seek.org/{type}/{id}?code={secure_code}
```

Where:
- `{type}`: `investigations`, `studies`, or `assays`
- `{id}`: The numeric ID of the item
- `{secure_code}`: A 40-character cryptographically secure random string

### Code generation
- Uses `SecureRandom.base64(30)` for cryptographic security
- Results in ~40 characters after URL encoding
- Collision probability: virtually zero

### Authorisation logic
1. **Check own codes**: Item checks its own `special_auth_codes`
2. **Check parent codes**: Children check if parent has the code
3. **Never check child codes**: Parents don't check children's codes
4. **Expiration check**: Only unexpired codes grant access

### Hierarchical rules
```ruby
# Study checking authorization
def auth_by_code?(code)
  # Check own codes
  return true if special_auth_codes.unexpired.include?(code)
  
  # Check parent Investigation's codes (downward propagation)
  return true if investigation.special_auth_codes.unexpired.include?(code)
  
  # Does NOT check child Assay codes (no upward propagation)
  false
end
```


## API access

Temporary links work with the {{ site.seek_instance.name | default: "FAIRDOM-SEEK" }} API:

```bash
# GET request with code
curl "https://your-seek.org/investigations/123.json?code=ABC123..."

# Response includes investigation data
{
  "data": {
    "id": "123",
    "type": "investigations",
    "attributes": {
      "title": "My Investigation",
      ...
    }
  }
}
```

