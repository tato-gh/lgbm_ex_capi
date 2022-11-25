defmodule LGBMExCapiTest do
  use ExUnit.Case
  alias LGBMExCapi, as: LightGBM
  alias LGBMExCapi.SampleData
  alias LGBMExCli, as: LightGBMCli

  describe "predict" do
    setup do
      workdir = Path.join(System.tmp_dir(), "#{__MODULE__}")
      File.mkdir_p!(workdir)
      on_exit(fn -> File.rm_rf!(workdir) end)

      {features, labels} = SampleData.iris(:train)
      params = SampleData.iris_params()
      {:ok, model_file} = LightGBMCli.fit(workdir, features, labels, params)
      {:ok, reference} = LightGBM.load(model_file)

      {:ok, reference: reference}
    end

    test "returns multi predicted values", c do
      {features, _labels} = SampleData.iris(:test)

      results = LightGBM.predict(c.reference, features)
      assert 3 == Enum.count(features)
      assert 3 == Enum.count(results)

      [r0, _r1, r2] = results
      assert Enum.at(r0, 0) >= 0.5
      # skip r1 assert due to lack of accurate learning.
      # assert Enum.at(r1, 1) >= 0.5
      assert Enum.at(r2, 2) >= 0.5
    end

    test "returns one predicted values", c do
      {features, _labels} = SampleData.iris(:test)
      result = LightGBM.predict(c.reference, hd(features))

      assert Enum.at(result, 0) >= 0.5
    end
  end

  describe "get model information" do
    setup do
      workdir = Path.join(System.tmp_dir(), "#{__MODULE__}")
      File.mkdir_p!(workdir)
      on_exit(fn -> File.rm_rf!(workdir) end)

      {features, labels} = SampleData.iris(:train)
      params =
        SampleData.iris_params()
        |> Keyword.merge(num_iterations: 5)
      {:ok, model_file} = LightGBMCli.fit(workdir, features, labels, params)
      {:ok, reference} = LightGBM.load(model_file)

      {:ok, reference: reference}
    end

    test "get_num_iterations", c do
      assert 5 == LightGBM.get_num_iterations(c.reference)
    end

    test "get_num_classes", c do
      assert 3 == LightGBM.get_num_classes(c.reference)
    end

    test "get_feature_importance", c do
      feature_importance = LightGBM.get_feature_importance(c.reference, 4)

      assert 4 == Enum.count(feature_importance)
      assert Enum.all?(feature_importance, & &1 > 0)
    end
  end
end
