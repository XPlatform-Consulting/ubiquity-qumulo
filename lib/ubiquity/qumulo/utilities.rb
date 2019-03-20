require 'ubiquity/qumulo/client'
require 'ubiquity/qumulo/helpers/find_changed_files'

module Ubiquity
  module Qumulo
    class Utilities < Client

      def initialize(args = { })
        super
      end

      def acl_get(args = { })
        api::FilesFileAcl.get(args)
      end

      def acl_set(args = { })
        api::FilesFileAcl.put(args)
      end

      def files_directory_entries_list(args)
        api::FilesEntries.get(args)
      end

      # @param [Hash] args
      # @option args [String] :ref File ID or absolute path
      # @option args [String] :name Name of the object to create
      # @option args [String] :action Operation to perform
      #   1 - CREATE_FILE
      #   2 - CREATE_DIRECTORY
      #   3 - CREATE_SYMLINK
      #   4 - CREATE_LINK
      #   5 - RENAME
      # @option args [String] :old_path Rename source or link target
      # @return [FilesEntries]
      def files_object_create(args = { })
        # Qumulo::Rest::V1::FilesEntries.post(:ref => '/', :name => 'test.txt', :action => 'CREATE_FILE')
        api::FilesEntries.post(args)
      end
      alias :file_create :files_object_create
      alias :directory_create :files_object_create
      alias :link_create :files_object_create

      def files_object_delete(args = { })
        api::Files.delete(args)
      end

      def get_changed_files(args = { })
        Helpers::FindChangedFilesHelper.new(args).find_changed_files
      end

      def get_changed_files_extended(args = { })
        Helpers::FindChangedFilesHelper.run(args).to_hash
      end

    end
  end
end
