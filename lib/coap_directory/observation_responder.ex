defmodule CoapDirectory.ObservationResponder do
  use GenServer

  def start_link(callback_url) do
    GenServer.start_link(__MODULE__, [callback_url], [])
  end

  # GenServer handlers

  def init([callback_url]) do
    {:ok, callback_url}
  end

  def handle_info(_msg, callback_url) do
    {:noreply, callback_url}
  end
end
