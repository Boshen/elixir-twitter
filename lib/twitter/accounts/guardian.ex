defmodule Twitter.Accounts.Guardian do
  @moduledoc """
  The Accounts Guardian.
  """
  use Guardian, otp_app: :twitter
  alias Twitter.Accounts

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  def resource_from_claims(%{"sub" => id}) do
    Accounts.get_user(id)
  end
end
