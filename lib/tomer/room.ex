defmodule Tomer.Room do
  alias Phoenix.PubSub
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
  def handle_call({:resume}, _from, %{ remainingEpoch: remainingEpoch }) do
    timerRef = Process.send_after(self(), {:timeout}, remainingEpoch)
    finalTime = System.os_time(:millisecond) + remainingEpoch
    newState = %{
      type: :running,
      finalTime: finalTime,
      timerRef: timerRef,
    }
    returnVal = %{
      type: :running,
      finalTime: finalTime,
    }
    {:reply, returnVal, newState}
  end

  @impl true
  def handle_call({:pause}, _from, %{ type: :running, finalTime: finalTime, timerRef: timerRef }) do
    Process.cancel_timer(timerRef)
    newState = %{
      type: :pause,
      remainingEpoch: finalTime - System.os_time(:millisecond),
    }
    {:reply, newState, newState}
  end

  def handle_info(x, _state) do
    newState = %{
      type: :standby,
    }
    PubSub.broadcast(Tomer.PubSub, "room:user", {:timeout, newState})
    {:noreply, newState}
  end
end
