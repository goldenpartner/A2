using SQLite
function move_user_resign(filename)
  DB = SQLite.DB(filename)
  sql = "insert into move(move_type, sourcex, sourcey, targetx, targety, option, i_am_cheating)"
  sql += " values (resign, -1, -1, -1, -1, resign, NULL)"
  SQLite.execute!(DB, sql)
  println("The user has resigned this game, the other user won.")
  println("Exit in 5 second....")
  sleep(5)
  exit(0)
end
