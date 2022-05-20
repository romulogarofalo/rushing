defmodule Rushing.Statistics do
  @moduledoc """
  module responsable for business part
  """

  alias Rushing.Helpers.Pagination
  alias Rushing.Statistics.Filter

  def list_statistics_paginated(%{page: page, per_page: per_page}, name, field, order) do
    field
    |> Filter.build_query_with_filters(name, order)
    |> Pagination.apply_pagination(page, per_page)
  end
end
