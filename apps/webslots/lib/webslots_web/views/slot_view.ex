defmodule PadelSlotsWeb.SlotView do
  use PadelSlotsWeb, :view
  alias PadelSlotsWeb.SlotView

  def render("index.json", %{slots: slots}) do
    render_many(slots, SlotView, "slot.json")
  end

  def render("show.json", %{slot: slot}) do
    render_one(slot, SlotView, "slot.json")
  end

  def render("slot.json", %{slot: slot}) do
    %{
      id: slot.id,
      club_name: slot.club_name,
      date: slot.date,
      start_time: slot.start_time,
      end_time: slot.end_time,
      court_id: slot.court_id,
      court_name: slot.court_name,
      status: slot.status
    }
  end
end
