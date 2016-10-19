using SQLite
include("pieces.jl")
function getValue(DB, sql)
  temp = string(SQLite.query(DB, sql)[1][1])
  value = temp[10:findfirst(temp, ')')-1]
  return value
end
module MCTS
  function count_self(table, color, table_type)
    count = 0
    if table_type == 'S'
      size = 9
    else
      size = 5
    end
    for i = 1:size
      for j = 1:size
        if table.temp_standard[i][j][2] == color
          count += 1
        end
      end
    end
    return count
  end
  function count_opp(table, color, table)
    if color == '1'
      return count_self(table, '0', table)
    else
      return count_self(table, '1', table)
    end
  end
  function get_kills(board, color, size)
    if color == 1
      color_opp = 0
    else
      color_opp = 1
    end
    if size == 5
      own = ["k", "g", "s", "b", "r", "p"]
    else
      pawn =10
      own = ["l", "n", "s", "g", "k", "g", "s", "n", "l", "b", "r", "p", "p", "p", "p", "p", "p", "p", "p", "p"]
    end
    for i = 1:size
      for j = 1:size
        if board[i, j][2] == color_opp
          deleteat!(own, findfirst(own, string(board[i, j][1])))
        end
      end
    end
    return own
  end
  function getAllMoves(char, board, x, y)
    if isupper(char[1])
      moves = getMovePro(char, board, x, y)
    else
      moves = getMoveStd(char, board, x, y)
    end
    return moves
  end
  function getMoveStd(char, board, x, y)
    name = char[1]
    if name == 'p'
      moves = pawn.getmoves(board, x, y)
    elseif name == 'b'
      moves = bishop.getmoves(board, x, y)
    elseif name == 'g'
      moves = gold_general.getmoves(board, x, y)
    elseif name == 'k'
      moves = king.getmoves(board, x, y)
    elseif name == 'l'
      moves = lance.getmoves(board, x, y)
    elseif name == 'n'
      moves = knight.getmoves(board, x, y)
    elseif name == 'r'
      moves = rook.getmoves(board, x, y)
    elseif name == 's'
      moves = silver_General.getmoves(board, x, y)
    end
    return moves
  end
  function getMovePro(char, board, x, y)
    name = char[1]
    if name == 'p'
      moves = Pawn.getmoves(board, x, y)
    elseif name == 'B'
      moves = Bishop.getmoves(board, x, y)
    elseif name == 'L'
      moves = Lance.getmoves(board, x, y)
    elseif name == 'N'
      moves = Knight.getmoves(board, x, y)
    elseif name == 'R'
      moves = Rook.getmoves(board, x, y)
    elseif name == 'S'
      moves = Silver_General.getmoves(board, x, y)
    end
    return moves
  end
  function move(filename)
    #sst up necessary variables
    DB = SQLite.DB(fliename)
    game_type = getValue(DB,  "select * from meta where key == \"type\"")
    if game_type == "minishogi"
      size = 5
      promote_line = 1
      table_type = 'M'
    else
      size = 9
      promote_line = 3
      table_type = 'S'
    end
    seed = parse(Int, getValue(DB,  "select * from meta where key == \"seed\""))
    srand(seed)
    cheating = false
    color = NaN
    temp = parse(Int, getValue(DB,"SELECT COUNT(*) FROM moves")[1][1])
    if temp%2 == 0
      color = 0
    else
      color = 1
    end
    board = getBoard(filename)


    kills = get_kills(board, color, size)
    #count for the pieces on the board
    self_count = count_self(table, color, table_type)
    opp_count = count_opp(table, color, table_type)
    c = 0
    source_x::Int
    source_y::Int
    xtarget::Int
    ytarget::Int

    source_x = NaN
    source_y = NaN
    move_type = NaN

    #choose a move type
    choose_move = rand(1:1000)
    if choose_move < 10
      println("Computer resigned! The other player wins!")
      println("Press enter to exit")
      readline()
      exit(0)
       move_type = 'd'
      source_x = -1
      source_y = -1
    else if choose_move < 700
      move_type = 'm'
    else
      move_type = 'd'
    end


    if move_type == 'd'
      piece_num = rand(1,length(table.kill))
      piece = kill[piece_num]
      target_index = rand(1, size^2-self_count-opp_count)
      for i = 1:size^2
        if table.temp_standard[i] == " "
          c += 1
        end
        if c == target_index
          table.temp_standard[i] = piece*"0"
          xtarget = convert(Int, ceil(i / size))
          ytarget = i % size
          sql_drop = "insert into move(move_type, sourcex, sourcey, targetx, targety, option, i_am_cheating)"
          sql_drop += " values (drop, -1, -1, $(xtarget), $(ytarget), piece, NULL)"
          stmt = SQLite.Stmt(DB, sql_drop)
          SQLite.execute!(stmt)
          return
        end
      end
    elseif move_type == 'm'
      piece_num = rand(1,self_count)
      for i = 1:size^2
        if table.temp_standard[i][2] == '0'
          c += 1
        end
        if c == piece_num
          move_char = table.temp_standard[i]
          break
        end
      end
      moves = getAllMoves(moveChar, table.temp_standard, x, y)
      x = convert(Int, ceil(i/size))
      y = i % size
      rand_move = rand(1:length(moves))
      xtarget = x + moves[rand_move][1]
      ytarget = y + moves[rand_move][2]
      table.temp_standard[(x-1)*size+y] = table.temp_standard[(xtarget-1)*size+ytarget]*"0"
      table.temp_standard[(x-1)*size+y] = " "
      if ytarget <= promote_line
        table.temp_standard[(xtarget-1)*size+ytarget] = uppercase(table.temp_standard[(xtarget-1)*size+ytarget])
        promotion = true
      end
    end

    #insert into moves table
    sql_move = "insert into move(move_type, sourcex, sourcey, targetx, targety, option, i_am_cheating)"
    if promotion && !cheating
      sql_move += " values ($(move_char), $(x), $(y), $(xtarget), $(ytarget), \'!\',  NULL)"
    elseif promotion && cheating
      sql_move += " values ($(move_char), $(x), $(y), $(xtarget), $(ytarget), \'!\',  \"Cheated\")"
    elseif !promotion && cheating
      sql_move += " values ($(move_char), $(x), $(y), $(xtarget), $(ytarget), NULL,  \"Cheated\")"
    else
      sql_move += " values ($(move_char), $(x), $(y), $(xtarget), $(ytarget), NULL,  NULL)"
    end
    stmt = SQLite.Stmt(DB, sql_move)
    SQLite.execute!(stmt)
    println("Computer just made a move.")
  end
end
