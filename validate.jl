include("pieces.jl")
using SQLite

DB = SQLite.DB(ARGS[1])
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
flag = true
for i = 1:length(SQLite.query(DB,"SELECT move_number FROM moves;")[1])
  global turn = i % 2 == 0 ? "0" : "1"

  move_type = SQLite.query(DB,"SELECT move_type FROM moves WHERE \"move_number\" = $i;")[1].values[1]
  sourcex = SQLite.query(DB,"SELECT sourcex FROM moves WHERE \"move_number\" = $i;")[1].values[1]
  sourcey = SQLite.query(DB,"SELECT sourcey FROM moves WHERE \"move_number\" = $i;")[1].values[1]
  targetx = SQLite.query(DB,"SELECT targetx FROM moves WHERE \"move_number\" = $i;")[1].values[1]
  targety = SQLite.query(DB,"SELECT targety FROM moves WHERE \"move_number\" = $i;")[1].values[1]
  try
    global option = string(SQLite.query(DB,"SELECT option FROM moves WHERE \"move_number\" = $i;")[1].values[1])
  catch
    global option = "NULL"
  end

  if move_type == "move"
    #token does not exist
    if board[sourcex,sourcey] == " "
      print(i," ")
      flag = false
      break
    #moves opponent token
  elseif string(board[sourcex,sourcey][2]) != turn
      print(i," ")
      flag = false
      break
    #cant do eat-self
  elseif board[targetx,targety] != " " && string(board[targetx,targety][2]) == turn
      print(i," ")
      flag = false
      break
    #cant promte in unpromoteble area
  elseif option == "!"
      if turn == "0" #white
        if targetx < 7
          print(i," ")
          flag = false
          break
        end
      else
        if targetx > 3
          print(i," ")
          flag = false
          break
        end
      end
  end
  valid_move = MCTS.getAllMoves(board[sourcex,sourcey],board,sourcex,sourcey,parse(turn))
  j = 1
  check = false
  while j < length(valid_move)
    check_valid=(sourcex+valid_move[j],sourcey+valid_move[j+1])
    if (targetx,targety) == check_valid
      check = true
      if board[targetx,targety] != " "
        push!(died_token,string(board[targetx,targety][1]))
      end
      board[targetx,targety] = board[sourcex,sourcey]
      board[sourcex,sourcey] = " "
      break
    end
    j = j + 2
  end
  if !check
    print(i," ")
    flag = false
    break
  end

  if move_type == "drop"
    index = 0
    #find index
    for k = 1:length(died_token)
      if died_token[k] == option * turn
        index = k
        break
      end
    end
    #died token dne
    info(index)
    if index == 0
      print(i," ")
      flag = false
      break
    #target place has token
    elseif board[targetx,targety] != " "
      print(i," ")
      flag = false
      break
    else
      board[targetx,targety] = option * turn
      deleteat!(died_token,index)
    end
  end
end
end
if flag
  println("0")
end
