defmodule Colly.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :name, :string
      add :content, :string
      add :likes_count, :integer
      add :dislikes_count, :integer

      timestamps()
    end

  end
end
