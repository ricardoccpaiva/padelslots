defmodule PadelSlots.Data.Repo.Migrations.CreateFreeParsedSlots do
  use Ecto.Migration

  def change do
    create table(:free_slots) do
      add :club_id, :string
      add :club_name, :string
      add :date, :date
      add :start_time, :time
      add :end_time, :time
      add :court_id, :string
      add :court_name, :string
    end
  end
end
