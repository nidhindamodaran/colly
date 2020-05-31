require IEx
defmodule CollyWeb.ItemLive.ItemComponent do

  use CollyWeb, :live_component
  use Timex
  alias Colly.Markdown
  
  def render(assigns) do
    ~L"""
     <div id="post-<%= @item.id %>" class="item mb-3">
      <div class="card">
        <div class="card-body item-body">
          <div class="card-text mb-5"><%= markdown(@item.content) %></div>
          
          <a href="#" phx-click="like" phx-target="<%= @myself %>" class="card-link">
            <span class="fas fa-caret-up mr-1"></span><%= @item.likes_count %>
          </a>
          <a href="#" phx-click="dislike" phx-target="<%= @myself %>" class="card-link">
            <i class="fas fa-caret-down mr-1"></i><%= @item.dislikes_count %>
          </a>
          <%= live_patch to: Routes.activity_show_path(@socket, :edit, @item.activity_uuid, @item.id), class: "card-link" do %>
            <i class="fas fa-edit mr-1"></i>
          <% end %>
          <%= link to: '#', phx_click: 'delete', phx_value_id: @item.id, class: "card-link" , data: [confirm: "Really?"] do %>
            <i class="fas fa-trash-alt mr-1"></i>
          <% end %>
          <small class="text-mute pull-right"><%= convert_time(@item.inserted_at) %></small>
        </div>
      </div>
     </div>
     """
  end

  def handle_event("like", _, socket) do
    Colly.Collab.increment_likes(socket.assigns.item)
    {:noreply,
    socket
    |> assign(:update_action, "prepend")}
  end

  def handle_event("dislike", _, socket) do
    Colly.Collab.increment_dislikes(socket.assigns.item)
    {:noreply,
    socket
    |> assign(:update_action, "prepend")}
  end

  def markdown(body) do
    body
    |> Markdown.to_html()
    |> raw
  end

  def convert_time(time) do
    {:ok, new_time} = time |> Timex.format("{h12}:{0m} {am}")

    new_time
  end
end