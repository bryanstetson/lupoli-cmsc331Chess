require 'rubygems'
require 'wx'
require 'Board'
require 'Coord'
include Wx

class Main < App
  
  attr_accessor :board, :chess
  
  def test()
      self.print
      for i in 0..7
        self.select(1, i)
        self.select(6, i)
        self.select(3, i)
        self.select(4, i)
        self.print
      end
      
      self.select(0, 4)
      self.print
      puts @board.wKing().pos
    end
  
  def on_init()
    @board = Board.new
    test = Frame.new(nil, -1, "Test")
    StaticText.new(test, -1, "test")
    test.show
    self.test
  end
  
  def print
    @board.print
  end
  
  def select(r, c)
    moves = @board.getPieceMoves(r, c)
    puts moves
  end
end

#Main.new.main_loop