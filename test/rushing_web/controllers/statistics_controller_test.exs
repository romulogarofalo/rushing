# defmodule RushingWeb.StatisticsControllerTest do
#   use ExUnit.Case
#   use RushingWeb.ConnCase

#   alias

#   describe "GET /api/statistics/page/:page/per_page/:per_page/filters/:filters" do
#     setup do
#       Enum.map(1..16, fn number ->
#         %{
#           "Player" => Integer.to_string(number),
#           "Team" => "JAX",
#           "Pos" => "RB",
#           "Att" => 2,
#           "Att/G" => 2,
#           "Yds" => 7,
#           "Avg" => 3.5,
#           "Yds/G" => 7,
#           "TD" => 0,
#           "Lng" => "7",
#           "1st" => 0,
#           "1st%" => 0,
#           "20+" => 0,
#           "40+" => 0,
#           "FUM" => 0
#         }
#         |> Statistics.create_changeset()
#         |> Repo.insert!()

#         %{inserted_data: inserted_data}
#       end)
#     end

#     test "with rigth params but no filter", %{inserted_data: inserted_data, conn: conn} do
#       inserted_data =
#         Enum.map(1..16, fn number ->
#           %{
#             "Player" => Integer.to_string(number),
#             "Team" => "JAX",
#             "Pos" => "RB",
#             "Att" => 2,
#             "Att/G" => 2,
#             "Yds" => 7,
#             "Avg" => 3.5,
#             "Yds/G" => 7,
#             "TD" => 0,
#             "Lng" => "7",
#             "1st" => 0,
#             "1st%" => 0,
#             "20+" => 0,
#             "40+" => 0,
#             "FUM" => 0
#           }
#           |> Statistics.create_changeset()
#           |> Repo.insert!()
#         end)

#       # %{result: first_page_with_10} = Repository.get_pages(1, 10)
#       # %{result: second_page_with_6} = Repository.get_pages(2, 10)

#       assert length(first_page_with_10) == 10

#       Enum.map(0..9, fn index ->
#         from_page = Enum.at(first_page_with_10, index)
#         from_db = Enum.at(inserted_data, index)
#         assert from_page.player_name == from_db.player_name
#       end)

#       Enum.map(0..5, fn index ->
#         from_page = Enum.at(second_page_with_6, index)
#         from_db = Enum.at(inserted_data, index + 10)
#         assert from_page.player_name == from_db.player_name
#       end)

#       assert length(second_page_with_6) == 6
#     end

#     test "with rigth params with name filter", %{inserted_data: inserted_data, conn: conn} do
#     end

#     test "with rigth params with order_by filter sort_total_rushing_yards", %{
#       inserted_data: inserted_data,
#       conn: conn
#     } do
#     end

#     test "with rigth params with order_by filter sort_longest_rush", %{
#       inserted_data: inserted_data,
#       conn: conn
#     } do
#     end

#     test "with rigth params with order_by filter sort_total_rushing_td", %{
#       inserted_data: inserted_data,
#       conn: conn
#     } do
#     end

#     test "with all filters", %{inserted_data: inserted_data, conn: conn} do
#     end

#     test "with wrong params", %{inserted_data: inserted_data, conn: conn} do
#     end
#   end
# end
