using SQLite

DB = SQLite.DB(ARGS[1])
move_number = length(SQLite.query(DB,"SELECT move_number FROM moves;")[1]) + 1
flag = true
kings = [(1,5),(9,5)]
for i = 1 : move_number
  global turn = i % 2 == 0 ? "0" : "1"

  move_type = SQLite.query(DB,"SELECT move_type FROM moves WHERE \"move_number\" = $i;")[1].values[1]
  sourcex = SQLite.query(DB,"SELECT sourcex FROM moves WHERE \"move_number\" = $i;")[1].values[1]
  sourcey = SQLite.query(DB,"SELECT sourcey FROM moves WHERE \"move_number\" = $i;")[1].values[1]
  targetx = SQLite.query(DB,"SELECT targetx FROM moves WHERE \"move_number\" = $i;")[1].values[1]
  targety = SQLite.query(DB,"SELECT targety FROM moves WHERE \"move_number\" = $i;")[1].values[1]
  #resign
  if move_type == "resign"
    println(turn == "1"?"R":"r")
    flag = false
    break
  elseif move_type == "move" || "drop"
    if (sourcex,sourcey) == kings[1]
      kings[1] == (targetx,targety)
    elseif (sourcex,sourcey) == kings[2]
      kings[2] == (targetx,targety)
    elseif (targetx,targety) == kings[1]
      println("B")
      flag = false
    elseif (targetx,targety) == kings[2]
      println("W")
      flag = false
    end
    end
  end
end
#game's on
if flag
  println("?")
end
info("DRAW unfinished")
