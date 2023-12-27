defmodule Stwa.Repo do
  use Ecto.Repo,
    otp_app: :stwa_elixir,
    adapter: Ecto.Adapters.Postgres
end
