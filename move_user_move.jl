using SQLite
DB = SQLite.DB(ARGS[1])
move_number = length(SQLite.query(DB,"SELECT move_number FROM moves")) + 1
sourcex = ARGS[2]
sourcey = ARGS[3]
targetx = ARGS[4]
targety = ARGS[5]
if length(ARGS) >= 6
  promote = ARGS[6] == "T" ? "!" : "NULL"
else
  promote = "NULL"
end
SQLite.query(DB,"INSERT INTO moves VALUES($move_number,
                                          \"move\",
                                          $sourcex,
                                          $sourcey,
                                          $targetx,
                                          $targety,
                                          $promote,
                                          NULL)")
