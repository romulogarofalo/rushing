defmodule Rushing.RepositoryTest do
  use ExUnit.Case
  use Rushing.DataCase

  alias Rushing.Repository
  alias Rushing.Models.Statistics

  describe "get_pages/3" do
    setup do
      inserted_data = Enum.map(1..16, fn number ->
        %{
          "Player" => Integer.to_string(number),
          "Team" => "JAX",
          "Pos" => "RB",
          "Att" => 2,
          "Att/G" => 2,
          "Yds" => 7,
          "Avg" => 3.5,
          "Yds/G" => 7,
          "TD" => 0,
          "Lng" => "7",
          "1st" => 0,
          "1st%" => 0,
          "20+" => 0,
          "40+" => 0,
          "FUM" => 0
        }
        |> Statistics.create_changeset()
        |> Repo.insert!()

      end)

      %{inserted_data: inserted_data}
    end

    test "with rigth params but no filter", %{inserted_data: inserted_data} do
      %{result: first_page_with_10} = Repository.get_pages(1, 10)
      %{result: second_page_with_6} = Repository.get_pages(2, 10)

      assert length(first_page_with_10) == 10

      Enum.map(0..9, fn index ->
        from_page = Enum.at(first_page_with_10, index)
        from_db = Enum.at(inserted_data, index)
        assert from_page.player_name == from_db.player_name
      end)

      Enum.map(0..5, fn index ->
        from_page = Enum.at(second_page_with_6, index)
        from_db = Enum.at(inserted_data, index + 10)
        assert from_page.player_name == from_db.player_name
      end)

      assert length(second_page_with_6) == 6
    end

    test "with rigth params with name filter", %{inserted_data: inserted_data}  do
      %{result: result} = Repository.get_pages(1, 10, ["name": "13"])
      [player_13] = result
      assert player_13.player_name == "13"
      assert length(result) == 1
    end

    test "with rigth params with order_by filter sort_total_rushing_yards", %{inserted_data: inserted_data}  do
      %{result: result} = Repository.get_pages(1, 10, ["total_rushing_yards": "asc"])

    end

    test "with rigth params with order_by filter sort_longest_rush", %{inserted_data: inserted_data}  do
    end

    test "with rigth params with order_by filter sort_total_rushing_td", %{inserted_data: inserted_data}  do
    end

    test "with all filters", %{inserted_data: inserted_data}  do
    end

    test "with wrong params", %{inserted_data: inserted_data}  do
    end
  end
end
