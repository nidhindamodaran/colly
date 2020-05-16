defmodule Colly.Repo.Migrations.UpdateItemsTable do
  use Ecto.Migration

  def change do
    alter table(:items) do
      add :activity_id, :integer
    end
    create index(:items, [:activity_id])
  end
end
