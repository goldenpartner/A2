using SQLite
include("pieces.jl")
using MCTS
function move(ARGS)
  #setup variables
  global color = NaN
  global move_type = NaN
  global cheating = false
  global promotion = false
  global move_char = ""
  global source_x = NaN
  global source_y = NaN
  global c = 0
  global x = -1
  global y = -1
  global x_pro = -1
  global y_pro = -1
  global x_l = -1
  global y_l = -1
  global v_l = -1
  #set up necessary variables
  filename = ARGS[1]
  DB = SQLite.DB(filename)
  game_type = string(SQLite.query(DB,  "select * from meta where key == \"type\"")[2].values[1])
  if game_type == "minishogi"
    size = 5
    promote_line = 1
    table_type = 'M'
  else
    size = 9
    promote_line = 3
    table_type = 'S'
  end

  move_num = SQLite.query(DB,"SELECT COUNT(*) FROM moves")[1].values[1]
  if move_num%2 != 0
    color = 0
    color_opp = 1
    if promote_line == 1
      promote_line = 5
    else
      promote_line = 7
    end
  else
    color = 1
    color_opp = 0
  end
  board, kills = getCurrentBoard(filename)

  board[5,1] = uppercase(board[5,1])
  #count for the pieces on the board

  self_count = MCTS.count_self(board, color, table_type)
  opp_count = MCTS.count_opp(board, color, table_type)

  #choose a move type
  choose_move = rand(1:1000)
  if choose_move < 10
    println("Computer resigned! The other player wins!")
    println("Press enter to exit")
    sql_move = "insert into moves(move_type, sourcex, sourcey, targetx, targety, option, i_am_cheating)"
    sql_move *= " values ($(move_num+1),\"resign\", -1, -1, -1, -1, NULL,  NULL)"
    return
  else
    move_type = 'm'
  end

  if move_num <= 1
    if color == 1
      x = 7
      y = 7
      x_l = 6
      y_l = 7
    else
      x = 3
      y = 3
      x_l = 4
      y_l = 3
    end
    move_type = 's'
  elseif (move_num ==2  && color == 1) || move_num == 3
    if color == 1
      x = 7
      y = move_num
      x_l = 6
      y_l = move_num
    else
      x = 3
      y = 8
      x_l = 4
      y_l = 8
    end
    move_type = 's'
  end

  #get opposite king position
  k_x = 0
  k_y = 0
  for i = 1:size
    for j = 1:size
      if board[i,j] == "k"*string(color_opp)
        k_x = i
        k_y = j
        break
      end
    end
  end

  if MCTS.check(board, k_x,k_y,color_opp)
    i, j = MCTS.get_check(board, k_x,k_y,color_opp)
    sql_move = "insert into moves(move_number,move_type, sourcex, sourcey, targetx, targety, option, i_am_cheating)"
    if promotion && !cheating
      sql_move *= " values ($(move_num+1),\"move\", $(i), $(j), $(k_x), $(k_y), \'!\',  NULL)"
    elseif promotion && cheating
      sql_move *= " values ($(move_num+1),\"move\", $(i), $(j), $(k_x), $(k_y), \'!\',  1)"
    elseif !promotion && cheating
      sql_move *= " values ($(move_num+1),\"move\", $(i), $(j), $(k_x), $(k_y), NULL,  1)"
    else
      sql_move *= " values ($(move_num+1),\"move\", $(i), $(j), $(k_x), $(k_y), NULL,  NULL)"
    end
    stmt = SQLite.Stmt(DB, sql_move)
    SQLite.execute!(stmt)
    return
  end
  if move_type == 'm' #make the move
    for i = 1:size
      for j = 1:size
        if board[i, j] == " "
          continue
        elseif board[i, j][2] == string(color)[1]
          move_char = board[i,j][1]
          global moves = MCTS.getAllMoves(board[i,j], board, i,j,color)
          if moves != nothing
            for k = 1:2:length(moves)
              xtarget = i+moves[k]
              ytarget = j+moves[k+1]
              temp = board[xtarget, ytarget]
              board[xtarget, ytarget] = board[i,j]
              board[i,j] = " "
              if MCTS.check(board, k_x,k_y,color_opp)#if the move an check the opposite, do it
                if xtarget <= promote_line
                  promotion = true
                else
                  promotion = false
                end
                sql_move = "insert into moves(move_number,move_type, sourcex, sourcey, targetx, targety, option, i_am_cheating)"
                if promotion && !cheating
                  sql_move *= " values ($(move_num+1),\"move\", $(i), $(j), $(xtarget), $(ytarget), \'!\',  NULL)"
                elseif promotion && cheating
                  sql_move *= " values ($(move_num+1),\"move\", $(i), $(j), $(xtarget), $(ytarget), \'!\',  1)"
                elseif !promotion && cheating
                  sql_move *= " values ($(move_num+1),\"move\", $(i), $(j), $(xtarget), $(ytarget), NULL,  1)"
                else
                  sql_move *= " values ($(move_num+1),\"move\", $(i), $(j), $(xtarget), $(ytarget), NULL,  NULL)"
                end
                stmt = SQLite.Stmt(DB, sql_move)
                SQLite.execute!(stmt)
                return
              else #if the move cannot check but can kill a opposite char, save it for compare
                if temp != " "
                  x = i
                  y = j
                  sql_move = "insert into moves(move_number,move_type, sourcex, sourcey, targetx, targety, option, i_am_cheating)"
                  if promotion && !cheating
                    sql_move *= " values ($(move_num+1),\"move\", $(x), $(y), $(xtarget), $(ytarget), \'!\',  NULL)"
                  elseif promotion && cheating
                    sql_move *= " values ($(move_num+1),\"move\", $(x), $(y), $(xtarget), $(ytarget), \'!\',  1)"
                  elseif !promotion && cheating
                    sql_move *= " values ($(move_num+1),\"move\", $(x), $(y), $(xtarget), $(ytarget), NULL,  1)"
                  else
                    sql_move *= " values ($(move_num+1),\"move\", $(x), $(y), $(xtarget), $(ytarget), NULL,  NULL)"
                  end
                  stmt = SQLite.Stmt(DB, sql_move)
                  SQLite.execute!(stmt)
                  return
                elseif (xtarget <= promote_line && promote_line <= 3) || (xtarget >= promote_line && promote_line >= 5)
                  promotion = true
                  sql_move = "insert into moves(move_number,move_type, sourcex, sourcey, targetx, targety, option, i_am_cheating)"
                  if promotion && !cheating
                    sql_move *= " values ($(move_num+1),\"move\", $(i), $(j), $(xtarget), $(ytarget), \'!\',  NULL)"
                  elseif promotion && cheating
                    sql_move *= " values ($(move_num+1),\"move\", $(i), $(j), $(xtarget), $(ytarget), \'!\',  1)"
                  elseif !promotion && cheating
                    sql_move *= " values ($(move_num+1),\"move\", $(i), $(j), $(xtarget), $(ytarget), NULL,  1)"
                  else
                    sql_move *= " values ($(move_num+1),\"move\", $(i), $(j), $(xtarget), $(ytarget), NULL,  NULL)"
                  end
                  stmt = SQLite.Stmt(DB, sql_move)
                  SQLite.execute!(stmt)
                  return
                else
                  board[i,j] = board[xtarget,ytarget]
                  board[xtarget,ytarget] = temp
                  sql_move = "insert into moves(move_number,move_type, sourcex, sourcey, targetx, targety, option, i_am_cheating)"
                  if promotion && !cheating
                    sql_move *= " values ($(move_num+1),\"move\", $(i), $(j), $(xtarget), $(ytarget), \'!\',  NULL)"
                  elseif promotion && cheating
                    sql_move *= " values ($(move_num+1),\"move\", $(i), $(j), $(xtarget), $(ytarget), \'!\',  1)"
                  elseif !promotion && cheating
                    sql_move *= " values ($(move_num+1),\"move\", $(i), $(j), $(xtarget), $(ytarget), NULL,  1)"
                  else
                    sql_move *= " values ($(move_num+1),\"move\", $(i), $(j), $(xtarget), $(ytarget), NULL,  NULL)"
                  end
                  stmt = SQLite.Stmt(DB, sql_move)
                  SQLite.execute!(stmt)
                  return
                end
              end
            end
          end
        end
      end
    end
  end
  println(x,y,x_l,y_l)
  i,j=x,y
  xtarget,ytarget = x_l,y_l
  move_char = board[i,j]
  sql_move = "insert into moves(move_number,move_type, sourcex, sourcey, targetx, targety, option, i_am_cheating)"
  if promotion && !cheating
    sql_move *= " values ($(move_num+1),\"move\", $(i), $(j), $(xtarget), $(ytarget), \'!\',  NULL)"
  elseif promotion && cheating
    sql_move *= " values ($(move_num+1),\"move\", $(i), $(j), $(xtarget), $(ytarget), \'!\',  1)"
  elseif !promotion && cheating
    sql_move *= " values ($(move_num+1),\"move\", $(i), $(j), $(xtarget), $(ytarget), NULL,  1)"
  else
    sql_move *= " values ($(move_num+1),\"move\", $(i), $(j), $(xtarget), $(ytarget), NULL,  NULL)"
  end
  stmt = SQLite.Stmt(DB, sql_move)
  SQLite.execute!(stmt)
  return
end
move(ARGS)
