To be used in conjunction with [CoapNode](https://github.com/mskv/coap_node). It mocks an IoT setup where many CoAP nodes register their resources at one CoAP directory.

```
~/coap_directory> iex -S mix
iex(1)>

~/coap_node> COAP_PORT=50000 iex -S mix
iex(1)> CoapNode.Resources.Switch.start(["switches", "1"], [])
:ok

~/coap_directory>
iex(1)> CoapDirectory.Client.get("switches/1") |> Task.await()
{:ok, :content, {:coap_content, :undefined, 60, :undefined, "switches/1 off"}}
iex(2)> CoapDirectory.Client.put("switches/1", "toggle") |> Task.await()
{:ok, :changed, {:coap_content, :undefined, 60, :undefined, ""}}
iex(3)> CoapDirectory.Client.get("switches/1") |> Task.await()
{:ok, :content, {:coap_content, :undefined, 60, :undefined, "switches/1 on"}}

iex(4)> CoapDirectory.ObserverSupervisor.start_observer("switches/1", self())
{:ok, #PID<0.288.0>}
iex(5)> CoapDirectory.Client.put("switches/1", "toggle") |> Task.await()
{:ok, :changed, {:coap_content, :undefined, 60, :undefined, ""}}
iex(6)> flush()
"switches/1 off"
:ok
```

To see it hooked up to the browser visit [CoapWebserver](https://github.com/mskv/coap_webserver).

Related blogposts:
  - [part 1](http://monterail.com/blog/2016/iot-with-elixir-and-coap-part-1-example-on-how-to-easily-prototype-and-build-an-iot-platform/)
  - [part 2](http://monterail.com/blog/2016/iot-with-elixir-and-coap-part-2-example-on-how-to-easily-prototype-and-build-an-iot-platform/)
