defmodule TomerWeb.PageController do
  use TomerWeb, :controller

  def home(conn, %{ "id" => id }) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false, isAdmin: false)
  end

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    id = :rand.uniform(30)
    redirect(conn, to: ~p"/?id=#{id}")
  end

  def admin(conn, %{ "id" => id }) do
    state = Tomer.Room.get()
    render(conn, :home, layout: false, isAdmin: true, state: state)
  end

  def admin(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    id = :rand.uniform(30)
    redirect(conn, to: ~p"/admin?id=#{id}")
  end
end
