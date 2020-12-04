defmodule PadelSlots.Data.Repo.Migrations.CreateSlots do
  use Ecto.Migration

  def change do
    create table(:slots) do
      add :club_id, :string
      add :club_name, :string
      add :slot_id, :string
      add :date, :date
      add :start, :time
      add :end, :time
      add :court_id, :string
      add :court_name, :string
      add :locked, :boolean
      add :status, :string
    end
  end
end
