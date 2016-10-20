include("piece.jl")
import king,root,pawn,bishop,silver_General,knight,lance,Gold_General,Pawn,Rook,Bishop,Silver_General,Knight,Lance
using SQLite

died_token = Array{String}(0)
board_type = SQLite.query(DB,"SELECT value FROM meta WHERE key = \"type\";")[1].values[1]
if board_type == "standard"
  global board = ["l0" "n0" "s0" "g0" "k0" "g0" "s0" "n0" "l0";
              " " "b0" " " " " " " " " " " "r0" " ";
              "p0" "p0" "p0" "p0" "p0" "p0" "p0" "p0" "p0";
              " " " " " " " " " " " " " " " " " ";
              " " " " " " " " " " " " " " " " " ";
              " " " " " " " " " " " " " " " " " ";
              "p1" "p1" "p1" "p1" "p1" "p1" "p1" "p1" "p1";
              " " "r1" " " " " " " " " " " "b1" " ";
              "l1" "n1" "s1" "g1" "k1" "g1" "s1" "n1" "l1";]
elseif board_type == "minishogi"
  global board = ["k0" "g0" "s0" "b0" "r0";
    "p0" " " " " " " " ";
    " " " " " " " " " ";
    " " " " " " " " "p1";
    "r1" "b1" "s1" "g1" "k1";]
end

for i = 1:length(SQLite.query(DB,"SELECT move_number FROM moves;")[1])
  global turn = i % 2 == 0 ? "0" : "1"

  move_type = SQLite.query(DB,"SELECT move_type FROM moves WHERE \"move_number\" = $i;")[1].values[1]
  sourcex = SQLite.query(DB,"SELECT sourcex FROM moves WHERE \"move_number\" = $i;")[1].values[1]
  sourcey = SQLite.query(DB,"SELECT sourcey FROM moves WHERE \"move_number\" = $i;")[1].values[1]
  targetx = SQLite.query(DB,"SELECT targetx FROM moves WHERE \"move_number\" = $i;")[1].values[1]
  targety = SQLite.query(DB,"SELECT targety FROM moves WHERE \"move_number\" = $i;")[1].values[1]
  option = SQLite.query(DB,"SELECT option FROM moves WHERE \"move_number\" = $i;")[1].values[1]

  if move_type == "move"
    if board[sourcex,sourcey] == " "
      print(i," ")
      continue
    elseif board[sourcex,sourcey][2] != turn
      print(i," ")
      continue
    elseif board[targetx,targety][2] == turn
      print(i," ")
      continue
    elseif option == "!"
      if turn = "0" #white
        if targetx < 7
          print(i," ")
          continue
        end
      else
        if targetx > 3
          print(i," ")
          continue
        end
      end
    else
      info("undo")
    end
  elseif move_type == "drop"
    index = 0
    #find index
    for k = 1:length(died_arr)
      if died_arr[k] == option * turn
        index = k
        break
      end
    end
    if index == 0
      print(i," ")
      continue
    elseif board[targetx,targety] != " "
      print(i," ")
      continue
    else
      board[targetx,targety] = option * turn
      deleteat!(died_token,index)
    end
  elseif move_type == "resign"
    info("undo")
  end
