using SQLite

DB = SQLite.DB(ARGS[1])
move_number = length(SQLite.query(DB,"SELECT move_number FROM moves")) + 1
SQLite.execute!(DB,"INSERT INTO moves VALUES($move_number,\"resign\",NULL,NULL,NULL,NULL,NULL,NULL)")
