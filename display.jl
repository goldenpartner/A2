temp_standard=["l0" "n0" "s0" "g0" "k0" "g0" "s0" "n0" "l0";
                " " "b0" " " " " " " " " " " "r0" " ";
                "p0" "p0" "p0" "p0" "p0" "p0" "p0" "p0" "p0";
                " " " " " " " " " " " " " " " " " ";
                " " " " " " " " " " " " " " " " " ";
                " " " " " " " " " " " " " " " " " ";
                "p1" "p1" "p1" "p1" "p1" "p1" "p1" "p1" "p1";
                " " "r1" " " " " " " " " " " "b1" " ";
                "l1" "n1" "s1" "g1" "k1" "g1" "s1" "n1" "l1";]

temp_mini=["k0" "g0" "s0" "b0" "r0";
      "p0" " " " " " " " ";
      " " " " " " " " " ";
      " " " " " " " " "p1";
      "r1" "b1" "s1" "g1" "k1";]

function defult_standard()
  standard=["l0" "n0" "s0" "g0" "k0" "g0" "s0" "n0" "l0";
            " " "b0" " " " " " " " " " " "r0" " ";
            "p0" "p0" "p0" "p0" "p0" "p0" "p0" "p0" "p0";
            " " " " " " " " " " " " " " " " " ";
            " " " " " " " " " " " " " " " " " ";
            " " " " " " " " " " " " " " " " " ";
            "p1" "p1" "p1" "p1" "p1" "p1" "p1" "p1" "p1";
            " " "r1" " " " " " " " " " " "b1" " ";
            "l1" "n1" "s1" "g1" "k1" "g1" "s1" "n1" "l1";]
end

function defult_mini()
  mini=["k0" "g0" "s0" "b0" "r0";
        "p0" " " " " " " " ";
        " " " " " " " " " ";
        " " " " " " " " "p1";
        "r1" "b1" "s1" "g1" "k1";]
end

Type="S"
matrix=temp_standard
function display()
  if (Type=="S")
    temp=1
      for i=1:9
        println("  +---+---+---+---+---+---+---+---+---+")
        print(temp," |")
        temp+=1
        for j=0:8
          if (matrix[i,9-j][end]=='1')
            print(" ")
            if(string(matrix[i,9-j][1])!="k")
              print_with_color(:red,string(matrix[i,9-j][1]))
            else
              print_with_color(:yellow,string(matrix[i,9-j][1]))
            end
            print(" |")
          else
            print(" ")
            if(string(matrix[i,9-j][1])!="k")
              print_with_color(:green,string(matrix[i,9-j][1]))
            else
              print_with_color(:yellow,string(matrix[i,9-j][1]))
            end
            print(" |")
          end
        end
        print("\n")
      end
      println("  +---+---+---+---+---+---+---+---+---+")
      println("    1   2   3   4   5   6   7   8   9")
  elseif(Type=="M")
      for i =1:5
        println("+---+---+---+---+---+")
        print("|")
        for j=0:4
          print(" ",matrix[i,5-j][1]," |")
        end
        print("\n")
      end
      println("+---+---+---+---+---+")
  else
    println("error!")
  end
end
