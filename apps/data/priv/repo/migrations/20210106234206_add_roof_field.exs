defmodule PadelSlots.Data.Repo.Migrations.AddRoofField do
  use Ecto.Migration

  def change do
    alter table(:slots) do
      add(:roof, :boolean)
    end

    alter table(:free_slots) do
      add(:roof, :boolean)
    end
  end
end
