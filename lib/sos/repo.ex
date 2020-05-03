defmodule Sos.Repo do
  use Ecto.Repo,
    otp_app: :sos,
    adapter: Ecto.Adapters.Postgres
end
