defmodule RushingWeb.StatisticsController do
  use RushingWeb, :controller

  alias Rushing.Statistics
  alias Rushing.Statistics.InputModel
  def index(conn, params) do
    with %{changes: changes} <- InputModel.create_changeset(params) do
      name = Map.get(changes, :name)
      filter = Map.get(changes, :filter)
      order = Map.get(changes, :order)

      render(conn, "show.json",
        data: Statistics.list_statistics(changes, name, filter, order)
      )
    else
      {:error, reason = %Ecto.ChangeError{}} ->
        render(conn, "changeset_error", reason)
    end
  end
end
