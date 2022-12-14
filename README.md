# LGBMExCapi

LGBMExCapi is a wrapper library for microsoft/LightGBM C-API, implemented by Elixir.

Functions

- `load/1`: Load LightGBM model from file.
- `predict/2`
- `get_num_iterations/1`
- `get_num_classes/1`
- `get_feature_importance/2`

Sample code

```elixir
alias LGBMExCapi, as: LightGBM

features_test = [
  [5.4, 3.9, 1.7, 0.4],
  [5.7, 2.8, 4.5, 1.3],
  [7.6, 3.0, 6.6, 2.1]
]

{:ok, nif_reference} = LightGBM.load(<model file path>)
results = LightGBM.predict(nif_reference, features_test)

num_iterations = LightGBM.get_num_iterations(nif_reference)
num_classes = LightGBM.get_num_classes(nif_reference)
feature_importance = LightGBM.get_feature_importance(nif_reference, num_features)
```

**NOTE**

- Beta version / Not stable
- See [LGBMExCli](https://github.com/tato-gh/lgbm_ex_cli) to create model file.


## Installation

**microsoft/LightGBM**

Refs: [LightGBM Installation Guide](https://lightgbm.readthedocs.io/en/latest/Installation-Guide.html#linux)


**Environment**

Set to make.

```
export ERL_EI_INCLUDE_DIR=$(elixir -e 'IO.puts [:code.root_dir, "/erts-", :erlang.system_info(:version), "/include"]')
export ERL_EI_LIBDIR=$(elixir -e 'IO.puts [:code.root_dir, "/usr", "/lib"]')
export LIGHTGBM_DIR=<microsoft/LightGBM directory path>
```

**Library**


```elixir
def deps do
  [
    {:lgbm_ex_capi, "0.1.0", git: "https://github.com/tato-gh/lgbm_ex_capi"}
  ]
end
```


## License

Copyright 2022 ta.to.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
