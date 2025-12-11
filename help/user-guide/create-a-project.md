---
title: Creating a Project
---

## What is a Project

A Project represents a group of one or more people collaborating together on a particular activity. The Project provides the ability to describe and promote the activity, and also give credit back to the team. The Project will have a title, and optionally a description, public website and avatar graphic. Users need to be a member of a Project before they can register items, which will then be related to that Project and a user can be in many Projects without limit.

As well as providing credit, a Project also has useful abilities such as default Sharing permissions and licence, and the ability to easily set sharing permissions across all members of the Project. Some members of the Project may have special Gatekeeper and Housekeeper roles within the Project - for more information see [Specialist user roles](roles).

The Project will have its own [Project Administrator](roles#project-administrator) - usually the user that initially requested the project. As well as editing the Project details, this user can also add and remove members, and set their roles and define additional administrators. They may also define new Institutions, Profiles (to describe members that have not yet registered) and Organisms.

A member of the Project will also be related to an Institution for the context of that Project (some users may be related to different Institutions for different Projects).

## What is a Programme

If configured to be enabled, {{ site.seek_instance.name | default: "FAIRDOM-SEEK" }} may also have Programmes. Programmes are an umbrella that contains one or more Projects. They are a self-administered area, that describes a broad activity (usually related to a funded grant), such as a consortium, or a long-running activity that will need additional Projects.

Once approved, The Programme will have a [Programme Administrator](roles#programme-administrator) who is free to immediately create additional Projects without requiring additional approval.

The Programme must have a title, and can optionally also have a description, funding details, website, and avatar graphic.

For users that just require a single Project, and don't require a Programme, a site managed Programme can be defined (recommended) to which their Project will be associated. They will then just administer their Project without needing to worry about Programmes. Their Project can be moved to their own Programme in the future if necessary.

## Creating a Project

You will first be prompted to create (or [Join a Project](join-a-project)) following registering a new {{ site.seek_instance.name | default: "FAIRDOM-SEEK" }} account. If you are already a member and wish to add additional Projects, you can choose to create a Project from the _Create_ menu in the top bar.

### Choosing a Programme

If enabled, first a Programme will need to be chosen or created. If configured, you will also have the option to choose a site managed Programme. By default, the site managed Programme is selected, but if unchecked there is an option to provide the title of a new one. Only the title is required at this stage, but further details can be provided later once created.

![Choose Programme]({{ "/images/user-guide/create-project-select-programme.png" | relative_url }}){:.screenshot}

If you already administer existing Programmes, a dropdown box will be shown instead allowing you to select one of your existing Programmes. You will also have the option to create a new one.

### Defining the Project

You next need to define the Project. At a minimum a title is required, but you can also here provide a description and webpage. Once created you can edit and add additional details and add members.

![Define Project]({{ "/images/user-guide/create-project-define-project.png" | relative_url }}){:.screenshot}

### Defining your Institution

When the Project is created, you will automatically become a member along with its administrator.
To become a member you also have to describe the institution (or affiliation) that you are associated with in relation to this Project. It doesn't have to be the same Institution as other Projects, and it is not unusual for it to be different.

Start to type the name of your institution, and existing options will be displayed that contain the text you type (or related to the Institution such as City). Hopefully your institution is found and you can just select it. If not, you can choose the top option to define a new one.

If describing a new Institution only the title is required, but you can also provide details about its website, city and country. You will also be able to edit and add additional information afterwards.

There is also support for the [Research Organization Registry (ROR)](https://ror.org/). Use the ROR search field to find your institution and select the matching entry to automatically populate the organization details and capture the ROR identifier. If you already know the identifier, you can enter it directly. When the organization is not listed in ROR, you can leave the field empty and continue manually.

If the institution you searched for already exists locally, it will appear under **Institutions saved locally**. Otherwise, it will be listed as a new **institutions fetched from ROR**.

![define_institution](images/user-guide/ror/ror_project.png)

### Approval step

If you are creating a Project within a Programme you administer, then there is no approval step. You will be shown a page to review the details and then create straight away.

Otherwise, an appropriate administrator will be notified by email about your request. They will also be notified directly when using {{ site.seek_instance.name | default: "FAIRDOM-SEEK" }}. The administrator will be shown a page that allows them to quickly review the details and either accept or reject the request, and in either case you will be notified by email.
