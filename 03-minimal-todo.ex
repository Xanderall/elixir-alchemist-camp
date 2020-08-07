defmodule MinimalTodo do
  def start do
    filename = IO.gets("Name of .csv to load: ") |> String.trim
    read(filename)
      |> parse
      |> show_todos
  end

  def get_command(data) do
    data
    command = IO.gets("Please choose:     R)ead Todos     A)dd todo     D)elete todo     L)oad csv      S)save csv     Q)uit: ")
      |> String.trim
      |> String.downcase
    case command do
      "r" -> show_todos(data)
      "d" -> delete_todo(data)
      "q" -> "Goodbye!"
      _ -> get_command(data)
    end
  end

  def delete_todo(data) do
    show_todos(data, false)
    todo = IO.gets("Which one to delete?\n") |> String.trim
    if Map.has_key? data, todo do
      new_map = Map.drop(data, [todo])
      IO.puts ~s{Entry "#{todo}" deleted}
      get_command(new_map)
    else
      IO.puts "Todo not found."
      show_todos(data)
    end
  end

  def read(filename) do
    case File.read(filename) do
        {:ok, body}      -> body
        {:error, reason} -> IO.puts ~s{Could not open file "#{filename}"}
                            IO.puts ~s{"#{:file.format_error reason}"\n}
                            start()
    end
  end

  def parse(body) do
    [header | lines] = String.split(body, ~r{(\r\n|\r|\n)})
    titles = tl String.split(header, ",")
    parse_lines(lines, titles)
  end

  def parse_lines(lines, titles) do
    Enum.reduce(lines, %{}, fn line, built ->
      [name | fields] = String.split(line, ",")
      if Enum.count(fields) == Enum.count(titles) do
        Map.merge(built, %{name => Enum.zip(titles, fields) |> Enum.into(%{})})
      else
        built
      end
    end)
  end

  def show_todos(data, next_command? \\ true) do
    items = Map.keys(data)
    if length(items)>0 do
      IO.puts "You have the following todos:\n"
      Enum.each(items, fn item -> IO.puts item end)
    else
      IO.puts "Todo-List is currently empty.\n"
    end
    if next_command? do
      get_command(data)
    end
  end
end