module Ghost
  class Cli
    class Task
      attr_accessor :out

      def initialize(out)
        self.out = out
      end

      def perform(*); end
      def description; end
      def help; end

      private

      def puts(*args)
        out.puts(*args)
      end

      def print(*args)
        out.print(*args)
      end
    end

    def tasks
      @tasks ||= Hash[self.class.tasks.map { |name, task| [name, task.new(out)] }]
    end

    class << self
      def task(name, desc = nil, &block)
        tasks[name] = Class.new(Task, &block)
        tasks[name]
      end

      def tasks
        @tasks ||= {}
      end
    end
  end
end

Dir[File.dirname(__FILE__) + "/task/*.rb"].each { |f| require(f) }
