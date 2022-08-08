defmodule SzettyBot.Repo do
  use Ecto.Repo,
    otp_app: :szetty_bot,
    adapter: Ecto.Adapters.SQLite3
end
