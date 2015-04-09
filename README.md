# Mongoid::Archivable

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

```
include Mongoid::Archivable
```

Now a `destroy` of a document will move the document to an Archive collection, namespaced under the document you're destroying.

## Example

```
user = User.create! name: "Example User"
user.destroy

User.count # => 0
User::Archive.count # => 1
```

## Development

Please report any issues to the [GitHub issue tracker](https://github.com/Sign2Pay/mongoid-archivable/issues).
