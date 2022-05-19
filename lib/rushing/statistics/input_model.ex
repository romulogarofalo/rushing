defmodule Rushing.Statistics.InputModel do
  @moduledoc """
  module responsable for validate client input
  """

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

    field(:filter, Ecto.Enum,
      values: [:total_rushing_yards, :longest_rush, :total_rushing_touchdowns]
    )

    field(:order, Ecto.Enum, values: [:asc, :desc])
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
    |> apply_action(:validate)
  end
end
