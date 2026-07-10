---
title: Roadmap
description: Development roadmap with current and upcoming FAIRDOM-SEEK priorities.
redirect_from: "/roadmap.html"
---


This is an outline of plans the core FAIRDOM-SEEK development team will be working on in the near future.

FAIRDOM-SEEK is developed following an Agile development process, meaning priorities may change - however, these items
are currently high priorities.

They are expected to be added to FAIRDOM-SEEK in roughly the order they are presented here.

Please also see the [WorkflowHub Roadmap](https://about.workflowhub.eu/roadmap/),
which is being built on and in conjunction with FAIRDOM-SEEK.

## Now

- Rails 8.1
- [Redis](https://redis.io) for session management and caching
- Investigate moving to [Sidekiq](https://sidekiq.org) for background job management
- Checking the content security policies (inline JS/CSS, nonces)
- Update to use [Apache Solr 9](https://solr.apache.org)

## Next

- S3 support
- [RO-Crate](https://www.researchobject.org/ro-crate/) for ISA/Collections

## Later

- _Currently under discussion_

---

## Completed

For a full history of completed features, please see the [Change Logs]({{ "/tech/releases/" | relative_url }}).
