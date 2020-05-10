defmodule CollyWeb.ItemLive.ItemComponent do
  use CollyWeb, :live_component
  
  def render(assigns) do
    ~L"""
     <div id="post-<%= @item.id %>" class="item">
      <div class="row">
        <div class="column column-10">
          <div class="post-avatar"></div>
        </div>
        <div class="column column-90 item-body">
          <%= @item.content %>
        </div>
      </div>

      <div class="row">
        <div class="column">
          <a href="#" phx-click="like" phx-target="<%= @myself %>">
            <i class="far fa-heart"></i><%= @item.likes_count %>
          </a>
        </div>
        <div class="column">
          <a href="#" phx-click="dislike" phx-target="<%= @myself %>">
            <i class="far fa-heart"></i><%= @item.dislikes_count %>
          </a>
        </div>
        <div class="column">
          <%= live_patch to: Routes.item_index_path(@socket, :edit, @item.id) do %>
            <i class="far fa-edit">EDIT</i>
          <% end %>
          <%= link to: '#', phx_click: 'delete', phx_value_id: @item.id do %>
            <i class="far fa-trash-alt">DELETE</i>
          <% end %>
        </div>
      </div>
     </div>
     """
  end

  def handle_event("like", _, socket) do
    Colly.Collab.increment_likes(socket.assigns.item)
    {:noreply, socket}
  end

  def handle_event("dislike", _, socket) do
    Colly.Collab.increment_dislikes(socket.assigns.item)
    {:noreply, socket}
  end
end