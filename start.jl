using SQLite

function setup()

  if(length(ARGS) >= 1)
    if(uppercase(ARGS[1]) == "S")
      Gametype = "standard"
    elseif (uppercase(ARGS[1])== "M")
      Gametype = "mini"
    else
      Gametype ="unset"
    end
  else
    Gametype ="unset"
  end

  if(length(ARGS) >= 2)
    if(uppercase(ARGS[2]) == "T")
      Cheating = "Cheating"
    else
      Cheating = ""
    end
  else
    Cheating = ""
  end


  #set data base and initialize

  #create data base
  DB = SQLite.DB("TestTable.db")

  #set table - "meta"
  create_table_meta = "create table meta(key varchar(255),value varchar(255))"
  SQLite.execute!(DB,create_table_meta)

  #initialize table - "meta"
  if (Gametype == "standard")
    insert_query ="insert into meta values(\"type\",\"standard\");"
    SQLite.execute!(DB,insert_query)
  elseif (Gametype == "unset")
    println("undecided game type, can not start")
    exit()
  else
    insert_query =" insert into meta values(\"type\",\"minishogi\");"
    SQLite.execute!(DB,insert_query)
  end

  if (Cheating == "Cheating")
    insert_query =" insert into meta values(\"legality\",\"cheating\");"
    SQLite.execute!(DB,insert_query)
  else
    insert_query =" insert into meta values(\"legality\",\"legal\");"
    SQLite.execute!(DB,insert_query)
  end
  
  insert_query =" insert into meta values(\"seed\",$(time()));"
  SQLite.execute!(DB,insert_query)


  #set table - "moves"
  create_table_moves ="create table moves(move_number varchar(255),move_type varchar(255),
                                          sourcex varchar(255), sourcey varchar(255),
                                          targetx varchar(255), targety varchar(255),
                                          option varchar(255), i_am_cheating varchar(255))"
  SQLite.execute!(DB,create_table_moves)

end
setup()
