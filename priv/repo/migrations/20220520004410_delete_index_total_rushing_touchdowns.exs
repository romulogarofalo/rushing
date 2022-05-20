defmodule Rushing.Repo.Migrations.DeleteIndexTotalRushingTouchdowns do
  use Ecto.Migration

  def change do
    execute "DROP INDEX rushing_statistics_td"
  end
end
