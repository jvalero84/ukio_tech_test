defmodule UkioWeb.ApartmentController do
  use UkioWeb, :controller

  alias Ukio.Apartments

  action_fallback UkioWeb.FallbackController

  @spec index(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def index(conn, _params) do
    apartments = Apartments.list_apartments()
    render(conn, :index, apartments: apartments)
  end
end
