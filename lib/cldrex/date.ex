defmodule CLDRex.Date do
  @moduledoc """
  Provide date localization for common date formats.
  """
  import CLDRex.Utils

  alias CLDRex.Main
  alias CLDRex.Formatters.CLDRDateFormatter

  @type locale :: atom | String.t
  @type date :: Date.t | {number, number, number}

  @doc """
  Convert the given date into the corresponding CLDR format.

  Accepted options are:

    - calendar: the calendar to use. default: `gregorian`
    - length: the date format to use. commonly available:
      - `full`
      - `long`
      - `medium`
      - `short`

  ## Examples

  ```
  iex> {date, time} = :calendar.universal_time
  {{2016, 7, 17}, {9, 38, 43}}

  iex> CLDRex.Date.localize(date, :en)
  "Sunday, July 17, 2016"
  ```

  ```
  iex> CLDRex.Date.localize({2016, 07, 11}, :en)
  "Monday, July 11, 2016"
  ```

  ```
  iex> CLDRex.Date.localize({2016, 07, 11}, :fr, length: "medium")
  "11 juil. 2016"
  ```

  """
  @spec localize(date, locale, Keyword.t) :: String.t
  def localize(date, locale, options \\ []) do
    locale   = normalize_locale(locale)
    cal      = get_in(options, [:calendar]) || default_calendar(locale)
    length   = get_in(options, [:length])   || default_date_format(locale, cal)

    f = get_in(Main.cldr_main_data,
      [locale, :calendars, cal, "dateFormats", length, "dateFormat", "pattern"])

    CLDRDateFormatter.format(date, f, {locale, cal})
  end

  @doc """
  Shortcut for `localize/3` when passed the `length: "short"` option.

  ## Examples

  ```
  iex> CLDRex.Date.short({2016, 07, 11}, :en)
  "7/11/2016"
  ```

  """
  @spec short(date, locale, atom) :: String.t
  def short(date, locale, calendar \\ nil),
    do: localize(date, locale, %{length: "short", calendar: calendar})

  @doc """
  Shortcut for `localize/3` when passed the `length: "medium"` option.

  ## Examples

  ```
  iex(7)> CLDRex.Date.medium({2016, 07, 11}, :es)
  "11 jul. 2016"
  ```

  """
  @spec medium(date, locale, atom) :: String.t
  def medium(date, locale, calendar \\ nil),
    do: localize(date, locale, %{length: "medium", calendar: calendar})

  @doc """
  Shortcut for `localize/3` when passed the `length: "long"` option.

  ## Examples

  ```
  iex> CLDRex.Date.long({2016, 07, 11}, :fr)
  "11 juillet 2016"
  ```

  """
  @spec long(date, locale, atom) :: String.t
  def long(date, locale, calendar \\ nil),
    do: localize(date, locale, %{length: "long", calendar: calendar})

  @doc """
  Shortcut for `localize/3` when passed the `length: "full"` option.

  ## Examples

  ```
  iex> CLDRex.Date.full({2016, 07, 11}, :de)
  "Montag, 11. Juli 2016"
  ```

  """
  @spec full(date, locale, atom) :: String.t
  def full(date, locale, calendar \\ nil),
    do: localize(date, locale, %{length: "full", calendar: calendar})
end
