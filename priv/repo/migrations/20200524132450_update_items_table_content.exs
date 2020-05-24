defmodule Colly.Repo.Migrations.UpdateItemsTableContent do
  use Ecto.Migration

  def change do
    alter table(:items) do
      modify :content, :text
    end
  end
end
