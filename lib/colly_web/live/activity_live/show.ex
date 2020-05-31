require IEx
require Logger
defmodule CollyWeb.ActivityLive.Show do
  use CollyWeb, :live_view

  alias Colly.Collab

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket), do: Collab.subscribe(id)

    {:ok,
    socket
    |> assign(:items, fetch_items(id))
    |> assign(:typing, false)
    |> assign(:update_action, "prepend")
    |> assign(:activity, Collab.get_activity!(id)),temporary_assigns: [items: []] }
  end

  @impl true
  def handle_params(%{"id" => id, "item_id" => item_id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:activity, Collab.get_activity!(id))
     |> assign(:item, Collab.get_item!(item_id))}
  end

  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:activity, Collab.get_activity!(id))}
  end

  defp apply_action(socket, :edit, %{"activity_id" => activity_id, "id" => id}) do
    socket
    |> assign(:page_title, "Edit Item")
    |> assign(:item, Collab.get_item!(id))
  end

  def handle_event("add", %{"item" => item}, socket) do
    Collab.create_item(socket.assigns.activity, item)
    Collab.notify_typing(socket.assigns.activity, "")
    {:noreply,
    socket
    |> assign(:update_action, "prepend")}
  end

  def handle_event("typing", %{"item" => item}, socket) do
    Collab.notify_typing(socket.assigns.activity, item["content"])
    {:noreply, socket}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    item = Collab.get_item!(id)
    {:ok, _} = Collab.delete_item(item)
    {:noreply,
    socket
    |> assign(:items, fetch_items(socket.assigns.activity.uuid))
    |> assign(:update_action, "replace")}
  end

  defp page_title(:show), do: "Activity"
  defp page_title(:edit), do: "Edit Item"

  @impl true
  def handle_info({:item_created, item}, socket) do
    {:noreply, update(socket, :items, fn items -> [item | items] end)}
  end

  def handle_info({:item_updated, item}, socket) do
    {:noreply, update(socket, :items, fn items -> [item | items] end)}
  end

  def handle_info({:item_deleted, item}, socket) do
    {:noreply, update(socket, :items, fn items -> fetch_items(socket.assigns.activity.uuid) end)}
  end

  def handle_info({:typing, content}, socket) do
    {:noreply, update(socket, :typing, fn typing -> String.strip(content) != "" end)}
  end

  defp fetch_items(id) do
    Collab.list_items(id)
  end
end
