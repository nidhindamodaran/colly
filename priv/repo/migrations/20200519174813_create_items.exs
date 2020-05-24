defmodule Colly.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :name, :string
      add :content, :string
      add :likes_count, :integer
      add :dislikes_count, :integer
      
      add :activity_uuid, references(:activities, type: :uuid, column: :uuid)

      timestamps()
    end

  end
end
