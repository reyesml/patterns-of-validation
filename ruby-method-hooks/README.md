# Repetitive Validation


Suppose we've implemented a `Gateway` class that we want to secure. Every method in the gateway should perform some sort of authorization/validation before servicing the request.

One technique we could take is to structure our `Gateway` like this:

```ruby
class Gateway
  def read(id:)
    authorize
    puts "read #{id}"
  end

  def write(id:, body:)
    authorize
    puts "write #{id}: #{body}"
  end

  def delete(id:)
    authorize
    puts "delete #{id}"
  end

  def list
    authorize
    puts 'listing all'
  end

  private

  def authorize
    puts 'authorized'
  end
end
```

This is simple enough, and it works.  The downside to this approach is that it's easy to forget to add an `authorize` call at the beginning of each method.

We can reduce the likelyhood of a developer forgetting to safeguard their methods by adding a `before_all` hook, like this example:

```ruby
require_relative 'lib/hooks'

class Gateway
  def read(id:)
    puts "read #{id}"
  end

  def write(id:, body:)
    puts "write #{id}: #{body}"
  end

  def delete(id:)
    puts "delete #{id}"
  end

  def list
    puts 'listing all'
  end

  private

  def authorize(*)
    puts 'authorized'
  end

  include Hooks
  before_all :authorize
end
```
The idea is to make defensive coding the default.

The magic happens within the `Hooks` module. The `Hooks` module adds a new method, `before_all` that allows us to register a callback on every instance method within our `Gateway`. Now developers can add new methods to the `Gateway` class and not worry about forgetting to safeguard them.

_Disclaimer: The examples in this repository are pretty hacky, and shouldn't be used in production code. If you're looking to add production-worthy hooks to your codebase, I'd refer you to the Rails `ActiveModel` library._
