using SQLite
DB = SQLite.DB(ARGS[1])
#get current move_id
move_number = length(SQLite.query(DB,"SELECT move_number FROM moves;")[1]) + 1
turn = move_number % 2 == 0 ? "0" : "1"
token = ARGS[2]*turn
targetx = ARGS[3]
targety = ARGS[4]
SQLite.query(DB,"INSERT INTO moves VALUES($move_number,
                                          \"drop\",
                                          -1,
                                          -1,
                                          $targetx,
                                          $targety,
                                          \"$token\",
                                          NULL)")
