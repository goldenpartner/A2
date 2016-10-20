module king
  allMove = [1 1 1 0 0 1 -1 -1 -1 0 0 -1 1 -1 -1 1]
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
  allMove = [1 0 -1 0 0 1 0 -1]
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
            elseif board[(target[1]-1)*l + target[2]] == " "
              push!(valid, move_x*(i-x))
              push!(valid, 0)
            elseif board[(target[1]-1)*l + target[2]] == '1'
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
            elseif board[(target[1]-1)*l + target[2]] == " "
              push!(valid, move_x*(x-i))
              push!(valid, 0)
            elseif board[(target[1]-1)*l + target[2]] == '1'
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
              elseif board[(target[1]-1)*l + target[2]] == " "
                push!(valid, 0)
                push!(valid, move_y*(i-y))
              elseif board[(target[1]-1)*l + target[2]] == '1'
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
              elseif board[(target[1]-1)*l + target[2]] == " "
                push!(valid, 0)
                push!(valid, move_y*(y-i))
              elseif board[(target[1]-1)*l + target[2]] == '1'
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
  allMove = [1 0 -1 0 0 1 0 -1 1 1 1 -1 -1 1 -1 -1]
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
        elseif board[(target[1]-1)*l + target[2]] == " "
          push!(valid, move_x*(i-x))
          push!(valid, 0)
        elseif board[(target[1]-1)*l + target[2]] == '1'
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
  allMove = [1 1 1 -1 -1 1 -1 -1]
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
        elseif board[(target[1]-1)*l + target[2]] == " "
          push!(valid, move_x*(i-x))
          push!(valid, 0)
        elseif board[(target[1]-1)*l + target[2]] == '1'
          push!(valid, move_x*(i-x))
          push!(valid, 0)
          break
        end
      end
    end
  end
end

module Bishop
  allMove = [1 1 1 -1 -1 1 -1 -1 0 1 0 -1 1 0 -1 0]
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
        elseif board[(target[1]-1)*l + target[2]] == " "
          push!(valid, move_x*(i-x))
          push!(valid, 0)
        elseif board[(target[1]-1)*l + target[2]] == '1'
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
  allmove_w = [1 0 -1 0 0 1 0 -1 1 1 1 -1]
  allmove_b = [-1 0 -1 -1 -1 1 0 1 0 -1 1 0]
  name = "g"
  value = 5
  function getmoves(board, x, y, color)
    if collor == 1
      allmMove = allmove_b
    else
      allMove = allmove_w
    end
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
  allmove_w = [1 1 1 0 1 -1 -1 -1 -1 1]
  allmove_b = [-1 0 -1 -1 -1 1 1 -1 1 1]
  name = "s"
  value = 5
  function getmoves(board, x, y, color)
    if collor == 1
      allmMove = allmove_b
    else
      allMove = allmove_w
    end
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
  allmove_w = [1 0 -1 0 0 1 0 -1 1 1 1 -1]
  allmove_b = [-1 0 -1 -1 -1 1 0 1 0 -1 1 0]
  name = "g"
  value = 5
  function getmoves(board, x, y, color)
    if collor == 1
      allmMove = allmove_b
    else
      allMove = allmove_w
    end
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
  allmove_w = [2 -1 2 1]
  allmove_b = [-2 1 -2 -1]
  name = "n"
  value = 3
  function getmoves(board, x, y)
    if collor == 1
      allmMove = allmove_b
    else
      allMove = allmove_w
    end
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
  allmove_w = [1 0 -1 0 0 1 0 -1 1 1 1 -1]
  allmove_b = [-1 0 -1 -1 -1 1 0 1 0 -1 1 0]
  name = "g"
  value = 5
  function getmoves(board, x, y, color)
    if collor == 1
      allmMove = allmove_b
    else
      allMove = allmove_w
    end
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
  allmove_w = [1 0]
  allmove_b = [-1 0]
  name = "l"
  value = 3
  function getmoves(board, x, y)
    if collor == 1
      allmMove = allmove_b
    else
      allMove = allmove_w
    end
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
  allmove_w = [1 0 -1 0 0 1 0 -1 1 1 1 -1]
  allmove_b = [-1 0 -1 -1 -1 1 0 1 0 -1 1 0]
  name = "g"
  value = 5
  function getmoves(board, x, y, color)
    if collor == 1
      allmMove = allmove_b
    else
      allMove = allmove_w
    end
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
  allmove_w = [1 0]
  allmove_b = [-1 0]
  name = "p"
  value = 1
  function getmoves(board, x, y)
    if collor == 1
      allmMove = allmove_b
    else
      allMove = allmove_w
    end
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
  allmove_w = [1 0 -1 0 0 1 0 -1 1 1 1 -1]
  allmove_b = [-1 0 -1 -1 -1 1 0 1 0 -1 1 0]
  name = "g"
  value = 5
  function getmoves(board, x, y, color)
    if collor == 1
      allmMove = allmove_b
    else
      allMove = allmove_w
    end
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
