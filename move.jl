using SQLite
include("display.jl")
include("pieces.jl")
module MCTS
  function count_self(table)
    count = 0
    if table.Type == "S"
      for i = 1:9
        for j = 1:9
          if table.temp_standard[i][j][2] == '1'
            count += 1
          end
        end
      end
    else
      for i = 1:9
        for j = 1:9
          if table.temp_mini[i][j][2] == '1'
            count += 1
          end
        end
      end
    end
    return count
  end
  function count_opp(table)
    count = 0
    if table.Type == "S"
      for i = 1:9
        for j = 1:9
          if table.temp_standard[i][j][2] == '0'
            count += 1
          end
        end
      end
    else
      for i = 1:9
        for j = 1:9
          if table.temp_mini[i][j][2] == '0'
            count += 1
          end
        end
      end
    end
    return count
  end
  function move(filename)
    DB = SQLite.DB(fliename)
    game_type = SQLite.execute!(DB,  "select * from meta where key == \"type\"")
    cheat = SQLite.execute!(DB,  "select * from meta where key == \"legality\"")
    seed = SQLite.execute!(DB,  "select * from meta where key == \"seed\"")
    cheating = false
    #Choose one character to move randomly
    source_x::Int
    source_y::Int
    xtarget::Int
    ytarget::Int

    source_x = NaN
    source_y = NaN
    move_type = ''
    kills = []
    choose_move = rand(1:1000)
    if choose_move < 10
      println("Computer resigned! The other player wins!")
      println("Exit in 5 second")
      sleep(5)
      exit(0)
       move_type = 'd'
      source_x = -1
      source_y = -1
    else
      move_type = 'm'
    end

    self_count = count_self(table)
    opp_count = count_opp(table)
    c = 0
    if move_type == 'd'
      piece_num = rand(1,length(table.kill))
      piece = table.kill[piece_num]
      if table.Type == "S"
        target_index = rand(1, 81-self_count-opp_count)
        for i = 1:81
          if table.temp_standard[i] == " "
            c += 1
          end
          if c == target_index
            table.temp_standard[i] = piece*"0"
            xtarget = convert(Int, ceil(i / 9))
            ytarget = i % 9
            sql_drop = "insert into move(move_type, sourcex, sourcey, targetx, targety, option, i_am_cheating)"
            sql_drop += " values (drop, -1, -1, $(xtarget), $(ytarget), piece, NULL)"
            stmt = SQLite.Stmt(DB, sql_drop)
            SQLite.execute!(stmt)
            return
          end
        end
      else
        target_index = rand(1,25-self_count-opp_count)
        for i = 1:25
          if table.temp_standard[i] == " "
            c += 1
          end
          if c == target_index
            table.temp_standard[i] = piece
            xtarget = convert(Int, ceil(i / 5))
            ytarget = i % 5
            sql_drop = "insert into move(move_type, sourcex, sourcey, targetx, targety, option, i_am_cheating)"
            sql_drop += " values (drop, -1, -1, $(xtarget), $(ytarget), piece, NULL)"
            stmt = SQLite.Stmt(DB, sql_drop)
            SQLite.execute!(stmt)
            return
          end
        end
      end
    elseif move_type == 'm'
      piece_num = rand(1,self_count)
      if table.Type == "S"
        for i = 1:81
          if table.temp_standard[i][2] == '0'
            c += 1
          end
          if c == piece_num
            move_char = table.temp_standard[i]
            break
          end
        end
        moves = getAllMoves(moveChar, table.temp_standard, x, y)
        x = convert(Int, ceil(i/9))
        y = i % 9
        rand_move = rand(1:length(moves))
        xtarget = x + moves[rand_move][1]
        ytarget = y + moves[rand_move][2]
        table.temp_standard[(x-1)*9+y] = table.temp_standard[(xtarget-1)*9+ytarget]*"0"
        table.temp_standard[(x-1)*9+y] = " "
        if ytarget <= 3
          table.temp_standard[(xtarget-1)*9+ytarget] = uppercase(table.temp_standard[(xtarget-1)*9+ytarget])
          promotion = true
        end
      else
        for i = 1:25
          if table.temp_standard[i][2] == '0'
            c += 1
          end
          if c == piece_num
            move_char = table.temp_standard[i]
            break
          end
        end
        moves = getAllMoves(moveChar, table.temp_standard, x, y)
        x = convert(Int, ceil(i/5))
        y = i % 5
        rand_move = rand(1:length(moves))
        xtarget = x + moves[rand_move][1]
        ytarget = y + moves[rand_move][2]
        table.temp_standard[(x-1)*5+y] = table.temp_standard[(xtarget-1)*5+ytarget]*"0"
        table.temp_standard[(x-1)*5+y] = " "
        if ytarget <= 2
          table.temp_standard[(xtarget-1)*5+ytarget] = uppercase(table.temp_standard[(xtarget-1)*5+ytarget])
          promotion = true
        end
      end
    end

    sql_move = "insert into move(move_type, sourcex, sourcey, targetx, targety, option, i_am_cheating)"
    if promotion && !cheating
      sql_move += " values ($(move_char), $(x), $(y), $(xtarget), $(ytarget), \'!\',  NULL)"
    elseif promotion and cheating
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
end
