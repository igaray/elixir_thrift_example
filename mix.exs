defmodule ElixirThriftExample.Mixfile do
  use Mix.Project

  def project do
    [apps_path: "apps",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  defp deps do
    [
      {:cowboy, "~> 1.1"},
      {:distillery, "~> 1.5"},
      {:thrift, "~> 1.3"},
    ]
  end
end
