defmodule RushingWeb.StatisticsController do
  use RushingWeb, :controller

  alias Rushing.Repository

  def index(conn, %{"page" => page, "per_page" => per_page, "filters" => filters}) do
    filters_json = Jason.decode!(filters)
    page_int = String.to_integer(page)
    per_page_int = String.to_integer(per_page)
    render(conn, "show.json", data: Repository.get_pages(page_int, per_page_int, filters_json))
  end
end
