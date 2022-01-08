defmodule Eoq.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Eoq.Repo,
      # Start the Telemetry supervisor
      EoqWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Eoq.PubSub},
      # Start the Endpoint (http/https)
      EoqWeb.Endpoint,
      # Start a worker by calling: Eoq.Worker.start_link(arg)
      # {Eoq.Worker, arg}
      Eoq.LotSizeCalculator
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Eoq.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    EoqWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
