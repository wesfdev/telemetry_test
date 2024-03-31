defmodule TelemetryTestWeb.PageController do
  use TelemetryTestWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def test(conn, _params) do
    json(conn, %{success: true})
  end
end
