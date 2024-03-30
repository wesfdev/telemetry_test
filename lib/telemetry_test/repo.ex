defmodule TelemetryTest.Repo do
  use Ecto.Repo,
    otp_app: :telemetry_test,
    adapter: Ecto.Adapters.Postgres
end
