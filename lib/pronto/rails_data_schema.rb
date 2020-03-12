require 'pronto'

module Pronto
  class RailsDataSchema < Runner
    def run
      return [] unless migration_patches.any?

      if schema_file_present?
        schema_patch = @patches.find { |patch| detect_schema_file(patch.new_file_full_path) }
        return generate_messages_for('data_schema.rb') unless changes_detected?(schema_patch)
      end

      []
    end

    private

    def schema_file_present?
      File.exist?('db/data_schema.rb')
    end

    def migration_patches
      return [] unless @patches
      @migration_patches ||= @patches
        .select { |patch| detect_added_migration_file(patch) }
    end

    def generate_messages_for(target)
      migration_patches.map do |patch|
        first_line = patch.added_lines.first
        Message.new(patch.delta.new_file[:path], first_line, :warning,
                  "Data migration file detected, but no changes in #{target}",
          nil, self.class)
      end
    end

    def detect_added_migration_file(patch)
      return unless patch.delta.added?
      /(.*)db[\\|\/]data[\\|\/](\d{14}_([_A-Za-z]+)\.rb)$/i =~
        patch.delta.new_file[:path]
    end

    def detect_schema_file(path)
      /db[\\|\/]data_schema.rb/i =~ path.to_s
    end

    def changes_detected?(patch)
      patch && (patch.additions > 0 || patch.deletions > 0)
    end
  end
end
