using SQLite
include("pieces.jl")
using MCTS
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
global v_l=-1
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

t = string(SQLite.query(DB,"SELECT COUNT(*) FROM moves")[1][1])
move_num = parse(Int, t[10:findfirst(t, ')')-1])
if move_num%2 == 0
  color = 0
  color_opp = 1
else
  color = 1
  color_opp = 0
end
board, kills = getCurrentBoard(filename)

board[5,1] = uppercase(board[5,1])
#count for the pieces on the board

self_count = MCTS.count_self(board, color, table_type)
opp_count = MCTS.count_opp(board, color, table_type)

#setup variables

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
elseif choose_move < 700
  move_type = 'm'
else
  if length(kills) == 0
    move_type = 'm'
  else
    move_type = 'd'
  end
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

if move_type == 'd' #make the drop
  drop_weight = -1
  drop_char = ""
  count = 0
  #count how many pawns we have on the board
  for i = 1:size
    for j = 1:size
      if board[i, j][1] == 'p'
        count += 1
      end
    end
  end
  #decide if AI can drop a pawn somewhere
  if count == size
    drop_pawn = false
  else
    drop_pawn = true
  end
  #select a piece
  for i = 1:length(kills)
    w = MCTS.get_weight_std(kills[i][1])
    if w > drop_weight
      drop_weight = w
      drop_char = string(kills[i][1])*string(color)
    end
  end
  #decide drop or choose to move instead
  if drop_char == "p"*string(color) && !drop_pawn
    move_type = 'm'
  elseif (drop_char != "p"*string(color)) || (drop_char == "p"*string(color) && drop_pawn)
    for i = 1:size
      for j = 1:size
        if board[i,j] == " "
          board[i,j] = drop_char
          if MCTS.check(board, k_x, k_y, color_opp)
            sql_move = "insert into moves(move_type, sourcex, sourcey, targetx, targety, option, i_am_cheating)"
            sql_move *= " values ($(move_num+1),\"drop\", -1, -1, $(i), $(j), \"d\",  NULL)"
            return
          else
            board[i,j] = " "
          end
        end
      end
    end
  end
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
                if isupper(temp[1])
                  v = MCTS.get_weight_pro(temp[1])
                else
                  v = MCTS.get_weight_std(temp[1])
                end
                if v > v_l
                  v_l = v
                  x_l = xtarget
                  y_l = ytarget
                  move_char = board[xtarget, ytarget]
                end
              elseif xtarget <= promote_line
                x_pro = xtarget
                y_pro = ytarget
                x = i
                y = j
                move_char = board[xtarget, ytarget]
                promotion = true
              end
              board[i,j] = board[xtarget,ytarget]
              board[xtarget,ytarget] = temp
            end
          end
        end
      end
    end
  end
  if x_l == -1
    x_l = x_pro
    y_l = y_pro
  end
  sql_move = "insert into moves(move_number,move_type, sourcex, sourcey, targetx, targety, option, i_am_cheating)"
  if promotion && !cheating
    sql_move *= " values ($(move_num+1),\"move\", $(x), $(y), $(x_l), $(y_l), \'!\',  NULL)"
  elseif promotion && cheating
    sql_move *= " values ($(move_num+1),\"move\", $(x), $(y), $(x_l), $(y_l), \'!\',  1)"
  elseif !promotion && cheating
    sql_move *= " values ($(move_num+1),\"move\", $(x), $(y), $(x_l), $(y_l), NULL,  1)"
  else
    sql_move *= " values ($(move_num+1),\"move\", $(x), $(y), $(x_l), $(y_l), NULL,  NULL)"
  end
  stmt = SQLite.Stmt(DB, sql_move)
  SQLite.execute!(stmt)
  return
end
