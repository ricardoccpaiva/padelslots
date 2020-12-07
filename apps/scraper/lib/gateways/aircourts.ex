defmodule Scraper.Gateways.Aircourts do
  def fetch_slots(date) do
    options = [recv_timeout: 5000]

    url =
      "https://aircourts.com/index.php/v2/api/search?city=13&sport=4&date=#{date}&start_time=08:00&time_override=1&page=1&page_size=100000"

    case HTTPoison.get(url, options) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Poison.decode!(body)

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts("Not found :(")

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
    end
  end
end
