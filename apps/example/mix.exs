defmodule Example.Mixfile do
  use Mix.Project

  def project do
    [
      app: :example,
      build_embedded: Mix.env == :prod,
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps: deps(),
      deps_path: "../../deps",
      elixir: "~> 1.3",
      lockfile: "../../mix.lock",
      start_permanent: Mix.env == :prod,
      version: "0.1.0",

      compilers: [:thrift | Mix.compilers],
      thrift_files: thrift_files(),
      thrift_options: ~w[--gen erl:maps],
      thrift_output: "src/gen",
      thrift_version: ">= 0.9.3",
    ]
  end

  def application do
    [
      applications: [:logger, :cowboy, :gun],
      mod: {Example.App, []}
    ]
  end

  defp thrift_files do
    Mix.Utils.extract_files(["thrift"], [:thrift])
  end

  defp deps do
    [
    ]
  end
end
