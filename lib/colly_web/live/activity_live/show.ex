require IEx
defmodule CollyWeb.ActivityLive.Show do
  use CollyWeb, :live_view

  alias Colly.Collab

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket), do: Collab.subscribe(id)

    {:ok,
    socket
    |> assign(:items, fetch_items(id))
    |> assign(:activity, Collab.get_activity!(id)),temporary_assigns: [items: []] }

    # {:ok, assign(socket, :items, fetch_items()), temporary_assigns: [items: []]}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:activity, Collab.get_activity!(id))}
  end

  def handle_event("add", %{"item" => item}, socket) do
    Collab.create_item(socket.assigns.activity, item)
    {:noreply, socket}
  end

  defp page_title(:show), do: "Show Activity"
  defp page_title(:edit), do: "Edit Activity"

  @impl true
  def handle_info({:item_created, item}, socket) do
    {:noreply, update(socket, :items, fn items -> [item | items] end)}
  end

  def handle_info({:item_updated, item}, socket) do
    {:noreply, update(socket, :items, fn items -> [item | items] end)}
  end

  defp fetch_items(id) do
    Collab.list_items(id)
  end
end
