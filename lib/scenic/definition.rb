module Scenic
  # @api private
  class Definition
    def initialize(name, version)
      @name = name
      @version = version.to_i
    end

    def to_sql
      File.read(full_path).tap do |content|
        if content.empty?
          raise "Define view query in #{path} before migrating."
        end
      end
    end

    def full_path
      full_path = Rails.application.paths["db/migrate"].expanded.map { |p| p.gsub(/migrate$/, "views") }.find do |path|
        File.exists?(Pathname.new(path).join(filename))
      end

      raise "Define view query in #{path} before migrating." if full_path.nil?

      Pathname.new(full_path).join(filename)
    end

    def path
      File.join("db", "views", filename)
    end

    def version
      @version.to_s.rjust(2, "0")
    end

    private

    def filename
      "#{@name}_v#{version}.sql"
    end
  end
end
