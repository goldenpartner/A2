module king
  allMove = [[1 1]; [1 0]; [0 1]; [-1 -1]; [-1 0]; [0 -1]; [1 -1]; [-1 1]]
  name = "k"
  value = 100
  function getmoves(board, x, y)
    current_pos = [x, y]
    l = convert(Int, sqrt(length(board)))
    valid = []
    for i = 1:2:16
      move = [allMove[i], allMove[i+1]]
      target = current_pos + move
      if (target[1] > l || target[1] < 1) || (target[2] > l || target[2] < 1)
        continue
      elseif board[(target[1]-1)*l + target[2]] == " "
        push!(valid, allMove[i])
        push!(valid, allMove[i+1])
      elseif board[(target[1]-1)*l + target[2]][2] == '1'
        push!(valid, allMove[i])
        push!(valid, allMove[i+1])
      end
    end
    return valid
  end
end

module rook
  allmove = [[1, 0], [-1, 0], [0, 1], [0, -1]]
  name = "r"
  value = 9
  function getmoves(board, x, y)
    current_pos = [x, y]
    l = convert(Int, sqrt(length(board)))
    valid = []
    for j = 1:2:8
      move = [allMove[j], allMove[j+1]]
      move_x = move[1]
      move_y = move[2]
      if move_y == 0
        if move_x == 1
          for i = x:l
            target = current_pos + move*(i-x)
            if ((target[1]-1)*l + target[2] > l) || ((target[1]-1)*l + target[2] < 1)
              continue
            else if board[(target[1]-1)*l + target[2]] == " "
              push!(valid, move_x*(i-x))
              push!(valid, 0)
            else if board[(target[1]-1)*l + target[2]] == '1'
              push!(valid, move_x*(i-x))
              push!(valid, 0)
              break
            end
          end
        elseif move_x == -1
          for i = x:-1:1
            target = current_pos + move*(x-i)
            if ((target[1]-1)*l + target[2] > l) || ((target[1]-1)*l + target[2] < 1)
              continue
            else if board[(target[1]-1)*l + target[2]] == " "
              push!(valid, move_x*(x-i))
              push!(valid, 0)
            else if board[(target[1]-1)*l + target[2]] == '1'
              push!(valid, move_x*()x-i)
              push!(valid, 0)
              break
            end
           end
          end
        else
          if move_y == 1
            for i = y:l
              target = current_pos + move*(i-y)
              if ((target[1]-1)*l + target[2] > l) || ((target[1]-1)*l + target[2] < 1)
                continue
              else if board[(target[1]-1)*l + target[2]] == " "
                push!(valid, 0)
                push!(valid, move_y*(i-y))
              else if board[(target[1]-1)*l + target[2]] == '1'
                push!(valid, 0)
                push!(valid, move_y*(i-y))
                break
              end
            end
          elseif move_y == -1
            for i = y:-1:1
              target = current_pos + move*(y-i)
              if ((target[1]-1)*l + target[2] > l) || ((target[1]-1)*l + target[2] < 1)
                continue
              else if board[(target[1]-1)*l + target[2]] == " "
                push!(valid, 0)
                push!(valid, move_y*(y-i))
              else if board[(target[1]-1)*l + target[2]] == '1'
                push!(valid, 0)
                push!(valid, move_y*(y-i))
                break
              end
             end
          end
        end
    end
    return valid
  end
end

