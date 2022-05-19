defmodule Rushing.Helpers.Pagination do
  @moduledoc """
  module responsable for pagination
  """

  import Ecto.Query

  alias Rushing.Repo

  @derive Jason.Encoder

  defstruct [
    :result,
    :count,
    :page,
    :has_next,
    :has_prev
  ]

  @doc """
  To use this pagination you will need to pass row number in select fields
  """
  @spec apply_pagination(Ecto.Query.t(), integer(), integer()) :: %__MODULE__{}
  def apply_pagination(query, page, per_page) do
    sub = subquery(query)

    result =
      where(
        sub,
        [e],
        e.row_number > ^(per_page * (page - 1)) and e.row_number <= ^(per_page * page)
      )
      |> Repo.all()

    count = Repo.one(from e in sub, select: count("*"))

    has_next = length(result)
    has_prev = page > 1

    %__MODULE__{
      result: result,
      count: count,
      page: page,
      has_next: has_next,
      has_prev: has_prev
    }
  end
end
