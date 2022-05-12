defmodule RushingWeb.StatisticsView do
  use RushingWeb, :view

  def render("show.json", %{data: page}) do
    Jason.encode!(page)
  end
end
