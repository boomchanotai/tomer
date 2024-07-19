defmodule TomerWeb.PageController do
  use TomerWeb, :controller

  def home(conn, params) do
    # The home page is often custom made,
    # so skip the default app layout.
    isLive = Map.get(params, "isLive", "false")
    render(conn, :home, layout: false, isAdmin: false, isLive: isLive == "true")
  end

  def admin(conn, _params) do
    state = Tomer.Room.get()
    render(conn, :home, layout: false, isAdmin: true, state: state, isLive: false)
  end
end
