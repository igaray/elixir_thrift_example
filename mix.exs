defmodule ElixirThriftExample.Mixfile do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
    ]
  end

  defp deps do
    [
      {:distillery, "~> 1.5"},
      {:ranch, git: "https://github.com/ninenines/ranch", ref: "1.4.0", override: true},
      {:cowboy, git: "https://github.com/ninenines/cowboy.git", branch: "master"},
      {:thrift, git: "git@github.com:pinterest/elixir-thrift.git", branch: "thrift_tng"},
    ]
  end
end
