resp = IO.gets "What would you like to count? Words, characters or lines in a file (type w/c/l):" |> String.trim()
IO.puts resp
case resp do
    "w" -> IO.puts "Count words"
    "c" -> IO.puts "Count characters"
    "l" -> IO.puts "count lines"
    _ -> 
end

filename = IO.gets("File to count the word from: ") |> String.trim()

words= File.read!(filename)
    |> String.split(~r{(\\n|[^\w'])+})
    |> Enum.filter(fn x -> x != "" end)

IO.inspect words
words |> Enum.count() |> IO.puts()
