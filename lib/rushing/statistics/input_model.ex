defmodule Rushing.Statistics.InputModel do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          page: integer(),
          per_page: integer(),
          name: String.t() | nil,
          filter: String.t() | nil,
          order: String.t() | nil
        }

  @primary_key false
  embedded_schema do
    field(:page, :integer)
    field(:per_page, :integer)
    field(:name, :string)
    field(:filter, :string)
    field(:order, :string)
  end

  @castable_fields [
    :page,
    :per_page,
    :name,
    :filter,
    :order
  ]

  @required_fields [
    :page,
    :per_page
  ]

  def create_changeset(params) do
    %__MODULE__{}
    |> cast(params, @castable_fields)
    |> validate_required(@required_fields)
  end
end
