defmodule Rushing.Repo.Migrations.CreateRushingStatistics do
  use Ecto.Migration

  def change do
    create table(:rushing_statistics) do
      add :player_name, :string, null: false
      add :player_team_abbreviation, :string, null: false
      add :player_postion, :string, null: false
      add :rushing_attempts_per_game_average, :integer, null: false
      add :rushing_attempts, :float, null: false
      add :total_rushing_yards, :integer, null: false
      add :rushing_average_yards_per_attempt, :float, null: false
      add :rushing_yards_per_game, :float, null: false
      add :total_rushing_touchdowns, :integer, null: false
      add :longest_rush, :integer, null: false
      add :is_longest_rush_a_td, :boolean, null: false, default: false
      add :rushing_first_downs, :integer, null: false
      add :rushing_first_down_percentage, :float, null: false
      add :rushing_more_than_twenty_yards, :float, null: false
      add :rushing_more_than_forty_yards, :integer, null: false
      add :rushing_fumbles, :integer, null: false

      timestamps()
    end

    create index(:rushing_statistics, [:player_name])
    create index(:rushing_statistics, [:total_rushing_yards])
    create index(:rushing_statistics, [:longest_rush])
    create index(:rushing_statistics, [:total_rushing_touchdowns])
    create index(:rushing_statistics, [:inserted_at])
  end
end
