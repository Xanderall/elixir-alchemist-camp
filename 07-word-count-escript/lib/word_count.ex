defmodule WordCount do

  def start(parsed, file, invalid) do
    if invalid != [] || file == ["h"] || file == [] do
      show_help()
    else
      read_file(parsed, file)
    end
  end

  def show_help() do
    IO.puts """
What would you like to count? Words, characters or lines?

Usage: [filename] -[flags]
For flags type (w)ords, (c)haracters or (l)ines - or combinations of it:

E.g.: somefile.txt -lc
"""
  end

  def read_file(parsed, filename) do

    # Interprete flags given by user via cli
    flags = case Enum.count(parsed) do
      0   -> [:words]
      _   -> Enum.map(parsed, &elem(&1, 0))
    end

    # Load file and do calculations
    fileContent = File.read!(filename)
    words = fileContent
      |> String.split(~r{(\\n|[^\w'])+})
      |> Enum.filter(fn x -> x != "" end)
    chars = String.split(fileContent, "") |> Enum.filter(fn x -> x != "" end)
    lines = String.split(fileContent,~r{(\r\n|\n|\r)})

    # Display results
    IO.inspect flags
    Enum.each(flags, fn x ->
        case x do
            :words -> # 'w'
                IO.puts "Words: #{Enum.count(words)}"
            :chars -> # 'c'
                IO.puts "Characters: #{length(chars)}"
            :lines -> # 'l'
                IO.puts "Lines: #{Enum.count(lines)}"
            _ -> IO.puts ~s{Requested option "#{[x]}" does not exist}
        end
    end)

  end
end
