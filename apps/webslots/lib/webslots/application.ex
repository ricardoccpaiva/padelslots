defmodule PadelSlots.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      PadelSlots.Data.Repo,
      # Start the Telemetry supervisor
      PadelSlotsWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: PadelSlots.PubSub},
      # Start the Endpoint (http/https)
      PadelSlotsWeb.Endpoint
      # Start a worker by calling: PadelSlots.Worker.start_link(arg)
      # {PadelSlots.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PadelSlots.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    PadelSlotsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
