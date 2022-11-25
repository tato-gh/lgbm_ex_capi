defmodule LGBMExCapi do
  @moduledoc """
  Documentation for `LGBMExCapi`.
  """

  alias LGBMExCapi.Interface

  @doc """
  Load model from file.

  Returns the reference, that is important to specify nif resource.
  """
  def load(file) do
    args = encode_to_json_charlist(%{file: file})
    Interface.booster_create_from_model_file(args)
  end

  @doc """
  Predict data.
  """
  def predict(_reference, []), do: []

  def predict(reference, features) do
    first_elem = hd(features)
    cond do
      is_list(first_elem) -> predict_rows(reference, features)
      true -> predict_row(reference, features)
    end
  end

  defp predict_rows(reference, features) do
    ncol = Enum.count(hd(features))
    json_arg =
      encode_to_json_charlist(%{
        row: List.flatten(features),
        nrow: Enum.count(features),
        ncol: ncol
      })

    Interface.booster_predict_for_mat(reference, json_arg)
    |> decode_json_charlist()
    |> Map.get("result")
  end

  defp predict_row(reference, features) do
    json_arg =
      encode_to_json_charlist(%{
        row: features,
        ncol: Enum.count(features)
      })

    Interface.booster_predict_for_mat_single_row(reference, json_arg)
    |> decode_json_charlist()
    |> Map.get("result")
  end

  def get_num_iterations(reference) do
    Interface.booster_get_current_iteration(reference)
  end

  def get_num_classes(reference) do
    Interface.booster_get_num_classes(reference)
  end

  def get_feature_importance(reference, num_features) do
    Interface.booster_feature_importance(reference, num_features)
    |> Jason.decode!()
    |> Map.get("result")
    |> Enum.map(& round(&1))
  end

  defp encode_to_json_charlist(attrs) do
    Jason.encode!(attrs)
    |> String.to_charlist()
  end

  defp decode_json_charlist(charlist) do
    charlist
    |> List.to_string()
    |> Jason.decode!()
  end
end
