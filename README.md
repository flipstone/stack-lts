# Stack Docker Image

## Released Versions

| Date       | Image Version | Stack Version      | Arch            |
|------------|---------------|--------------------|-----------------|
| 2018-03-12 | v1            | 1.6.5              | x86-64          |
| 2018-05-23 | v2            | 1.7.1              | x86-64          |
| 2018-10-10 | v2            | 1.9.0.1-prerelease | x86-64          |
| 2018-12-20 | v2            | 1.9.3              | x86-64          |
| 2019-06-03 | v2            | 2.1.0.3-rc         | x86-64          |
| 2021-02-02 | v3            | 2.5.1              | x86-64          |
| 2021-05-26 | v4            | 2.7.1              | x86-64          |
| 2021-12-26 | v5            | 2.7.3              | x86-64, aarch64 |

## Versioning
When making updates to this repo, if the contents of the docker image, besides
the stack version, change, the image version should be updated.  The stack
version within a particular docker image, does not necessitate an image version
bump.  Additionally, any particular stack version could be used within multiple
image versions.
