defmodule TelemetryTest.CodeCoverage.PromEx do
  @moduledoc false
  use PromEx.Plugin

  @total_code_coverage_event [:telemetry_test, :code_coverage, :total]

  @impl true
  def event_metrics(_opts) do
    [
      code_coverage_general_event_metrics()
    ]
  end

  defp code_coverage_general_event_metrics() do
    Event.build(
      :telemetry_test_code_coverage_general_event_metrics,
      [
        last_value(
          @total_code_coverage_event,
          description: "Total code coverage by coveralls",
          tags: [:type],
          tag_values: &get_code_coverage_tag_values/1
        )
      ]
    )
  end

  defp get_code_coverage_tag_values(%{type: type}) do
    %{type: type}
  end
end
