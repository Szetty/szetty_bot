defmodule SzettyBot.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      # SzettyBot.Repo,
      # Start the Telemetry supervisor
      # SzettyBotWeb.Telemetry,
      # Start the PubSub system
      # {Phoenix.PubSub, name: SzettyBot.PubSub},
      # Start the Endpoint (http/https)
      SzettyBotWeb.Endpoint,
      # Start a worker by calling: SzettyBot.Worker.start_link(arg)
      # {SzettyBot.Worker, arg}
      SzettyBot.Consumer
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SzettyBot.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SzettyBotWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
