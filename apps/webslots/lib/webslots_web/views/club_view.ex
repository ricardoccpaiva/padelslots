defmodule PadelSlotsWeb.ClubView do
  use PadelSlotsWeb, :view
  alias PadelSlotsWeb.ClubView

  def render("index.json", %{clubs: clubs}) do
    render_many(clubs, ClubView, "club.json")
  end

  def render("show.json", %{club: club}) do
    render_one(club, ClubView, "club.json")
  end

  def render("club.json", %{club: club}) do
    %{
      id: club.id,
      name: club.name
    }
  end
end
