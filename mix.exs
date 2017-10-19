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
      {:cowlib, git: "https://github.com/ninenines/cowlib", ref: "2.0.0", override: true},
      {:cowboy, git: "https://github.com/ninenines/cowboy", ref: "2.0.0"},

      {:gun, git: "git@github.com:ninenines/gun", ref: "1.0.0-pre.4"},

      {:thrift, git: "git@github.com:pinterest/elixir-thrift", branch: "master"},
    ]
  end
end
