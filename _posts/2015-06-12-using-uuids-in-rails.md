---
layout: post
title: "Using UUIDs in Rails"
date: 2015-06-12 20-06-35
description: "A quick explanation on how to generate UUIDs in Rails while using the Postgres and SQLite databases"
tags: [database, development, rails, ruby]
comments: true
---

### Why use UUIDs?
It may seem like a trivial decision at first glance, but using UUIDs can have an intricate effect on your applications design structure. If you are building an application and have an `id:integer` column that auto increments with the creation of every item you add to that table you could end up with some sever issues. As applications grow in size we end up having to seperate parts of the application into different servers: a cluster of database servers, background, jobs, cache server, an httpd server, and throw in a few servers for actual application and you've got a whole cluster of services to deal with.

Lets say you've got 3 servers running the actual application, each one chugging along running serveral instances of your web application. Now say it's a basic CRUD application if you've got several instances writing to the database at once you will have a conflict. If you've got a table named books and a few rows are being added at once by seperate visitors, you're auto incrimenting the rows and lets say on each one it creates row id: 72. Now when they combine their information together you're going to have an issue with inconsistent data trying to overlap.

```ruby
id: 72, title: The Raven
id: 72, title: My Side of the Mountain
id: 72, title: The Giver
```

Now if we were inserting these datasets into the different database servers while using UUIDs we may could up with something to the following example below.

```ruby
id: 898f73bc-290c-4427-b75a-68f34464e188, title: The Raven
id: dd126f47-de45-4cbe-aa1c-8b052693498e, title: My Side of the Mountain
id: 479af9a8-c096-42e2-8a29-4a321cdd5f7c, title: The Giver
```

UUIDs are simple 128-bit generated values and only consisting of formated using hexadecimal text. Depending on [how they're being generated](https://en.wikipedia.org/wiki/Universally_unique_identifier#Variants_and_versions) their values are generally a random value that will rarely have a collision value. It's generally safe to say that you can use a distributed application and have several servers generating rows of data and almost never have the same UUID generated (I'm not saying it can't happen, it's just a lot less likely to happen).

### How can I do this is Rails?
When you are generating models and scaffolds the `id` column is usually automatically generated with every table (unless specified), this is a feature build into Rails to make it easier and faster to develop.

```ruby
create_table "books", force: :cascade do |t|
  t.string   "title"
  t.timestamps null: false
end

# Generates
id:integer, PRIMARY KEY, auto_increment
title:string
created_at:datetime "created_at", null: false
updated_at:datetime "updated_at", null: false
```

Now depending on what database you are using to test, develop, and deploy you application there are different steps that are required in order to get your application to properly recognize and use the UUID datatype. I have seperated into different sections how I got UUIDs to work in both Postgresql and the SQLite databases.

### Postgresql
The method in order to get uuids to work with Postgres tends to be quite a bit easier (in my opinion), because Postgres has a built in method for generating unique uuids for row ids.

```shell
rails g migration enable_uuid_extension
```

In the migration we tell the Postgres database to use the uuid extension, we do this in order to have the database automatically generate UUIDs on the objects creation rather than having the Rails Application generate the UUIDs and adding additional process time to the server.

```ruby
class EnableUuidExtension < ActiveRecord::Migration[5.1]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
  end
end
```

Now lets generate a book model and get started on adjusting the migration to allow the application to generate a UUID for the id instead of a basic integer.

```ruby
rails g model Book title:string
```

Now we also need to change id: to use the :uuid datatype instead of letting the application automatically assigning it.

```ruby
class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books, id: :uuid  do |t|
      t.string :title
      t.timestamps null: false
    end
  end
end
```

Now access the rails console `rails c` in order to verifiy that UUIDs are being generated upon the models object creation. At this point in time the default version of UUID generation used by Rails is `uuid_generate_v4()` which seems to be quite sufficient to avoiding collisions.

```ruby
2.2.1 :001 > Book.create(title: 'The Raven')
(0.4ms)  BEGIN
  SQL (35.2ms)  INSERT INTO "books" ("title", "created_at", "updated_at") VALUES ($1, $2, $3) RETURNING "id"  [["title", "The Raven"], ["created_at", "2015-06-13 05:31:03.762157"], ["updated_at", "2015-06-13 05:31:03.762157"]]
   (197.1ms)  COMMIT
 => #<Book id: "f55ea573-1eec-4053-b7f5-7b693b344da9", title: "The Raven", created_at: "2015-06-13 05:31:03", updated_at: "2015-06-13 05:31:03">
```

If you look closely you will notice that the Book.id is no longer being generated a basic integer, it is not being generating a Hex based text string. As show above: `Book[id]: f55ea573-1eec-4053-b7f5-7b693b344da9`

### SQLite

To begin using UUIDs with sqlite you will need to install the [`activeuuid`](https://github.com/jashmenn/activeuuid) gem, when using this gem it will save the uuid: as a binary(16) datatype. I haven't dug around to much into the gem, but it does seem to work quite effectively for it's purpose.

```ruby
# Gemfile
gem 'activeuuid'  # https://github.com/jashmenn/activeuuid
```

We will now need to adjust the migration to explicity use the uuid: datatype for :id and completely disregard using the default :id dataset and configuration.

```ruby
# migrations
class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books, :id => false do |t|
      t.uuid :id, :primary_key => true, null: false
      t.string :title

      t.timestamps null: false
    end
  end
end
```

You will also need to include `ActiveUUID::UUID` in your model to enable UUID generation, you will need to specify a `natural_key` to supply a dataset in order to generate a UUID. If this step is not included the application will throw a heap of errors about the books.id using an invalid uuid datatype.

```ruby
#models/book.rb
class Book < ActiveRecord::Base
  include ActiveUUID::UUID
  natural_key :created_at
end
```

Upon creating a book object, you should recieve output with something similar to the example shown below.

```ruby
2.2.1 :002 > Book.create(title: 'The Raven')
   (0.1ms)  begin transaction
  SQL (0.5ms)  INSERT INTO "books" ("id", "title", "created_at", "updated_at") VALUES (?, ?, ?, ?)  [["id", "<16 bytes of binary data>"], ["title", "The Raven"], ["created_at", "2015-06-13 05:57:45.728134"], ["updated_at", "2015-06-13 05:57:45.728134"]]
   (3.4ms)  commit transaction
 => #<Book id: #<UUID:0x3feef3549684 UUID:a5093dd9-cb33-5783-b01c-0d0d381490f1>, title: "The Raven", created_at: "2015-06-13 05:57:45", updated_at: "2015-06-13 05:57:45">
```

#### Updated: 08/27/2019

The previous method used the `uuid-ossp` extension which relies on `uuid_generate_v4` to generate UUIDs. The recommended method `pgcrypto` uses the Postgres function `gen_random_uuid` to generate UUIDs, this method generates UUIDs faster and with better collision prevention.

-----

#### Resources
* [activeuuid](https://github.com/jashmenn/activeuuid)
* [PostgreSQL UUID type](http://www.postgresql.org/docs/9.3/static/datatype-uuid.html)
* [PostgreSQL uuid-ossp extensions](http://www.postgresql.org/docs/9.3/static/uuid-ossp.html)
