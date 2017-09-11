defmodule Example.Mixfile do
  use Mix.Project

  def project do
    [
      app: :example,
      build_embedded: Mix.env == :prod,
      build_path: "../../_build",
      compilers: [:thrift | Mix.compilers],
      config_path: "../../config/config.exs",
      deps: deps(),
      deps_path: "../../deps",
      elixir: "~> 1.3",
      lockfile: "../../mix.lock",
      start_permanent: Mix.env == :prod,
      thrift_files: thrift_files(),
      thrift_options: ~w[--gen erl:maps],
      thrift_output: "src/gen"
      thrift_version: ">= 0.9.3",
      version: "0.1.0",
    ]
  end

  def application do
    [
      applications: [:logger],
      mod: {Example, []}
    ]
  end

  defp thrift_files do
    Mix.Utils.extract_files(["src/thrift"], [:thrift])
  end

  defp deps do
    [
      {:thrift, "~> 1.3"}
    ]
  end
end
