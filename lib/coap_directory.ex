defmodule CoapDirectory do
  use Application

  def start(_type, _args) do
    CoapDirectory.ResourceRegistry.start
    CoapDirectory.Supervisor.start_link
  end
end
