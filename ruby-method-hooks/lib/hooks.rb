module Hooks
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    def before_all(except: [], &block)
      @before_all_hooks ||= []
      @before_all_hooks << { block: block, except: except }
    end

    def after_all(except: [], &block)
      @after_all_hooks ||= []
      @after_all_hooks << { block: block, except: except }
    end

    def method_added(method_name)
      return if @adding

      @adding = true
      original_method = instance_method(method_name)
      define_method(method_name) do |*args, &block|
        before_all_hooks = self.class.instance_variable_get(:@before_all_hooks) || []
        before_all_hooks.each do |hook|
          hook[:block].call(*args) unless hook[:except].include? method_name
        end

        original_method.bind(self).call(*args, &block)

        after_all_hooks = self.class.instance_variable_get(:@after_all_hooks) || []
        after_all_hooks.each do |hook|
          hook[:block].call(*args) unless hook[:except].include? method_name
        end
      end
      @adding = false
    end
  end
end
