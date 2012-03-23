module DelegateMultiparameter
  class Railtie < ::Rails::Railtie
    initializer "delegate_multiparameter.active_record" do |app|
      ActiveSupport.on_load(:active_record) do
          ::ActiveRecord::Base.send(:include, DelegateMultiparameter::ActiveRecord)
        end
    end
  end
end

