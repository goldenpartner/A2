using SQLite
DB = SQLite.DB(ARGS[1])
#get current move_id
move_number = length(SQLite.query(DB,"SELECT move_number FROM moves;")[1]) + 1
token = ARGS[2]
targetx = ARGS[3]
targety = ARGS[4]
SQLite.query(DB,"INSERT INTO moves VALUES($move_number,
                                          \"drop\",
                                          NULL,
                                          NULL,
                                          $targetx,
                                          $targety,
                                          \"$token\",
                                          NULL)")
