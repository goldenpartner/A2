using SQLite
include("pieces.jl")
  #set up necessary variables
filename = ARGS[1]
DB = SQLite.DB(filename)
game_type = string(SQLite.query(DB,  "select * from meta where key == \"type\"")[2].values[1])
println(game_type)
game_type = game_type[10:findfirst(game_type, ')')-1]
if game_type == "minishogi"
  size = 5
  promote_line = 1
  table_type = 'M'
else
  size = 9
  promote_line = 3
  table_type = 'S'
end
seed_temp = string(SQLite.query(DB,  "select * from meta where key == \"seed\"")[2].values[1])
println(seed_temp)
seed = parse(Float64, seed_temp)
srand(int(seed))
cheating = false
color = NaN
t = string(SQLite.query(DB,"SELECT COUNT(*) FROM moves")[1][1])
temp = parse(Int, t[10:findfirst(t, ')')-1])
if temp%2 == 0
  color = 0
  color_opp = 1
else
  color = 1
  color_opp = 0
end
board, kills = getCurrentBoard(filename)
#count for the pieces on the board
self_count = MCTS.count_self(board, color, table_type)
opp_count = MCTS.count_opp(board, color, table_type)
c = 0

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
for i = 1:size
  for j = 1:size
    if board[i,j] == "k"*string(color_opp)
      k_x = i
      k_y = j
      break
    end
  end
end

if move_type == 'd'
  #make the drop
  drop_weight = -1
  drop_char = ""
  for i = 1:length(kills)
    w = get_weight_std(kills[i][1])
    if w > drop_weight
      w = drop_weight
      drop_char = string(kills[i][1])*color
    end
  end

  for i = 1:size
    for j = 1:size
      if board[i,j] == " "
        board[i,j] = drop_char
        if MCTS.check(board, k_x, k_y, color_opp)
          sql_move = "insert into move(move_type, sourcex, sourcey, targetx, targety, option, i_am_cheating)"
          sql_move += " values ($(drop_char), $(x), $(y), $(i), $(j), "d",  NULL)"
          exit(0)
        else
          board[i,j] = " "
        end
      end
    end
  end
elseif move_type == 'm'
  #make the move
  x_l = -1
  y_l = -1
  v_l=-1
  for i = 1:size
    for j = 1:size
      if board[i, j] != " " && board[i, j][2] == string(color)[1]
        moves = MCTS.getAllMoves(board[i,j],i,j,color)
        for k = 1:length(moves)
          xtarget = i+moves[k]
          ytarget = j+moves[k+1]
          temp = board[xtarget, ytarget]
          board[xtarget, ytarget] = board[i,j]
          board[i,j] = " "
          #if the move an check the opposite, do it
          if MCTS.check(board, k_x,k_y,color_opp)
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
            exit(0)
          #if the move cannot check but can kill a opposite char, save it for compare
          else
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
                move_char = board[x_l,y_l]
              end
            elseif xtarget <= promote_line
              x_pro = xtarget
              y_por = ytarget
              x = i
              y = j
              move_char = board[xtarget, ytarget]
            end
            board[i,j] = board[xtarget,ytarget]
            board[xtarget,ytarget] = temp
          end
        end
      end
    end
  end
  if x_l == -1
    x_l = x_pro
    y_l = y_pro
  end
  sql_move = "insert into move(move_type, sourcex, sourcey, targetx, targety, option, i_am_cheating)"
  if promotion && !cheating
    sql_move += " values ($(move_char), $(x), $(y), $(x_l), $(y_l), \'!\',  NULL)"
  elseif promotion && cheating
    sql_move += " values ($(move_char), $(x), $(y), $(x_l), $(y_l), \'!\',  \"Cheated\")"
  elseif !promotion && cheating
    sql_move += " values ($(move_char), $(x), $(y), $(x_l), $(y_l), NULL,  \"Cheated\")"
  else
    sql_move += " values ($(move_char), $(x), $(y), $(x_l), $(y_l), NULL,  NULL)"
  end
  stmt = SQLite.Stmt(DB, sql_move)
  SQLite.execute!(stmt)
  exit(0)
end
