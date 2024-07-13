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
    id = gen_random_id()
    redirect(conn, to: ~p"/?id=#{id}")
  end

  def admin(conn, %{ "id" => id }) do
    state = Tomer.Room.get()
    render(conn, :home, layout: false, isAdmin: true, state: state)
  end

  def admin(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    id = gen_random_id()
    redirect(conn, to: ~p"/admin?id=#{id}")
  end
  
  defp gen_random_id do
    adjs = [
      "fat",
      "ancient",
      "lewd",
      "scarce",
      "hollow",
      "utopian",
      "tiny",
      "tangible",
      "acceptable",
      "distinct",
      "spectacular",
      "ablaze",
      "average",
      "meaty",
      "uttermost",
      "hideous",
      "belligerent",
      "rainy",
      "wakeful",
      "greedy"
    ]
    nouns = [
      "scent",
      "butter",
      "sheep",
      "crayon",
      "jewel",
      "elbow",
      "bag",
      "yard",
      "whip",
      "yam",
      "vegetable",
      "vessel",
      "force",
      "part",
      "fifth",
      "team",
      "toes",
      "riddle",
      "week",
      "heat"
    ]
    "#{Enum.random(adjs)}-#{Enum.random(nouns)}"
  end
end
