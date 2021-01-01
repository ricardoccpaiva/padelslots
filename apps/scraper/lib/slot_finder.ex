defmodule Scraper.SlotFinder do
  import Ecto.Query

  def find do
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
  end
end
