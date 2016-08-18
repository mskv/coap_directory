defmodule CoapDirectory do
  use Application

  def start(_type, _args) do
    dispatch = :cowboy_router.compile([{:_, [{"/[...]", CoapDirectory.HttpRequestHandler, []}]}])
    {:ok, _} = :cowboy.start_http(:http, 100, [port: 8080], [env: [dispatch: dispatch]])
    CoapDirectory.ResourceRegistry.start
    CoapDirectory.ObservationResponder.start
    CoapDirectory.Supervisor.start_link
  end
end
