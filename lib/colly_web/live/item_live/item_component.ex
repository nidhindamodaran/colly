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
          <i class="far fa-heart"></i><%= @item.likes_count %>
        </div>
        <div class="column">
          <i class="far fa-heart"></i><%= @item.dislikes_count %>
        </div>
        <div class="column">
          <%= live_patch to: Routes.item_index_path(@socket, :edit, @item.id) do %>
            <i class="far fa-edit"></i>
          <% end %>
          <%= link to: '#', phx_click: 'delete', phx_value_id: @item.id do %>
            <i class="far fa-trash-alt"></i>
          <% end %>
        </div>
      </div>
     </div>
     """
  end
end