defmodule Rushing.Statistics do
  @moduledoc """
  module responsable for business part
  """

  alias Rushing.Helpers.Pagination
  alias Rushing.Statistics.Repository

  def list_statistics_paginated(%{page: page, per_page: per_page}, name, field, order) do
    field
    |> list_statistics(name, order)
    |> Pagination.apply_pagination(page, per_page)
  end

  def list_statistics(field, name, order) do
    field
    |> Repository.row_number_statistics(order)
    |> Repository.add_filter(:name, name)
    |> Repository.add_filter(field, order)
  end
end
