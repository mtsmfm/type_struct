class TypeStruct
  UnionNotFoundError = Class.new(StandardError)

  class MultiTypeError < StandardError
    THIS_LIB_REGEXP = %r{lib/type_struct[./]}
    PWD = Pathname.new(Dir.pwd)
    attr_reader :errors
    def initialize(errors)
      @errors = errors
      super("\n#{build_message}")
    end

    private

    def build_message
      @errors.map { |e|
        b = e.backtrace_locations.find do |b|
          b.absolute_path !~ THIS_LIB_REGEXP
        end
        relative_path = Pathname.new(b.absolute_path).relative_path_from(PWD)
        "#{relative_path}:#{b.lineno}:in #{e.class} #{e}"
      }.join("\n")
    end
  end
end
