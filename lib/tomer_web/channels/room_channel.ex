defmodule TomerWeb.RoomChannel do
  alias Tomer.Room
  alias TomerWeb.Presence
  use TomerWeb, :channel

  @impl true
  def join("room:user", payload, socket) do
    send(self(), :after_join)
    case payload do
      %{ "id" => id } ->
        socket = socket |> assign(:user_id, id) |> assign(:admin, authorized?(Map.get(payload, "secretKey", "")))
        {:ok, socket}
      %{} -> {:ok, socket}
    end
  end

  # Get current state
  @impl true
  def handle_in("get", _payload, socket) do
    data = Room.get()
    push(socket, "get", data)
    {:noreply, socket}
  end

  # Standby -> pause
  @impl true
  def handle_in("set", %{ "remainingEpoch" => remainingEpoch }, socket) do
    if !socket.assigns.admin do
      {:noreply, socket}
    else
      state = Room.set(remainingEpoch)
      broadcast(socket, "state_changed", state)
      {:noreply, socket}
    end
  end

  # Pause -> Standby
  @impl true
  def handle_in("reset", _payload, socket) do
    if !socket.assigns.admin do
      {:noreply, socket}
    else
      state = Room.reset()
      broadcast(socket, "state_changed", state)
      {:noreply, socket}
    end
  end

  #  Pause -> Running
  @impl true
  def handle_in("resume", _payload, socket) do
    if !socket.assigns.admin do
      {:noreply, socket}
    else
      state = Room.resume()
      broadcast(socket, "state_changed", state)
      {:noreply, socket}
    end
  end

  # Running -> Puase
  @impl true
  def handle_in("pause", _payload, socket) do
    if !socket.assigns.admin do
      {:noreply, socket}
    else
      state = Room.pause()
      broadcast(socket, "state_changed", state)
      {:noreply, socket}
    end
  end

  # Running -> Puase
  @impl true
  def handle_in("chat", %{"content" => content} = payload, socket) do
    if !socket.assigns.admin do
      {:noreply, socket}
    else
      broadcast(socket, "chat", payload)
      {:noreply, socket}
    end
  end

  @impl true
  def handle_in(x, payload, socket) do
    IO.puts "Unexpected state"
    {:noreply, socket}
  end

  @impl true
  def handle_info({:timeout, newState}, socket) do
    broadcast(socket, "state_changed", newState)
    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    {:ok, _} = Presence.track(socket, socket.assigns.user_id, %{
      online_at: inspect(System.system_time(:second))
    })

    push(socket, "presence_state", Presence.list(socket))
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(secretKey) do
    secretKey == Application.fetch_env!(:tomer, :secret_key)
  end
end
