module Ubiquity::Qumulo::Rest::V1

  # == Class Description
  #
  #
  # == Supported Methods
  # GET, REPLACE, PATCH
  class FileResource < ::Qumulo::Rest::Base
    uri_spec '/v1/fs/file/:id/attributes'
    field :ref, String
  end

end
