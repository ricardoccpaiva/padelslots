defmodule Webslots.Clubs do
  import Ecto.Query, warn: false

  alias PadelSlots.Data.Repo
  alias PadelSlots.Data.Model.Slot

  def list() do
    query =
      from slot in Slot,
        group_by: [slot.club_name, slot.club_id],
        select: %{name: slot.club_name, id: slot.club_id}

    Repo.all(query)
  end
end
