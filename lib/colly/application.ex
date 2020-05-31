defmodule Colly.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    
    children = [
      # Start the Ecto repository
      Colly.Repo,
      # Start the Telemetry supervisor
      CollyWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Colly.PubSub},
      # Start the Endpoint (http/https)
      CollyWeb.Endpoint,
      # Start a worker by calling: Colly.Worker.start_link(arg)
      # {Colly.Worker, arg}
      Colly.Scheduler
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Colly.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    CollyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
