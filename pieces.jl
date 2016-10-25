include("getboard.jl")
module MCTS
  module king
    allMove = [1 1 1 0 1 -1 0 1 0 -1 -1 -1 -1 0 -1 1]
    name = "k"
    value = 100
    function getmoves(board, x, y, color)
      current_x, current_y = x, y
      if color == 1
        color_opp = 0
      else
        color_opp = 1
      end
      l = convert(Int, sqrt(length(board)))
      valid = []
      for i = 1:2:16
        move_x, move_y = allMove[i], allMove[i+1]
        target_x, target_y = current_x + move_x, current_y + move_y
        if !((1<= target_x <=l) && (1<=target_y<=l))
          continue
        elseif board[target_x, target_y] == " "
          push!(valid, move_x)
          push!(valid, move_y)
        elseif board[target_x, target_y][2] == string(color_opp)[1]
          push!(valid, move_x)
          push!(valid, move_y)
        elseif board[target_x, target_y][2] == string(color)[1]
          continue
        end
      end
      return valid
    end

    function check(board, x, y, color)
      if color == 1
        color_opp = 0
        k = ()
      else
        color_opp = 1
      end
      for i = 1:size(board)[1]
        for j = 1:size(board)[2]
          if board[i,j] != " " && board[i,j][2] == '1'
            color = 1
            moves = getAllMoves(board[i,j][1], board, i,j,color_opp)
            for k = 1:2:length(moves)
              target_index = (i+moves[k], j+moves[k+1])
              if target_index == (x, y)
                return true
              end
            end
          end
        end
      end
      return false
    end
  end
  module rook
    allMove = [1 0 -1 0 0 1 0 -1]
    name = "r"
    value = 9
    function getmoves(board, x, y, color)
      current_x, current_y = x, y
      if color == 1
        color_opp = 0
      else
        color_opp = 1
      end
      l = convert(Int, sqrt(length(board)))
      valid = []
      for j = 1:2:length(allMove)
        dir = 1
        move_x, move_y = allMove[j], allMove[j+1]
        target_x = current_x+move_x*dir
        target_y = current_y+move_y*dir
        while (1<= target_x <=l) && (1<=target_y<=l)
          if board[target_x, target_y] == " "
            push!(valid, move_x*dir)
            push!(valid, move_y*dir)
          elseif board[target_x, target_y][2] == string(color_opp)[1]
            push!(valid, move_x*dir)
            push!(valid, move_y*dir)
            break
          elseif board[target_x, target_y][2] == string(color)[1]
            break
          end
          dir += 1
          target_x = current_x+move_x*dir
          target_y = current_y+move_y*dir
        end
      end
      return valid
    end
  end

  module Rook
    allMove = [1 0 -1 0 0 1 0 -1 1 1 1 -1 -1 1 -1 -1]
    name = "R"
    value = 13
    function getmoves(board, x, y, color)
      current_x, current_y = x, y
      if color == 1
        color_opp = 0
      else
        color_opp = 1
      end
      l = convert(Int, sqrt(length(board)))
      valid = []
      for j = 1:2:8
        dir = 1
        move_x, move_y = allMove[j], allMove[j+1]
        target_x = current_x+move_x*dir
        target_y = current_y+move_y*dir
        while (1<= target_x <=l) && (1<=target_y<=l)
          if board[target_x, target_y] == " "
            push!(valid, move_x*dir)
            push!(valid, move_y*dir)
          elseif board[target_x, target_y][2] == string(color_opp)[1]
            push!(valid, move_x*dir)
            push!(valid, move_y*dir)
            break
          elseif board[target_x, target_y][2] == string(color)[1]
            break
          end
          dir += 1
          target_x = current_x+move_x*dir
          target_y = current_y+move_y*dir
        end
      end
      for i = 9:2:16
        move_x, move_y = allMove[i], allMove[i+1]
        target_x, target_y = current_x + move_x, current_y + move_y
        if !((1<= target_x <=l) && (1<=target_y<=l))
          continue
        elseif board[target_x, target_y] == " "
          push!(valid, move_x)
          push!(valid, move_y)
        elseif board[target_x, target_y][2] == string(color_opp)[1]
          push!(valid, move_x)
          push!(valid, move_y)
          break
        elseif board[target_x, target_y][2] == string(color)[1]
          continue
        end
      end
      return valid
    end
  end

  module bishop
    allMove = [1 1 1 -1 -1 1 -1 -1]
    name = "b"
    value = 8
    function getmoves(board, x, y, color)
      current_x, current_y = x, y
      if color == 1
        color_opp = 0
      else
        color_opp = 1
      end
      l = convert(Int, sqrt(length(board)))
      valid = []
      for j = 1:2:length(allMove)
        dir = 1
        move_x, move_y = allMove[j], allMove[j+1]
        target_x = current_x+move_x*dir
        target_y = current_y+move_y*dir
        while (1<= target_x <=l) && (1<=target_y<=l)
          if board[target_x, target_y] == " "
            push!(valid, move_x*dir)
            push!(valid, move_y*dir)
          elseif board[target_x, target_y][2] == string(color_opp)[1]
            push!(valid, move_x*dir)
            push!(valid, move_y*dir)
            break
          elseif board[target_x, target_y][2] == string(color)[1]
            break
          end
          dir += 1
          target_x = current_x+move_x*dir
          target_y = current_y+move_y*dir
        end
      end
      return valid
    end
  end

  module Bishop
    allMove = [1 1 1 -1 -1 1 -1 -1 0 1 0 -1 1 0 -1 0]
    name = "B"
    value = 12
    function getmoves(board, x, y, color)
      current_x, current_y = x, y
      if color == 1
        color_opp = 0
      else
        color_opp = 1
      end
      l = convert(Int, sqrt(length(board)))
      valid = []
      for j = 1:2:8
        dir = 1
        move_x, move_y = allMove[j], allMove[j+1]
        target_x = current_x+move_x*dir
        target_y = current_y+move_y*dir
        while (1<= target_x <=l) && (1<=target_y<=l)
          if board[target_x, target_y] == " "
            push!(valid, move_x*dir)
            push!(valid, move_y*dir)
          elseif board[target_x, target_y][2] == string(color_opp)[1]
            push!(valid, move_x*dir)
            push!(valid, move_y*dir)
            break
          elseif board[target_x, target_y][2] == string(color)[1]
            break
          end
          dir += 1
          target_x = current_x+move_x*dir
          target_y = current_y+move_y*dir
        end
      end
      for i = 9:2:16
        move_x, move_y = allMove[i], allMove[i+1]
        target_x, target_y = current_x + move_x, current_y + move_y
        if !((1<= target_x <=l) && (1<=target_y<=l))
          continue
        elseif board[target_x, target_y] == " "
          push!(valid, move_x)
          push!(valid, move_y)
        elseif board[target_x, target_y][2] == string(color_opp)[1]
          push!(valid, move_x)
          push!(valid, move_y)
          break
        elseif board[target_x, target_y][2] == string(color)[1]
          continue
        end
      end
      return valid
    end
  end

  module Gold_General
    allmove_w = [1 0 -1 0 0 1 0 -1 1 1 1 -1]
    allmove_b = [-1 0 -1 -1 -1 1 0 1 0 -1 1 0]
    name = "g"
    value = 5
    function getmoves(board, x, y, color)
      current_x, current_y = x, y
      if color == 1
        color_opp = 0
        allMove = allmove_b
      else
        color_opp = 1
        allMove = allmove_w
      end
      l = convert(Int, sqrt(length(board)))
      valid = []
      for i = 1:2:length(allMove)
        move_x, move_y = allMove[i], allMove[i+1]
        target_x, target_y = current_x + move_x, current_y + move_y
        if !((1<= target_x <=l) && (1<=target_y<=l))
          continue
        elseif board[target_x, target_y] == " "
          push!(valid, move_x)
          push!(valid, move_y)
        elseif board[target_x, target_y][2] == string(color_opp)[1]
          push!(valid, move_x)
          push!(valid, move_y)
        elseif board[target_x, target_y][2] == string(color)[1]
          continue
        end
      end
      return valid
    end
  end

  module silver_General
    allmove_w = [1 1 1 0 1 -1 -1 -1 -1 1]
    allmove_b = [-1 0 -1 -1 -1 1 1 -1 1 1]
    name = "s"
    value = 5
    function getmoves(board, x, y, color)
      current_x, current_y = x, y
      if color == 1
        color_opp = 0
        allMove = allmove_b
      else
        color_opp = 1
        allMove = allmove_w
      end
      l = convert(Int, sqrt(length(board)))
      valid = []
      for i = 1:2:length(allMove)
        move_x, move_y = allMove[i], allMove[i+1]
        target_x, target_y = current_x + move_x, current_y + move_y
        if !((1<= target_x <=l) && (1<=target_y<=l))
          continue
        elseif board[target_x, target_y] == " "
          push!(valid, move_x)
          push!(valid, move_y)
        elseif board[target_x, target_y][2] == string(color_opp)[1]
          push!(valid, move_x)
          push!(valid, move_y)
        elseif board[target_x, target_y][2] == string(color)[1]
          continue
        end
      end
      return valid
    end
  end

  module Silver_General
    allmove_w = [1 0 -1 0 0 1 0 -1 1 1 1 -1]
    allmove_b = [-1 0 -1 -1 -1 1 0 1 0 -1 1 0]
    name = "g"
    value = 5
    function getmoves(board, x, y, color)
      current_x, current_y = x, y
      if color == 1
        color_opp = 0
        allMove = allmove_b
      else
        color_opp = 1
        allMove = allmove_w
      end
      l = convert(Int, sqrt(length(board)))
      valid = []
      for i = 1:2:length(allMove)
        move_x, move_y = allMove[i], allMove[i+1]
        target_x, target_y = current_x + move_x, current_y + move_y
        if !((1<= target_x <=l) && (1<=target_y<=l))
          continue
        elseif board[target_x, target_y] == " "
          push!(valid, move_x)
          push!(valid, move_y)
        elseif board[target_x, target_y][2] == string(color_opp)[1]
          push!(valid, move_x)
          push!(valid, move_y)
        elseif board[target_x, target_y][2] == string(color)[1]
          continue
        end
      end
      return valid
    end
  end

  module knight
    allmove_w = [2 -1 2 1]
    allmove_b = [-2 1 -2 -1]
    name = "n"
    value = 3
    function getmoves(board, x, y, color)
      current_x, current_y = x, y
      if color == 1
        color_opp = 0
        allMove = allmove_b
      else
        color_opp = 1
        allMove = allmove_w
      end
      l = convert(Int, sqrt(length(board)))
      valid = []
      for i = 1:2:length(allMove)
        move_x, move_y = allMove[i], allMove[i+1]
        target_x, target_y = current_x + move_x, current_y + move_y
        if !((1<= target_x <=l) && (1<=target_y<=l))
          continue
        elseif board[target_x, target_y] == " "
          push!(valid, move_x)
          push!(valid, move_y)
        elseif board[target_x, target_y][2] == string(color_opp)[1]
          push!(valid, move_x)
          push!(valid, move_y)
        elseif board[target_x, target_y][2] == string(color)[1]
          continue
        end
      end
      return valid
    end
  end

  module Knight
    allmove_w = [1 0 -1 0 0 1 0 -1 1 1 1 -1]
    allmove_b = [-1 0 -1 -1 -1 1 0 1 0 -1 1 0]
    name = "g"
    value = 5
    function getmoves(board, x, y, color)
      current_x, current_y = x, y
      if color == 1
        color_opp = 0
        allMove = allmove_b
      else
        color_opp = 1
        allMove = allmove_w
      end
      l = convert(Int, sqrt(length(board)))
      valid = []
      for i = 1:2:length(allMove)
        move_x, move_y = allMove[i], allMove[i+1]
        target_x, target_y = current_x + move_x, current_y + move_y
        if !((1<= target_x <=l) && (1<=target_y<=l))
          continue
        elseif board[target_x, target_y] == " "
          push!(valid, move_x)
          push!(valid, move_y)
        elseif board[target_x, target_y][2] == string(color_opp)[1]
          push!(valid, move_x)
          push!(valid, move_y)
        elseif board[target_x, target_y][2] == string(color)[1]
          continue
        end
      end
      return valid
    end
  end

  module lance
    allmove_w = [1 0]
    allmove_b = [-1 0]
    name = "l"
    value = 3
    function getmoves(board, x, y, color)
      current_x, current_y = x, y
      if color == 1
        color_opp = 0
        allMove = allmove_b
      else
        color_opp = 1
        allMove = allmove_w
      end
      l = convert(Int, sqrt(length(board)))
      valid = []
      for i = 1:2:length(allMove)
        move_x, move_y = allMove[i], allMove[i+1]
        target_x, target_y = current_x + move_x, current_y + move_y
        if !((1<= target_x <=l) && (1<=target_y<=l))
          continue
        elseif board[target_x, target_y] == " "
          push!(valid, move_x)
          push!(valid, move_y)
        elseif board[target_x, target_y][2] == string(color_opp)[1]
          push!(valid, move_x)
          push!(valid, move_y)
        elseif board[target_x, target_y][2] == string(color)[1]
          continue
        end
      end
      return valid
    end
  end

  module Lance
    allmove_w = [1 0 -1 0 0 1 0 -1 1 1 1 -1]
    allmove_b = [-1 0 -1 -1 -1 1 0 1 0 -1 1 0]
    name = "g"
    value = 5
    function getmoves(board, x, y, color)
      current_x, current_y = x, y
      if color == 1
        color_opp = 0
        allMove = allmove_b
      else
        color_opp = 1
        allMove = allmove_w
      end
      l = convert(Int, sqrt(length(board)))
      valid = []
      for i = 1:2:length(allMove)
        move_x, move_y = allMove[i], allMove[i+1]
        target_x, target_y = current_x + move_x, current_y + move_y
        if !((1<= target_x <=l) && (1<=target_y<=l))
          continue
        elseif board[target_x, target_y] == " "
          push!(valid, move_x)
          push!(valid, move_y)
        elseif board[target_x, target_y][2] == string(color_opp)[1]
          push!(valid, move_x)
          push!(valid, move_y)
        elseif board[target_x, target_y][2] == string(color)[1]
          continue
        end
      end
      return valid
    end
  end

  module pawn
    allmove_w = [1 0]
    allmove_b = [-1 0]
    name = "p"
    value = 1
    function getmoves(board, x, y, color)
      if color == 1
        color_opp = 0
        allMove = allmove_b
      else
        color_opp = 1
        allMove = allmove_w
      end
      l = convert(Int, sqrt(length(board)))
      valid = []
      target_x= x+allMove[1]
      if board[target_x, y] == " "
        push!(valid, allMove[1])
        push!(valid, 0)
      elseif board[target_x, y][2] == string(color_opp)[1]
        push!(valid, allMove[1])
        push!(valid, 0)
      end
      return valid
    end
  end

  module Pawn
    allmove_w = [1 0 -1 0 0 1 0 -1 1 1 1 -1]
    allmove_b = [-1 0 -1 -1 -1 1 0 1 0 -1 1 0]
    name = "g"
    value = 5
    function getmoves(board, x, y, color)
      current_x, current_y = x, y
      if color == 1
        color_opp = 0
        allMove = allmove_b
      else
        color_opp = 1
        allMove = allmove_w
      end
      l = convert(Int, sqrt(length(board)))
      valid = []
      for i = 1:2:length(allMove)
        move_x, move_y = allMove[i], allMove[i+1]
        target_x, target_y = current_x + move_x, current_y + move_y
        if !((1<= target_x <=l) && (1<=target_y<=l))
          continue
        elseif board[target_x, target_y] == " "
          push!(valid, move_x)
          push!(valid, move_y)
        elseif board[target_x, target_y][2] == string(color_opp)[1]
          push!(valid, move_x)
          push!(valid, move_y)
        elseif board[target_x, target_y][2] == string(color)[1]
          continue
        end
      end
      return valid
    end
  end
  function getValue(DB, sql)
    temp = string(SQLite.query(DB, sql)[1][1])
    value = temp[10:findfirst(temp, ')')-1]
    return value
  end

  function count_self(table, color, table_type)
    println(table)
    count = 0
    if table_type == 'S'
      size = 9
    else
      size = 5
    end
    for i = 1:size
      for j = 1:size
        if table[(i-1)*size+j] == " "
          continue
        elseif table[(i-1)*size+j][2] == string(color)[1]
          count += 1
        end
      end
    end
    return count
  end
  function count_opp(table, color, table_type)
    if color == '1'
      return count_self(table, '0', table_type)
    else
      return count_self(table, '1', table_type)
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
          deleteat!(own, findfirst(own, lowercase(string(board[i, j][1]))))
        end
      end
    end
    return own
  end

  function get_range(board, color, size)
    arr1 = Array{Tuple}(0)
    arr2 = Array{Tuple}(0)
    if color == 1
      color_opp = 0
    else
      color_opp = 1
    end
    for i = 1:size
      for j = 1:size
        if board[i, j][2] == string(color)
          push!(arr1, (i, j))
          moves = getAllMoves(board[i, j], board, i, j)
          for k = 1:2:length(moves)
            if board[i+moves[k], j+moves[k+1]] == " " || board[i+moves[k], j+moves[k+1]][2] == string(color_opp)
              push!(arr2, (i+move[k], j+move[k+1]))
            end
          end
        end
      end
    end
    return arr1, arr2
  end

  function get_weight_pro(char)
    if char == 'P'
      w = pawn.value
    elseif char == 'B'
      w = bishop.value
    elseif char == 'G'
      w = gold_general.value
    elseif char == 'K'
      w = king.value
    elseif char == 'L'
      w = lance.value
    elseif char == 'N'
      w = knight.value
    elseif char == 'R'
      w = rook.value
    elseif char == 'S'
      w = silver_General.value
    end
    return w
  end
  function get_weight_std(char)
    if char == 'p'
      w = pawn.value
    elseif char == 'b'
      w = bishop.value
    elseif char == 'g'
      w = gold_general.value
    elseif char == 'k'
      w = king.value
    elseif char == 'l'
      w = lance.value
    elseif char == 'n'
      w = knight.value
    elseif char == 'r'
      w = rook.value
    elseif char == 's'
      w = silver_General.value
    end
    return w
  end
  function count_weight(board, color, size)
    weight = 0
    for i = 1:size
      for j = 1:size
        if board[i,j][2] == string(color)
          if isupper(board[i,j])
            w = get_weight_pro(board[i, j][1])
          else
            w = get_weight_std(board[i, j][1])
          end
            weight += w
        end
      end
    end
    return weight
  end

  function getAllMoves(char, board, x, y, color)
    if isupper(char[1])
      return getMovePro(char, board, x, y, color)
    else
      return getMoveStd(char, board, x, y, color)
    end
  end
  function getMoveStd(char, board, x, y, color)
    name = char[1]
    if name == 'p'
      return pawn.getmoves(board, x, y, color)
    elseif name == 'b'
      return bishop.getmoves(board, x, y, color)
    elseif name == 'g'
      return Gold_General.getmoves(board, x, y, color)
    elseif name == 'k'
      return king.getmoves(board, x, y, color)
    elseif name == 'l'
      return lance.getmoves(board, x, y, color)
    elseif name == 'n'
      return knight.getmoves(board, x, y,color)
    elseif name == 'r'
      return rook.getmoves(board, x, y,color)
    elseif name == 's'
      return silver_General.getmoves(board, x, y, color)
    end
  end
  function getMovePro(char, board, x, y,color)
    name = char[1]
    if name == 'p'
      return Pawn.getmoves(board, x, y,color)
    elseif name == 'B'
      return Bishop.getmoves(board, x, y,color)
    elseif name == 'L'
      return Lance.getmoves(board, x, y,color)
    elseif name == 'N'
      return  Knight.getmoves(board, x, y,color)
    elseif name == 'R'
      return Rook.getmoves(board, x, y,color)
    elseif name == 'S'
      return Silver_General.getmoves(board, x, y,color)
    end
  end
end
