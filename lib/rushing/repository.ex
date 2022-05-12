defmodule Rushing.Repository do

  import Ecto.Query

  alias Rushing.Repo
  alias Rushing.Models.Statistics

  def get_pages(page, per_page, filters \\ []) do
    sub_query = from r in Statistics,
    select: (
      %{
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
        row_number: (row_number() |> over(order_by: r.id))})

    query = from e in subquery(sub_query),
      where: e.row_number > ^(per_page * (page - 1)) and e.row_number <= ^(per_page * page)

    query_filtered = Enum.reduce(filters, query, fn {key, value}, _new_query ->
        add_filter(key, value, query)
    end)

    result = Repo.all(query_filtered)
    count = Repo.one(from e in query_filtered, select: count("*"))

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

  def add_filter("name", value, query), do: from u in query, where: like(u.player_name, ^"%#{value}%")

  def add_filter("total_rushing_yards", "desc", query), do: from u in query, order_by: [desc: u.total_rushing_yards]
  def add_filter("total_rushing_yards", "asc", query), do: from u in query, order_by: [asc: u.total_rushing_yards]

  def add_filter("longest_rush", "desc", query), do: from u in query, order_by: [desc: u.longest_rush]
  def add_filter("longest_rush", "asc", query), do: from u in query, order_by: [asc: u.longest_rush]

  def add_filter("total_rushing_touchdowns", "desc", query), do: from u in query, order_by: [desc: u.total_rushing_touchdowns]
  def add_filter("total_rushing_touchdowns", "asc", query), do: from u in query, order_by: [asc: u.total_rushing_touchdowns]
end
