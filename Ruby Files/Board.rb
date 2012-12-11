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
  
  @board
  @previous
  
  @white
  @black
  @wKing
  @bKing
  
  @enPassante
  @castle
  
  #Initialize board with starting piece positions (White from row0, Black from row7)
  def initialize()
    @previous = nil
    @enPassante = Array.allocate()
    @castle = Array.allocate()
    
    @white = Array.allocate()
    @black = Array.allocate()
    
    row0 = Array.new(8, nil)
    row1 = Array.new(8, nil)
    row2 = Array.new(8, nil)
    row3 = Array.new(8, nil)
    row4 = Array.new(8, nil)
    row5 = Array.new(8, nil)
    row6 = Array.new(8, nil)
    row7 = Array.new(8, nil)
    
    row0[0], row0[7] = Rook.new(WHITE, 0, 0), Rook.new(WHITE, 0, 7)
    row7[0], row7[7] = Rook.new(BLACK, 7, 0), Rook.new(BLACK, 7, 7)
    
    row0[1], row0[6] = Knight.new(WHITE, 0, 1), Knight.new(WHITE, 0, 6)
    row7[1], row7[6] = Knight.new(BLACK, 7, 1), Knight.new(BLACK, 7, 6)
    
    row0[2], row0[5] = Bishop.new(WHITE, 0, 2), Bishop.new(WHITE, 0, 5)
    row7[2], row7[5] = Bishop.new(BLACK, 7, 2), Bishop.new(BLACK, 7, 5)
    
    row0[3], row7[3] = Queen.new(WHITE, 0, 3), Queen.new(BLACK, 7, 3)
    row0[4], row7[4] = King.new(WHITE, 0, 4), King.new(BLACK, 7, 4)
    
    for i in 0..7
      row1[i] = Pawn.new(WHITE, 1, i)
      row6[i] = Pawn.new(BLACK, 6, i)
    end
    
    @board = [row0, row1, row2, row3, row4, row5, row6, row7]
    @wKing = @board[0][4]
    @bKing = @board[7][4]
    
    @castle = [@board[0][0], @board[0][7], @board[7][0], @board[7][7]]
    
    for i in 0..7
      @white << @board[0][i]
      @white << @board[1][i]
      @black << @board[7][i]
      @black << @board[6][i]
    end
  end
  
  #Move a piece at row r, column c to new position pos (Does not handle pre or post conditions)
  def move(r, c, pos)
    col = nil
    
    if @board[r][c].color == WHITE
      col = @black
    else
      col = @white
    end
    
    col.delete(@board[pos.row][pos.col])
    
    @board[pos.row][pos.col] = @board[r][c]
    @board[pos.row][pos.col].move(pos)
    @previous = @board[pos.row][pos.col]
    @board[r][c] = nil
    
    if @previous.class == Pawn and @enPassante.length > 0
      for p in @enPassante
        prePos = @previous.pos
        passPos = p.pos
        if prePos.down == passPos or prePos.up == passPos
          @board[passPos.row][passPos.col] = nil
          col.delete(p)
        end
      end
    elsif @previous.class == Rook
      @castle.delete(@previous)
    end
    
    @enPassante = Array.allocate()
    analyze()
  end
  
  #Determine if King is in checkmate
  def checkmate?(color)
    
    if color == WHITE and @wKing.inCheck
      return stalemate?(WHITE)
    elsif color == BLACK and @bKing.inCheck 
      return stalemate?(BLACK)
    end
    
    false
  end
  
  #Determine if the any valid moves remain
  def stalemate?(color)
    king = nil
    col = nil
    
    if color == WHITE
      king = @wKing
      col = @white
    else
      king = @bKing
      col = @black
    end
    
    for p in col
      for m in validMoves(p)
        if m != nil
          return false
        end
      end
    end
    
    true
  end
  
  #Analyze the board for check or checkmate conditions
  def analyze()
    sameCol = nil
    oppCol = nil
    sameKing = nil
    oppKing = nil
    
    @black = Array.allocate()
    @white = Array.allocate()
    
    for row in @board
      for p in row
        if p != nil and p.color == WHITE
          @white << p
          if p.class == King
            @wKing = p
          end
        elsif p != nil and p.color == BLACK
          @black << p
          if p.class == King
            @bKing = p
          end
        end
      end
    end
    
    
    if @previous.color == WHITE or @previous == @bKing
      sameCol = @white
      oppCol = @black
      king = @bKing
      oppKing = @wKing
    elsif @previous.color == BLACK or @previous == @wKing
      sameCol = @black
      oppCol = @white
      king = @wKing
      oppKing = @bKing
    end
    
    check = false
    kPos = king.pos
    for p in sameCol
      if getMoves(p).include?(kPos)
        king.check
        check = true
      end
    end
    
    if !check
      king.unCheck
    end
    
    check = false
    kPos = oppKing.pos
    for p in oppCol
      if getMoves(p).include?(kPos)
        oppKing.check
        check = true
      end
    end
    
    if !check
      oppKing.unCheck
    end
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
  
  
  #Simulate a move to determine if valid
  def invalid?(piece, m)
    colorList = nil
    king = nil
    
    if piece.color == WHITE
      colorList = @black
      king = @wKing
    else
      colorList = @white
      king = @bKing
    end
    
    invalid = false
    prev = @previous
    temp = @board[m.row][m.col]
    start = piece.pos
    move(start.row, start.col, m)
    
    if king.inCheck
      invalid = true
    end
    
    move(m.row, m.col, start)
    @board[m.row][m.col] = temp
    @previous = prev
    analyze()
    invalid
  end
  
  
  #Get valid moves for a piece at row r, column c
  def getPieceMoves(r, c)
    moves = Array.allocate()
    
    piece = @board[r][c]
    
    if piece != nil
      moves = validMoves(piece)
    end
    
    moves
  end
  
  
  #Retrieve only valid Moves
  def validMoves(piece)
    moves = getMoves(piece)
    invalid = Array.allocate()
            
    for m in moves
      if invalid?(piece, m)
        invalid << m
      end
    end
    
    moves = moves - invalid
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
  
  #Get all valid spaces for pawn movement
  def pawn(piece)
    moves = piece.getSpecialMoves()
    leftEnPassante = false
    rightEnPassante = false
    
    left = piece.pos.left
    lPiece = nil
    right = piece.pos.right
    rPiece = nil
    
    if left != nil
      lPiece = @board[left.row][left.col]
      if lPiece != nil and lPiece.color != piece.color and lPiece.class == Pawn and !lPiece.alreadyMoved
        leftEnPassante = true
        @enPassante << lPiece
      end
    end
    
    if right != nil and @board[right.row][right.col] != nil
      rPiece = @board[right.row][right.col]
      if rPiece != nil and rPiece.color != piece.color and rPiece.class == Pawn and !rPiece.alreadyMoved
        rightEnPassante = true
        @enPassante << rPiece
      end
    end
    
    lcorner = moves[1]
    rcorner = moves[2]
    
    if lcorner == nil or (@board[lcorner.row][lcorner.col] == nil and !leftEnPassante)
      moves.delete(lcorner)
    end
    
    if rcorner == nil or (@board[rcorner.row][rcorner.col] == nil and !rightEnPassante)
      moves.delete(rcorner)
    end
    
    moves
  end
  
  #Determines whether castling is currently a legal move
  def castle?(color)
    king = nil
    
    if color == WHITE
      king = @wKing
    else
      king = @bKing
    end
    
    if king.moved or king.inCheck
      return false
    end
    
    kPos = king.pos
    
    for p in @castle
      left = leftSpaces(p)[-1]
      right = rightSpaces(p)[-1]
          
      if left != nil and @board[left.row][left.col] == nil and left.left == kPos
        if !invalid?(king, Coord.new(kPos.row, 1))
          return true
        end
      elsif right != nil and @board[right.row][right.col] == nil and right.right == kPos
        if !invalid?(king, Coord.new(kPos.row, 6))
          return true
        end
      end
    end
    
    false
  end
  
  
  #Performs a castle maneuver based on the rook column selected (assumes preconditions are met)
  def castle(row, column)
    if column == 0 and @castle.include?(@board[row][column])
      move(row, column, Coord.new(row, 2))
      move(row, 4, Coord.new(row, 1))
      return true
    elsif column == 7 and @castle.include?(@board[row][column])
      move(row, column, Coord.new(row, 5))
      move(row, 4, Coord.new(row, 6))
      return true
    end
    
    false
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
  
  
  def moveTest
    puts "MOVEMENT TESTS"
    puts "Test Pawn Movement"
    for i in 0..7
      moves = getMoves(@board[1][i])
      move(1, i, moves[1])
      
      moves = getMoves(@board[6][i])
      move(6, i, moves[1])
    end
    
    print
    
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
    print
    
    puts "Test Knight Movement"
    move(0, 1, getPieceMoves(0, 1)[0])
    move(7, 1, getPieceMoves(7, 1)[0])
    move(0, 6, getPieceMoves(0, 6)[0])
    move(7, 6, getPieceMoves(7, 6)[0])
    print
    
    puts "Test Bishop and Queen Movement"
    move(0, 2, getPieceMoves(0, 2)[0])
    move(7, 3, getPieceMoves(7, 3)[0])
    print
    
    puts "Test King Movement"
    puts getPieceMoves(7, 4)
    move(0, 4, getPieceMoves(0, 4)[0])
    move(7, 4, getPieceMoves(7, 4)[0])
    print
    
    puts "Test Special Conditions"
    
    move(3, 5, Coord.new(3, 3))
    move(6, 4, Coord.new(4, 3))
    move(3, 3, Coord.new(4, 3))
    print
    
    puts "Black King Expected: (7, 4) and (6, 4)"
    puts getPieceMoves(7, 3)
    move(4, 5, Coord.new(4, 3))
    print
    puts "White King Expected: (0, 4), (1, 4), and (2, 4)"
    puts getPieceMoves(1, 3)
  end
  
  def checkTest(expected)
    puts "CHECK CONDITIONS TEST (EXPECTED = " + expected.to_s + ")"
    @board[1] = Array.new(8, nil)
    @board[6] = Array.new(8, nil)
    
    for p in @white
      if p.class == Pawn
        @white.delete(p)
      end
    end
    
    for p in  @black
      if p.class == Pawn
        @black.delete(p)
      end
    end
    
    move(0, 3, Coord.new(1, 4))
    move(7, 5, Coord.new(6, 4))
    move(0, 2, Coord.new(5, 7))
      
      if expected
        move(7, 1, Coord.new(6, 3))
      else
        move(7, 0, Coord.new(0, 0))
      end
      
      
    move(1, 4, Coord.new(4, 7))
    print
    puts "Black King in check?"
    puts @bKing.inCheck
    puts "Black King in checkmate?"
    puts checkmate?(BLACK)
  end
  
  def pawnTest()
    puts "PAWN RULES TEST"
    puts "En Passante Test"
    move(1, 0, Coord.new(2, 0))
    move(6, 0, Coord.new(4, 0))
    move(7, 1, Coord.new(5, 0))
    move(1, 1, Coord.new(3, 1))
    move(4, 0, Coord.new(3, 1))
    move(5, 0, Coord.new(4, 2))
    move(1, 2, Coord.new(3, 2))
    print
    move(3, 1, Coord.new(2, 2))
    print
    puts "Promotion Test"
    move(2, 2, Coord.new(1, 2))
    move(1, 2, Coord.new(0, 1))
    print
    puts "Promote previous? " + promote?.to_s
    
    puts "Promote to Queen"
    promote(1)
    print
    
    puts "Promote to Rook"
    promote(2)
    print
    
    puts "Promote to Bishop"
    promote(3)
    print
    
    puts "Promote to Knight"
    promote(4)
    print
  end
  
  def staleCastleTest
    puts "STALEMATE/CASTLE TESTS"
    @board[1] = Array.new(8, nil)
    @board[6] = Array.new(8, nil)
    @board[7] = Array.new(8, nil)
    @board[7][4] = King.new(BLACK, 7, 4)
    @board[7][0] = Rook.new(BLACK, 7, 0)
    @board[7][7] = Rook.new(BLACK, 7, 7)
    
    for p in @white
      if p.class == Pawn
        @white.delete(p)
      end
    end
    
    temp = Array.new(@black)
    @black = Array.allocate()
    for p in  temp
      if p.class == King or p.class == Rook
        @black << p
      end
    end
    
    move(0, 0, Coord.new(6, 0))
    print
    
    puts "Black can castle? " + castle?(BLACK).to_s
    puts "White can castle? " + castle?(WHITE).to_s
    puts "Right Castle Black"
    castle(7, 7)
    print
    
    move(6, 0, Coord.new(7, 0))
    move(7, 5, Coord.new(7, 3))
    move(0, 3, Coord.new(7, 3))
    move(7, 6, Coord.new(6, 7))
    
    print
    puts "Black King in stalemate? " + stalemate?(BLACK).to_s
    
    move(7, 3, Coord.new(5, 5))
    print
    puts "Black King in stalemate? " + stalemate?(BLACK).to_s
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
end

#Board.new.moveTest
#Board.new.checkTest(true)
#Board.new.checkTest(false)
#Board.new.pawnTest
#Board.new.staleCastleTest
#puts "TESTS COMPLETED"