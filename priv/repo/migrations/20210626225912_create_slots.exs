defmodule Padelslots.Repo.Migrations.CreateSlots do
  use Ecto.Migration

  def change do
    create table(:slots) do
      add :club_id, :string
      add :club_name, :string
      add :slot_id, :string
      add :date, :date
      add :start_time, :time
      add :end_time, :time
      add :court_id, :string
      add :court_name, :string
      add :locked, :boolean
      add :status, :string
      add :roof, :boolean
    end
  end
end
