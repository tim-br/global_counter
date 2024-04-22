defmodule GlobalCounter.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    subdomains = System.get_env("COUNTER_MT_SUBDOMAINS") |> String.split(",")
    subdomains = subdomains ++ ["default"]

    global_counter_children =
      Enum.map(subdomains, fn subdomain ->
        opts = %{init_integer: 0, subdomain: subdomain}

        child_spec = %{
          id: String.to_atom("GlobalCounter_#{subdomain}"),
          start: {GlobalCounter, :start_link, [opts]},
          restart: :permanent,
          type: :worker
        }

        Supervisor.child_spec(child_spec, [])
      end)

    children =
      [
        # Starts a worker by calling: GlobalCounter.Worker.start_link(arg)
        # Starting PubSub
        {Phoenix.PubSub, name: GlobalCounter.PubSub, adapter: Phoenix.PubSub.PG2}
      ] ++ global_counter_children

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GlobalCounter.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
