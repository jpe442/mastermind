class Code
  attr_reader :pegs
    
  PEGS = {r: "red", g: "green", b: "blue",y: "yellow", o: "orange", p: "purple"}

  def self.parse(guess)
    # take a string and parse into a code or candidate
    by_color = guess.downcase.split("")
    pegs = by_color.map do |ch|
      sym = ch.to_sym
      unless !PEGS.keys.include?(sym)
        ch.to_sym
      else
        raise "Invalid color: #{ch}, included in code..."
      end
    end
    Code.new(pegs)
  end
    
  def self.random
  # this generates a 4-digit code at random from PEGS
    pegs = PEGS.keys.shuffle.take(4)
  # this creates a new code object based upon the random peg combo
    Code.new(pegs)

  end
    
  def initialize(pegs)
    @pegs = pegs
  end
    
  def exact_matches(code)
    count = 0
    self.pegs.each_index do |i|
      count += 1 if self[i] == code[i]
    end
      
    count
        
  end

  def near_matches(code)
    count = 0
    counted = []
    self.pegs.each_index do |i|
      code.pegs.each_index do |i2|
        unless counted.include?(i)
          if self[i] == code[i2]
            count += 1 unless i == i2
            counted << i
          end
        end
      end
    end
    
    count
  end

  def ==(guess)
    return false unless guess.class == Code
    if self.pegs == guess.pegs
      return true
    else 
      return false 
    end
    
  end

  def [](i)
    pegs[i]
  end
      

    
end

class Game
  attr_reader :secret_code
  
  def initialize(secret_code=Code.random)
  # this needs at least a code argument to begin unless generating at random
    @secret_code = secret_code
  end

  def get_guess
    begin 
      puts "Please enter a code..."
      guess = $stdin.gets.chomp.strip
      Code.parse(guess)
    rescue
      puts "Please retry..."
      retry
    end
  end

  def display_matches(code)
    puts "exact Matches: #{@secret_code.exact_matches(code)}".strip
    puts "near Matches: #{@secret_code.near_matches(code)}".strip
  end
  
  def play
  # this loops on get_guess until 10 rounds or until code is guessed
    count = 0
    until count == 10
      puts "Guesses Used: #{count}"
      count += 1
      break if count == 10
      guess = get_guess
      display_matches(guess)
      break if self.secret_code.==(guess)
    end
    
    if count >= 10
      puts "Guesses Used: #{count}"
      puts "You ran out of guesses! Game Over..."
    else
      puts "Congratulations you guessed the secret code in #{count} guesses!"
    end
  end
    
end


new_game = Game.new
new_game.play
