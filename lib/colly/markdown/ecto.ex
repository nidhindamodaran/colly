defmodule Colly.Markdown.Ecto do
  alias Colly.Markdown
  @behaviour Ecto.Type

  @impl Ecto.Type
  def type, do: :string

  @impl Ecto.Type
  def cast(binary) when is_binary(binary) do
    {:ok, %Markdown{text: binary}}
  end
  def cast(%Markdown{} = markdown), do: {:ok, markdown}
  def cast(_other), do: :error

  @impl Ecto.Type
  def load(binary) when is_binary(binary) do
    {:ok, %Markdown{text: binary, html: Markdown.to_html(binary)}}
  end
  def load(_other), do: :error

  @impl Ecto.Type
  def dump(%Markdown{text: binary}) when is_binary(binary) do
    {:ok, binary}
  end
  def dump(binary) when is_binary(binary), do: {:ok, binary}
  def dump(_other), do: :error
end