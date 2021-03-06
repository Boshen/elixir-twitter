defmodule TwitterWeb.Guardian.ErrorHandler do
  @moduledoc """
  The Guardian ErrorHandler.
  """

  import Plug.Conn
  use TwitterWeb, :controller

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, _reason}, _opts) do
    conn
    |> put_status(:unauthorized)
    |> json(to_string(type))
  end
end
