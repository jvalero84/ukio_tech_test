defmodule Ukio.Bookings.Handlers.BookingCreator do
  alias Ukio.Apartments

  @spec create(map()) :: any()
  def create(
        %{"check_in" => check_in, "check_out" => check_out, "apartment_id" => apartment_id} =
          params
      ) do
    with a <- Apartments.get_apartment!(apartment_id),
         {:ok, b} <- checkAvailability(a, check_in),
         c <- generate_booking_data(a, check_in, check_out)
    do
      Apartments.create_booking(c)
    end
  end

  defp generate_booking_data(apartment, check_in, check_out) do
    %{
      apartment_id: apartment.id,
      check_in: check_in,
      check_out: check_out,
      monthly_rent: apartment.monthly_price,
      utilities: 20_000,
      deposit: 100_000
    }
  end

  @spec checkAvailability(atom() | %{:id => any(), optional(any()) => any()}, any()) ::
          {:error, <<_::312>>} | {:ok, 0}
  def checkAvailability(apartment, check_in) do
    case Apartments.get_num_bookings_for_date(apartment.id, check_in) do
       0 -> {:ok, 0}
       _ -> {:error, "_cannot_doublebook"}
    end
  end

end
