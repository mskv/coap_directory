defmodule CoapDirectory.Mixfile do
  use Mix.Project

  def project do
    [app: :coap_directory,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [
      applications: [:logger, :gen_coap, :cowboy, :httpoison],
      mod: {CoapDirectory, []}
    ]
  end

  defp deps do
    [
      {:cowboy, github: "ninenines/cowboy", tag: "2.0.0-pre.3"},
      {:gen_coap, git: "https://github.com/gotthardp/gen_coap.git"},
      {:coap, git: "https://github.com/mskv/coap.git"},
      {:httpoison, "~> 0.9.0"},
      {:poison, "~> 2.0"}
    ]
  end
end
