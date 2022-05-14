defmodule Rushing.StatisticsTest do
  use ExUnit.Case
  use Rushing.DataCase

  alias Rushing.Statistics
  alias Rushing.Statistics.StatisticsModel

  describe "list_statistics/5" do
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

    test "with rigth params but no filter", %{inserted_data: inserted_data} do
      %{result: first_page_with_10} = Statistics.list_statistics(1, 10, nil, nil, nil)
      %{result: second_page_with_6} = Statistics.list_statistics(2, 10, nil, nil, nil)

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

    test "with rigth params with name filter", %{inserted_data: inserted_data} do
      %{result: result} = Statistics.list_statistics(1, 10, "13", nil, nil)
      [player_13] = result
      assert player_13.player_name == "13"
      assert length(result) == 1
    end

    test "with rigth params with order_by filter sort_total_rushing_yards", %{
      inserted_data: inserted_data
    } do
      Enum.map(0..16, fn number ->
        %{
          "Player" => "another player",
          "Team" => "JAX",
          "Pos" => "RB",
          "Att" => 2,
          "Att/G" => 2,
          "Yds" => Integer.to_string(number),
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

      %{result: result} = Statistics.list_statistics(1, 13, nil, "total_rushing_yards", "asc")

      list_to_test1 = [0, 1, 2, 3, 4, 5, 6, 7, 7, 7, 7, 7, 7]

      Enum.map(list_to_test1, fn index ->
        param = Enum.at(result, index)
        assert param.total_rushing_yards == index
      end)

      %{result: result} = Statistics.list_statistics(1, 13, nil, "total_rushing_yards", "desc")
      list_to_test2 = [16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 7, 7, 7]

      Enum.map(list_to_test1, fn index ->
        param = Enum.at(result, index)
        assert param.total_rushing_yards == Enum.at(list_to_test2, index)
      end)
    end

    test "with rigth params with order_by filter sort_longest_rush", %{
      inserted_data: inserted_data
    } do
      Enum.map(0..16, fn number ->
        %{
          "Player" => "another player",
          "Team" => "JAX",
          "Pos" => "RB",
          "Att" => 2,
          "Att/G" => 2,
          "Yds" => 4,
          "Avg" => 3.5,
          "Yds/G" => 7,
          "TD" => 0,
          "Lng" => Integer.to_string(number),
          "1st" => 0,
          "1st%" => 0,
          "20+" => 0,
          "40+" => 0,
          "FUM" => 0
        }
        |> StatisticsModel.create_changeset()
        |> Repo.insert!()
      end)

      %{result: result} = Statistics.list_statistics(1, 13, nil, "longest_rush", "asc")

      list_to_test1 = [0, 1, 2, 3, 4, 5, 6, 7, 7, 7, 7, 7, 7]

      Enum.map(list_to_test1, fn index ->
        param = Enum.at(result, index)
        assert param.longest_rush == index
      end)

      %{result: result} = Statistics.list_statistics(1, 13, nil, "longest_rush", "desc")
      list_to_test2 = [16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 7, 7, 7]

      Enum.map(list_to_test1, fn index ->
        param = Enum.at(result, index)
        assert param.longest_rush == Enum.at(list_to_test2, index)
      end)
    end

    test "with rigth params with order_by filter total_rushing_touchdowns", %{
      inserted_data: inserted_data
    } do
      Enum.map(0..16, fn number ->
        %{
          "Player" => "another player",
          "Team" => "JAX",
          "Pos" => "RB",
          "Att" => 2,
          "Att/G" => 2,
          "Yds" => 4,
          "Avg" => 3.5,
          "Yds/G" => 7,
          "TD" => Integer.to_string(number),
          "Lng" => 3,
          "1st" => 3,
          "1st%" => 3,
          "20+" => 3,
          "40+" => 3,
          "FUM" => 3
        }
        |> StatisticsModel.create_changeset()
        |> Repo.insert!()
      end)

      %{result: result} = Statistics.list_statistics(1, 13, nil, "total_rushing_touchdowns", "asc")

      list_to_test1 = [0, 1, 2, 3, 4, 5, 6, 6, 6, 6, 6, 6, 6]

      Enum.map(list_to_test1, fn index ->
        param = Enum.at(result, index)
        assert param.total_rushing_touchdowns == index
      end)

      %{result: result} = Statistics.list_statistics(1, 13, nil, "total_rushing_touchdowns", "desc")

      list_to_test2 = [16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 6, 6]

      Enum.map(list_to_test1, fn index ->
        param = Enum.at(result, index)
        assert param.total_rushing_touchdowns == Enum.at(list_to_test2, index)
      end)
    end

    # test "with wrong params", %{inserted_data: inserted_data} do
    # end
  end
end
