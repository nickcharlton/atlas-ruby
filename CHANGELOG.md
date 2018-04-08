# CHANGELOG

## 2.0.0 (07/04/2018)

_**WARNING**: This will be the last major release of this gem. I recommend
using [hashicorp/vagrant_cloud](https://github.com/hashicorp/vagrant_cloud) as
it's maintained by HashiCorp._

* Use headers, not query arguments for the token ([#23][]).
* Deprecate the `access_token` configuration option ([#23][]).
* Refresh cassettes ([#16][], [#17][], [#18][], [#19][], [#20][], [#21][],
  [#22][]).
* Implement validations for required attributes ([#14][]).
* Improve `date_accessor` specs ([#13][]).
* Rename keys in-place to avoid assigning nil ([#12][]).

[#12]: https://github.com/nickcharlton/atlas-ruby/pull/12
[#13]: https://github.com/nickcharlton/atlas-ruby/pull/13
[#14]: https://github.com/nickcharlton/atlas-ruby/pull/14
[#16]: https://github.com/nickcharlton/atlas-ruby/pull/16
[#17]: https://github.com/nickcharlton/atlas-ruby/pull/17
[#18]: https://github.com/nickcharlton/atlas-ruby/pull/18
[#19]: https://github.com/nickcharlton/atlas-ruby/pull/19
[#20]: https://github.com/nickcharlton/atlas-ruby/pull/20
[#21]: https://github.com/nickcharlton/atlas-ruby/pull/21
[#22]: https://github.com/nickcharlton/atlas-ruby/pull/22
[#23]: https://github.com/nickcharlton/atlas-ruby/pull/23

## 1.6.0 (31/07/2016)

* Switch to use the new Atlas API URL ([#11][])
* Add a `.ruby-version` to specify Ruby 2.4.1.
* Update Travis to use Ruby 2.4.1.

## 1.5.0 (05/01/2016)

* Revert the callback functionality from 1.4.0.
    - This would never have worked as the binstore doesn't support chunked
      encoding.
* Add `pry` as a development dependency.

## 1.4.0 (16/10/2016)

* Allows providing a callback for file uploads so that it's possible to monitor
  the upload progress ([#7][]).

## 1.3.0 (15/02/2016)

* Adds timestamps to `Box`, `BoxVersion` and `BoxProvider`.

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
[#7]: https://github.com/nickcharlton/atlas-ruby/pull/7
[#11]: https://github.com/nickcharlton/atlas-ruby/pull/11
