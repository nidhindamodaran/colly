defmodule CollyWeb.ItemLive.ItemComponent do
  use CollyWeb, :live_component
  
  def render(assigns) do
    ~L"""
     <div id="post-<%= @item.id %>" class="item mb-3">
      <div class="card">
        <div class="card-body item-body">
          <div class="card-text"><%= @item.content %></div>
          
          <a href="#" phx-click="like" phx-target="<%= @myself %>" class="card-link">
            <span class="fas fa-thumbs-up"></span><%= @item.likes_count %>
          </a>
          <a href="#" phx-click="dislike" phx-target="<%= @myself %>" class="card-link">
            <i class="fas fa-thumbs-down"></i><%= @item.dislikes_count %>
          </a>
          <%= live_patch to: Routes.item_index_path(@socket, :edit, @item.id), class: "card-link" do %>
            <i class="fas fa-edit"></i>
          <% end %>
          <%= link to: '#', phx_click: 'delete', phx_value_id: @item.id, class: "card-link" do %>
            <i class="fas fa-trash-alt"></i>
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