defmodule Tomer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TomerWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:tomer, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Tomer.PubSub},
      # Start a worker by calling: Tomer.Worker.start_link(arg)
      # {Tomer.Worker, arg},
      # Start to serve requests, typically the last entry
      TomerWeb.Endpoint,
      Tomer.Room
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Tomer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TomerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
