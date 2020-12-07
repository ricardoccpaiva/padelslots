defmodule Scraper.Worker do
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def start_link(name, args) do
    GenServer.start_link(__MODULE__, args, name: name)
  end

  # GenServer Callbacks
  def init(%{} = _args) do
    timer =
      :timer.tc(fn ->
        PadelSlots.Data.Repo.delete_all(PadelSlots.Data.Model.Slot)
      end)

    timer |> IO.inspect(label: "Delete all took:")

    today = Date.utc_today()

    Enum.each(
      Date.range(today, Date.add(today, 25)),
      fn date ->
        scrape(Date.to_string(date))
      end
    )

    {:ok, %{}}
  end

  def scrape(date) do
    timer =
      :timer.tc(fn ->
        slots = Scraper.Gateways.Aircourts.fetch_slots(date)
        results = Map.get(slots, "results")

        Enum.each(results, fn elem -> save_slots(elem) end)

        length(results)
      end)

    IO.puts("Scrape date #{date} took #{inspect(timer)}")
  end

  defp save_slots(elem) do
    club_id = Map.get(elem, "club_id")
    club_name = Map.get(elem, "club_name")

    slots =
      Map.get(elem, "slots")
      |> Enum.map(fn slot -> build_slot(club_id, club_name, slot) end)

    PadelSlots.Data.Repo.transaction(fn ->
      PadelSlots.Data.Repo.insert_all(PadelSlots.Data.Model.Slot, slots)
    end)
  end

  defp build_slot(club_id, club_name, elem) do
    slot_id = Map.get(elem, "slot_id")
    {:ok, date} = Date.from_iso8601(Map.get(elem, "date"))
    st = Map.get(elem, "start")
    {:ok, start_time} = Time.from_iso8601("#{st}:00")
    ed = Map.get(elem, "end")
    {:ok, end_time} = Time.from_iso8601("#{ed}:00")
    court_id = Map.get(elem, "court_id")
    court_name = Map.get(elem, "court_name")
    locked = Map.get(elem, "locked")
    status = Map.get(elem, "status")

    %{
      club_id: club_id,
      club_name: club_name,
      slot_id: slot_id,
      date: date,
      start_time: start_time,
      end_time: end_time,
      court_id: court_id,
      court_name: court_name,
      locked: true,
      status: status
    }
  end
end
