defmodule Twitter.Accounts.Pipeline do
  @moduledoc """
  The Accounts Pipeline.
  """
  use Guardian.Plug.Pipeline,
    otp_app: :twitter,
    error_handler: Twitter.Accounts.ErrorHandler,
    module: Twitter.Accounts.Guardian

  plug Guardian.Plug.VerifyCookie, claims: %{"typ" => "access"}

  plug Guardian.Plug.LoadResource, allow_blank: true
end
