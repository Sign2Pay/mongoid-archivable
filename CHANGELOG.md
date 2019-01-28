# 1.7.1

* FIX: BSON 4+ returns BSON::Document instead of Hash, [#15](https://github.com/Sign2Pay/mongoid-archivable/pull/15)

# 1.7.0

* `restore` returns nil if save unsuccessful, [#14](https://github.com/Sign2Pay/mongoid-archivable/pull/14)
* added `restore!` method, [#14](https://github.com/Sign2Pay/mongoid-archivable/pull/14)
* updated `ProcessLocalizedFields` to correctly restore embedded polymorphic relations, [#13](https://github.com/Sign2Pay/mongoid-archivable/pull/13)

# 1.6.0

* Support different database or client for archived documents, [#12](https://github.com/Sign2Pay/mongoid-archivable/pull/12), thanks to [@jackbit](https://github.com/jackbit)

# 1.5.2

* correctly restore localized fields on self and embedded documents

# 1.5.0

* support Mongoid 6
