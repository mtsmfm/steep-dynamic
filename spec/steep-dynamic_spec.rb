RSpec.describe Steep::Dynamic do
  around do |ex|
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        ex.run
      end
    end
  end

  def run_steep_check
    stdout = StringIO.new
    stderr = StringIO.new
    stdin = StringIO.new

    exit_status = Steep::CLI.new(argv: %w(check), stdout: stdout, stderr: stderr, stdin: stdin).run

    stdout.rewind
    stderr.rewind

    [stdout.read, stderr.read, exit_status]
  end

  describe "attr_reader" do
    it "passes steep check without dynamic annotation" do
      File.write("Steepfile", <<~STR)
        require "steep-dynamic"

        target :lib do
          signature "sig"
          check "lib"
        end
      STR

      FileUtils.mkdir("sig")
      File.write("sig/app.rbs", <<~STR)
        class Foo
          attr_reader foo: String
        end
      STR

      FileUtils.mkdir("lib")
      File.write("lib/app.rb", <<~STR)
        class Foo
          attr_reader :foo
        end
      STR

      stdout, stderr, exit_status = run_steep_check

      aggregate_failures do
        expect(stdout).to eq ""
        expect(stderr).to eq ""
        expect(exit_status).to eq 0
      end
    end
  end

  describe "attr_writer" do
    it "passes steep check without dynamic annotation" do
      File.write("Steepfile", <<~STR)
        require "steep-dynamic"

        target :lib do
          signature "sig"
          check "lib"
        end
      STR

      FileUtils.mkdir("sig")
      File.write("sig/app.rbs", <<~STR)
        class Foo
          attr_writer foo: String
        end
      STR

      FileUtils.mkdir("lib")
      File.write("lib/app.rb", <<~STR)
        class Foo
          attr_writer :foo
        end
      STR

      stdout, stderr, exit_status = run_steep_check

      aggregate_failures do
        expect(stdout).to eq ""
        expect(stderr).to eq ""
        expect(exit_status).to eq 0
      end
    end
  end

  describe "attr_accessor" do
    it "passes steep check without dynamic annotation" do
      File.write("Steepfile", <<~STR)
        require "steep-dynamic"

        target :lib do
          signature "sig"
          check "lib"
        end
      STR

      FileUtils.mkdir("sig")
      File.write("sig/app.rbs", <<~STR)
        class Foo
          attr_writer foo: String
        end
      STR

      FileUtils.mkdir("lib")
      File.write("lib/app.rb", <<~STR)
        class Foo
          attr_accessor :foo
        end
      STR

      stdout, stderr, exit_status = run_steep_check

      aggregate_failures do
        expect(stdout).to eq ""
        expect(stderr).to eq ""
        expect(exit_status).to eq 0
      end
    end
  end
end
