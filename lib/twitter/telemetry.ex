defmodule Twitter.Telemetry do
  require Logger

  def handle_event([:twitter, :repo, :query], time, metadata, _config) do
    warn_slow_query(time, metadata)
  end

  defp warn_slow_query(time, metadata) do
    us = System.convert_time_unit(time, :native, :microsecond)
    ms = div(us, 100) / 10

    if ms > 50 do
      Logger.warn(fn ->
        [
          "SLOW QUERY",
          ?\s,
          "db=",
          Float.to_string(ms),
          "ms",
          ?\n,
          metadata.query,
          ?\s,
          inspect(metadata.params, charlists: false)
        ]
      end)
    end
  end
end
