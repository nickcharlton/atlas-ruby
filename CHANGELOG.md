# CHANGELOG

## 1.2.1 (03/10/2015)

* Fixes a bug where self-hosted box URLs wouldn't store correctly ([#1][])
* Fixes a bug where the box version description couldn't be specified on
  creation ([#2][]).

## 1.2.0 (29/07/2015)

* Adds custom error classes and catching in the request.
* Moves the JSON response parsing into the request, removing from the
  resources.

## 1.1.0 (27/07/2015)

* Adds support for uploading boxes to providers.
* Adds shorter methods to create versions from boxes, and providers from
  versions.

## 1.0.0 (24/07/2015)

* Initial release; handles creating, updating, deleting boxes, versions and
  providers.

[#1]: https://github.com/nickcharlton/atlas-ruby/issues/1
[#2]: https://github.com/nickcharlton/atlas-ruby/issues/2
