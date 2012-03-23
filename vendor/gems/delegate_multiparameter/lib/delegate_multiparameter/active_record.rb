module DelegateMultiparameter
  module ActiveRecord
    module ClassMethods
      def multiparameter_delegations
        @multiparameter_delegations ||= []
      end

      def delegate_multiparameter(*args)
        attrs, options = args[0..-2], args.last
        attrs.each do |attr|
          delegate attr, "#{attr}=", options
        end
        multiparameter_delegations << options.merge!({:attributes => attrs})
      end
    end

    def self.included(base)
      base.send :extend, ClassMethods
      base.send :alias_method_chain, :attributes=, :multiparameter_delegation
    end

    def attributes_with_multiparameter_delegation=(new_attributes, guard_protected_attributes = true)
      self.class.multiparameter_delegations.each do |delegation|
        attribute_keys_to_delegate = []
        prefix = delegation[:prefix].nil? ? '' : delegation[:prefix] == true ? delegation[:to].to_s+'_' : delegation[:prefix].to_s+'_'
        delegation[:attributes].each do |attribute_name|
          attribute_keys_to_delegate += new_attributes.keys.find_all { |key| key.to_s =~ /^#{prefix}#{attribute_name}(\(.+\))?$/ }
        end

        attributes_to_delegate = attribute_keys_to_delegate.inject({}) do |mem, key|
          key_without_prefix = key.gsub(/^#{prefix}/,'')
          mem[key_without_prefix] = new_attributes.delete(key)
          mem
        end

        send(delegation[:to]).send(:attributes=, attributes_to_delegate, guard_protected_attributes) unless attributes_to_delegate.empty?
      end

      self.send(:attributes_without_multiparameter_delegation=, new_attributes, guard_protected_attributes)
    end
  end
end
