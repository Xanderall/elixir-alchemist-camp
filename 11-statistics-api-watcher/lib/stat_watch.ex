defmodule StatWatch do

  def stats_url do
    youtube_api_v3 = "https://www.googleapis.com/youtube/v3/"
    channel = "id=" <> ""
    key = "key=" <> ""
    "#{youtube_api_v3}channels?#{channel}#{key}&part=statistics"
  end
  
  def column_names do
    Enum.join ~w{DateTime Subscribers Videos Views}, ","
  end

  def festch_stats() do
    now = %{DateTime.utc_now | microsecond: {0,0}} |> DateTime.to_string
    %{body: body} = HTTPoison.get! stats_url()
    %{items: [%{statistics: stats} | _]} = Poison.decode! body, keys: :atoms
    [ now,
      stats.subscriberCount,
      stats.videoCount,
      stats.viewCount
    ] |> Enum.join(", ")
  end

  def save_csv(row_of_stats) do
    filename = "sats.csv"
    unless File.exists? filename do
      File.write! filename, column_names() <> "\n"    
    end
    File.write!(filename, row_of_stats <> "\n", [:append])
  end
end
