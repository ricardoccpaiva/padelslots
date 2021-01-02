defmodule Webslots.PadelSlots do
  import Ecto.Query, warn: false

  alias PadelSlots.Data.Repo
  alias PadelSlots.Data.Model.FreeSlot

  def list_slots(club_id, date) do
    if date == nil do
      Repo.all(from(u in FreeSlot, where: u.club_id == ^club_id))
    else
      Repo.all(
        from(u in FreeSlot,
          where: u.club_id == ^club_id and u.date == ^date
        )
      )
    end
  end
end
