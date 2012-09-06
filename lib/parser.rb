require_relative("abbreviation")

class Parser

  attr_accessor :path, :options

  def initialize path, options={}
    self.path    = path
    self.options = options
  end

  def file
    @file ||= File.open(path)
  end

  def parse_line line
    Abbreviation.new(line.tr(options.fetch(:strip, ''),'').split(options.fetch(:split, /\s*=\s*/)))
  end

  def error e, line, num
    $stderr.puts "ERROR (#{path}:#{num}): #{e.class} -- #{e.message}"
    $stderr.puts line
  end

  def parse &block
    line_num = 0
    file.each_line do |line|
      line_num += 1
      next if line.strip.empty?
      next if line[0] == '#'
      begin
        abbreviation = parse_line(line.chomp)# rescue nil
      rescue => e
        error(e, line, line_num)
      end
      yield abbreviation if abbreviation
      # break if line_num > 20 
    end
  end

  def print
    parse do |abbreviation|
      puts abbreviation.to_tsv
    end
  end

  class BibTeX < self

    def initialize type, path, options={}
      super(path, options)
      @type = type
    end
    
    def parse_line line
      args = {}
      args[:symbol] = $1 if line =~ Regexp.new("^@string\\((.*) *=", true)
      args[@type]   = $1 if line =~ Regexp.new("= *\"(.*)\"\\)\s*$",  true)
      Abbreviation.new(args)
    end
  end

  class JabRef < self
    def parse_line line
      return if line =~ /^#/
      long_and_short, symbol, whatever = line.split(';')
      long, short = long_and_short.split('=')
      Abbreviation.new([long, short, symbol])
    end
  end

end
