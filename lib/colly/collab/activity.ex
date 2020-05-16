defmodule Colly.Collab.Activity do
  use Ecto.Schema
  import Ecto.Changeset

  schema "activities" do
    field :description, :string, default: "New Description"
    field :name, :string, default: "New Activity"
    field :visitors_count, :integer, default: 0

    timestamps()
  end

  @doc false
  def changeset(activity, attrs) do
    activity
    |> cast(attrs, [])
    |> validate_required([])
  end
end
