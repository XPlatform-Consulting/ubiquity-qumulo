module Ubiquity::Qumulo::Rest::V1

  # class FilesCreate < Qumulo::Rest::Base
  #   uri_spec '/v1/conf/files/:ref/entries/'
  #   field :name, String
  #   field :action, String
  #   field :old_path, String
  #   field :ref, String
  #
  # end

  # == Class Description
  #
  #
  # == Supported Methods
  # DELETE
  #
  class Files < ::Qumulo::Rest::Base
    uri_spec '/v1/files/:ref'
    field :ref, String
    field :limit, Integer
    field :before, Integer
    field :after, Integer
  end

  class FilesAggregates < ::Qumulo::Rest::Base
    uri_spec '/v1/files/:ref/aggregates/'
    field :ref, String
    query_param 'max-entries'
    query_param 'order-by'
  end

  # == Class Description
  #
  #
  # == Supported Methods
  # GET, POST
  #
  class FilesEntries < ::Qumulo::Rest::Base
    uri_spec '/v1/files/:ref/entries/'
    field :ref, String

    # Get Fields
    field :limit, Integer
    field :before, Integer
    field :after, Integer
    query_param 'limit'

    # Post Fields
    field :name, String
    field :action, String
    field :old_path, String
  end

  class FilesFileAcl < ::Qumulo::Rest::Base
    uri_spec '/v1/files/:ref/info/acl'
    field :ref, String
  end

    class FilesData < ::Qumulo::Rest::Base
      uri_spec '/v1/files/:ref/data'
      field :ref, String
      field :body, String

      def put(request_opts = {})
        store_result(
            http(request_opts).
                put_raw(resolved_path,
                         @attrs['body'],
                         { :headers => { 'Content-Type' => 'application/octet-stream' } }
                )
        )
      end

  end

end
