
# Custom resource based on the InSpec resource DSL
class JavaInfo < Inspec.resource(1)
  name 'java_info'

  desc "java verification class"

  example "java verification class"

  def initialize(path=nil)
    @path ||= path
    @result = which_java
    if @path
      @file = inspec.file(@path)
      @result = bulk_java_min_version(@path)
      return skip_resource "Can't find file \"#{@path}\"" if !@file.directory?
    end
  end

  def exists?
    return @result.exit_status.to_i==0
  end

  def location
    return @result.
        stdout.
        to_s.
        chomp.
        gsub('java is','')
  end

  def java_home
    return false if inspec.os[:family].to_s == 'unknown'

    if inspec.os.linux? | inspec.os.unix?
      res = inspec.backend.run_command("echo $JAVA_HOME")
    elsif inspec.os.windows?
      res = inspec.backend.run_command("echo %JAVA_HOME%")
    else
      warn "java is not found on your OS: #{inspec.os[:family]}"
      return false
    end
    return res.
        stdout.
        to_s.
        chomp
  end

  def release
    return bulk_java_min_version(@path).
        stderr.
        to_s.
        split("\n").
        first.
        gsub('java version','').
        delete("\\\"")
  end

  def version
    return bulk_java_min_version(@path).
        stderr.
        to_s.
        split("\n").
        first.
        gsub('java version','').
        delete("\\\"").
        to_s.
        scan(/\d\.\d/).
        first
  end

  private
  def which_java
    return false if inspec.os[:family].to_s == 'unknown'

    if inspec.os.linux?
      res = inspec.backend.run_command("bash -c 'type \"java\"'")
    elsif inspec.os.windows?
      res = inspec.backend.run_command("where.exe \"java\"")
    elsif inspec.os.unix?
      res = inspec.backend.run_command("type \"java\"")
    else
      warn "java is not found on your OS: #{inspec.os[:family]}"
      return false
    end
    return res
  end

  def bulk_java_min_version(path)
    if !path.nil? && File.exist?(path)
      res ||= inspec.backend.run_command("#{path}/bin/java -version")
    else
      res ||= inspec.backend.run_command('java -version')
    end
    return res
  end
end
