module Hooks
  def self.included(base)
    base.extend ClassMethods
    base.register_base base
  end

  module ClassMethods
    def register_base(base)
      @base = base
    end

    def before_all(func, except: [])
      base = @base
      method_overrides = Module.new do
        (base.instance_methods(false) - except).each do |name|
          define_method(name) do |*args, &block|
            send(func, *args, &block)
            super(*args, &block)
          end
        end
      end
      prepend method_overrides
    end

    def before(func, *targets)
      method_overrides = Module.new do
        targets.each do |name|
          define_method(name) do |*args, &block|
            send(func, *args, &block)
            super(*args, &block)
          end
        end
      end
      prepend method_overrides
    end

    def after(func, *targets)
      method_overrides = Module.new do
        targets.each do |name|
          define_method(name) do |*args, &block|
            super(*args, &block)
            send(func, *args, &block)
          end
        end
      end
      prepend method_overrides
    end
  end
end
