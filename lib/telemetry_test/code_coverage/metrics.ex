defmodule TelemetryTest.CodeCoverage.Metrics do
  @moduledoc false
  use GenServer

  alias ExCoveralls.Stats
  require Logger

  @coverage_report_path "cover/excoveralls.json"

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    load_metrics()
    {:ok, state}
  end

  defp load_metrics() do
    case File.read(@coverage_report_path) do
      {:ok, content} ->
        {:ok, metrics} = content |> Jason.decode(keys: :atoms)
        publish_metrics(metrics)

      {:error, _} ->
        Logger.error("Failed to read coverage report file")
    end
  end

  defp publish_metrics(source) do
    source_files = source.source_files || []
    result = Stats.source(source_files)

    :telemetry.execute([:telemetry_test, :code_coverage], %{total: result.coverage}, %{
      type: :coverage
    })
  end

  defp keys_to_atoms(json) when is_map(json) do
    Map.new(json, &reduce_keys_to_atoms/1)
  end

  defp reduce_keys_to_atoms({key, val}) when is_map(val),
    do: {String.to_atom(key), keys_to_atoms(val)}

  defp reduce_keys_to_atoms({key, val}) when is_list(val),
    do: {String.to_atom(key), Enum.map(val, &keys_to_atoms(&1))}

  defp reduce_keys_to_atoms({key, val}), do: {String.to_atom(key), val}
end
