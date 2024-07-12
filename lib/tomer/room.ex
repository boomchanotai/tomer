defmodule Tomer.Room do
  use GenServer

  @impl true
  def init(_args) do
    state = %{
      type: :standby
    }
    {:ok, state}
  end

  @impl true
  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def get() do
    GenServer.call(__MODULE__, {:get})
  end

  def set(remainingEpoch) do
    GenServer.call(__MODULE__, {:set, remainingEpoch})
  end

  def reset() do
    GenServer.call(__MODULE__, {:reset})
  end

  def resume() do
    GenServer.call(__MODULE__, {:resume})
  end

  def pause() do
    GenServer.call(__MODULE__, {:pause})
  end

  @impl true
  def handle_call({:get}, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call({:set, remainingEpoch}, _from, %{ type: :standby }) do
    newState = %{
      type: :pause,
      remainingEpoch: remainingEpoch,
    }
    {:reply, newState, newState}
  end

  @impl true
  def handle_call({:reset}, _from, %{ type: :pause }) do
    newState = %{
      type: :standby,
    }
    {:reply, newState, newState}
  end

  @impl true
  def handle_call({:resume}, _from, %{ remainingEpoch: remainingEpoch, type: :pause }) do
    newState = %{
      type: :running,
      finalTime: System.os_time(:millisecond) + remainingEpoch,
    }
    {:reply, newState, newState}
  end

  @impl true
  def handle_call({:pause}, _from, %{ type: :running, finalTime: finalTime }) do
    newState = %{
      type: :pause,
      remainingEpoch: finalTime - System.os_time(:millisecond),
    }
    {:reply, newState, newState}
  end

end
