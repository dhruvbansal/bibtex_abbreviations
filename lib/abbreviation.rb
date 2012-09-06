require 'set'

class Abbreviation

  def self.stop_words
    @stop_words ||= Set.new(%w[of and a in on an it])
  end

  attr_accessor :long, :symbol
  
  attr_reader :short
  def short= string
    return unless string
    @short = string.split.map do |word|
      case
      when word.size > 1  && word =~ /\.$/ then word                # Proc.
      when word.size > 1  && word !~ /\.$/ then word + '.'          # Proc
      when word.size == 1 && word =~ /\.$/ then word.gsub(/\.$/,'') # B.
      when word.size == 1 && word !~ /\.$/ then word                # B
      end
    end.compact.join(' ')
  end

  def initialize hsh_or_array
    if hsh_or_array.is_a?(Hash)
      self.long   = hsh_or_array[:long]
      self.short  = hsh_or_array[:short]
      self.symbol = hsh_or_array[:symbol]
    else
      self.long   = hsh_or_array.shift
      self.short  = hsh_or_array.shift
      self.symbol = hsh_or_array.shift
    end
  end

  def to_tsv
    [symbol, short, long].map(&:to_s).join("\t")
  end

  def to_hash
    {}.tap do |h|
      h[:long]   = long   if long
      h[:short]  = short  if short
      h[:symbol] = symbol if symbol
    end
  end

  def generate_symbol
    (long || short).split.map do |word|
      word.first.upcase unless self.class.stop_words.include?(word)
    end.compact.join
  end

  def to_long
    %Q{@string(#{symbol} = "#{long}")}
  end

  def to_short
    %Q{@string(#{symbol} = "#{short}")}
  end
  
end
