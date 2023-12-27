defmodule Stwa.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      StwaWeb.Telemetry,
      Stwa.Repo,
      {DNSCluster, query: Application.get_env(:stwa_elixir, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Stwa.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Stwa.Finch},
      # Start a worker by calling: Stwa.Worker.start_link(arg)
      # {Stwa.Worker, arg},
      # Start to serve requests, typically the last entry
      StwaWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Stwa.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    StwaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
