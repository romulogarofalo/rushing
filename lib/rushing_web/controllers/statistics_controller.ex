defmodule RushingWeb.StatisticsController do
  use RushingWeb, :controller

  alias Rushing.Statistics

  def index(
        conn,
        %{
          "page" => page,
          "per_page" => per_page,
          "name_filter" => name,
          "field_order" => field,
          "order_direction" => order
        }
      ) do
    page_int = String.to_integer(page)
    per_page_int = String.to_integer(per_page)
    # TO DO: make a changeset to validate input
    render(conn, "show.json",
      data: Statistics.list_statistics(page_int, per_page_int, name, field, order)
    )
  end
end
