defmodule LGBMExCapi.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/tato-gh/lgbm_ex_capi"

  def project do
    [
      app: :lgbm_ex_capi,
      version: @version,
      elixir: "~> 1.13",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      compilers: [:elixir_make | Mix.compilers()],
      # Docs
      name: "LGBMExCapi",
      description: "microsoft/LightGBM C-API simple wrapper",
      source_url: @source_url,
      docs: docs(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.27", only: :dev, runtime: false},
      {:elixir_make, "~> 0.6", runtime: false},
      {:jason, "~> 1.4"},
      {:lgbm_ex_cli, "0.1.0", git: "https://github.com/tato-gh/lgbm_ex_cli", runtime: false, only: :test}
    ]
  end

  defp docs do
    [
      main: "readme",
      api_reference: false,
      extras: ["README.md"]
    ]
  end

  defp package do
    [
      maintainers: ["ta.to."],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => @source_url}
    ]
  end
end
