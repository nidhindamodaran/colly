defmodule Colly.CollabTest do
  use Colly.DataCase

  alias Colly.Collab

  describe "items" do
    alias Colly.Collab.Item

    @valid_attrs %{content: "some content", dislikes_count: 42, likes_count: 42, name: "some name"}
    @update_attrs %{content: "some updated content", dislikes_count: 43, likes_count: 43, name: "some updated name"}
    @invalid_attrs %{content: nil, dislikes_count: nil, likes_count: nil, name: nil}

    def item_fixture(attrs \\ %{}) do
      {:ok, item} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Collab.create_item()

      item
    end

    test "list_items/0 returns all items" do
      item = item_fixture()
      assert Collab.list_items() == [item]
    end

    test "get_item!/1 returns the item with given id" do
      item = item_fixture()
      assert Collab.get_item!(item.id) == item
    end

    test "create_item/1 with valid data creates a item" do
      assert {:ok, %Item{} = item} = Collab.create_item(@valid_attrs)
      assert item.content == "some content"
      assert item.dislikes_count == 42
      assert item.likes_count == 42
      assert item.name == "some name"
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Collab.create_item(@invalid_attrs)
    end

    test "update_item/2 with valid data updates the item" do
      item = item_fixture()
      assert {:ok, %Item{} = item} = Collab.update_item(item, @update_attrs)
      assert item.content == "some updated content"
      assert item.dislikes_count == 43
      assert item.likes_count == 43
      assert item.name == "some updated name"
    end

    test "update_item/2 with invalid data returns error changeset" do
      item = item_fixture()
      assert {:error, %Ecto.Changeset{}} = Collab.update_item(item, @invalid_attrs)
      assert item == Collab.get_item!(item.id)
    end

    test "delete_item/1 deletes the item" do
      item = item_fixture()
      assert {:ok, %Item{}} = Collab.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> Collab.get_item!(item.id) end
    end

    test "change_item/1 returns a item changeset" do
      item = item_fixture()
      assert %Ecto.Changeset{} = Collab.change_item(item)
    end
  end

  describe "activities" do
    alias Colly.Collab.Activity

    @valid_attrs %{description: "some description", name: "some name", visitors_count: 42}
    @update_attrs %{description: "some updated description", name: "some updated name", visitors_count: 43}
    @invalid_attrs %{description: nil, name: nil, visitors_count: nil}

    def activity_fixture(attrs \\ %{}) do
      {:ok, activity} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Collab.create_activity()

      activity
    end

    test "list_activities/0 returns all activities" do
      activity = activity_fixture()
      assert Collab.list_activities() == [activity]
    end

    test "get_activity!/1 returns the activity with given id" do
      activity = activity_fixture()
      assert Collab.get_activity!(activity.id) == activity
    end

    test "create_activity/1 with valid data creates a activity" do
      assert {:ok, %Activity{} = activity} = Collab.create_activity(@valid_attrs)
      assert activity.description == "some description"
      assert activity.name == "some name"
      assert activity.visitors_count == 42
    end

    test "create_activity/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Collab.create_activity(@invalid_attrs)
    end

    test "update_activity/2 with valid data updates the activity" do
      activity = activity_fixture()
      assert {:ok, %Activity{} = activity} = Collab.update_activity(activity, @update_attrs)
      assert activity.description == "some updated description"
      assert activity.name == "some updated name"
      assert activity.visitors_count == 43
    end

    test "update_activity/2 with invalid data returns error changeset" do
      activity = activity_fixture()
      assert {:error, %Ecto.Changeset{}} = Collab.update_activity(activity, @invalid_attrs)
      assert activity == Collab.get_activity!(activity.id)
    end

    test "delete_activity/1 deletes the activity" do
      activity = activity_fixture()
      assert {:ok, %Activity{}} = Collab.delete_activity(activity)
      assert_raise Ecto.NoResultsError, fn -> Collab.get_activity!(activity.id) end
    end

    test "change_activity/1 returns a activity changeset" do
      activity = activity_fixture()
      assert %Ecto.Changeset{} = Collab.change_activity(activity)
    end
  end
end
