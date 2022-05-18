defmodule RushingWeb.StatisticsControllerTest do
  use ExUnit.Case
  use RushingWeb.ConnCase

  alias Rushing.Statistics.StatisticsModel

  describe "GET /api/statistics/page/:page/per_page/:per_page/filters/:filters" do
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

    test "with rigth params but no filter", %{inserted_data: inserted_data, conn: conn} do

      %{resp_body: body_page_1} =
        get(conn, "/api/statistics/page/1/per_page/10", name: "", filter: "", order: "")
      %{resp_body: body_page_2} =
        get(conn, "/api/statistics/page/2/per_page/10", name: "", filter: "", order: "")

      %{"result" => first_page_with_10} = Jason.decode!(body_page_1)
      |> Jason.decode!()

      %{"result" => second_page_with_6} = Jason.decode!(body_page_2)
      |> Jason.decode!()

      inserted_data_result = inserted_data
      |> Jason.encode!()
      |> Jason.decode!()

      Enum.map(0..9, fn index ->
        from_page = Enum.at(first_page_with_10, index)
        from_db = Enum.at(inserted_data_result, index)
        assert from_page["player_name"] == from_db["player_name"]
      end)

      Enum.map(0..5, fn index ->
        from_page = Enum.at(second_page_with_6, index)
        from_db = Enum.at(inserted_data_result, index + 10)
        assert from_page["player_name"] == from_db["player_name"]
      end)

      assert length(second_page_with_6) == 6
    end

    test "with rigth params with name filter", %{conn: conn} do
      %{resp_body: body_page_1} =
        get(conn, "/api/statistics/page/1/per_page/10", name: "13", filter: "", order: "")

      %{"result" => first_page_with_10}
      = body_page_1
      |> Jason.decode!()
      |> Jason.decode!()

      [row] = first_page_with_10

      assert row["player_name"] == "13"
      assert length(first_page_with_10) == 1
    end

    test "with rigth params with order_by filter sort_total_rushing_yards", %{
      conn: conn
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

      %{resp_body: body_page_1} =
        get(conn, "/api/statistics/page/1/per_page/13", name: "", filter: "total_rushing_yards", order: "asc")

      %{"result" => first_page_with_10}
      = body_page_1
      |> Jason.decode!()
      |> Jason.decode!()

      list_to_test1 = [0, 1, 2, 3, 4, 5, 6, 7, 7, 7, 7, 7, 7]

      Enum.map(list_to_test1, fn index ->
        param = Enum.at(first_page_with_10, index)
        assert param["total_rushing_yards"] == index
      end)

      %{resp_body: body_page_1_desc} =
        get(conn, "/api/statistics/page/1/per_page/13", name: "", filter: "total_rushing_yards", order: "desc")

      %{"result" => first_page_with_10_desc}
      = body_page_1_desc
      |> Jason.decode!()
      |> Jason.decode!()

      list_to_test2 = [16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 7, 7, 7]

      Enum.map(list_to_test1, fn index ->
        param = Enum.at(first_page_with_10_desc, index)
        assert param["total_rushing_yards"] == Enum.at(list_to_test2, index)
      end)
    end

    test "with rigth params with order_by filter sort_longest_rush", %{
      conn: conn
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

      %{resp_body: body_page_1} =
        get(conn, "/api/statistics/page/1/per_page/13", name: "", filter: "longest_rush", order: "asc")

      %{"result" => first_page_with_10}
      = body_page_1
      |> Jason.decode!()
      |> Jason.decode!()

      list_to_test1 = [0, 1, 2, 3, 4, 5, 6, 7, 7, 7, 7, 7, 7]

      Enum.map(list_to_test1, fn index ->
        param = Enum.at(first_page_with_10, index)
        assert param["longest_rush"] == index
      end)

      %{resp_body: body_page_1_desc} =
        get(conn, "/api/statistics/page/1/per_page/13", name: "", filter: "longest_rush", order: "desc")

      %{"result" => first_page_with_10_desc}
      = body_page_1_desc
      |> Jason.decode!()
      |> Jason.decode!()

      list_to_test2 = [16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 7, 7, 7]

      Enum.map(list_to_test1, fn index ->
        param = Enum.at(first_page_with_10_desc, index)
        assert param["longest_rush"] == Enum.at(list_to_test2, index)
      end)
    end

    test "with rigth params with order_by filter total_rushing_touchdowns", %{
      conn: conn
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

      %{resp_body: body_page_1} =
        get(conn, "/api/statistics/page/1/per_page/13", name: "", filter: "total_rushing_touchdowns", order: "asc")

      %{"result" => first_page_with_10}
      = body_page_1
      |> Jason.decode!()
      |> Jason.decode!()

      list_to_test1 = [0, 1, 2, 3, 4, 5, 6, 6, 6, 6, 6, 6, 6]

      Enum.map(list_to_test1, fn index ->
        param = Enum.at(first_page_with_10, index)
        assert param["total_rushing_touchdowns"] == index
      end)

      %{resp_body: body_page_1_desc} =
        get(conn, "/api/statistics/page/1/per_page/13", name: "", filter: "total_rushing_touchdowns", order: "desc")

      %{"result" => first_page_with_10_desc}
      = body_page_1_desc
      |> Jason.decode!()
      |> Jason.decode!()

      list_to_test2 = [16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 6, 6]

      Enum.map(list_to_test1, fn index ->
        param = Enum.at(first_page_with_10_desc, index)
        assert param["total_rushing_touchdowns"] == Enum.at(list_to_test2, index)
      end)
    end

    test "with all filters", %{inserted_data: inserted_data, conn: conn} do
    end

    # test "with wrong params", %{inserted_data: inserted_data, conn: conn} do
    # end
  end
end
