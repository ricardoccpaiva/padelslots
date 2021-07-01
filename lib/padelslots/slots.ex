defmodule Padelslots.Slots do
  alias Padelslots.Gateways.Aircourts

  def find(date) do
    date
    |> Date.to_string()
    |> Aircourts.fetch_slots()
    |> Map.get("results")
  end

  def save(results) do
    Enum.each(results, fn result -> save_slots(result) end)
  end

  defp save_slots(elem) do
    club_id = Map.get(elem, "club_id")
    club_name = Map.get(elem, "club_name")
    court_name = Map.get(elem, "name")
    roof = Map.get(elem, "roof") == "1"

    slots =
      Map.get(elem, "slots")
      |> Enum.map(fn slot -> build(club_id, club_name, court_name, roof, slot) end)

    Padelslots.Repo.transaction(fn ->
      Padelslots.Repo.insert_all(Padelslots.Models.Slot, slots)
    end)
  end

  defp build(club_id, club_name, court_name, roof, elem) do
    slot_id = Map.get(elem, "slot_id")
    {:ok, date} = Date.from_iso8601(Map.get(elem, "date"))
    st = Map.get(elem, "start")
    {:ok, start_time} = Time.from_iso8601("#{st}:00")
    ed = Map.get(elem, "end")
    {:ok, end_time} = Time.from_iso8601("#{ed}:00")
    court_id = Map.get(elem, "court_id")
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
      status: status,
      roof: roof
    }
  end
end
