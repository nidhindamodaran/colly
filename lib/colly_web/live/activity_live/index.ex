require IEx
defmodule CollyWeb.ActivityLive.Index do
  use CollyWeb, :live_view

  alias Colly.Collab
  alias Colly.Collab.Activity

  @impl true
  def mount(_params, _session, socket) do
    # {:ok, assign(socket, :activities, fetch_activities())}
    {:ok, activity} = Collab.create_activity()
    {:ok, push_redirect(socket, to: "/#{activity.uuid}")}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Activity")
    |> assign(:activity, Collab.get_activity!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Activity")
    |> assign(:activity, %Activity{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Activities")
    |> assign(:activity, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    activity = Collab.get_activity!(id)
    {:ok, _} = Collab.delete_activity(activity)

    {:noreply, assign(socket, :activities, fetch_activities())}
  end

  defp fetch_activities do
    Collab.list_activities()
  end
end
