defmodule CoapDirectory.HttpRequestHandler do
  import Coap.Records
  alias CoapDirectory.Client

  def init(req, _options) do
    path = :cowboy_req.path(req) |> String.slice(1, String.length(:cowboy_req.path(req)))
    method = :cowboy_req.method(req) |> String.downcase |> String.to_atom
    {:ok, request_body, req} = :cowboy_req.body(req)
    content = coap_content(payload: request_body)

    {response_code, response_body} = case Client.request(path, method, content) do
      task = %Task{} ->
        {:ok, _response_type, {:coap_content, _etag, _max_age, _format, payload}} = Task.await(task)
        {200, payload}
      :not_found -> {404, "not found"}
    end

    req = :cowboy_req.reply(response_code, [{"content-type", "text/plain"}], response_body, req)
    {:ok, req, nil}
  end

  def terminate(_reason, _req, _state), do: :ok
end
