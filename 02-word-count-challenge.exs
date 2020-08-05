# Part 1: Get file and format input
filename = IO.gets("File to apply counter to: ") |> String.trim()

fileContent = File.read!(filename)
words = fileContent
    |> String.split(~r{(\\n|[^\w'])+})
    |> Enum.filter(fn x -> x != "" end)
chars = String.to_charlist(fileContent)
lines = String.split(fileContent,~r{(\r\n|\n|\r)})

# Part 2: Ask user of wanted output
userRequests =  IO.gets("""
What would you like to count? Words, characters or lines in dinwl?
Type w, c or l - or combinations of it:
""") |> String.trim() |> String.to_charlist()

Enum.each(userRequests,fn x ->
    case x do
        119 -> # 'w'
            IO.puts "Words: #{Enum.count(words)}"
        99 -> # 'c'
             IO.puts "Characters: #{length(chars)}"
        108 -> # 'l'
            IO.puts "Lines: #{Enum.count(lines)}"
        _ -> IO.puts ~s{Requested option "#{[x]}" does not exist}
    end
end)