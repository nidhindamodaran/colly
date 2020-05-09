defmodule Colly.Repo do
  use Ecto.Repo,
    otp_app: :colly,
    adapter: Ecto.Adapters.Postgres
end
