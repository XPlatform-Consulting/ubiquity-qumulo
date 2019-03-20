require "qumulo/rest"

module Ubiquity::Qumulo::Rest

  # REST API v1
  module V1
    require 'ubiquity/qumulo/rest/v1/file'
    require 'ubiquity/qumulo/rest/v1/file_resource'
  end

  class Http < ::Qumulo::Rest::Http

    def http_execute(request)
      request.content_type ||= "application/json" # unless request.content_type
      request["Authorization"] = @bearer_token if @bearer_token
      http = Net::HTTP.new(@host, @port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.open_timeout = @open_timeout
      http.read_timeout = @read_timeout

      # Print debug information
      if @request_opts.debug
        http.set_debug_output($stderr)
      end

      response = http.start {|cx| cx.request(request)}
      result = {:response => response, :code => response.code.to_i}
      result[:body] = response.body # for debugging
      if response.is_a?(Net::HTTPSuccess)
        # XXX - we should not always parse the body.  For file data,
        # we should store it to an open stream, or just store it as binary.
        # This is not yet implemented.
        begin
          result[:attrs] = JSON.parse(response.body)
        rescue JSON::ParserError
          # Sometimes QFSD returns non-json body. (e.g. /v1/setpassword)
          # Ignore body of unparsable success response.
          result[:attrs] = {}
        end
      else
        begin
          result[:error] = JSON.parse(response.body)
        rescue JSON::ParserError
          result[:error] = { :message => response.msg }
        end
      end
      result
    end

    def put_raw(path, body, options = { })
      headers = options[:headers]
      post = Net::HTTP::Put.new(path, headers)
      post.body = body
      http_execute(post)
    end

  end

end
