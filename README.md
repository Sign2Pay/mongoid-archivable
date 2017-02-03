# Mongoid::Archivable

[![Build Status](https://travis-ci.org/Sign2Pay/mongoid-archivable.svg)](https://travis-ci.org/Sign2Pay/mongoid-archivable) [![Gem Version](https://badge.fury.io/rb/mongoid-archivable.svg)](http://badge.fury.io/rb/mongoid-archivable)

Moves Mongoid documents to an archive instead of destroying them.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mongoid-archivable'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mongoid-archivable

## Usage

In any Mongoid document, do this:

```ruby
include Mongoid::Archivable
```

Now a `destroy` of a document will move the document to an Archive collection, namespaced under the document you're destroying.

You can restore an archive as well. Send the `.restore` message to it. For now the archived document is retained, but that might change in the future.

## Example

```ruby
user = User.create! name: "Example User"
user.destroy

User.count # => 0
User::Archive.count # => 1

archived_user = User::Archive.last
archived_user.restore

User.count # => 1
User::Archive.count # => 1
```

## Development

Please report any issues to the [GitHub issue tracker](https://github.com/Sign2Pay/mongoid-archivable/issues).
