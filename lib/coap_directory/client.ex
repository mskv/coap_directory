defmodule CoapDirectory.Client do
  import Coap.Records
  alias Coap.Storage

  def discover do
    Storage.all |> Enum.map(fn({path, _address}) -> path end)
  end

  def get(path) do
    request(path, :get, coap_content())
  end

  def put(path, payload) do
    request(path, :put, coap_content(payload: payload))
  end

  def request(path, method, content) do
    case Storage.get(path) do
      :not_found -> :not_found
      address -> async_request(address, path, method, content)
    end
  end

  defp async_request(address, path, method, content) do
    Task.async(fn -> :coap_client.request(method, coap_uri(address, path), content) end)
  end

  defp coap_uri(address, path) do
    {ip, port} = address
    'coap://' ++ :inet.ntoa(ip) ++ ':' ++ Integer.to_char_list(port) ++ '/' ++
    String.to_char_list(path)
  end
end
