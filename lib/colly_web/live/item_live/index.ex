defmodule CollyWeb.ItemLive.Index do
  use CollyWeb, :live_view

  alias Colly.Collab
  alias Colly.Collab.Item

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Collab.subscribe()

    {:ok, assign(socket, :items, fetch_items()), temporary_assigns: [items: []]}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Item")
    |> assign(:item, Collab.get_item!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Item")
    |> assign(:item, %Item{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Items")
    |> assign(:item, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    item = Collab.get_item!(id)
    {:ok, _} = Collab.delete_item(item)

    {:noreply, assign(socket, :items, fetch_items())}
  end

  @impl true
  def handle_info({:item_created, item}, socket) do
    {:noreply, update(socket, :items, fn items -> [item | items] end)}
  end

  def handle_info({:item_updated, item}, socket) do
    {:noreply, update(socket, :items, fn items -> [item | items] end)}
  end

  defp fetch_items do
    Collab.list_items()
  end


end
