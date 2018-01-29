defmodule Project3.Mixfile do
  use Mix.Project

  def project do
    [
      app: :project3,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      escript: escript(),
      deps: deps()
    ]
  end

  
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp escript() do
    [
    main_module: Project3
    ]
    end

 
  defp deps do
    [
    
      {:convertat, "~> 1.0"}
    ]
  end
end
