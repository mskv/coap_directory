defmodule CoapDirectory.ObserverSupervisor do
  use Supervisor

  @name CoapDirectory.ObserverSupervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: @name)
  end

  def start_observer(path, target_pid) do
    Supervisor.start_child(@name, [path, target_pid])
  end

  def init([]) do
    children = [
      worker(CoapDirectory.Observer, [], restart: :temporary)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end
end
