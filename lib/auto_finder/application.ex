defmodule AutoFinder.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      AutoFinder.Repo,
      # Start the Telemetry supervisor
      AutoFinderWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: AutoFinder.PubSub},
      # Start the Endpoint (http/https)
      AutoFinderWeb.Endpoint
      # Start a worker by calling: AutoFinder.Worker.start_link(arg)
      # {AutoFinder.Worker, arg}
    ]

    :ok =
      :telemetry.attach(
        "logger-json-ecto",
        [:auto_finder, :repo, :query],
        &LoggerJSON.Ecto.telemetry_logging_handler/4,
        :info
      )

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AutoFinder.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AutoFinderWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
