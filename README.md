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

## Standalone Storage

By default, the archived documents will be stored in primary client and database. If you want to use different database or client for all archived documents, you can create the following middleware:

```ruby
# Rails : config/initializers/mongoid_archivable.rb
# Ruby : config/mongoid_archivable.rb

Mongoid::Archivable.configure do |config|
  config.database = "archives"
  config.client = "secondary"
end
```

But if you only want to use different database or client in spesific Mongoid document, you can use this approach:

```ruby
class User
  include Mongoid::Document
  include Mongoid::Archive
  archive_in database: 'achives', client: 'secondary'
end
```

In your mongoid.yml will show like this:

```yaml
development:
  clients:
    default:
      database: project_development
      hosts:
        - localhost:27017
      options:
        <<: *client_options
    secondary:
      database: archives
      hosts:
        - localhost:27018
      options:
        <<: *client_options
```


## Development

Please report any issues to the [GitHub issue tracker](https://github.com/Sign2Pay/mongoid-archivable/issues).
