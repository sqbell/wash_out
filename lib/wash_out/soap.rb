require 'active_support/concern'

module WashOut
  module SOAP
    extend ActiveSupport::Concern

    module ClassMethods
      attr_accessor :soap_actions

      # Define a SOAP action +action+. The function has two required +options+:
      # :args and :return. Each is a type +definition+ of format described in
      # WashOut::Param#parse_def.
      #
      # An optional option :to can be passed to allow for names of SOAP actions
      # which are not valid Ruby function names.
      def soap_action(action, options={})
        if action.is_a?(Symbol)
          if soap_config.camelize_wsdl.to_s == 'lower'
            options[:to] ||= action.to_s
            action         = action.to_s.camelize(:lower)
          elsif soap_config.camelize_wsdl
            options[:to] ||= action.to_s
            action         = action.to_s.camelize
          end
        end

        default_response_tag = soap_config.camelize_wsdl ? 'Response' : '_response'
        default_response_tag = "tns:#{action}#{default_response_tag}"

        self.soap_actions[action] = options.merge(
          :in           => WashOut::Param.parse_def(soap_config, options[:args]),
          :out          => WashOut::Param.parse_def(soap_config, options[:return]),
          :error        => WashOut::Param.parse_def(soap_config, options[:error]),
          :to           => options[:to] || action,
          :response_tag => options[:response_tag] || default_response_tag
        )
      end
    end

    included do
      include WashOut::Configurable
      include WashOut::Dispatcher
      include WashOut::WsseParams
      self.soap_actions = {}
    end
  end
end
