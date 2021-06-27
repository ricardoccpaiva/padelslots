defmodule Padelslots.Models.Slot do
  use Ecto.Schema

  schema "slots" do
    field(:club_id, :string)
    field(:club_name, :string)
    field(:slot_id, :string)
    field(:date, :date)
    field(:start_time, :time)
    field(:end_time, :time)
    field(:court_id, :string)
    field(:court_name, :string)
    field(:locked, :boolean)
    field(:status, :string)
    field(:roof, :boolean)
  end
end
