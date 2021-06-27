defmodule Padelslots.Models.FreeSlot do
  use Ecto.Schema

  schema "free_slots" do
    field(:club_id, :string)
    field(:club_name, :string)
    field(:date, :date)
    field(:start_time, :time)
    field(:end_time, :time)
    field(:court_id, :string)
    field(:court_name, :string)
    field(:roof, :boolean)
  end
end
