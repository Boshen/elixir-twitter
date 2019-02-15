defmodule TwitterWeb.ErrorHelpersTest do
  use TwitterWeb.ConnCase
  alias TwitterWeb.ErrorHelpers

  test "translate_error" do
    assert ErrorHelpers.translate_error({"1 error", %{}}) == "1 error"
  end

  test "translate_error plural" do
    assert ErrorHelpers.translate_error({"%{count} errors", %{count: 2}}) == "2 errors"
  end
end
