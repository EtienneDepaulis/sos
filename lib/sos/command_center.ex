defmodule Sos.CommandCenter do
  @moduledoc """
  The CommandCenter context.
  """

  import Ecto.Query, warn: false
  alias Sos.Repo

  alias Sos.CommandCenter.Patient

  def all_patients do
    Patient
    |> order_by([p], [asc: p.last_name])
  end

  @doc """
  Returns the list of patients.

  ## Examples

      iex> list_patients()
      [%Patient{}, ...]

  """
  def list_patients do
    all_patients()
    |> Repo.all
  end

  def list_patients(query) do
    all_patients()
    |> where([p], ilike(p.first_name, ^"%#{query}%") or ilike(p.last_name, ^"%#{query}%"))
    |> Repo.all
  end

  @doc """
  Gets a single patient.

  Raises `Ecto.NoResultsError` if the Patient does not exist.

  ## Examples

      iex> get_patient!(123)
      %Patient{}

      iex> get_patient!(456)
      ** (Ecto.NoResultsError)

  """
  def get_patient!(id), do: Repo.get!(Patient, id)

  @doc """
  Creates a patient.

  ## Examples

      iex> create_patient(%{field: value})
      {:ok, %Patient{}}

      iex> create_patient(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_patient(attrs \\ %{}) do
    %Patient{}
    |> Patient.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:patient_created)
  end

  @doc """
  Updates a patient.

  ## Examples

      iex> update_patient(patient, %{field: new_value})
      {:ok, %Patient{}}

      iex> update_patient(patient, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_patient(%Patient{} = patient, attrs) do
    patient
    |> Patient.changeset(attrs)
    |> Repo.update()
    |> broadcast(:patient_updated)
  end

  @doc """
  Deletes a patient.

  ## Examples

      iex> delete_patient(patient)
      {:ok, %Patient{}}

      iex> delete_patient(patient)
      {:error, %Ecto.Changeset{}}

  """
  def delete_patient(%Patient{} = patient) do
    patient
    |> Repo.delete
    |> broadcast(:patient_deleted)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking patient changes.

  ## Examples

      iex> change_patient(patient)
      %Ecto.Changeset{data: %Patient{}}

  """
  def change_patient(%Patient{} = patient, attrs \\ %{}) do
    Patient.changeset(patient, attrs)
  end

  def subscribe do
    Phoenix.PubSub.subscribe(Sos.PubSub, "patients")
  end

  defp broadcast({:error, _reason} = error, _event), do: error

  defp broadcast({:ok, patient}, event) do
    Phoenix.PubSub.broadcast(Sos.PubSub, "patients", {event, patient})
    {:ok, patient}
  end
end
