# frozen_string_literal: true
require_relative 'lib/hooks'

class Gateway
  include Hooks

  before_all { authorize }
  before_all(except: [:list]) { |*args| validate_id(*args) }

  after_all { puts 'After!' }

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

  def self.validate_id(id:, **)
    validity = (id.is_a? Numeric) ? 'valid' : 'invalid'
    puts validity
  end

  def self.authorize
    puts 'authorized'
  end
end
