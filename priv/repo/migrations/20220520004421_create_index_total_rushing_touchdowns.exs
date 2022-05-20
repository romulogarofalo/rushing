defmodule Rushing.Repo.Migrations.CreateIndexTotalRushingTouchdowns do
  use Ecto.Migration

  def change do
    create index(:rushing_statistics, [:total_rushing_touchdowns])
  end
end
