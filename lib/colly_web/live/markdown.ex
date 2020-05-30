defmodule Colly.Markdown do
  defstruct text: "", html: nil

  def to_html(%__MODULE__{text: text}) when is_binary(text) do
    to_html(text)
  end
  def to_html(binary) when is_binary(binary) do
    Earmark.to_html(binary)
  end
  def to_html(_other), do: ""

  defimpl Phoenix.HTML.Safe do
    def to_iodata(%Colly.Markdown{} = markdown) do
      Colly.Markdown.to_html(markdown)
    end
  end
end