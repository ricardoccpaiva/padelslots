import Config

config :data,
  ecto_repos: [PadelSlots.Data.Repo]

config :data, PadelSlots.Data.Repo,
  database: "data_repo",
  username: "rp",
  password: "rp12345",
  hostname: System.get_env("PG_HOST")
