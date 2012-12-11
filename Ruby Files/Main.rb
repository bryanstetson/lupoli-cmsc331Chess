require 'rubygems'
require 'wx'
require_relative  'Board'
require_relative  'Coord'
require_relative 'BoardGUI'
#include Wx

class Main < Wx::App
  
   attr_accessor :board
   
   def on_init()
      BoardGUI.new(Wx::Frame.new(nil, :title => 'frame')).show
      Login.new(Wx::Frame.new(nil, :title => 'frame')).show
   end
   
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
   end
  
   def print
      @board.print
   end
  
   def select(r, c)
      moves = @board.getPieceMoves(r, c)
      puts moves
   end
end

Main.new.main_loop

