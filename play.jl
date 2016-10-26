using SQLite
include("support_functions.jl")
#run(`julia display.jl chess`)

function start_interface()
  brand()
  meun()

  option = readline()
  while (option != 3 && option != "exit" && option != "Exit")
    try
      option = parse(option)
    catch
      option = option
    end

    if option == 2 || option == "Play" || option == "play"
      about()
    elseif option == 3 || option == "exit" || option == "Exit"
      return
    else
      chess_game()
    end

    meun()
    option = readline()

  end

  return
end

function chess_game()
  println("For play standard shogi, enter 1 \; ")
  println("For play mini shogi , enter 2 \; ")
  shogi_type = parse(readline())
  println("Do you would you like cheating mode ;
  Enter 1 to allow cheating mode ;
  Enter 2 dont allow cheating mode ;")
  cheating_mode = parse(readline())
  if shogi_type == 1
    shogi_type = "S"
  else
    shogi_type = "M"
  end
  if cheating_mode == 1
    cheating_mode = "T"
  else
    cheating_mode = " "
  end

  #start name file
  new_game = "new_game"
  run(`julia start.jl $new_game $shogi_type $cheating_mode`)
  # pick side
  println("Enter \"W\" for whith side, Enter \"B\" for black side")
  side = readline()[1]
  println("You chose $side ")
  if side == 'W'
    side = 0
  else
    side = 1
  end
  #start game
  run(`julia --color=yes -- display.jl $new_game`)


  #get each parameter
  move_number = 1
  DB = SQLite.DB(new_game)
  while (wingame(DB)== "?")
    println("move_number : $move_number")
    if move_number%2 == side
      println("your turn:  ")
      println("format: move_type,sourceX,sourceY,targetX,targetY,option")
      println("move_type can be: move,resign,or drop")
      println("option can be: b,g,k,l,n,p,r,s, T \(T for promote\)")
      println("place \"0\" if position is empty")
      move_code = readline()
      temp = search(move_code,',')
      move_type = move_code[1:temp-1]
      println(move_type)

      move_code = move_code[temp+1:end]
      temp = search(move_code,',')
      sourceX = parse(move_code[1:temp-1])
      println(sourceX)

      move_code = move_code[temp+1:end]
      temp = search(move_code,',')
      sourceY = parse(move_code[1:temp-1])
      println(sourceY)

      move_code = move_code[temp+1:end]
      temp = search(move_code,',')
      targetX = parse(move_code[1:temp-1])
      println(targetX)

      move_code = move_code[temp+1:end]
      temp = search(move_code,',')
      targetY = parse(move_code[1:1])
      println(targetY)

      move_code = move_code[temp+1:end]
      option = move_code[1]
      println(option)

      if move_type == "move"
        run(`julia move_user_move.jl $new_game $sourceX $sourceY $targetX $targetY $option`)
      elseif move_type == "drop"
        run(`julia move_user_drop.jl $new_game $option $targetX $targetY`)
      else
        run(`julia move_user_resign.jl $new_game`)
      end
    else
      println("AI is moving : ")
      sleep(1)
      run(`julia move.jl $new_game`)
    end
    run(`julia --color=yes -- display.jl $new_game`)
    move_number = move_number+1
  end
  if (wingame(DB) == "B")
    if (side == 1)
      println(" YOU WIN! ")
    else
      println(" YOU LOST")
    end
  else
    if (side == 0)
      println(" YOU WIN! ")
    else
      println(" YOU LOST")
    end
  end

end


function wingame(filename)
  DB = SQLite.DB(filename)
  move_number = length(SQLite.query(DB,"SELECT move_number FROM moves;")[1])
  flag = true
  kings = [(1,5),(9,5)]
  for i = 1 : move_number
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
    targetx = SQLite.query(DB,"SELECT targetx FROM moves WHERE \"move_number\" = $i;")[1].values[1]
    targety = SQLite.query(DB,"SELECT targety FROM moves WHERE \"move_number\" = $i;")[1].values[1]
    try
      global option = string(SQLite.query(DB,"SELECT option FROM moves WHERE \"move_number\" = $i;")[1].values[1])
    catch
      global option = "NULL"
    end
    #resign
    if move_type == "resign"
      return(turn == "1"?"R":"r")
      flag = false
      break
    elseif move_type == "move" || move_type == "drop"
      if (sourcex,sourcey) == kings[1]
        kings[1] = (targetx,targety)
      elseif (sourcex,sourcey) == kings[2]
        kings[2] = (targetx,targety)
      end
      if (targetx,targety) == kings[1]
        return("B")
        flag = false
        break
      elseif (targetx,targety) == kings[2]
        return("W")
        flag = false
        break
      end
    end
  end
  #game's on
  if flag
    return("?")
  end
end




start_interface()
