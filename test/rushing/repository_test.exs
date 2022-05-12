defmodule Rushing.RepositoryTest do
  use ExUnit.Case
  use Rushing.DataCase

  alias Rushing.Repository
  alias Rushing.Models.Statistics

  describe "get_pages/3" do
    test "with rigth params but no filter" do
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
  end
end
