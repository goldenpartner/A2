standard=["l0" "n0" "s0" "g0" "k0" "g0" "s0" "n0" "l0";
          " " "b0" " " " " " " " " " " "r0" " ";
          "p0" "p0" "p0" "p0" "p0" "p0" "p0" "p0" "p0";
          " " " " " " " " " " " " " " " " " ";
          " " " " " " " " " " " " " " " " " ";
          " " " " " " " " " " " " " " " " " ";
          "p1" "p1" "p1" "p1" "p1" "p1" "p1" "p1" "p1";
          " " "r1" " " " " " " " " " " "b1" " ";
          "l1" "n1" "s1" "g1" "k1" "g1" "s1" "n1" "l1";]

mini=["k0" "g0" "s0" "b0" "r0";
      "p0" " " " " " " " ";
      " " " " " " " " " ";
      " " " " " " " " "p1";
      "r1" "b1" "s1" "g1" "k1";]
function move_user_move(filename,xsource,ysource,xtarget,ytarget,promote)
  if(standard[xsource][ysource] == " ")
    return false
  if(standard[xtarget][ytarget] != " ")
    died_token = standard[xtarget][ytarget]
    standard[xtarget][ytarget] = standard[xsource][ysource]
    standard[xsource][ysource] = " "
    return died_token
  else
    standard[xtarget][ytarget] = standard[xsource][ysource]
    standard[xsource][ysource] = " "
  end
  if(ytarget <= 3)
    standard[xtarget][ytarget] = uppercase(standard[xtarget][ytarget])
  end
end
