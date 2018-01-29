defmodule Convertat.Mixfile do
  use Mix.Project

  @version "1.1.0"

  def project do
    [
      app: :convertat,
      version: @version,
      name: "Convertat",
      source_url: "https://github.com/whatyouhide/convertat",
      elixir: "~> 1.0",
      deps: deps,
      package: package,
      description: description,
      test_coverage: [tool: ExCoveralls],
    ]
  end

  def application do
    [applications: [:logger]]
  end

  defp description do
    """
    Provides functions for converting from and to arbitrary bases.
    """
  end

  defp package do
    [
      contributors: ["Andrea Leopardi"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/whatyouhide/convertat"},
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.6", only: :docs},
      {:benchfella, github: "alco/benchfella", only: :dev},
      {:excoveralls, "~> 0.3", only: :test},
    ]
  end
end
