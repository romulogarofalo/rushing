defmodule Rushing.Statistics.InputModelTest do
	use ExUnit.Case
	doctest Rushing.Statistics.InputModel
	alias Rushing.Statistics.InputModel

  describe "create_changeset/1" do
    test "with ok params" do
      params = %{
        "page" => "1",
        "per_page" => "10",
        "name" => "",
        "filter" => "",
        "order" => ""
      }

      assert {:ok,
      %Rushing.Statistics.InputModel{
        filter: nil,
        name: nil,
        order: nil,
        page: 1,
        per_page: 10
      }} == InputModel.create_changeset(params)
    end

    test "with all params" do
      params = %{
        "page" => "1",
        "per_page" => "10",
        "name" => "aaa",
        "filter" => "total_rushing_yards",
        "order" => "desc"
      }

      assert {:ok,
      %Rushing.Statistics.InputModel{
        filter: :total_rushing_yards,
        name: "aaa",
        order: :desc,
        page: 1,
        per_page: 10
      }} == InputModel.create_changeset(params)
    end

    test "with no params" do
      params = %{}

      assert {:error,
        %Ecto.Changeset{
          action: :validate,
          changes: %{},
          constraints: [],
          data: %Rushing.Statistics.InputModel{filter: nil, name: nil, order: nil, page: nil, per_page: nil},
          empty_values: [""],
          errors: [page: {"can't be blank", [validation: :required]}, per_page: {"can't be blank", [validation: :required]}],
          filters: %{},
          params: %{},
          prepare: [],
          repo: nil,
          repo_opts: [],
          required: [:page, :per_page],
          types: %{filter: {:parameterized, Ecto.Enum, %{mappings: [total_rushing_yards: "total_rushing_yards", longest_rush: "longest_rush", total_rushing_touchdowns: "total_rushing_touchdowns"], on_cast: %{"longest_rush" => :longest_rush, "total_rushing_touchdowns" => :total_rushing_touchdowns, "total_rushing_yards" => :total_rushing_yards}, on_dump: %{longest_rush: "longest_rush", total_rushing_touchdowns: "total_rushing_touchdowns", total_rushing_yards: "total_rushing_yards"}, on_load: %{"longest_rush" => :longest_rush, "total_rushing_touchdowns" => :total_rushing_touchdowns, "total_rushing_yards" => :total_rushing_yards}, type: :string}}, name: :string, order: {:parameterized, Ecto.Enum, %{mappings: [asc: "asc", desc: "desc"], on_cast: %{"asc" => :asc, "desc" => :desc}, on_dump: %{asc: "asc", desc: "desc"}, on_load: %{"asc" => :asc, "desc" => :desc}, type: :string}}, page: :integer, per_page: :integer},
          valid?: false,
          validations: []
        }
      } == InputModel.create_changeset(params)
    end
  end
end
