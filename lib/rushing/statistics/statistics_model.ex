defmodule Rushing.Statistics.StatisticsModel do
  @moduledoc """
  Model responsable to insert new rushing statistics
  from json seeds file
  """

  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, except: [:__struct__, :__meta__]}

  @castable_fields [
    :player_name,
    :player_team_abbreviation,
    :player_position,
    :rushing_attempts_per_game_average,
    :rushing_attempts,
    :total_rushing_yards,
    :rushing_average_yards_per_attempt,
    :rushing_yards_per_game,
    :total_rushing_touchdowns,
    :longest_rush,
    :is_longest_rush_a_td,
    :rushing_first_downs,
    :rushing_first_down_percentage,
    :rushing_more_than_twenty_yards,
    :rushing_more_than_forty_yards,
    :rushing_fumbles
  ]

  schema "rushing_statistics" do
    field(:player_name, :string)
    field(:player_team_abbreviation, :string)
    field(:player_position, :string)
    field(:rushing_attempts_per_game_average, :integer)
    field(:rushing_attempts, :float)
    field(:total_rushing_yards, :integer)
    field(:rushing_average_yards_per_attempt, :float)
    field(:rushing_yards_per_game, :float)
    field(:total_rushing_touchdowns, :integer)
    field(:longest_rush, :integer)
    field(:is_longest_rush_a_td, :boolean)
    field(:rushing_first_downs, :integer)
    field(:rushing_first_down_percentage, :float)
    field(:rushing_more_than_twenty_yards, :float)
    field(:rushing_more_than_forty_yards, :integer)
    field(:rushing_fumbles, :integer)

    timestamps()
  end

  def create_changeset(params) do
    parsed_params = parse_params(params)

    %__MODULE__{}
    |> cast(parsed_params, @castable_fields)
    |> validate_required(@castable_fields)
  end

  defp parse_params(params) do
    %{
      player_name: params["Player"],
      player_team_abbreviation: params["Team"],
      player_position: params["Pos"],
      rushing_attempts_per_game_average: params["Att"],
      rushing_attempts: params["Att/G"],
      total_rushing_yards: parse_yards(params["Yds"]),
      rushing_average_yards_per_attempt: params["Avg"],
      rushing_yards_per_game: params["Yds/G"],
      total_rushing_touchdowns: params["TD"],
      longest_rush: parse_longest_run(params["Lng"]),
      is_longest_rush_a_td: parse_is_longest_run(params["Lng"]),
      rushing_first_downs: params["1st"],
      rushing_first_down_percentage: params["1st"],
      rushing_more_than_twenty_yards: params["20+"],
      rushing_more_than_forty_yards: params["40+"],
      rushing_fumbles: params["FUM"]
    }
  end

  defp parse_longest_run(run) when is_nil(run), do: 0
  defp parse_longest_run(run) when is_integer(run), do: run

  defp parse_longest_run(run) when is_binary(run) do
    if run =~ "T" do
      run
      |> String.split("T")
      |> Enum.join()
      |> String.to_integer()
    else
      String.to_integer(run)
    end
  end

  defp parse_is_longest_run(run) when is_nil(run), do: false
  defp parse_is_longest_run(run) when is_integer(run), do: false
  defp parse_is_longest_run(run) when is_binary(run), do: run =~ "T"

  def longest_rush(%{longest_rush: longest_rush, is_longest_rush_a_td: true}),
    do: "#{longest_rush}T"

  def longest_rush(%{longest_rush: longest_rush}), do: longest_rush

  defp parse_yards(yards) when is_nil(yards), do: 0

  defp parse_yards(yards) when is_binary(yards) do
    yards
    |> String.replace(",", "")
    |> String.to_integer()
  end

  defp parse_yards(yards) when is_integer(yards), do: yards
end
