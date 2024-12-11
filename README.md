# team-assignments
This repository holds the public facing team assignments.


This repository works together with the private team-management repository to make it possible for self-service
team membership updates.

### How it works
The `*team-overrides.yaml` file here lists only teams intended to be publicly managed

The full team-manager configuration file is kept in the private `team-management` repository

The team manager tool used in the `team-management` repository workflows has been enhanced to substitute the team member and mentor information from the override file here in place of the team member and mentor lists in the full configuration, before taking GitHub API actions.

Enhancement Implementation Pull Request: https://github.com/cilium/team-manager/pull/28
