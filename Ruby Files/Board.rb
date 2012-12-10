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
  
  @row0
  @row1
  @row2
  @row3
  @row4
  @row5
  @row6
  @row7
  
  @blocks
  @previous
  @validBlack
  @validWhite
  
  attr :board, :white, :black, :wKing, :bKing
  
  #Initialize board with starting piece positions (White from row0, Black from row7)
  def initialize()
    @previous = nil
    @white = Array.allocate()
    @black = Array.allocate()
    
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
    
    for i in 0..7
      @white << @row0[i]
      @white << @row1[i]
      @black << @row7[i]
      @black << @row6[i]
    end
  end
  
  #Move a piece at row r, column c to new position pos (Does not handle pre or post conditions)
  def move(r, c, pos)
    
    if @board[r][c].color == WHITE
      @black.delete(@board[pos.row][pos.col])
    else
      @white.delete(@board[pos.row][pos.col])
    end
    
    @board[pos.row][pos.col] = @board[r][c]
    @board[pos.row][pos.col].move(pos)
    @previous = @board[pos.row][pos.col]
    @board[r][c] = nil
    
    analyze()
  end
  
  #Determine if King is in checkmate
  def checkmate?(color)
    checkmate = false
    if color == WHITE
      if @wKing.inCheck
        checkmate = stalemate?(WHITE)
      end
    else
      if @bKing.inCheck 
        checkmate = stalemate?(BLACK)
      end
    end
    
    checkmate
  end
  
  #Determine if the any valid moves remain
  def stalemate?(color)
    stalemate = true
    valid = nil
    king = nil
    
    if color == WHITE
      valid = @validWhite
      king = @wKing
    else
      valid = @validBlack
      king = @bKing
    end
    
    if valid != nil
      for pos in valid
        if pos != nil
          stalemate = false
        end
      end
    end
    
    kingMoves = validKingMoves(king)
    for pos in kingMoves
      if pos != nil
        stalemate = false
      end
    end
    
    stalemate
  end
  
  #Analyze the board for check or checkmate conditions
  def analyze()
    threats = Array.allocate()
    temp = Array.allocate()
    valid = Array.allocate()
    
    checkList = nil
    col = nil
    oppCol = nil
    king = nil
    kPos = nil
    
    if @previous.color == WHITE
      col = @white
      oppCol = @black
      king = @bKing
      kPos = @bKing.pos
      checkList = @validBlack
    else
      col = @black
      oppCol = @white
      king = @wKing
      kPos = @wKing.pos
      checkList = @validWhite
    end
    
    for p in col
      check = getMoves(p).include?(kPos)
      if check
        temp = [p.pos]
        
        if p.linear
          if upSpaces(p).include?(kPos)
            temp << upSpaces(p)
          elsif leftSpaces(p).include?(kPos)
            temp << leftSpaces(p)
          elsif rightSpaces(p).include?(kPos)
            temp << rightSpaces(p)
          elsif downSpaces(p).include?(kPos)
            temp << downSpaces(p)
          end
        end
        
        if p.diagonal
          if leftUpSpaces(p).include?(kPos)
            temp << leftUpSpaces(p)
          elsif leftDownSpaces(p).include?(kPos)
            temp << leftDownSpaces(p)
          elsif rightUpSpaces(p).include?(kPos)
            temp << rightUpSpaces(p)
          elsif rightDownSpaces(p).include?(kPos)
            temp << rightDownSpaces(p)
          end
        end
        
        temp = threats - temp
        threats = threats - temp
         
        king.check
      end
    end
    
    for p in oppCol
      moves = getMoves(p)
      #Determine what valid moves exist for pieces
      if king.inCheck and p.class != King
        for m in moves
          if threats.include?(m)
            valid << m
          end
        end
        
      elsif p.class != King
        valid << moves
      end
    end
    
    checkList = valid
  end
  
  #Determine if pawn should be promoted
  def promote?
    promote = false
    if @previous.class == Pawn
      if @previous.color == WHITE
        if @previous.pos.row == 7
          promote = true
        end
      else
        if @previous.pos.row == 0
          promote = true
        end
      end
    end
    
    promote
  end
  
  
  #Promote pawn to new piece (Does not handle pre or post conditions
  def promote(pieceClass)
    prePos = @previous.pos
    col = @previous.color
    pList = nil
    
    if col == WHITE
      pList = @white
    else
      pList = @black
    end
    
    pList.delete(@previous)
    
    if pieceClass == 1
      @board[prePos.row][prePos.col] = Queen.new(col, prePos.row, prePos.col)
    elsif pieceClass == 2
      @board[prePos.row][prePos.col] = Rook.new(col, prePos.row, prePos.col)
    elsif pieceClass == 3
      @board[prePos.row][prePos.col] = Bishop.new(col, prePos.row, prePos.col)
    elsif pieceClass == 4
      @board[prePos.row][prePos.col] = Knight.new(col, prePos.row, prePos.col)
    end
    
    @previous = @board[prePos.row][prePos.col]
    pList << @previous
  end
  
  
  #Print board
  
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
  
  
  #Simulate a move to determine if valid
  
  def simulate(king, m)
    colorList = nil
    if king.color == WHITE
      colorList = @black
    else
      colorList = @white
    end
    
    invalid = false
    prev = @previous
    temp = @board[m.row][m.col]
    start = king.pos
    move(start.row, start.col, m)
    
    for p in colorList
      if getMoves(p).include?(king.pos)
        invalid = true
        puts p
      end
    end
    
    move(m.row, m.col, start)
    @board[m.row][m.col] = temp
    @previous = prev
    invalid
  end
  
  
  #Determine if a piece is blocking the King from check, return valid movement spaces
  def blockingCheck(piece, kPos)
    valid = Array.allocate()
    moves = Array.allocate()
    temp = getMoves(piece)
    
    if upSpaces(piece).include?(kPos)
      ePos = downSpaces(piece)[-1]
      if ePos != nil 
        enemy = @board[ePos.row][ePos.col]
        if enemy.color != piece.color and enemy.linear
          valid = upSpaces(piece) + downSpaces(piece)
        end
      end
      
    elsif downSpaces(piece).include?(kPos)
      ePos = upSpaces(piece)[-1]
      if ePos != nil 
        enemy = @board[ePos.row][ePos.col]
        if enemy.color != piece.color and enemy.linear
          valid = upSpaces(piece) + downSpaces(piece)
        end
      end
      
    elsif leftSpaces(piece).include?(kPos)
      ePos = rightSpaces(piece)[-1]
      if ePos != nil 
        enemy = @board[ePos.row][ePos.col]
        if enemy.color != piece.color and enemy.linear
          valid = leftSpaces(piece) + rightSpaces(piece)
        end
      end
      
    elsif rightSpaces(piece).include?(kPos)
      ePos = leftSpaces(piece)[-1]
      if ePos != nil 
        enemy = @board[ePos.row][ePos.col]
        if enemy.color != piece.color and enemy.linear
          valid = leftSpaces(piece) + rightSpaces(piece)
        end
      end
      
    elsif leftUpSpaces(piece).include?(kPos)
      ePos = rightDownSpaces(piece)[-1]
      if ePos != nil 
        enemy = @board[ePos.row][ePos.col]
        if enemy.color != piece.color and enemy.diagonal
          valid = leftUpSpaces(piece) + rightDownSpaces(piece)
        end
      end
      
    elsif leftDownSpaces(piece).include?(kPos)
      ePos = rightUpSpaces(piece)[-1]
      if ePos != nil 
        enemy = @board[ePos.row][ePos.col]
        if enemy.color != piece.color and enemy.diagonal
          valid = rightUpSpaces(piece) + leftDownSpaces(piece)
        end
      end
      
    elsif rightUpSpaces(piece).include?(kPos)
      ePos = leftDownSpaces(piece)[-1]
      if ePos != nil 
        enemy = @board[ePos.row][ePos.col]
        if enemy.color != piece.color and enemy.diagonal
          valid = rightUpSpaces(piece) + leftDownSpaces(piece)
        end
      end
      
    elsif rightDownSpaces(piece).include?(kPos)
      ePos = leftUpSpaces(piece)[-1]
      if ePos != nil 
        enemy = @board[ePos.row][ePos.col]
        if enemy.color != piece.color and enemy.diagonal
          valid = leftUpSpaces(piece) + rightDownSpaces(piece)
        end
      end
      
    else
      valid = getMoves(piece)
    end
    
    for m in temp
      if valid.include?(m)
        moves << m
      end
    end
    
    moves
  end
  
  #Get valid moves for a piece at row r, column c
  
  def getPieceMoves(r, c)
    moves = Array.allocate()
    king = nil
    kPos = nil
    checkList = nil
    
    piece = @board[r][c]
    
    if piece != nil
      
      if piece.color == WHITE
        king = @wKing
        kPos = @wKing.pos
        checkList = @validWhite
      elsif piece.color == BLACK
        king = @bKing
        kPos = @bKing.pos
        checkList = @validBlack
      end 
      
      if piece.class == King
        moves = validKingMoves(piece)
        
      else
        
        temp = blockingCheck(piece, kPos)
        
        if checkList != nil and king.inCheck
          for m in temp
            if checkList.include?(m)
              moves << m
            end
          end
        else
          moves = temp
        end
        
      end
      
    end
    
    moves
  end
  
  #Get all available moves based on piece movement type
  def getMoves(piece)
    moves = Array.allocate()
    
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
  
  
  #Get all open spaces above piece, until next piece or end of board
  
  def upSpaces(piece)
    lines = Array.allocate()
    pos = piece.pos.up
    space = nil
    
    while space == nil and pos != nil
      space = @board[pos.row][pos.col]
      if space == nil or space.color != piece.color
        lines  << pos
      end
      pos = pos.up
    end
    
    lines
  end
  
  
  #Get all open spaces below piece, until next piece or end of board
  
  def downSpaces(piece)
    lines = Array.allocate()
    pos = piece.pos.down
    space = nil
    
    while space == nil and pos != nil
      space = @board[pos.row][pos.col]
      if space == nil or space.color != piece.color
        lines << pos
      end
      pos = pos.down
    end
    
    lines
  end
  
  
  #Get all open spaces left of piece, until next piece or end of board
  
  def leftSpaces(piece)
    lines = Array.allocate()
    pos = piece.pos.left
    space = nil
    
    while space == nil and pos != nil
      space = @board[pos.row][pos.col]
      if space == nil or space.color != piece.color
        lines << pos
      end
      pos = pos.left
    end
    
    lines
  end
  
  
  #Get all open spaces right of piece, until next piece or end of board
  
  def rightSpaces(piece)
    lines = Array.allocate()
    pos = piece.pos.right
    space = nil
    
    while space == nil and pos != nil
      space = @board[pos.row][pos.col]
      if space == nil or space.color != piece.color
        lines << pos
      end
      pos = pos.right
    end
    
    lines
  end
  
  
  #Get all open spaces in leftUp diagonal from piece, until next piece or end of board
  
  def leftUpSpaces(piece)
    diagonals = Array.allocate()
    pos = piece.pos.leftUp
    space = nil
    
    while space == nil and pos != nil
      space = @board[pos.row][pos.col]
      if space == nil or space.color != piece.color
        diagonals << pos
      end
      pos = pos.leftUp
    end
    
    diagonals
  end
  
  
  #Get all open spaces in leftDown diagonal from piece, until next piece or end of board
  
  def leftDownSpaces(piece)
    diagonals = Array.allocate()
    pos = piece.pos.leftDown
    space = nil
    
    while space == nil and pos != nil
      space = @board[pos.row][pos.col]
      if space == nil or space.color != piece.color
        diagonals << pos
      end
      pos = pos.leftDown
    end
    
    diagonals
  end
  
  
  #Get all open spaces in rightUp diagonal from piece, until next piece or end of board
  
  def rightUpSpaces(piece)
    diagonals = Array.allocate()
    pos = piece.pos.rightUp
    space = nil
    
    while space == nil and pos != nil
      space = @board[pos.row][pos.col]
      if space == nil or space.color != piece.color
        diagonals << pos
      end
      pos = pos.rightUp
    end
    
    diagonals
  end
  
  
  #Get all open spaces in rightDown diagonal from piece, until next piece or end of board
  
  def rightDownSpaces(piece)
    diagonals = Array.allocate()
    pos = piece.pos.rightDown
    space = nil
    
    while space == nil and pos != nil
      space = @board[pos.row][pos.col]
      if space == nil or space.color != piece.color
        diagonals << pos
      end
      pos = pos.rightDown
    end
    
    diagonals
  end
  
  
  #Get all valid spaces for pawn movement
  
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
  
  
  #Get valid diagonal spaces in all four directions from piece
  
  def getDiagonal(piece)
    leftUpSpaces(piece) + leftDownSpaces(piece) + rightUpSpaces(piece) + rightDownSpaces(piece)
  end
  
  
  #Get valid spaces in same row or column from piece
  
  def getLinear(piece)
    upSpaces(piece) + downSpaces(piece) + leftSpaces(piece) + rightSpaces(piece)
  end
  
  
  #Get special move spaces (King, Knight, or Pawn)
  
  def getSpecial(piece)
    temp = Array.allocate()
    moves = Array.allocate()
    
    if piece.class == Pawn
      temp += pawn(piece)
    else
      temp += piece.getSpecialMoves
    end
    
    for pos in temp
      if pos != nil and (@board[pos.row][pos.col] == nil or @board[pos.row][pos.col].color != piece.color)
        moves << pos
      end
    end
    
    moves
  end
  
  
  #Retrieve only valid King Moves
  def validKingMoves(piece)
    moves = getMoves(piece)
    
    if piece.class == King
      invalid = Array.allocate()
              
      for m in moves
        if simulate(piece, m)
          invalid << m
        end
      end
      
      moves = moves - invalid
    end
  end
  
  
  
  def test
    
    puts "Test Pawn Movement"
    for i in 0..7
      moves = getMoves(@board[1][i])
      move(1, i, moves[1])
      
      moves = getMoves(@board[6][i])
      move(6, i, moves[1])
    end
    
    self.print
    
    puts "Eliminate Pawns"
    for i in 0..3
      move(3, 2*i, Coord.new(4, 2*i + 1))
      move(4, 2*i, Coord.new(3, 2*i + 1))
    end
    
    puts "Test Rook Movement"
    move(0, 7, getPieceMoves(0, 7)[2])
    move(7, 7, getPieceMoves(7, 7)[2])
    move(3, 7, Coord.new(3, 5))
    move(4, 7, Coord.new(4, 5))
    self.print
    
    puts "Test Knight Movement"
    move(0, 1, getPieceMoves(0, 1)[0])
    move(7, 1, getPieceMoves(7, 1)[0])
    move(0, 6, getPieceMoves(0, 6)[0])
    move(7, 6, getPieceMoves(7, 6)[0])
    self.print
    
    puts "Test Bishop and Queen Movement"
    move(0, 2, getPieceMoves(0, 2)[0])
    move(7, 3, getPieceMoves(7, 3)[0])
    self.print
    
    puts "Test King Movement"
    puts getPieceMoves(7, 4)
    move(0, 4, getPieceMoves(0, 4)[0])
    move(7, 4, getPieceMoves(7, 4)[0])
    self.print
    
    puts "Test Special Conditions"
    
    move(3, 5, Coord.new(3, 3))
    move(6, 4, Coord.new(4, 3))
    move(3, 3, Coord.new(4, 3))
    self.print
    
    puts "Black King Expected: (7, 4) and (6, 4)"
    puts getPieceMoves(7, 3)
    move(4, 5, Coord.new(4, 3))
    self.print
    puts "White King Expected: (0, 4), (1, 4), and (2, 4)"
    puts getPieceMoves(1, 3)
    puts "Eliminate Pieces and Force Checkmate"
    move(1, 3, getPieceMoves(1, 3)[0])
    move(4, 3, Coord.new(0, 3))
    move(0, 0, Coord.new(0, 3))
    move(7, 3, getPieceMoves(7, 3)[0])
    move(0, 3, Coord.new(7, 3))
    move(6, 2, Coord.new(7, 3))
    move(2, 4, Coord.new(3, 4))
    move(7, 3, Coord.new(5, 3))
    move(3, 4, Coord.new(2, 4))
    move(7, 5, Coord.new(5, 7))
    move(2, 4, Coord.new(3, 4))
    move(7, 2, Coord.new(6, 1))
    move(3, 4, Coord.new(4, 5))
    move(5, 3, Coord.new(4, 3))
    move(7, 4, Coord.new(6, 4))
    move(4, 5, Coord.new(5, 6))
    move(5, 7, Coord.new(7, 5))
    move(5, 6, Coord.new(6, 7))
    move(4, 3, Coord.new(4, 6))
    move(6, 7, Coord.new(7, 7))
    move(6, 4, Coord.new(6, 5))
    move(7, 7, Coord.new(6, 7))
    move(4, 6, Coord.new(5, 6))
    move(6, 7, Coord.new(7, 7))
    move(5, 6, Coord.new(6, 6))
    self.print
    puts "Checkmate? " + checkmate?(WHITE).to_s
    puts validKingMoves(@wKing)
    
  end
  
end

Board.new.test