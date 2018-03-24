require 'thor'
require 'fileutils'

class Poach < Thor
  desc 'OPTIONS', 'Make executable jar from current directory'
  option :name,
    :default => 'app',
    :desc => 'The desired name of the jar. (Eg: "my_app" will generate my_app.jar)'
  def make()
    nashorn_main_jar = File.dirname(__FILE__) + "/../resources/nashorn-main.jar"
    application_jars = Dir.glob 'jars/**/*.jar'
    application_contents = Dir.glob("**/*").reject do |f|
      f =~ %r[dist/|jars/] || !(File.file? f) || File.basename(f) =~ /\.(coffee|java)$/
    end

    # Recreate dist/ folder
    FileUtils.rm_rf "dist"
    Dir.mkdir "dist"

    # Copy all jars into dist/
    jars = application_jars + [nashorn_main_jar]
    jars.each do |jar|
      FileUtils.cp jar, "dist/#{File.basename jar}"
    end

    # Extract and remove all jars
    Dir.chdir "dist" do
      Dir.entries(".").reject{|d| d =~ /^(\.\.?)$/}.each do |jar|
        `jar xf #{jar}`
        FileUtils.rm_rf "./#{jar}"
      end
    end

    # Copy all application contents into dist/
    application_contents.each do |file|
      FileUtils.mkdir_p "dist/#{File.dirname file}"
      FileUtils.cp file, "dist/#{file}"
    end

    # Create jar
    Dir.chdir "dist" do
      `jar cfe #{options[:name]}.jar com.github.jbreeden.NashornMain .`
      Dir.entries(".").reject{|f| f =~ /#{options[:name]}.jar|^(\.\.?)$/}.each do |f|
        FileUtils.rm_rf f
      end
    end
  end

  desc 'extract app.jar regex', 'extract all files from jar matching the regex'
  def extract(jar, regex)
    contents = `jar tf #{jar}`
    scripts = contents.each_line.grep(Regexp.new(regex)).map { |l| l.strip }
    scripts.each do |script|
      puts "Running: " + "jar xf #{jar} #{script}"
      system "jar xf #{jar} #{script}"
    end
  end

  desc 'update app.jar glob', 'update jar with all files matching the glob'
  def update(jar, glob)
    contents = `jar tf #{jar}`
    files = Dir[glob]
    files.each do |file|
      puts "Running: " + "jar uf #{jar} #{file}"
      system "jar uf #{jar} #{file}"
    end
  end

  default_task :make
end
