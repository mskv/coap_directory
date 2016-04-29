defmodule CoapDirectory do
  use Application

  def start(_type, _args) do
    CoapDirectory.Supervisor.start_link
  end
end
