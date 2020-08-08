defmodule Todo do
  def start do
    load_csv()
  end

  def get_command(data) do
    data
    command = askUser("Please choose:     R)ead Todos     A)dd todo     D)elete todo     L)oad csv      S)save csv     Q)uit: ")
    case String.downcase(command) do
      "r" -> show_todos(data)
      "a" -> add_todo(data)
      "d" -> delete_todo(data)
      "l" -> load_csv()
      "s" -> save_csv(data)
      "q" -> "Goodbye!"
      _ -> get_command(data)
    end
  end

  def add_todo(data) do
    name = get_item_name(data)
    titles = get_fields(data)
    fields = Enum.map(titles, fn fields -> field_from_user(fields) end)
    new_todo = %{name => Enum.into(fields, %{})}
    new_data = Map.merge(data, new_todo)
    get_command(new_data)
  end

  def get_item_name(data) do
    name = askUser("Name of new todo: ")
    if Map.has_key?(data, name) do
        IO.puts "This todo already exists!"
        get_item_name(data)
    else
        name
    end
  end

  def get_fields(data) do
    data[hd Map.keys(data)] |> Map.keys
  end

  def askUser(question) do
    IO.gets(question) |> String.trim
  end

  def field_from_user(name) do
    field = askUser("#{name}: ")
    case field do
        _ -> {name, field}
    end
  end

  def load_csv() do
    read(askUser("Name of .csv to load: "))
      |> parse
      |> show_todos
  end

  def delete_todo(data) do
    show_todos(data, false)
    todo = askUser("Which one to delete?\n")
    if Map.has_key? data, todo do
      new_map = Map.drop(data, [todo])
      IO.puts ~s{Entry "#{todo}" deleted}
      get_command(new_map)
    else
      IO.puts "Todo not found."
      show_todos(data)
    end
  end

  def prepare_csv_to_save(data) do
    header = [ "Topic" | get_fields data]
    topics = Map.keys(data)
    topic_rows = Enum.map(topics, fn topic ->
        [topic | Map.values(data[topic])]
    end)
    rows = [header | topic_rows]
    row_strings = Enum.map(rows, &(Enum.join(&1, ","))) # put , in and convert list to binary
    Enum.join(row_strings, "\n") # remove lines for binary file
  end

  def save_csv(data) do
    filename = askUser("Name of csv to save to: ")
    filedata = prepare_scv_to_save(data)

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