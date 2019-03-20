module Ubiquity::Qumulo::Helpers

  class FindChangedFilesHelper

    attr_accessor :changed_files, :changed_since, :max_change_time

    # @param [Hash] args
    # @option args [String] :path

    # @option args [String|Time] :changed_since
    def initialize(args = { })
      earliest_time = Time.at(0)

      @aggregates_get_method = args[:get_method] || self.method(:files_aggregates_get)
      @path = args[:path] || args[:ref] || '/'
      @recursive = args.fetch(:recursive, true)
      @add_full_file_path = args.fetch(:add_full_file_path, true)
      _changed_since = args[:changed_since] || earliest_time

      @changed_files = [ ]
      @changed_since = _changed_since.is_a?(Time) ? _changed_since : Time.parse(_changed_since)
      @max_change_time = earliest_time
      @newest_file = nil
    end

    def files_aggregates_get(args = { })
      response = Ubiquity::Qumulo::Rest::V1::FilesAggregates.get(args)
      response.attrs['files']
    end

    def process_file(file, parent_path = nil)
      file['full_path'] = File.join(parent_path, file['name']) if parent_path

      max_changed_time = file['max_change_time']
      max_change_time_as_time = Time.parse(max_changed_time)

      is_newest_file = (max_change_time_as_time > @max_change_time)
      if is_newest_file
        @max_change_time = max_change_time_as_time
        @newest_file = file
      end

      is_changed_file = (max_change_time_as_time > @changed_since)
      # puts "(#{is_changed_file}) #{max_change_time_as_time} > #{changed_since}"
      @changed_files << file if is_changed_file
    end

    def find_changed_files(path = @path, options = { })
      recursive = options.fetch(:recursive, @recursive)
      parent_path = options.fetch(:add_full_file_path, @add_full_file_path) ? path : nil

      directories = []

      nodes = @aggregates_get_method.call(:ref => path)
      nodes.each do |n|
        case n['type']
          when 'FS_FILE_TYPE_DIRECTORY'
            directories << n
          else
            process_file(n, parent_path)
        end
      end

      directories.each do |directory|
        child_directory_path = File.join(path, directory['name'])
        find_changed_files(child_directory_path, options)
      end if recursive

      @changed_files
    end

    def self.run(args = { })
      self.new(args).run
    end

    def run
      find_changed_files
      self
    end

    def max_change_time
      @max_change_time.strftime("%Y-%m-%dT%H:%M:%S.#{@max_change_time.usec}Z")
    end

    def to_hash
      { :changed_files => @changed_files, :max_change_time => max_change_time, :newest_file => @newest_file }
    end

  end

end
