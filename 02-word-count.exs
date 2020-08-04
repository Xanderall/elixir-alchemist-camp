filename = IO.gets("File to count the word from: ") |> String.trim()

words= File.read!(filename)
    |> String.split(~r{(\\n|[^\w'])+})
    |> Enum.filter(fn x -> x != "" end)

IO.inspect words
words |> Enum.count() |> IO.puts()
