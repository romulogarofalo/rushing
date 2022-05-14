defmodule RushingWeb.StatisticsController do
  use RushingWeb, :controller

  alias Rushing.Repository

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

    render(conn, "show.json",
      data: Repository.get_pages(page_int, per_page_int, name, field, order)
    )
  end
end
