# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :szetty_bot,
  ecto_repos: [SzettyBot.Repo],
  discord_guild_id: 406_770_575_994_912_769

config :nostrum,
  token: "MTAwNTQwNDI1MTQ3Mzg1MDQyOA.GxO8gv.7ljx76EK85zeOyEqkpDEwJrVK1w1qxjuXPCDuA",
  gateway_intents: [
    :guild_messages,
    :message_content
  ]

# Configures the endpoint
config :szetty_bot, SzettyBotWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: SzettyBotWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: SzettyBot.PubSub,
  live_view: [signing_salt: "Pn++YHys"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :szetty_bot, SzettyBot.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.29",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: :all

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
