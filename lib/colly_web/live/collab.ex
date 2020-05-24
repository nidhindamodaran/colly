require IEx
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

  def list_items(activity_id) do
    query = from(i in Item, where: [activity_uuid: ^activity_id], order_by: [desc: i.id])
    Repo.all(query)
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
  def create_item(activity, attrs \\ %{}) do
    %Item{}
    |> Item.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:activity, activity)
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
    item
    |> Repo.delete()
    |> broadcast(:item_deleted)
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

  def subscribe(activity_id) do
    Phoenix.PubSub.subscribe(Colly.PubSub, "items:#{activity_id}")
  end

  defp broadcast({:error, _reason} = error, _event), do: error

  defp broadcast({:ok, item}, event) do
    Phoenix.PubSub.broadcast(Colly.PubSub, "items:#{item.activity_uuid}", {event, item})
    {:ok, item}
  end

  defp broadcast(event, content, activity) do
    Phoenix.PubSub.broadcast(Colly.PubSub, "items:#{activity.uuid}", {event, content})
  end

  alias Colly.Collab.Activity

  @doc """
  Returns the list of activities.

  ## Examples

      iex> list_activities()
      [%Activity{}, ...]

  """
  def list_activities do
    Repo.all(Activity)
  end

  @doc """
  Gets a single activity.

  Raises `Ecto.NoResultsError` if the Activity does not exist.

  ## Examples

      iex> get_activity!(123)
      %Activity{}

      iex> get_activity!(456)
      ** (Ecto.NoResultsError)

  """
  def get_activity!(id), do: Repo.get!(Activity, id)

  @doc """
  Creates a activity.

  ## Examples

      iex> create_activity(%{field: value})
      {:ok, %Activity{}}

      iex> create_activity(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_activity(attrs \\ %{}) do
    %Activity{}
    |> Activity.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a activity.

  ## Examples

      iex> update_activity(activity, %{field: new_value})
      {:ok, %Activity{}}

      iex> update_activity(activity, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_activity(%Activity{} = activity, attrs) do
    activity
    |> Activity.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a activity.

  ## Examples

      iex> delete_activity(activity)
      {:ok, %Activity{}}

      iex> delete_activity(activity)
      {:error, %Ecto.Changeset{}}

  """
  def delete_activity(%Activity{} = activity) do
    Repo.delete(activity)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking activity changes.

  ## Examples

      iex> change_activity(activity)
      %Ecto.Changeset{data: %Activity{}}

  """
  def change_activity(%Activity{} = activity, attrs \\ %{}) do
    Activity.changeset(activity, attrs)
  end

  def notify_typing(activity, content) do
    broadcast(:typing, content, activity)
  end
end
