defmodule Rushing.Helpers.Pagination do
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

  def apply_pagination(query, page, per_page) do
    sub = subquery(query)

    result = where(sub, [e], e.row_number > ^(per_page * (page - 1)) and e.row_number <= ^(per_page * page))
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
