defmodule Padelslots.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Padelslots.Repo,
      # Start the Telemetry supervisor
      PadelslotsWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Padelslots.PubSub},
      # Start the Endpoint (http/https)
      PadelslotsWeb.Endpoint,
      # Start a worker by calling: Padelslots.Worker.start_link(arg)
      Padelslots.Workers.Scraper
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Padelslots.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    PadelslotsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
