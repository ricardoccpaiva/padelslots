defmodule Scraper.Worker do
  use GenServer
  import Ecto.Query

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def start_link(name, args) do
    GenServer.start_link(__MODULE__, args, name: name)
  end

  # GenServer Callbacks
  def init(%{} = _args) do
    if(true) do
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
    end

    IO.puts("Scraping finished, shall i continue? ")
    :timer.sleep(10000)

    timer =
      :timer.tc(fn ->
        number_of_days_to_search = 7

        slot_count =
          PadelSlots.Data.Repo.aggregate(
            from(
              u in PadelSlots.Data.Model.Slot,
              where:
                u.status == "available" and u.date < from_now(^number_of_days_to_search, "day")
            ),
            :count,
            :id
          )

        slot_count |> IO.inspect(label: "Available slots count:")

        Enum.each(
          Enum.to_list(1..slot_count),
          fn offset ->
            slots =
              PadelSlots.Data.Repo.all(
                from(
                  u in PadelSlots.Data.Model.Slot,
                  where:
                    u.status == "available" and
                      u.date < from_now(^number_of_days_to_search, "day"),
                  limit: 3,
                  offset: ^offset
                )
              )

            case slots do
              [slot1, slot2, slot3] ->
                if slot1.club_id == slot2.club_id && slot2.club_id == slot3.club_id &&
                     slot1.court_id == slot2.court_id && slot2.court_id == slot3.court_id &&
                     slot1.date == slot2.date && slot2.date == slot3.date &&
                     slot1.end_time == slot2.start_time && slot2.end_time == slot3.start_time do
                  IO.puts(
                    "----> vaga encontrada em #{slot1.club_name} no dia #{slot1.date} das #{
                      slot1.start_time
                    } às #{slot3.end_time} no campo #{slot1.court_name}"
                  )
                end

              _ ->
                IO.puts("----> End of search reached.")
            end
          end
        )
      end)

    IO.puts("Bot took #{inspect(timer)}")

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
    court_name = Map.get(elem, "name")

    slots =
      Map.get(elem, "slots")
      |> Enum.map(fn slot -> build_slot(club_id, club_name, court_name, slot) end)

    PadelSlots.Data.Repo.transaction(fn ->
      PadelSlots.Data.Repo.insert_all(PadelSlots.Data.Model.Slot, slots)
    end)
  end

  defp build_slot(club_id, club_name, court_name, elem) do
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
      status: status
    }
  end
end
