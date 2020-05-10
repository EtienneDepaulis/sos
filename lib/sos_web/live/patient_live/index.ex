defmodule SosWeb.PatientLive.Index do
  use SosWeb, :live_view

  alias Sos.CommandCenter
  alias Sos.CommandCenter.Patient

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: CommandCenter.subscribe()

    {:ok, assign(socket, patients: CommandCenter.list_patients(), query: "", loading: false, new_patient_ids: [])}
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

  @impl true
  def handle_event("filter", %{"query" => query}, socket) do
    send(self(), {:run_filter, query})

    socket =
      assign(socket,
        query: query,
        loading: true
      )

    {:noreply, socket}
  end

  @impl true
  def handle_info({:patient_created, patient}, socket) do
    {:noreply, assign(socket, patients: CommandCenter.list_patients(socket.assigns.query), new_patient_ids: [patient.id])}
  end

  @impl true
  def handle_info({:patient_updated, patient}, socket) do
    {:noreply, assign(socket, patients: CommandCenter.list_patients(socket.assigns.query), new_patient_ids: [patient.id])}
  end

  @impl true
  def handle_info({:patient_deleted, patient}, socket) do
    {:noreply, update(socket, :patients, fn patients -> patients |> remove_patient(patient) end)}
  end

  @impl true
  def handle_info({:run_filter, query}, socket) do
    case CommandCenter.list_patients(query) do
      [] ->
        socket =
          socket
          |> assign(patients: [], loading: false)

        {:noreply, socket}

      patients ->
        socket = assign(socket, patients: patients, loading: false)
        {:noreply, socket}
    end
  end

  defp remove_patient(patients, patient) do
    patients
    |> Enum.filter(fn p -> p.id != patient.id end)
  end
end
