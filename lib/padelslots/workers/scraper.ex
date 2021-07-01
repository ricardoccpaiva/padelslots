defmodule Padelslots.Workers.Scraper do
  use GenServer
  use Padelslots.Decorators.StopWatch
  alias Padelslots.Repo
  alias Padelslots.Slots
  alias Padelslots.FreeSlots

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def start_link(name, args) do
    GenServer.start_link(__MODULE__, args, name: name)
  end

  # GenServer Callbacks
  def init(_args) do
    delete_all()
    Process.send_after(self(), :scrape_all, 0)

    {:ok, %{}}
  end

  def handle_info(:scrape_all, _state) do
    scrape_all()

    {:noreply, %{}}
  end

  @decorate measure()
  defp scrape_all() do
    today = Date.utc_today()

    today
    |> Date.range(Date.add(today, 15))
    |> Task.async_stream(
      fn date ->
        find_slots(date)
        find_free_slots(date)
      end,
      timeout: :infinity
    )
    |> Stream.run()

    Process.send_after(self(), :scrape_all, 1_800_000)
  end

  @decorate measure()
  defp delete_all() do
    Repo.delete_all(Padelslots.Models.Slot)
    Repo.delete_all(Padelslots.Models.FreeSlot)
  end

  @decorate measure()
  defp find_slots(date) do
    date
    |> Slots.find()
    |> Slots.save()
  end

  @decorate measure()
  defp find_free_slots(date) do
    date
    |> FreeSlots.find()
    |> Enum.filter(fn slot -> slot != nil end)
    |> FreeSlots.save()
  end
end
