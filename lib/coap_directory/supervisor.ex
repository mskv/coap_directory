defmodule CoapDirectory.Supervisor do
  use Supervisor

  @name CoapDirectory.Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: @name)
  end

  def init([]) do
    children = [
      worker(Coap.Storage, [[], []])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
