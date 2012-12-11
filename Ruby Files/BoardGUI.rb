require 'wx'
require_relative 'Board'
require_relative 'Coord'

class BoardGUI < Wx::Dialog
   
   @moveNum
   @click1
   @click2
   
   @grid #row x col
   #need a grid to tell if a space background in @grid is light or dark
   def initialize(parent)
      super(parent, :title => "Chess Board", :size => Wx::Size.new(405, 425))
      
      @moveNum = 1
      @grid = Hash.new
      
      #Blank spaces
      light_file = File.join( File.dirname(__FILE__), 'images', 'light.png')
      dark_file = File.join( File.dirname(__FILE__), 'images', 'dark.png')
      png_light = Wx::Bitmap.new(light_file, Wx::BITMAP_TYPE_PNG)
      png_dark = Wx::Bitmap.new(dark_file, Wx::BITMAP_TYPE_PNG)
      
      #Black pieces
      black_bishop_dark = File.join( File.dirname(__FILE__), 'images', 'BlackBishopDark.png')
      black_bishop_light = File.join( File.dirname(__FILE__), 'images', 'BlackBishopLight.png')
      black_king_dark = File.join( File.dirname(__FILE__), 'images', 'BlackKingDark.png')
      black_king_light = File.join( File.dirname(__FILE__), 'images', 'BlackKingLight.png')
      black_knight_dark = File.join( File.dirname(__FILE__), 'images', 'BlackKnightDark.png')
      black_knight_light = File.join( File.dirname(__FILE__), 'images', 'BlackKnightLight.png')
      black_pawn_dark = File.join( File.dirname(__FILE__), 'images', 'BlackPawnDark.png')
      black_pawn_light = File.join( File.dirname(__FILE__), 'images', 'BlackPawnLight.png')
      black_queen_dark = File.join( File.dirname(__FILE__), 'images', 'BlackQueenDark.png')
      black_queen_light = File.join( File.dirname(__FILE__), 'images', 'BlackQueenLight.png')
      black_rook_dark = File.join( File.dirname(__FILE__), 'images', 'BlackRookDark.png')
      black_rook_light = File.join( File.dirname(__FILE__), 'images', 'BlackRookLight.png')
      png_black_bishop_dark = Wx::Bitmap.new(black_bishop_dark, Wx::BITMAP_TYPE_PNG)
      png_black_bishop_light = Wx::Bitmap.new(black_bishop_light, Wx::BITMAP_TYPE_PNG)
      png_black_king_dark = Wx::Bitmap.new(black_king_dark, Wx::BITMAP_TYPE_PNG)
      png_black_king_light = Wx::Bitmap.new(black_king_light, Wx::BITMAP_TYPE_PNG)
      png_black_knight_dark = Wx::Bitmap.new(black_knight_dark, Wx::BITMAP_TYPE_PNG)
      png_black_knight_light = Wx::Bitmap.new(black_knight_light, Wx::BITMAP_TYPE_PNG)
      png_black_pawn_dark = Wx::Bitmap.new(black_pawn_dark, Wx::BITMAP_TYPE_PNG)
      png_black_pawn_light = Wx::Bitmap.new(black_pawn_light, Wx::BITMAP_TYPE_PNG)
      png_black_queen_dark = Wx::Bitmap.new(black_queen_dark, Wx::BITMAP_TYPE_PNG)
      png_black_queen_light = Wx::Bitmap.new(black_queen_light, Wx::BITMAP_TYPE_PNG)
      png_black_rook_dark = Wx::Bitmap.new(black_rook_dark, Wx::BITMAP_TYPE_PNG)
      png_black_rook_light = Wx::Bitmap.new(black_rook_light, Wx::BITMAP_TYPE_PNG)
      
      #White pieces
      white_bishop_dark = File.join( File.dirname(__FILE__), 'images', 'WhiteBishopDark.png')
      white_bishop_light = File.join( File.dirname(__FILE__), 'images', 'WhiteBishopLight.png')
      white_king_dark = File.join( File.dirname(__FILE__), 'images', 'WhiteKingDark.png')
      white_king_light = File.join( File.dirname(__FILE__), 'images', 'WhiteKingLight.png')
      white_knight_dark = File.join( File.dirname(__FILE__), 'images', 'WhiteKnightDark.png')
      white_knight_light = File.join( File.dirname(__FILE__), 'images', 'WhiteKnightLight.png')
      white_pawn_dark = File.join( File.dirname(__FILE__), 'images', 'WhitePawnDark.png')
      white_pawn_light = File.join( File.dirname(__FILE__), 'images', 'WhitePawnLight.png')
      white_queen_dark = File.join( File.dirname(__FILE__), 'images', 'WhiteQueenDark.png')
      white_queen_light = File.join( File.dirname(__FILE__), 'images', 'WhiteQueenLight.png')
      white_rook_dark = File.join( File.dirname(__FILE__), 'images', 'WhiteRookDark.png')
      white_rook_light = File.join( File.dirname(__FILE__), 'images', 'WhiteRookLight.png')
      png_white_bishop_dark = Wx::Bitmap.new(white_bishop_dark, Wx::BITMAP_TYPE_PNG)
      png_white_bishop_light = Wx::Bitmap.new(white_bishop_light, Wx::BITMAP_TYPE_PNG)
      png_white_king_dark = Wx::Bitmap.new(white_king_dark, Wx::BITMAP_TYPE_PNG)
      png_white_king_light = Wx::Bitmap.new(white_king_light, Wx::BITMAP_TYPE_PNG)
      png_white_knight_dark = Wx::Bitmap.new(white_knight_dark, Wx::BITMAP_TYPE_PNG)
      png_white_knight_light = Wx::Bitmap.new(white_knight_light, Wx::BITMAP_TYPE_PNG)
      png_white_pawn_dark = Wx::Bitmap.new(white_pawn_dark, Wx::BITMAP_TYPE_PNG)
      png_white_pawn_light = Wx::Bitmap.new(white_pawn_light, Wx::BITMAP_TYPE_PNG)
      png_white_queen_dark = Wx::Bitmap.new(white_queen_dark, Wx::BITMAP_TYPE_PNG)
      png_white_queen_light = Wx::Bitmap.new(white_queen_light, Wx::BITMAP_TYPE_PNG)
      png_white_rook_dark = Wx::Bitmap.new(white_rook_dark, Wx::BITMAP_TYPE_PNG)
      png_white_rook_light = Wx::Bitmap.new(white_rook_light, Wx::BITMAP_TYPE_PNG)
      
      #Initialize the board with blank spaces
      count = 0
      for i in 0..7
         for j in 0..7
            #Each button id = ji (where j is row i is col)
            id = (j * 10) + i
            if(count % 2 == 0)
               @grid[[j,i]] = Wx::BitmapButton.new(self, id, png_light, Wx::Point.new(i * 50, j * 50), Wx::Size.new(50, 50))
               evt_button(id) {|event| on_click(event)}
            else
               @grid[[j,i]] = Wx::BitmapButton.new(self, id, png_dark, Wx::Point.new(i * 50, j * 50), Wx::Size.new(50, 50))
               evt_button(id) {|event| on_click(event)}
            end
            count += 1
         end
         count += 1
      end
      
      #Place pieces on the grid
      #Note. "black associated"(black bottom white top) corresponding with Board.rb logic 
      @grid[[0,0]].set_bitmap_label(png_white_rook_light)
      @grid[[0,7]].set_bitmap_label(png_white_rook_dark)
      @grid[[0,1]].set_bitmap_label(png_white_knight_dark)
      @grid[[0,6]].set_bitmap_label(png_white_knight_light)
      @grid[[0,2]].set_bitmap_label(png_white_bishop_light)
      @grid[[0,5]].set_bitmap_label(png_white_bishop_dark)
      @grid[[0,3]].set_bitmap_label(png_white_king_dark)
      @grid[[0,4]].set_bitmap_label(png_white_queen_light)
      @grid[[1,0]].set_bitmap_label(png_white_pawn_dark)
      @grid[[1,1]].set_bitmap_label(png_white_pawn_light)
      @grid[[1,2]].set_bitmap_label(png_white_pawn_dark)
      @grid[[1,3]].set_bitmap_label(png_white_pawn_light)
      @grid[[1,4]].set_bitmap_label(png_white_pawn_dark)
      @grid[[1,5]].set_bitmap_label(png_white_pawn_light)
      @grid[[1,6]].set_bitmap_label(png_white_pawn_dark)
      @grid[[1,7]].set_bitmap_label(png_white_pawn_light)
      
      @grid[[7,0]].set_bitmap_label(png_black_rook_dark)
      @grid[[7,7]].set_bitmap_label(png_black_rook_light)
      @grid[[7,1]].set_bitmap_label(png_black_knight_light)
      @grid[[7,6]].set_bitmap_label(png_black_knight_dark)
      @grid[[7,2]].set_bitmap_label(png_black_bishop_dark)
      @grid[[7,5]].set_bitmap_label(png_black_bishop_light)
      @grid[[7,3]].set_bitmap_label(png_black_king_light)
      @grid[[7,4]].set_bitmap_label(png_black_queen_dark)
      @grid[[6,0]].set_bitmap_label(png_black_pawn_light)
      @grid[[6,1]].set_bitmap_label(png_black_pawn_dark)
      @grid[[6,2]].set_bitmap_label(png_black_pawn_light)
      @grid[[6,3]].set_bitmap_label(png_black_pawn_dark)
      @grid[[6,4]].set_bitmap_label(png_black_pawn_light)
      @grid[[6,5]].set_bitmap_label(png_black_pawn_dark)
      @grid[[6,6]].set_bitmap_label(png_black_pawn_light)
      @grid[[6,7]].set_bitmap_label(png_black_pawn_dark)
      
   end
   
   def on_click(event)
      if(@moveNum == 1)
         @click1 = event.get_id()
         @moveNum = 2
         print("Click 1 %d\n" % @click1)
      else
         @click2 = event.get_id()
         @moveNum = 1
         print("Click 2 %d\n" % @click2)
      end
      
   end
   
   def exit
      close
      destroy
   end
