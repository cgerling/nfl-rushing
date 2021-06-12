defmodule NflRushingWeb.Telemetry do
  use Supervisor
  import Telemetry.Metrics

  @spec start_link(term) :: Supervisor.on_start()
  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    children = [
      {:telemetry_poller, measurements: periodic_measurements(), period: 10_000}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  @spec metrics() :: list
  def metrics do
    [
      # Phoenix Metrics
      summary("phoenix.endpoint.stop.duration",
        unit: {:native, :millisecond}
      ),
      summary("phoenix.router_dispatch.stop.duration",
        tags: [:route],
        unit: {:native, :millisecond}
      ),

      # Database Metrics
      summary("nfl_rushing.repo.query.total_time", unit: {:native, :millisecond}),
      summary("nfl_rushing.repo.query.decode_time", unit: {:native, :millisecond}),
      summary("nfl_rushing.repo.query.query_time", unit: {:native, :millisecond}),
      summary("nfl_rushing.repo.query.queue_time", unit: {:native, :millisecond}),
      summary("nfl_rushing.repo.query.idle_time", unit: {:native, :millisecond}),

      # VM Metrics
      summary("vm.memory.total", unit: {:byte, :kilobyte}),
      summary("vm.total_run_queue_lengths.total"),
      summary("vm.total_run_queue_lengths.cpu"),
      summary("vm.total_run_queue_lengths.io")
    ]
  end

  @spec periodic_measurements() :: list
  defp periodic_measurements do
    []
  end
end
