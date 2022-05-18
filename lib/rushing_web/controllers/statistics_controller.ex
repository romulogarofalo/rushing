defmodule RushingWeb.StatisticsController do
  use RushingWeb, :controller

  alias Rushing.Statistics
  alias Rushing.Statistics.InputModel
  alias Rushing.Helpers.Csv

  def index(conn, params) do
    with %{changes: changes} <- InputModel.create_changeset(params) do
      name = Map.get(changes, :name)
      filter = Map.get(changes, :filter)
      order = Map.get(changes, :order)

      render(conn, "show.json", data: Statistics.list_statistics_paginated(changes, name, filter, order))
    else
      {:error, reason = %Ecto.ChangeError{}} ->
        render(conn, "changeset_error", reason)
    end
  end

  def download(conn, params) do
    params_with_page = Map.merge(params,
    %{
      "page" => 1,
      "per_page" => 10
    })

    %{changes: changes} = InputModel.create_changeset(params_with_page)
    name = Map.get(changes, :name)
    filter = Map.get(changes, :filter)
    order = Map.get(changes, :order)

    conn =
      conn
      |> put_resp_content_type("text/csv")
      |> put_resp_header("content-disposition", ~s[attachment; filename="report.csv"])
      |> send_chunked(:ok)

    {:ok, conn} = Csv.download(name, filter, order, conn)

    conn
  end
end
