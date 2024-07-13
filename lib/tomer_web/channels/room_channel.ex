defmodule TomerWeb.RoomChannel do
  alias Tomer.Room
  use TomerWeb, :channel

  @impl true
  def join("room:user", payload, socket) do
    {:ok, socket}
  end

  # Get current state
  @impl true
  def handle_in("get", _payload, socket) do
    data = Room.get()
    IO.inspect data
    push(socket, "get", data)
    {:noreply, socket}
  end

  # Standby -> pause
  @impl true
  def handle_in("set", %{ "remainingEpoch" => remainingEpoch }, socket) do
    state = Room.set(remainingEpoch)
    broadcast(socket, "state_changed", state)
    {:noreply, socket}
  end

  # Pause -> Standby
  @impl true
  def handle_in("reset", _payload, socket) do
    state = Room.reset()
    broadcast(socket, "state_changed", state)
    {:noreply, socket}
  end

  #  Pause -> Running
  @impl true
  def handle_in("resume", _payload, socket) do
    state = Room.resume()
    broadcast(socket, "state_changed", state)
    {:noreply, socket}
  end

  # Running -> Puase
  @impl true
  def handle_in("pause", _payload, socket) do
    state = Room.pause()
    broadcast(socket, "state_changed", state)
    {:noreply, socket}
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

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
