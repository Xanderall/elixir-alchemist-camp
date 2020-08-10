defmodule MiniMarkdown do
  
  # Try it out with:
  # test_string |> to_html
  # write_test

  def to_html(text) do
    text
      |> h2
      |> h1
      |> p
      |> bold
      |> italics
      |> small
      |> big
  end

  def h2(text) do
    Regex.replace(~r/(\## +)([^\r\n]+)((\r\n|\r|\n)+$)?/, text, "<h2>\\2</h2>")
  end

  def h1(text) do
    Regex.replace(~r/(\# +)([^\r\n]+)((\r\n|\r|\n)+$)?/, text, "<h1>\\2</h1>")
    #Regex.replace(~r/(\r\n|\r|\n|^)\# +([^#][^\n\r]+)/, text, "<h1>\\2</h1>")
  end

  def p(text) do
    Regex.replace(~r/(\r\n|\r|\n|^)+([^#<][^\r\n]+)((\r\n|\r|\n)+$)?/, text, "<p>\\2</p>")
  end

  def bold(text) do
    Regex.replace(~r/\*\*(.*)\*\*/, text, "<strong>\\1</strong>")
  end

  def italics(text) do
    Regex.replace(~r/\*(.*)\*/, text, "<em>\\1</em>")
  end

  def small(text) do
    Regex.replace(~r/\-\-(.*)\-\-/, text, "<small>\\1</small>")
  end

  def big(text) do
    Regex.replace(~r/\+\+(.*)\+\+/, text, "<big>\\1</big>")
  end

  def test_string do
    """
    # The essence of markdown coding
    I *so much* enjoyed the sun outside, that I was in an **excellent mood** for coding.
    
    ## Your opinion counts
    What about you?

    Have fun with ++big++ and --small-- surprises!
    """
  end

  def write_test() do
    File.write("05-markdown-result.html", test_string |> to_html)
  end

  def easy_replace(text, str, tag) do #an idea to streamline
    Regex.replace(~r/#{str}(.*)#{str}/, text, "<#{tag}>\\1</#{tag}>")
  end

end