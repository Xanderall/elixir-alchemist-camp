defmodule Ch8 do

    # Card deck
    def generate_deck(options \\ %{}) do
        suits = ~w{Spades Hearts Clubs Diamonds}
        ranks = Enum.map(1..10, &Integer.to_string/1) ++ ~w{Jack Queen King Ace}
        for r <- ranks, s <- suits, do: r <> " of " <> s
    end

    # Find Pythagorean Triangle
    def triangles(n) when n<1, do: []
    def triangles(n) do
        for a <- 1..n, b <- 1..n, c <- 1..n,
            c >= b, b >= a, a+b >c,
            a*a + b*b == c*c,
            do: {a, b, c}
    end

end