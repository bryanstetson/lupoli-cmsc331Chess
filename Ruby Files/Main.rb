require 'rubygems'
require 'wx'
require 'Board'
require 'Coord'
include Wx

class Main < App
  
  attr_accessor :board, :chess
  
  def test()
      @board = Board.new
      
      self.print
      for i in 0..7
        self.select(1, i)
        self.select(6, i)
        self.print
      end
    end
  
  def on_init()
    @board = Board.new
    test = Frame.new(nil, -1, "Test")
    StaticText.new(test, -1, "test")
    test.show
  end
  
  def print
    @board.print
  end
  
  def select(r, c)
    moves = @board.getPieceMoves(r, c)
    @board.move(r, c, moves[1])
  end
end

Main.new.main_loop

#test = Main.test
