defmodule SosWeb.PatientLive.Index do
  use SosWeb, :live_view

  alias Sos.CommandCenter
  alias Sos.CommandCenter.Patient

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: CommandCenter.subscribe()

    {:ok, assign(socket, :patients, fetch_patients())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Patient")
    |> assign(:patient, CommandCenter.get_patient!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Patient")
    |> assign(:patient, %Patient{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Patients")
    |> assign(:patient, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    patient = CommandCenter.get_patient!(id)
    {:ok, _} = CommandCenter.delete_patient(patient)

    {:noreply, socket}
  end

  def handle_info({:patient_created, patient}, socket) do
    {:noreply, update(socket, :patients, fn patients -> [patient | patients] end)}
  end

  def handle_info({:patient_updated, patient}, socket) do
    {:noreply, update(socket, :patients, fn patients -> [patient | patients] end)}
  end

  def handle_info({:patient_deleted, patient}, socket) do
    {:noreply, update(socket, :patients, fn patients -> patients |> remove_patient(patient) end)}
  end

  defp fetch_patients do
    CommandCenter.list_patients()
  end

  defp refresh_patients(patients, patient) do
    patients
    |> Enum.map(fn p -> maybe_replace_patient(p, patient) end)
  end

  def maybe_replace_patient(original_patient, new_patient) do
    if original_patient.id == new_patient.id do
      new_patient
    else
      original_patient
    end
  end

  defp remove_patient(patients, patient) do
    patients
    |> Enum.filter(fn p -> p.id != patient.id end)
  end
end