module Rook
  allmove = [[1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [1, -1], [-1, 1], [-1, -1]]
  name = "R"
  value = 13
  function getmoves(board, x, y)
    current_pos = [x, y]
    l = convert(Int, sqrt(length(board)))
    valid = []
    for j = 1:2:8
      move = [allMove[j], allMove[j+1]]
      move_x = move[1]
      move_y = move[2]
      for i = 1:l
        target = current_pos + move*i
        if (target[1] > l || target[1] < 1) || (target[2] > l || target[2] < 1)
          break
        else if board[(target[1]-1)*l + target[2]] == " "
          push!(valid, move_x*(i-x))
          push!(valid, 0)
        else if board[(target[1]-1)*l + target[2]] == '1'
          push!(valid, move_x*(i-x))
          push!(valid, 0)
          break
        end
      end
    end
    for i = 9:2:16
      move = [allMove[i], allMove[i+1]]
      target = current_pos + move
      if (target[1] > l || target[1] < 1) || (target[2] > l || target[2] < 1)
        continue
      elseif board[(target[1]-1)*l + target[2]] == " "
        push!(valid, allMove[i])
        push!(valid, allMove[i+1])
      elseif board[(target[1]-1)*l + target[2]][2] == '1'
        push!(valid, allMove[i])
        push!(valid, allMove[i+1])
      end
    end
    return valid
  end
end

module bishop
  allmove = [[1, 1], [1, -1], [-1, 1], [-1, -1]]
  name = "b"
  value = 8
  function getmoves(board, x, y)
    current_pos = [x, y]
    l = convert(Int, sqrt(length(board)))
    valid = []
    for j = 1:2:8
      move = [allMove[j], allMove[j+1]]
      move_x = move[1]
      move_y = move[2]
      for i = 1:l
        target = current_pos + move*i
        if (target[1] > l || target[1] < 1) || (target[2] > l || target[2] < 1)
          continue
        else if board[(target[1]-1)*l + target[2]] == " "
          push!(valid, move_x*(i-x))
          push!(valid, 0)
        else if board[(target[1]-1)*l + target[2]] == '1'
          push!(valid, move_x*(i-x))
          push!(valid, 0)
          break
        end
      end
    end
  end
end

module Bishop
  allmove = [[1, 1], [1, -1], [-1, 1], [-1, -1], [0, 1], [0, -1], [1, 0], [-1, 0]]
  name = "B"
  value = 12
  function getmoves(board, x, y)
    current_pos = [x, y]
    l = convert(Int, sqrt(length(board)))
    valid = []
    for j = 1:2:8
      move = [allMove[j], allMove[j+1]]
      move_x = move[1]
      move_y = move[2]
      for i = 1:l
        target = current_pos + move*i
        if (target[1] > l || target[1] < 1) || (target[2] > l || target[2] < 1)
          break
        else if board[(target[1]-1)*l + target[2]] == " "
          push!(valid, move_x*(i-x))
          push!(valid, 0)
        else if board[(target[1]-1)*l + target[2]] == '1'
          push!(valid, move_x*(i-x))
          push!(valid, 0)
          break
        end
      end
    end
    for i = 9:2:16
      move = [allMove[i], allMove[i+1]]
      target = current_pos + move
      if (target[1] > l || target[1] < 1) || (target[2] > l || target[2] < 1)
        continue
      elseif board[(target[1]-1)*l + target[2]] == " "
        push!(valid, allMove[i])
        push!(valid, allMove[i+1])
      elseif board[(target[1]-1)*l + target[2]][2] == '1'
        push!(valid, allMove[i])
        push!(valid, allMove[i+1])
      end
    end
  end
end

module Gold_General
  allmove = [[1,1], [1,0], [1,-1], [0,1], [0,-1], [-1, 0]]
  name = "g"
  value = 5
  function getmoves(board, x, y)
    current_pos = [x, y]
    l = convert(Int, sqrt(length(board)))
    valid = []
    for i = 1:2:16
      move = [allMove[i], allMove[i+1]]
      target = current_pos + move
      if (target[1] > l || target[1] < 1) || (target[2] > l || target[2] < 1)
        continue
      elseif board[(target[1]-1)*l + target[2]] == " "
        push!(valid, allMove[i])
        push!(valid, allMove[i+1])
      elseif board[(target[1]-1)*l + target[2]][2] == '1'
        push!(valid, allMove[i])
        push!(valid, allMove[i+1])
      end
    end
    return valid
  end
end

module silver_General
  allmove = [[1,1], [1,0], [1,-1], [-1, -1], [-1, 1]]
  name = "s"
  value = 5
  function getmoves(board, x, y)
    current_pos = [x, y]
    l = convert(Int, sqrt(length(board)))
    valid = []
    for i = 1:2:16
      move = [allMove[i], allMove[i+1]]
      target = current_pos + move
      if (target[1] > l || target[1] < 1) || (target[2] > l || target[2] < 1)
        continue
      elseif board[(target[1]-1)*l + target[2]] == " "
        push!(valid, allMove[i])
        push!(valid, allMove[i+1])
      elseif board[(target[1]-1)*l + target[2]][2] == '1'
        push!(valid, allMove[i])
        push!(valid, allMove[i+1])
      end
    end
    return valid
  end
end

module Silver_General
  allmove = [[1,1], [1,0], [1,-1], [0,1], [0,-1], [-1, 0]]
  name = "S"
  value = 5
  function getmoves(board, x, y)
    current_pos = [x, y]
    l = convert(Int, sqrt(length(board)))
    valid = []
    for i = 1:2:16
      move = [allMove[i], allMove[i+1]]
      target = current_pos + move
      if (target[1] > l || target[1] < 1) || (target[2] > l || target[2] < 1)
        continue
      elseif board[(target[1]-1)*l + target[2]] == " "
        push!(valid, allMove[i])
        push!(valid, allMove[i+1])
      elseif board[(target[1]-1)*l + target[2]][2] == '1'
        push!(valid, allMove[i])
        push!(valid, allMove[i+1])
      end
    end
    return valid
  end
end

module knight
  allmove = [[2, -1], [2, 1]]
  name = "n"
  value = 3
  function getmoves(board, x, y)
    current_pos = [x, y]
    l = convert(Int, sqrt(length(board)))
    valid = []
    for i = 1:2:16
      move = [allMove[i], allMove[i+1]]
      target = current_pos + move
      if (target[1] > l || target[1] < 1) || (target[2] > l || target[2] < 1)
        continue
      elseif board[(target[1]-1)*l + target[2]] == " "
        push!(valid, allMove[i])
        push!(valid, allMove[i+1])
      elseif board[(target[1]-1)*l + target[2]][2] == '1'
        push!(valid, allMove[i])
        push!(valid, allMove[i+1])
      end
    end
    return valid
  end
end

module Knight
  allmove = [[1,1], [1,0], [1,-1], [0,1], [0,-1], [-1, 0]]
  name = "N"
  value = 5
  function getmoves(board, x, y)
    current_pos = [x, y]
    l = convert(Int, sqrt(length(board)))
    valid = []
    for i = 1:2:16
      move = [allMove[i], allMove[i+1]]
      target = current_pos + move
      if (target[1] > l || target[1] < 1) || (target[2] > l || target[2] < 1)
        continue
      elseif board[(target[1]-1)*l + target[2]] == " "
        push!(valid, allMove[i])
        push!(valid, allMove[i+1])
      elseif board[(target[1]-1)*l + target[2]][2] == '1'
        push!(valid, allMove[i])
        push!(valid, allMove[i+1])
      end
    end
    return valid
  end
end

module lance
  allmove = [[1, 0]]
  name = "l"
  value = 3
  function getmoves(board, x, y)
    current_pos = [x, y]
    l = convert(Int, sqrt(length(board)))
    valid = []
    for i = 1:2:16
      move = [allMove[i], allMove[i+1]]
      target = current_pos + move
      if (target[1] > l || target[1] < 1) || (target[2] > l || target[2] < 1)
        continue
      elseif board[(target[1]-1)*l + target[2]] == " "
        push!(valid, allMove[i])
        push!(valid, allMove[i+1])
      elseif board[(target[1]-1)*l + target[2]][2] == '1'
        push!(valid, allMove[i])
        push!(valid, allMove[i+1])
      end
    end
    return valid
  end
end

module Lance
  allmove = [[1,1], [1,0], [1,-1], [0,1], [0,-1], [-1, 0]]
  name = "L"
  value = 5
  function getmoves(board, x, y)
    current_pos = [x, y]
    l = convert(Int, sqrt(length(board)))
    valid = []
    for i = 1:2:16
      move = [allMove[i], allMove[i+1]]
      target = current_pos + move
      if (target[1] > l || target[1] < 1) || (target[2] > l || target[2] < 1)
        continue
      elseif board[(target[1]-1)*l + target[2]] == " "
        push!(valid, allMove[i])
        push!(valid, allMove[i+1])
      elseif board[(target[1]-1)*l + target[2]][2] == '1'
        push!(valid, allMove[i])
        push!(valid, allMove[i+1])
      end
    end
    return valid
  end
end

module pawn
  allmove = [[1, 0]]
  name = "p"
  value = 1
  function getmoves(board, x, y)
    current_pos = [x, y]
    l = convert(Int, sqrt(length(board)))
    valid = []
    move = [1, 0]
    target = current_pos + move
    if (target[1] > l || target[1] < 1) || (target[2] > l || target[2] < 1)
      return valid
    elseif board[(target[1]-1)*l + target[2]] == " "
      push!(valid, allMove[i])
      push!(valid, allMove[i+1])
    elseif board[(target[1]-1)*l + target[2]][2] == '1'
      push!(valid, allMove[i])
      push!(valid, allMove[i+1])
    end
    return valid
  end
end

module Pawn
  allmove = [[1,1], [1,0], [1,-1], [0,1], [0,-1], [-1, 0]]
  name = "P"
  value = 5
  function getmoves(board, x, y)
    current_pos = [x, y]
    l = convert(Int, sqrt(length(board)))
    valid = []
    for i = 1:2:16
      move = [allMove[i], allMove[i+1]]
      target = current_pos + move
      if (target[1] > l || target[1] < 1) || (target[2] > l || target[2] < 1)
        continue
      elseif board[(target[1]-1)*l + target[2]] == " "
        push!(valid, allMove[i])
        push!(valid, allMove[i+1])
      elseif board[(target[1]-1)*l + target[2]][2] == '1'
        push!(valid, allMove[i])
        push!(valid, allMove[i+1])
      end
    end
    return valid
  end
end
