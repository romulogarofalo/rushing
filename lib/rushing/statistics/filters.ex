defmodule Rushing.Statistics.Filter do
  @moduledoc """
  module responsable to build the querys
  these querys was based in https://use-the-index-luke.com/
  """

  import Ecto.Query

  alias Rushing.Statistics.StatisticsModel

  def build_query_with_filters(field, name, order) do
    field
    |> row_number_statistics(order)
    |> add_filter(:name, name)
    |> add_filter(field, order)
  end

  @spec add_filter(Ecto.Query.t(), atom() | nil, atom() | String.t() | nil) :: Ecto.Query.t()
  defp add_filter(query, nil, nil), do: query
  defp add_filter(query, nil, _), do: query
  defp add_filter(query, :name, nil), do: query

  defp add_filter(query, :name, value),
    do: from(u in query, where: like(u.player_name, ^"%#{value}%"))

  defp add_filter(query, :total_rushing_yards, :desc),
    do: from(u in query, order_by: [desc: u.total_rushing_yards])

  defp add_filter(query, :total_rushing_yards, :asc),
    do: from(u in query, order_by: [asc: u.total_rushing_yards])

  defp add_filter(query, :longest_rush, :desc),
    do: from(u in query, order_by: [desc: u.longest_rush])

  defp add_filter(query, :longest_rush, :asc),
    do: from(u in query, order_by: [asc: u.longest_rush])

  defp add_filter(query, :total_rushing_touchdowns, :desc),
    do: from(u in query, order_by: [desc: u.total_rushing_touchdowns])

  defp add_filter(query, :total_rushing_touchdowns, :asc),
    do: from(u in query, order_by: [asc: u.total_rushing_touchdowns])

  @spec row_number_statistics(
          :longest_rush | nil | :total_rushing_touchdowns | :total_rushing_yards,
          :asc | :desc | nil
        ) :: Ecto.Query.t()
  defp row_number_statistics(field, order) do
    StatisticsModel
    |> select(
      [s],
      %{
        player_name: s.player_name,
        player_team_abbreviation: s.player_team_abbreviation,
        player_position: s.player_position,
        rushing_attempts_per_game_average: s.rushing_attempts_per_game_average,
        rushing_attempts: s.rushing_attempts,
        total_rushing_yards: s.total_rushing_yards,
        rushing_average_yards_per_attempt: s.rushing_average_yards_per_attempt,
        rushing_yards_per_game: s.rushing_yards_per_game,
        total_rushing_touchdowns: s.total_rushing_touchdowns,
        longest_rush: s.longest_rush,
        is_longest_rush_a_td: s.is_longest_rush_a_td,
        rushing_first_downs: s.rushing_first_downs,
        rushing_first_down_percentage: s.rushing_first_down_percentage,
        rushing_more_than_twenty_yards: s.rushing_more_than_twenty_yards,
        rushing_more_than_forty_yards: s.rushing_more_than_forty_yards,
        rushing_fumbles: s.rushing_fumbles,
        row_number: over(row_number(), :get_field_to_order)
      }
    )
    |> windows(get_field_to_order: [order_by: ^get_field_to_order(field, order)])
  end

  defp get_field_to_order(:total_rushing_yards, :desc) do
    [desc: dynamic([r], r.total_rushing_yards)]
  end

  defp get_field_to_order(:total_rushing_yards, :asc) do
    [asc: dynamic([r], r.total_rushing_yards)]
  end

  defp get_field_to_order(:longest_rush, :desc) do
    [desc: dynamic([r], r.longest_rush)]
  end

  defp get_field_to_order(:longest_rush, :asc) do
    [asc: dynamic([r], r.longest_rush)]
  end

  defp get_field_to_order(:total_rushing_touchdowns, :desc) do
    [desc: dynamic([r], r.total_rushing_touchdowns)]
  end

  defp get_field_to_order(:total_rushing_touchdowns, :asc) do
    [asc: dynamic([r], r.total_rushing_touchdowns)]
  end

  defp get_field_to_order(nil, nil) do
    [desc: dynamic([r], r.total_rushing_yards)]
  end
end
