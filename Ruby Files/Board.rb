require 'Coord'
require 'Piece'
require 'King'
require 'Queen'
require 'Bishop'
require 'Rook'
require 'Knight'
require 'Pawn'

class Board
  WHITE = 1
  BLACK = 0
  
  attr :board, :row0, :row1, :row2, :row3, :row4, :row5, :row6, :row7, :previous, :wKing, :bKing
  
  def initialize()
    @previous = nil
    
    @row0 = Array.new(8, nil)
    @row1 = Array.new(8, nil)
    @row2 = Array.new(8, nil)
    @row3 = Array.new(8, nil)
    @row4 = Array.new(8, nil)
    @row5 = Array.new(8, nil)
    @row6 = Array.new(8, nil)
    @row7 = Array.new(8, nil)
    
    @row0[0], @row0[7] = Rook.new(WHITE, 0, 0), Rook.new(WHITE, 0, 7)
    @row7[0], @row7[7] = Rook.new(BLACK, 7, 0), Rook.new(BLACK, 7, 7)
    
    @row0[1], @row0[6] = Knight.new(WHITE, 0, 1), Knight.new(WHITE, 0, 6)
    @row7[1], @row7[6] = Knight.new(BLACK, 7, 1), Knight.new(BLACK, 7, 6)
    
    @row0[2], @row0[5] = Bishop.new(WHITE, 0, 2), Bishop.new(WHITE, 0, 5)
    @row7[2], @row7[5] = Bishop.new(BLACK, 7, 2), Bishop.new(BLACK, 7, 5)
    
    @row0[3], @row7[3] = Queen.new(WHITE, 0, 3), Queen.new(BLACK, 7, 3)
    @row0[4], @row7[4] = King.new(WHITE, 0, 4), King.new(BLACK, 7, 4)
    
    for i in 0..7
      @row1[i] = Pawn.new(WHITE, 1, i)
      @row6[i] = Pawn.new(BLACK, 6, i)
    end
    
    @board = [@row0, @row1, @row2, @row3, @row4, @row5, @row6, @row7]
    @wKing = @board[0][4]
    @bKing = @board[7][4]
  end
  
  def move(r, c, pos)
    @board[pos.row][pos.col] = @board[r][c]
    @board[pos.row][pos.col].move(pos)
    @previous = @board[pos.row][pos.col]
    @board[r][c] = nil
  end
  
  def print
    s = "BOARD BEGIN \n"
    for row in @board
      for p in row
        s += " | " + p.to_s.ljust(12)
      end
      
      s += " |\n"
    end
    
    puts s + "BOARD END"
  end
  
  def getPieceMoves(r, c)
    if @board[r][c] != nil
      piece = @board[r][c]
      moves = Array.new
      
      if piece.diagonal
        moves += getDiagonal(piece)
      end
        
      if piece.linear
        moves += getLinear(piece)
      end
      
      if piece.special
        moves = getSpecial(piece)
      end
      
      moves
    end
  end
  
  def getDiagonal(piece)
    diagonals = Array.new
    center = piece.pos
    
    pos = center.rightUp
    if pos != nil
      space = @board[pos.row][pos.col]
      while (space == nil or space.color != piece.color) and pos != nil
        pos = pos.rightUp
        space = @board[pos.row][pos.col]
        diagonals.insert(pos)
      end
    end
    
    pos = center.leftUp
    if pos != nil
      space = @board[pos.row][pos.col]
      while (space == nil or space.color != piece.color) and pos != nil
        pos = pos.leftUp
        space = @board[pos.row][pos.col]
        diagonals.insert(pos)
      end
    end
    
    pos = center.rightDown
    if pos != nil
      space = @board[pos.row][pos.col]
      while (space == nil or space.color != piece.color) and pos != nil
        pos = pos.rightDown
        space = @board[pos.row][pos.col]
        diagonals.insert(pos)
      end
    end
    
    pos = center.leftDown
    if pos != nil
      space = @board[pos.row][pos.col]
      while (space == nil or space.color != piece.color) and pos != nil
        pos = pos.leftDown
        space = @board[pos.row][pos.col]
        diagonals.insert(pos)
      end
    end
    
    diagonals
  end
  
  def getLinear(piece)
    lines = Array.new
    center = piece.pos
    
    pos = center.up
    if pos != nil
      space = @board[pos.row][pos.col]
      while (space == nil or space.color != piece.color) and pos != nil
        pos = pos.up
        space = @board[pos.row][pos.col]
        lines.insert(pos)
      end
    end
    
    pos = center.down
    if pos != nil
      space = @board[pos.row][pos.col]
      while (space == nil or space.color != piece.color) and pos != nil
        pos = pos.down
        space = @board[pos.row][pos.col]
        lines.insert(pos)
      end
    end
    
    pos = center.right
    if pos != nil
      space = @board[pos.row][pos.col]
      while (space == nil or space.color != piece.color) and pos != nil
        pos = pos.right
        space = @board[pos.row][pos.col]
        lines.insert(pos)
      end
    end
    
    pos = center.left
    if pos != nil
      space = @board[pos.row][pos.col]
      while (space == nil or space.color != piece.color) and pos != nil
        pos = pos.left
        space = @board[pos.row][pos.col]
        lines.insert(pos)
      end
    end
    
    lines
  end
  
  def pawn(piece)
    moves = piece.getSpecialMoves()
    
    lcorner = moves[1]
    rcorner = moves[2]
    
    if lcorner == nil or @board[lcorner.row][lcorner.col] == nil
      moves.delete(lcorner)
    end
    
    if rcorner == nil or @board[rcorner.row][rcorner.col] == nil
      moves.delete(rcorner)
    end
    
    moves
  end
  
  def getSpecial(piece)
    moves = Array
    if(piece.class == Pawn)
      moves = pawn(piece)
    else
      moves = piece.getSpecialMoves
      
      for pos in moves
        if pos == nil or (@board[pos.row][pos.col] != nil and @board[pos.row][pos.col].color == piece.color)
          moves.delete(pos)
        end
      end
    end
    
    moves
  end
  
end

#test = Board.new
#moves = test.getPieceMoves(1, 7)
#for m in moves
#  puts m
#end