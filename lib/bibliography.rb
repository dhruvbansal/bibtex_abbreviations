require 'set'

class Bibliography

  def load parser
    parser.parse do |abbreviation|
      add(abbreviation)
    end
  end

  def new?(abbreviation)
    return false if abbreviation.symbol.nil? || abbreviation.symbol.empty?
    return false if symbols.include?(abbreviation.symbol)
    return false if abbreviation.long.nil? || abbreviation.long.empty?
    return false if longs.include?(abbreviation.long)
    true
  end

  def symbols
    @symbols ||= Set.new
  end

  def longs
    @longs ||= Set.new
  end
  
  def abbreviations
    @abbreviations ||= {}
  end

  def new_best_symbol_for abbreviation, counter=0
    symbol = abbreviation.symbol
    symbol = abbreviation.generate_symbol if symbol.nil? || symbol.empty?
    symbol = symbol + counter.to_s(16)    if counter > 0

    if symbols.include?(symbol)
      new_best_symbol_for(abbreviation, counter + 1)
    else
      symbol
    end
  end
  
  def add abbreviation
    return unless new?(abbreviation)
    symbol = new_best_symbol_for(abbreviation)
    symbols.add(symbols)
    longs.add(abbreviation.long)
    abbreviations[symbol] = abbreviation
  end

end
