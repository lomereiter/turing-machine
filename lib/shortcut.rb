class Shortcut
  attr_reader :symbol, :pattern
  def initialize(symbol, pattern)
    @symbol = symbol
    @pattern = pattern
    if @pattern.class == String then
      @pattern = @pattern.chars.to_a
    end
    # TODO: check that pattern doesn't include symbol itself
  end

  def to_s
    @pattern.to_s
  end
end
