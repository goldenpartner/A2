function sumup(a, b)
  total = 0
  for i = a:b
    count = 0
    for j = 1:i
      if rem(i, j) == 0
        count += 1
      end
    end
    if count != 2
      total += i
    end
  end
  return total
end
