alias Rushing.Repo
alias Rushing.Statistics.StatisticsModel

"priv/rushing.json"
|> File.stream!([:raw, read_ahead: 17], :line)
|> Enum.reduce_while("", fn element, acc ->
  cond do
    element =~ "}" ->
      (acc <> "}")
      |> Jason.decode!()
      |> StatisticsModel.create_changeset()
      |> Repo.insert!()

      {:cont, ""}

    element =~ "[" ->
      {:cont, acc}

    element =~ "]" ->
      {:halt, ""}

    true ->
      {:cont, acc <> element}
  end
end)
