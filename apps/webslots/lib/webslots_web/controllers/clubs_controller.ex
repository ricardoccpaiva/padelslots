defmodule PadelSlotsWeb.ClubController do
  use PadelSlotsWeb, :controller

  alias Webslots.Clubs

  action_fallback PadelSlotsWeb.FallbackController

  def index(conn, _params) do
    clubs = Clubs.list()

    render(conn, "index.json", clubs: clubs)
  end
end
