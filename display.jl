#Standard 9*9
module table
  temp_standard=["l0" "n0" "s0" "g0" "k0" "g0" "s0" "n0" "l0";
            " " "b0" " " " " " " " " " " "r0" " ";
            "p0" "p0" "p0" "p0" "p0" "p0" "p0" "p0" "p0";
            " " " " " " " " " " " " " " " " " ";
            " " " " " " " " " " " " " " " " " ";
            " " " " " " " " " " " " " " " " " ";
            "p1" "p1" "p1" "p1" "p1" "p1" "p1" "p1" "p1";
            " " "r1" " " " " " " " " " " "b1" " ";
            "l1" "n1" "s1" "g1" "k1" "g1" "s1" "n1" "l1";]
  #rebersed left is (9,9) right is (9,1)
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
  kill = []
  lose = []
  function display()
    if (Type=="S")
        for i=1:9
          println("+---+---+---+---+---+---+---+---+---+")
          print("|")
          for j=0:8
            print(" ",matrix[i,9-j][1]," |")
          end
          print("\n")
        end
        println("+---+---+---+---+---+---+---+---+---+")
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
end
