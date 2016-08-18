defmodule CoapDirectory.ObservationResponder do
  use GenServer
  use HTTPoison.Base

  def start_link(callback_url) do
    GenServer.start_link(__MODULE__, [callback_url], [])
  end

  # GenServer handlers

  def init([callback_url]) do
    {:ok, callback_url}
  end

  def handle_info(resource_observation, callback_url) do
    [resource_name, resource_state] = String.split(resource_observation, " ")
    post!(callback_url, %{resource: %{name: resource_name, state: resource_state}})
    {:noreply, callback_url}
  end

  defp process_request_body(body) do
    Poison.encode!(body)
  end

  defp process_request_headers(headers) do
    [{"content-type", "application/json"} | headers]
  end
end
