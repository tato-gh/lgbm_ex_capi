import Config

if Mix.env == :test do
  config :lgbm_ex_cli,
    lightgbm_cmd: Path.join(System.get_env("LIGHTGBM_DIR") || "", "lightgbm")
end
