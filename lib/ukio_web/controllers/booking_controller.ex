defmodule UkioWeb.BookingController do
  use UkioWeb, :controller

  alias Ukio.Apartments
  alias Ukio.Apartments.Booking
  alias Ukio.Bookings.Handlers.BookingCreator

  action_fallback UkioWeb.FallbackController

  @spec create(any(), map()) :: any()
  def create(conn, %{"booking" => booking_params}) do
    case BookingCreator.create(booking_params) do
      {:ok, booking} ->
        conn
        |> put_status(:created)
        |> render(:show, booking: booking)
      {:error, _error} ->
        conn
        |> put_status(:unauthorized) # 401
        |> put_view(json: UkioWeb.ErrorJSON)
        |> render("401.json")
    end
  end

  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    booking = Apartments.get_booking!(id)
    render(conn, :show, booking: booking)
  end
end
