defmodule Rushing.Models.StatisticsTest do
	use ExUnit.Case
  use Rushing.DataCase

	alias Rushing.Models.Statistics
  alias Rushing.Repo

  describe "create_changeset/1" do
    test "with rigth params" do
      input = %{
        "Player" => "Joe Banyard",
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

      assert {
        :ok,
        %Statistics{
          is_longest_rush_a_td: false,
          longest_rush: 7,
          player_name: "Joe Banyard",
          player_postion: "RB",
          player_team_abbreviation: "JAX",
          rushing_attempts: 2.0,
          rushing_attempts_per_game_average: 2,
          rushing_average_yards_per_attempt: 3.5,
          rushing_first_down_percentage: 0.0,
          rushing_first_downs: 0,
          rushing_fumbles: 0,
          rushing_more_than_forty_yards: 0,
          rushing_more_than_twenty_yards: 0.0,
          rushing_yards_per_game: 7.0,
          total_rushing_touchdowns: 0,
          total_rushing_yards: 7
        }
      } = Statistics.create_changeset(input)
      |> Repo.insert()
    end

    test "with empety params" do
      assert %{
        errors: [
          player_name: {"can't be blank", [validation: :required]},
          player_team_abbreviation: {"can't be blank", [validation: :required]},
          player_postion: {"can't be blank", [validation: :required]},
          rushing_attempts_per_game_average: {"can't be blank",
           [validation: :required]},
          rushing_attempts: {"can't be blank", [validation: :required]},
          rushing_average_yards_per_attempt: {"can't be blank",
           [validation: :required]},
          rushing_yards_per_game: {"can't be blank", [validation: :required]},
          total_rushing_touchdowns: {"can't be blank", [validation: :required]},
          rushing_first_downs: {"can't be blank", [validation: :required]},
          rushing_first_down_percentage: {"can't be blank", [validation: :required]},
          rushing_more_than_twenty_yards: {"can't be blank", [validation: :required]},
          rushing_more_than_forty_yards: {"can't be blank", [validation: :required]},
          rushing_fumbles: {"can't be blank", [validation: :required]}
        ],
        valid?: false
      } = Statistics.create_changeset(%{})
    end

    test "with wrong params" do
      input = %{
        "Player" => 2,
        "Team" => 2,
        "Pos" => 1,
        "Att" => "2",
        "Att/G" => "2",
        "Yds" => "7",
        "Avg" => "3.5",
        "Yds/G" => "7",
        "TD" => "0",
        "Lng" => "7",
        "1st" => "0",
        "1st%" => "0",
        "20+" => "0",
        "40+" => "0",
        "FUM" => "0"
      }

      assert %{
        errors: [
          player_name: {"is invalid", [type: :string, validation: :cast]},
          player_team_abbreviation: {"is invalid", [type: :string, validation: :cast]},
          player_postion: {"is invalid", [type: :string, validation: :cast]}
        ],
        valid?: false
      } = Statistics.create_changeset(input)
    end
  end
end
