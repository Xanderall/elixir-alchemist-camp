defmodule Tictac do
  @payers [:x, :o]

  def new_board do # Generate empty board
    for s <- squares(), into: %{}, do: {s, :empty}
  end

  def squares do # generate MapSet of e.g. %Square{col: 1, row: 3}
      for c <- 1..3, r <- 1..4, into: MapSet.new(), do: %Square{col: c, row: r}
  end

  def check_player(p) do
    case p do
      :x -> {:ok, p}
      :o -> {:ok, p}
      _  -> {:error, :invalid_player}
    end
  end

  def place_piece(board, place, player) do
    case board[place] do
      nil -> {:error, :invalid_location}
      :x  -> {:error, :occupied}
      :o  -> {:error, :occupied}
      :empty -> {:ok, %{board | place => player }}
    end
  end

  def play_at(board, col, row, player) do
    with {:ok, valid_player} <- check_player(player),
         {:ok, square}       <- Square.new(col, row),
         {:ok, new_board}    <- place_piece(board, square, valid_player),
    do: new_board
  end
end