end

class Login < Wx::Dialog
   @logSuccess = false
   def initialize(parent)
      super(parent, :title => "Login", :size => Wx::Size.new(400, 300))
      evt_erase_background :on_erase_background

      f_path = File.join(File.dirname(__FILE__), 'images', 'ChessMaster_Logo.jpg')
      f_bitmap = Wx::Bitmap.new(Wx::Image.new(f_path), Wx::BITMAP_TYPE_JPEG)
      Wx::BitmapButton.new(self, 1, f_bitmap, Wx::Point.new(0, 0), Wx::Size.new(400, 100))
      
      @labelP1 = Wx::StaticText.new(self, -1, 'Player 1 (White):', :pos => [ 10, 155])
      @textP1 = Wx::TextCtrl.new(self, :value => '', :pos => [ 100, 150])
      
      @labelP2 = Wx::StaticText.new(self, -1, 'Player 2 (Black):', :pos => [ 10, 195])
      @textP2 = Wx::TextCtrl.new(self, :value => '', :pos => [ 100, 190 ])
      
      @start = Wx::Button.new(self, -1, 'Start Game', :pos => [ 10, 230])
      @exit = Wx::Button.new(self, -1, 'Exit', :pos => [ 125, 230])
      
      self.evt_button(@start.get_id) {render_board}
      self.evt_button(@exit.get_id) {exit}
   end

   def on_erase_background(evt)
      # Use the event's DC object to draw whatever background you want
      evt.dc.gradient_fill_linear( client_rect,
         Wx::WHITE, Wx::BLACK, Wx::NORTH )
   end
   
   def render_board
      self.hide
   end
   
   def exit
      close
      destroy
   end
end