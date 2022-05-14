defmodule Rushing.Repository do
  import Ecto.Query

  alias Rushing.Repo
  alias Rushing.Models.Statistics

  def get_pages(page, per_page, name, field, order) do
    sub_query =
      from r in Statistics,
        select: %{
          player_name: r.player_name,
          player_team_abbreviation: r.player_team_abbreviation,
          player_postion: r.player_postion,
          rushing_attempts_per_game_average: r.rushing_attempts_per_game_average,
          rushing_attempts: r.rushing_attempts,
          total_rushing_yards: r.total_rushing_yards,
          rushing_average_yards_per_attempt: r.rushing_average_yards_per_attempt,
          rushing_yards_per_game: r.rushing_yards_per_game,
          total_rushing_touchdowns: r.total_rushing_touchdowns,
          longest_rush: r.longest_rush,
          is_longest_rush_a_td: r.is_longest_rush_a_td,
          rushing_first_downs: r.rushing_first_downs,
          rushing_first_down_percentage: r.rushing_first_down_percentage,
          rushing_more_than_twenty_yards: r.rushing_more_than_twenty_yards,
          rushing_more_than_forty_yards: r.rushing_more_than_forty_yards,
          rushing_fumbles: r.rushing_fumbles,
          row_number: over(row_number(), :get_field_to_order)
        },
        windows: [get_field_to_order: [order_by: ^get_field_to_order(field, order)]]

    query_filtered_name =
      if not is_nil(name) do
        add_filter("name", name, sub_query)
      else
        sub_query
      end

    query_filtered =
      if not is_nil(field) do
        add_filter(field, order, query_filtered_name)
      else
        query_filtered_name
      end

    query =
      from e in subquery(query_filtered),
        where: e.row_number > ^(per_page * (page - 1)) and e.row_number <= ^(per_page * page)

    result = Repo.all(query)
    count = Repo.one(from e in query, select: count("*"))

    has_next = length(result)
    has_prev = page > 1

    %{
      result: result,
      count: count,
      page: page,
      has_next: has_next,
      has_prev: has_prev
    }
  end

  def get_field_to_order("total_rushing_yards", "desc") do
    [desc: dynamic([r], r.total_rushing_yards)]
  end

  def get_field_to_order("total_rushing_yards", "asc") do
    [asc: dynamic([r], r.total_rushing_yards)]
  end

  def get_field_to_order("longest_rush", "desc") do
    [desc: dynamic([r], r.longest_rush)]
  end

  def get_field_to_order("longest_rush", "asc") do
    [asc: dynamic([r], r.longest_rush)]
  end

  def get_field_to_order("total_rushing_touchdowns", "desc") do
    [desc: dynamic([r], r.total_rushing_touchdowns)]
  end

  def get_field_to_order("total_rushing_touchdowns", "asc") do
    [asc: dynamic([r], r.total_rushing_touchdowns)]
  end

  def get_field_to_order(nil, nil) do
    [desc: dynamic([r], r.total_rushing_yards)]
  end

  def add_filter("name", value, query),
    do: from(u in query, where: like(u.player_name, ^"%#{value}%"))

  def add_filter("total_rushing_yards", "desc", query),
    do: from(u in query, order_by: [desc: u.total_rushing_yards])

  def add_filter("total_rushing_yards", "asc", query),
    do: from(u in query, order_by: [asc: u.total_rushing_yards])

  def add_filter("longest_rush", "desc", query),
    do: from(u in query, order_by: [desc: u.longest_rush])

  def add_filter("longest_rush", "asc", query),
    do: from(u in query, order_by: [asc: u.longest_rush])

  def add_filter("total_rushing_touchdowns", "desc", query),
    do: from(u in query, order_by: [desc: u.total_rushing_touchdowns])

  def add_filter("total_rushing_touchdowns", "asc", query),
    do: from(u in query, order_by: [asc: u.total_rushing_touchdowns])
end
