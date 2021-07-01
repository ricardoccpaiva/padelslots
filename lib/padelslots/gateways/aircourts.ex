defmodule Padelslots.Gateways.Aircourts do
  use Tesla
  require Logger

  def fetch_slots(date) do
    url =
      "https://www.aircourts.com/index.php/v2/api/search?city=13&sport=4&date=#{date}&start_time=08:00&time_override=1&page=1&page_size=100000&favorites=0"

    case get(url) do
      {:ok, response} ->
        Jason.decode!(response.body)

      {:error, error} ->
        Logger.error("Failed to get data from aircours because of #{inspect(error)}")
        :error
    end
  end
end
