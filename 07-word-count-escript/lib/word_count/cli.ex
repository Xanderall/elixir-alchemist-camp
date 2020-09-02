defmodule WordCount.CLI do
  def main(args) do
    {parsed, arg, invalid} = OptionParser.parse(
        args,
        switches: [chars: nil, lines: nil, words: nil], #what should be returned
        aliases: [c: :chars, l: :lines, w: :words] # shortcut-alignment
    )
    # IO.inspect {parsed, arg, invalid}
    WordCount.start(parsed, arg, invalid)
  end
end