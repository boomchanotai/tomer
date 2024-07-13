defmodule TomerWeb.Presence do
  use Phoenix.Presence,
    otp_app: :tomer,
    pubsub_server: Tomer.PubSub
end
