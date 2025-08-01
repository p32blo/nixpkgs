{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  poetry-core,

  # dependencies
  markdown-it-py,
  pygments,
  typing-extensions,

  # optional-dependencies
  ipywidgets,

  # tests
  attrs,
  pytestCheckHook,
  which,

  # for passthru.tests
  enrich,
  httpie,
  rich-rst,
  textual,
}:

buildPythonPackage rec {
  pname = "rich";
  version = "14.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Textualize";
    repo = "rich";
    tag = "v${version}";
    hash = "sha256-gnKzb4lw4zgepTfJahHnpw2/vcg8o1kv8KfeVDSHcQI=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    markdown-it-py
    pygments
  ]
  ++ lib.optionals (pythonOlder "3.11") [ typing-extensions ];

  optional-dependencies = {
    jupyter = [ ipywidgets ];
  };

  nativeCheckInputs = [
    attrs
    pytestCheckHook
    which
  ];

  disabledTests = [
    # pygments 2.19 regressions
    # https://github.com/Textualize/rich/issues/3612
    "test_inline_code"
    "test_blank_lines"
    "test_python_render_simple_indent_guides"
  ];

  pythonImportsCheck = [ "rich" ];

  passthru.tests = {
    inherit
      enrich
      httpie
      rich-rst
      textual
      ;
  };

  meta = with lib; {
    description = "Render rich text, tables, progress bars, syntax highlighting, markdown and more to the terminal";
    homepage = "https://github.com/Textualize/rich";
    changelog = "https://github.com/Textualize/rich/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ris ];
  };
}
