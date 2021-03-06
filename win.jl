using SQLite

DB = SQLite.DB(ARGS[1])
move_number = length(SQLite.query(DB,"SELECT move_number FROM moves;")[1])
board_type = SQLite.query(DB,"SELECT value FROM meta WHERE key = \"type\";")[1].values[1]
flag = true
kings = board_type == "standard" ? [(1,5),(9,5)] : [(1,1),(5,5)]
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
  try
    global targetx = SQLite.query(DB,"SELECT targetx FROM moves WHERE \"move_number\" = $i;")[1].values[1]
  catch
    global targetx = -1
  end
  try
    global targety = SQLite.query(DB,"SELECT targety FROM moves WHERE \"move_number\" = $i;")[1].values[1]
  catch
    global targety = -1
  end
  try
    global option = string(SQLite.query(DB,"SELECT option FROM moves WHERE \"move_number\" = $i;")[1].values[1])
  catch
    global option = "NULL"
  end
  #resign
  if move_type == "resign"
    println(turn == "1"?"R":"r")
    flag = false
    break
  elseif move_type == "move" || move_type == "drop"
    if (sourcex,sourcey) == kings[1]
      kings[1] = (targetx,targety)
    elseif (sourcex,sourcey) == kings[2]
      kings[2] = (targetx,targety)
    end
    if (targetx,targety) == kings[1]
      println("B")
      flag = false
      break
    elseif (targetx,targety) == kings[2]
      println("W")
      flag = false
      break
    end
  end
end
#game's on
if flag
  println("?")
end
