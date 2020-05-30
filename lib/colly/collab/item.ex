defmodule Colly.Collab.Item do
  use Ecto.Schema
  import Ecto.Changeset
  alias Colly.Markdown

  schema "items" do
    field :content, Markdown.Ecto
    field :dislikes_count, :integer, default: 0
    field :likes_count, :integer, default: 0
    field :name, :string, default: "Item"
    belongs_to(:activity, Colly.Collab.Activity, foreign_key: :activity_uuid, references: :uuid, type: :binary_id)
    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:content])
    |> validate_required([:content])
    # |> validate_length(:content, min: 2)
    # |> strip_unsafe_body(attrs)
  end

  defp strip_unsafe_body(item, %{"content" => nil}) do
    item
  end

  defp strip_unsafe_body(item, %{"content" => content}) do
    {:safe, clean_content} = Phoenix.HTML.html_escape(content)
    item |> put_change(:content, clean_content)
  end

  defp strip_unsafe_body(item, _) do
    item
  end
end
