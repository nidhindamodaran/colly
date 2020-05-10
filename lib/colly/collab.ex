defmodule Colly.Collab do
  @moduledoc """
  The Collab context.
  """

  import Ecto.Query, warn: false
  alias Colly.Repo

  alias Colly.Collab.Item

  @doc """
  Returns the list of items.

  ## Examples

      iex> list_items()
      [%Item{}, ...]

  """
  def list_items do
    Repo.all(from i in Item, order_by: [desc: i.id])
  end

  def increment_likes(%Item{id: id}) do
    {1, [item]} = 
      from(i in Item, where: i.id == ^id, select: i)
      |> Repo.update_all(inc: [likes_count: 1])
    broadcast({:ok, item}, :item_updated)
  end

  def increment_dislikes(%Item{id: id}) do
    {1, [item]} = 
      from(i in Item, where: i.id == ^id, select: i)
      |> Repo.update_all(inc: [dislikes_count: 1])
    broadcast({:ok, item}, :item_updated)
  end

  @doc """
  Gets a single item.

  Raises `Ecto.NoResultsError` if the Item does not exist.

  ## Examples

      iex> get_item!(123)
      %Item{}

      iex> get_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_item!(id), do: Repo.get!(Item, id)

  @doc """
  Creates a item.

  ## Examples

      iex> create_item(%{field: value})
      {:ok, %Item{}}

      iex> create_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_item(attrs \\ %{}) do
    %Item{}
    |> Item.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:item_created)
  end

  @doc """
  Updates a item.

  ## Examples

      iex> update_item(item, %{field: new_value})
      {:ok, %Item{}}

      iex> update_item(item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_item(%Item{} = item, attrs) do
    item
    |> Item.changeset(attrs)
    |> Repo.update()
    |> broadcast(:item_updated)
  end

  @doc """
  Deletes a item.

  ## Examples

      iex> delete_item(item)
      {:ok, %Item{}}

      iex> delete_item(item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_item(%Item{} = item) do
    Repo.delete(item)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking item changes.

  ## Examples

      iex> change_item(item)
      %Ecto.Changeset{data: %Item{}}

  """
  def change_item(%Item{} = item, attrs \\ %{}) do
    Item.changeset(item, attrs)
  end

  def subscribe do
    Phoenix.PubSub.subscribe(Colly.PubSub, "items")
  end 

  defp broadcast({:error, _reason} = error, _event), do: error

  defp broadcast({:ok, item}, event) do
    Phoenix.PubSub.broadcast(Colly.PubSub, "items", {event, item})
    {:ok, item}
  end
end
