defmodule Rushing.Statistics do
  alias Rushing.Statistics.Repository
  alias Rushing.Helpers.Pagination

  # @spec list_statistics(number, number, any, any, any) ::
  #         %{count: any, has_next: non_neg_integer, has_prev: boolean, page: number, result: list}
  def list_statistics(%{page: page, per_page: per_page}, name, field, order) do
    paginated_result =
      field
      |> Repository.row_number_statistics(order)
      |> Repository.add_filter("name", name)
      |> Repository.add_filter(field, order)
      |> Pagination.apply_pagination(page, per_page)

    paginated_result
  end
end
