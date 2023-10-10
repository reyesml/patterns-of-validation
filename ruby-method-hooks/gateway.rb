#!/bin/ruby
# frozen_string_literal: true

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

  def validate_id(id:, **)
    validity = (id.is_a? Numeric) ? 'valid' : 'invalid'
    puts validity
  end

  def authorize(*)
    puts 'authorized'
  end

  # This isn't desirable, but the hooks have to be registered
  # after all of the class methods are defined. Otherwise we can't
  # determine which methods should be included in "all".
  include Hooks
  before_all :validate_id, except: [:list]
  before_all :authorize
end
