defmodule Rushing.Helpers.Csv do
  alias Rushing.Statistics
  alias Rushing.Statistics.StatisticsModel
  alias Rushing.Repo

  @first_line [
    "Player",
    "Team",
    "Pos",
    "Att/G",
    "Att",
    "Yds",
    "Avg",
    "Yds/G",
    "Td",
    "Lng",
    "1st",
    "1st%",
    "20+",
    "40+",
    "FUM"
  ]

  def download(name, field, order, conn) do
    Repo.transaction(
      fn ->
        Statistics.list_statistics(field, name, order)
        |> Repo.stream()
        |> Stream.map(&build_line/1)
        |> then(fn stream -> Stream.concat([@first_line], stream) end)
        |> NimbleCSV.RFC4180.dump_to_stream()
        |> Enum.reduce_while(conn, fn data, conn ->
          case Plug.Conn.chunk(conn, data) do
            {:ok, conn} ->
              {:cont, conn}

            {:error, :closed} ->
              {:halt, conn}
          end
        end)
      end,
      timeout: :infinity
    )
  end

  defp build_line(rushing_statistic) do
    [
      rushing_statistic.player_name,
      rushing_statistic.player_team_abbreviation,
      rushing_statistic.player_position,
      rushing_statistic.rushing_attempts_per_game_average,
      rushing_statistic.rushing_attempts,
      rushing_statistic.total_rushing_yards,
      rushing_statistic.rushing_average_yards_per_attempt,
      rushing_statistic.rushing_yards_per_game,
      rushing_statistic.total_rushing_touchdowns,
      StatisticsModel.longest_rush(rushing_statistic),
      rushing_statistic.rushing_first_downs,
      rushing_statistic.rushing_first_down_percentage,
      rushing_statistic.rushing_more_than_twenty_yards,
      rushing_statistic.rushing_more_than_forty_yards,
      rushing_statistic.rushing_fumbles
    ]
  end
end
