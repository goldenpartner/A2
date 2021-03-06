using SQLite

function getCurrentBoard(DB)
  DB = SQLite.DB(DB)
  drop_token = Array{String}(0)
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
    try
      global sourcex = SQLite.query(DB,"SELECT sourcex FROM moves WHERE \"move_number\" = $i;")[1].values[1]
    catch
      global sourcex = -1
    end
    try
      global sourcey = SQLite.query(DB,"SELECT sourcey FROM moves WHERE \"move_number\" = $i;")[1].values[1]
    catch
      global sourcey = -1
    end
    try
      global targetx = SQLite.query(DB,"SELECT targetx FROM moves WHERE \"move_number\" = $i;")[1].values[1]
    catch
      global targetx = -1
    end
    try
      global targety = SQLite.query(DB,"SELECT targety FROM moves WHERE \"move_number\" = $i;")[1].values[1]
    catch
      global targety = -1
    end
    try
      global option = string(SQLite.query(DB,"SELECT option FROM moves WHERE \"move_number\" = $i;")[1].values[1])
    catch
      global option = "NULL"
    end
    if move_type == "move"
      if board[targetx,targety] != " "
        push!(drop_token,lowercase(string(board[targetx,targety][1])*turn))
        board[targetx,targety] = board[sourcex,sourcey]
        board[sourcex,sourcey] = " "
      else
        board[targetx,targety] = board[sourcex,sourcey]
        board[sourcex,sourcey] = " "
      end
      if option == "!"
        board[targetx,targety] = uppercase(board[targetx,targety])
      end
    elseif move_type == "resign"
      return board,drop_token
    elseif move_type == "drop"
      index = 0
      for k = 1:length(drop_token)
        if drop_token[k] == option * turn
          index = k
          break
        end
      end
      if board[targetx,targety] != " "
        push!(drop_token,lowercase(string(board[targetx,targety][1])*turn))
      end
      if index != 0
        board[targetx,targety] = option * turn
        deleteat!(drop_token,index)
      else
        board[targetx,targety] = option * turn
      end
    end
  end
  return board,drop_token
end
