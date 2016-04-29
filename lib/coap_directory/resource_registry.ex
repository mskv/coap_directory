defmodule CoapDirectory.ResourceRegistry do
  use Coap.Resource
  alias Coap.Storage

  def start do
    start(["registry"], [])
  end

  # gen_coap handlers

  def coap_post(ch_id, _prefix, _name, content) do
    {ip, _channel_port} = ch_id
    {:coap_content, _etag, _max_age, _format, payload} = content
    {path, port} = parse_payload(payload)

    response = case Storage.set(path, {ip, port}) do
      false -> "path taken"
      _ -> "ok"
    end
    {:ok, :content, coap_content(payload: response)}
  end

  # private

  defp parse_payload(payload) do
    [path, port] = String.split(payload, " ")
    port = String.to_integer(port)
    {path, port}
  end
end
