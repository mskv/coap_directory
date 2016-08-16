defmodule CoapDirectory.Observer do
  use GenServer
  alias Coap.Storage

  def start_link(path, target_pid) do
    GenServer.start_link(__MODULE__, [path, target_pid], [])
  end

  # GenServer handlers

  def init([path, target_pid]) do
    case Storage.get(path) do
      :not_found -> {:stop, :not_found}
      address ->
        :coap_observer.observe(coap_uri(address, path))
        {:ok, target_pid}
    end
  end

  def handle_info({:coap_notify, _pid, :undefined, _code, _content}, target_pid) do
    {:stop, :normal, target_pid}
  end

  def handle_info({:coap_notify, _pid, _n, _code, content}, target_pid) do
    {:coap_content, _etag, _max_age, _format, payload} = content
    send(target_pid, payload)
    {:noreply, target_pid}
  end

  defp coap_uri(address, path) do
    {ip, port} = address
    'coap://' ++ :inet.ntoa(ip) ++ ':' ++ Integer.to_char_list(port) ++ '/' ++
    String.to_char_list(path)
  end
end
