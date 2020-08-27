defmodule Fibo do
# Comparison of different approaches to calculate fibonacci number
# While tail recursion (method 0) is still the fastest, maps also perform well (method 4)
# use Fibo.compare()

def compare(n \\ 500000) do
  #IO.puts "Standard: #{time(&fiboFast/1, n)}"
  Enum.each(0..4, fn method ->
    compareCase(n, method)
  end)
end

def fiboFast(1, _acc1, acc2), do: acc2
def fiboFast(n, acc1, acc2) do
  fiboFast(n-1, acc2, acc1+acc2)
end

def compareCase(n, method) do
  start = System.monotonic_time(:microsecond)
  fibo = case method do
    0 -> fiboFast(n, 0, 1)
    1 -> Enum.at(Enum.reduce(for x <- 1..n do x end, [0,1], fn _c, acc -> [Enum.at(acc,1),Enum.at(acc,0)+Enum.at(acc,1)] end),0)
    2 -> Enum.at(Enum.reduce(for x <- 1..n do x end, [0,1], fn _c, acc -> [a,b]=acc; [b,a+b] end),0)
    3 -> 2..n
          |> Enum.reduce([0,1], fn _, [a,b] -> [b, a+b] end)
          |> Enum.at(1)
    4 -> 2..n
          |> Enum.reduce(%{a: 0,b: 1}, fn _, acc -> %{a: acc.b, b: acc.a+acc.b } end)
          |> Map.get(:b)
  end
  stop = System.monotonic_time(:microsecond)
  IO.puts "Method #{method} - Calculated fibonacci of #{n} -> Microseconds: #{stop-start}"
end

def time(func, arg) do
  t0 = Time.utc_now
  func.(arg)
  Time.diff(Time.utc_now, t0, :microsecond)
end

end