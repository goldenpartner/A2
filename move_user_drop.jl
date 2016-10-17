using SQLite
function move_user_drop(filname, piece, xtarget, ytarget)
  DB = SQLite.DB(filename)
  sql = "insert into move(move_type, sourcex, sourcey, targetx, targety, option, i_am_cheating)"
  sql += " values (drop, -1, -1, $(xtarget), $(ytarget), piece, NULL)"
  SQLite.execute!(DB, sql)
end
