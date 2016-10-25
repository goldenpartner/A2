include("getboard.jl")
board,died_token = getCurrentBoard(ARGS[1])
x,y = size(board)
print("\n\n   ")
for i = 0 : x - 1
  print_with_color(:cyan,"   ",string('a' + i))
end
println()
for i = 1: 2*y + 1
  if i % 2 == 1
    print("    +")
  else
    print_with_color(:cyan," ",string(Int(i/2)))
    print("  |")
  end
  for j = 1:x
    if i % 2 == 1
      print("---+")
    else
      print(" ")
      if length(board[j,Int(i/2)]) < 2
        print(" ")
      else
        if board[j,Int(i/2)][2] == '0'
          print_with_color(board[j,Int(i/2)][1] == 'k'? :yellow : :bold,string(board[j,Int(i/2)][1]))
        else
          print_with_color(board[j,Int(i/2)][1] == 'k'? :yellow : :black,string(board[j,Int(i/2)][1]))
        end
      end
      print(" |")
    end
  end
  if i % 2 == 0
    print_with_color(:cyan," ",string(Int(i/2)))
  end
  println()
end
print("   ")
for i = 0 : x - 1
  print_with_color(:cyan,"   ",string('a' + i))
end

black = ""
white = ""
for i in died_token
  if i[2] == '0'
    white *= string(i[1]) * " "
  else
    black *= string(i[1]) * " "
  end
end
println("\nDrop Token")
println("Black: ",black)
println("White: ",white)
