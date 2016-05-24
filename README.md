#Chess  
A command line implementation of chess.  
  
Final Ruby project on The Odin Project:  
http://www.theodinproject.com/ruby-programming/ruby-final-project  
  
####Status  
Work in progress, development temporarily suspended.  
  
####Basic features  
 - Core chess functionalities (illegal move recognition, check/checkmate detection),  
 - Human vs Human game mode,
 - Save / load feature (1 slot available at the moment),  
 - Promotion.  
  
#### How to play  
Enter "start" to begin a new game or "load" to load previously saved game state.  
To move your pieces, enter coordinates in the following format:  
piece_position, target_square  
There must be a single space after the comma.  
  
Example:  
a2, a4  
Move white pawn from square A2 to square A4.  
  
You can save current game state by typing 'save' instead of making a move.  
Existing save file will be overwritten!  
  
####Planned additions  
 - Special move: castling,  
 - Special move: en passant,  
 - Further polishing.  
  