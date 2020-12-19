defmodule PadelSlotsWeb.SlotController do
  use PadelSlotsWeb, :controller

  alias Webslots.PadelSlots
  alias Webslots.PadelSlots.Slot

  action_fallback PadelSlotsWeb.FallbackController

  def index(conn, params) do
    club_id = Map.get(conn.query_params, "club_id")
    date = Map.get(conn.query_params, "date")

    slots = PadelSlots.list_slots(club_id, date)

    render(conn, "index.json", slots: slots)
  end
end
