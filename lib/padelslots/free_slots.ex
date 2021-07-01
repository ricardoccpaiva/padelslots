defmodule Padelslots.FreeSlots do
  import Ecto.Query
  alias Padelslots.Repo
  alias Padelslots.Models

  def find(dt) do
    date = Date.to_string(dt)

    {_time, free_slots} =
      :timer.tc(fn ->
        slot_count =
          Repo.aggregate(
            from(
              u in Models.Slot,
              where: u.status == "available" and u.date == ^date
            ),
            :count,
            :id
          )

        Enum.map(
          Enum.to_list(1..slot_count),
          fn offset ->
            slots =
              Repo.all(
                from(
                  u in Models.Slot,
                  where:
                    u.status == "available" and
                      u.date == ^date,
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
                  # IO.puts(
                  # "---> vaga encontrada em #{slot1.club_name} no dia #{slot1.date} das #{
                  #  slot1.start_time
                  # } às #{slot3.end_time} no campo #{slot1.court_name}"
                  # )

                  %{
                    club_id: slot1.club_id,
                    club_name: slot1.club_name,
                    date: slot1.date,
                    start_time: slot1.start_time,
                    end_time: slot3.end_time,
                    court_id: slot1.court_id,
                    court_name: slot1.court_name,
                    roof: slot1.roof
                  }
                end

              _ ->
                nil
            end
          end
        )
      end)

    free_slots
  end

  def save(slots) do
    IO.puts("Saving #{Enum.count(slots)} free slots")

    Repo.transaction(fn ->
      Repo.insert_all(Models.FreeSlot, slots)
    end)
  end
end
