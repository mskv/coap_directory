defmodule CoapDirectory.ObservationResponderSupervisor do
  use Supervisor

  @name CoapDirectory.ObservationResponderSupervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: @name)
  end

  def start_observation_responder(callback_url) do
    Supervisor.start_child(@name, [callback_url])
  end

  def init([]) do
    children = [
      worker(CoapDirectory.ObservationResponder, [], restart: :temporary)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end
end
