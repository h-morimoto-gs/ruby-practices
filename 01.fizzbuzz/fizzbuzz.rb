#1から20までの数をプリントするプログラムを書け。ただし3の倍数のときは数の代わりに｢Fizz｣と、5の倍数のときは｢Buzz｣とプリントし、3と5両方の倍数の場合には｢FizzBuzz｣とプリントすること。

#3, 5, 3と5の両方の倍数を指定する変数を用意
times_3 = 3
times_5 = 5
times_15 = 15

#1~20を一つずつ順に取りだす
(1..20).each do |number|
    #処理の実行
    if number % times_15 == 0
        puts "FizzBuzz"
    elsif number % times_5 == 0
        puts "Buzz"
    elsif number % times_3 == 0
        puts "Fizz"
    else
        puts number
    end
end
