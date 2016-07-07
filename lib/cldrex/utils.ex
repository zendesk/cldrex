defmodule CLDRex.Utils do
  @moduledoc false

  @doc false
  def normalize_locale(locale) when is_binary(locale) do
    locale
    |> String.replace("-", "_")
    |> String.downcase
    |> String.to_atom
  end

  @doc false
  def normalize_locale(locale) do
    locale
    |> to_string
    |> normalize_locale
  end

  @doc false
  def fallback(locale) do
    locale
    |> normalize_locale
    |> to_string
    |> String.split("_")
    |> Enum.at(0, "en")
    |> normalize_locale
  end
end