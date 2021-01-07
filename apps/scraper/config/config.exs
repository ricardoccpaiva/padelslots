# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

config :logger,
  level: :error

config :data,
  ecto_repos: [PadelSlots.Data.Repo]

config :data, PadelSlots.Data.Repo,
  database: "data_repo",
  username: "rp",
  password: "rp12345",
  hostname: System.get_env("PG_HOST")

# Sample configuration:
#
#     config :logger, :console,
#       level: :info,
#       format: "$date $time [$level] $metadata$message\n",
#       metadata: [:user_id]
#
