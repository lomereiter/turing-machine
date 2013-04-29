require 'set'

class TuringMachine
  def initialize
    @rules = {}
    @shortcuts = {}
    @empty_char = '~'
    @verbose = false
  end

  attr_accessor :empty_char, :verbose

  def add_shortcut(shortcut)
    symbol = shortcut.symbol
    if @shortcuts.has_key? symbol
      raise "Symbol #{symbol} is already used as a shortcut for #{@shortcuts[symbol]}"
    elsif shortcut.pattern.any? {|c| @shortcuts.has_key? c }
      s = shortcut.pattern.find {|c| @shortcuts.has_key? c }
      raise "Can't add shortcut #{symbol} because it includes another shortcut #{s}"
    end
    @shortcuts[symbol] = shortcut.pattern
  end

  def add_rule(rule)
    state = rule.from_state
    symbol = rule.from_symbol
    @rules[state] ||= {}
    if @rules[state].has_key? symbol
      raise "Rule for state #{state} and symbol #{symbol} already exists"
    else
      @rules[state][symbol] = rule
    end
  end

  def remove_rule(state, symbol)
    return unless @rules.has_key? symbol
    @rules[state].remove symbol
  end
  
  def load_from_file(filename)
    line_num = 0
    alphabet = Set.new
    shortcuts = Set.new
    File.readlines(filename).each do |line|
      line_num += 1
      line = line.strip
      next if line.empty?
      next if line =~ /^\s*#/
      if line =~ /^\s*([^\s])\s*=\s*(.*)/ then
        pattern = eval($2)
        alphabet += pattern
        if pattern.index $1
          raise "Shortcut at line #{line_num} references itself"
        elsif alphabet.include? $1
          raise "Name for shortcut at line #{line_num} already appeared in alphabet"
        end
        shortcuts += [$1]
        add_shortcut Shortcut.new($1, eval($2))
      elsif line =~ /^\s*(\d)\s*([^\s])\s*-\s*(\d)\s*([^\s])\s*([<>.])/
        rule = Rule.new($1.to_i, $2, $3.to_i, $4, $5)
        if shortcuts.include? $4 and $2 != $4
          raise "Invalid use of shortcut #{$4} in rule #{rule} at line #{line_num}"
        end
        add_rule rule
      elsif line =~ /^\s*set\s+([_\w]+)\s*=\s*(.*)/
        # TODO: check $1
        eval "@#{$1} = #{$2}"
      else
        raise "Invalid line #{line_num}: #{line}"
      end
    end
  end

  def run_on(tape, options={})
    position = 0
    state = 0
    loop do
      puts "State: #{state}, Position: #{position}, Tape: #{tape}" if @verbose
      c = tape[position] || @empty_char
      c = @empty_char if position < 0
      rules = possible_rules state, c
      if rules.empty?
        puts "No applicable rule found, exit." if @verbose
        break
      end
      if rules.length >= 2 then
        patterns = rules.map {|r| @shortcuts[r.from_symbol] || r.from_symbol }
        raise "Ambiguous rules: #{rules} (#{patterns.join(', ')})"
      end
      rule = rules[0]
      tape[position] = rule.to_symbol unless rule.keeps_character?
      state = rule.to_state
      position += 1 if rule.action == '>'
      position -= 1 if rule.action == '<'
      puts "Applied rule: #{rule}" if @verbose
    end
    tape
  end

  private
  def possible_rules(state, c)
    return [] unless @rules.has_key? state
    rs = []
    rs << @rules[state][c] if @rules[state].has_key?(c)
    @shortcuts.each do |symbol, characters|
      if characters.index c and @rules[state].has_key? symbol
        rs << @rules[state][symbol]
      end
    end
    rs
  end
end
