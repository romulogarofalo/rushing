defmodule RushingWeb.StatisticsController do
  use RushingWeb, :controller

  alias Rushing.Helpers.Csv
  alias Rushing.Statistics
  alias Rushing.Statistics.InputModel

  def index(conn, params) do
    case InputModel.create_changeset(params) do
      {:ok, %InputModel{} = changes} ->
        name = Map.get(changes, :name)
        filter = Map.get(changes, :filter)
        order = Map.get(changes, :order)

        render(conn, "show.json",
          data: Statistics.list_statistics_paginated(changes, name, filter, order)
        )

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "changeset_error", changeset.errors)
    end
  end

  def download(conn, params) do
    params_with_page =
      Map.merge(
        params,
        %{
          "page" => 1,
          "per_page" => 10
        }
      )

    {:ok, %{changes: changes}} = InputModel.create_changeset(params_with_page)
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
