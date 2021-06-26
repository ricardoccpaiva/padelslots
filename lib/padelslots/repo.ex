defmodule Padelslots.Repo do
  use Ecto.Repo,
    otp_app: :padelslots,
    adapter: Ecto.Adapters.Postgres
end
