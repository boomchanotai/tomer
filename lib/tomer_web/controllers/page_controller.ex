defmodule TomerWeb.PageController do
  use TomerWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false, isAdmin: false)
  end

  def admin(conn, _params) do
    state = Tomer.Room.get()
    render(conn, :home, layout: false, isAdmin: true, state: state)
  end
end
