defmodule Colly.Repo.Migrations.CreateActivities do
  use Ecto.Migration

  def change do
    create table(:activities, primary_key: false) do
      add :uuid, :uuid, primary_key: true
      add :name, :string
      add :description, :string
      add :visitors_count, :integer

      timestamps()
    end

  end
end
