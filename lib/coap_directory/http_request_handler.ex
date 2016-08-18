defmodule CoapDirectory.HttpRequestHandler do
  import Coap.Records
  alias CoapDirectory.Client
  alias CoapDirectory.ObservationResponderSupervisor
  alias CoapDirectory.ObserverSupervisor

  def init(req, _options) do
    {response_code, response_body} = handle_request(req)
    req = :cowboy_req.reply(response_code, [{"content-type", "text/plain"}], response_body, req)
    {:ok, req, nil}
  end

  def terminate(_reason, _req, _state), do: :ok

  # private

  defp handle_request(req) do
    case :cowboy_req.header("observe", req) do
      :undefined -> forward_request(req)
      callback_url -> start_observation(req, callback_url)
    end
  end

  defp forward_request(req) do
    case Client.request(extract_path(req), extract_method(req), extract_content(req)) do
      task = %Task{} ->
        {:ok, _response_type, {:coap_content, _etag, _max_age, _format, payload}} = Task.await(task)
        {200, payload}
      :not_found -> {404, "not found"}
    end
  end

  defp start_observation(req, callback_url) do
    {:ok, responder_pid} = ObservationResponderSupervisor.start_observation_responder(callback_url)
    case ObserverSupervisor.start_observer(extract_path(req), responder_pid) do
      {:ok, _observer_pid} -> {200, "observation started"}
      {:error, :not_found} -> {404, "not found"}
    end
  end

  defp extract_path(req) do
    :cowboy_req.path(req) |> String.slice(1, String.length(:cowboy_req.path(req)))
  end

  defp extract_method(req) do
    :cowboy_req.method(req) |> String.downcase |> String.to_atom
  end

  defp extract_content(req) do
    {:ok, request_body, _req} = :cowboy_req.body(req)
    coap_content(payload: request_body)
  end
end
