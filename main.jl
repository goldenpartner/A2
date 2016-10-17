include("support_functions.jl")
include("display.jl")
brand()
meun()
print_with_color(:blue,"         choose a number:")
choice_num = chomp(readline());
while(true)
  if choice_num == "1"
    println("\n")
   display()
   break
  elseif choice_num == "2"
   about()
  elseif choice_num == "3"
   exit()
   break
  end
 print_with_color(:blue,"         choose a number:")
 global choice_num = chomp(readline());
end
