require 'ubiquity/qumulo'
require 'ubiquity/qumulo/rest'

module Ubiquity
  module Qumulo
    class Client

      attr_accessor :api

      def initialize(args = { })
        @api = Qumulo::Rest::V1

        host_address = args[:host_address] || args[:hostname] || 'localhost'
        host_port = args[:host_port] || 8000

        username = args[:username] || 'admin'
        password = args[:password] || 'password'
        host_port = host_port.to_i rescue 8000

        ::Qumulo::Rest::Client.configure(:addr => host_address, :port => host_port, :http_class => Rest::Http)

        # Login everytime as the client is not setup to accept a bearer token directly
        ::Qumulo::Rest::Client.login(:username => username, :password => password)
      end

      def call(class_name, method, *args)
        klass = api.const_get(class_name)
        klass.send(method, *args)
      end

    end
  end
end
