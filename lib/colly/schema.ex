defmodule Colly.Schema do
  defmacro __using__(_) do
    quote do
    	use Ecto.Schema
      @primary_key {:uuid, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id
      @derive {Phoenix.Param, key: :uuid}
    end
  end
end