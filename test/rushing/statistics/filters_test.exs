defmodule Rushing.Statistics.FilterTest do
  use ExUnit.Case
  use Rushing.DataCase

  alias Rushing.Statistics.Filter
  alias Rushing.Statistics.StatisticsModel

  describe "build_query_with_filters/3" do
    setup do
      inserted_data =
        Enum.map(1..16, fn number ->
          %{
            "Player" => Integer.to_string(number),
            "Team" => "JAX",
            "Pos" => "RB",
            "Att" => 2,
            "Att/G" => 2,
            "Yds" => 7,
            "Avg" => 3.5,
            "Yds/G" => 7,
            "TD" => 6,
            "Lng" => "7",
            "1st" => 0,
            "1st%" => 0,
            "20+" => 0,
            "40+" => 0,
            "FUM" => 0
          }
          |> StatisticsModel.create_changeset()
          |> Repo.insert!()
        end)

      %{inserted_data: inserted_data}
    end

    test "with no filters", %{inserted_data: inserted_data} do
      list_filtered = Filter.build_query_with_filters(nil, nil, nil) |> Repo.all()

      Enum.map(0..9, fn index ->
        from_page = Enum.at(list_filtered, index)
        from_db = Enum.at(inserted_data, index)
        assert from_page.player_name == from_db.player_name
      end)
    end

    test "with rigth params with name filter" do
      result = Filter.build_query_with_filters(nil, "13", nil) |> Repo.all()

      [player_13] = result
      assert player_13.player_name == "13"
      assert length(result) == 1
    end
  end
end
