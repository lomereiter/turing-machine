class Rule
  attr_reader :from_state, :from_symbol, :to_state, :to_symbol, :action

  def initialize(from_state, from_symbol, to_state, to_symbol, action)
    @from_state = from_state
    @from_symbol = from_symbol
    @to_state = to_state
    @to_symbol = to_symbol
    @action = action
  end

  def keeps_character?
    @to_symbol == @from_symbol
  end

  def to_s
    "#{@from_state} #{@from_symbol} - #{@to_state} #{@to_symbol} #{@action}"
  end
end
