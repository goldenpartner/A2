using SQLite
DB = SQLite.DB(ARGS[1])
print("What is your name: ")
readline()
for i in "Actually,I don't care\nHello,Mrs.Briliant,you are in my world now !!\nWow Wow\n"
  print(i)
  sleep(0.1)
end
SQLite.query(DB,"delete from moves")
SQLite.execute!(DB,"INSERT INTO moves VALUES(100,\"FICtonia\",5,5,1,5,\"lost\",9)")
SQLite.execute!(DB,"INSERT INTO moves VALUES(100,\"FICtonia\",5,5,9,5,\"lost\",9)")
print("Do you want to resign[Y/N]: ")
a = chomp(readline())
if a == "N"
  for i in "In my dictionary, N means Yes."
    print(i)
    sleep(0.1)
  end
end
for i in "You have resigned,I am the winner.\nCongrate to myself"
  print(i)
  sleep(0.1)
end
