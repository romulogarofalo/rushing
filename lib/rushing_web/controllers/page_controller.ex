defmodule RushingWeb.PageController do
  use RushingWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
