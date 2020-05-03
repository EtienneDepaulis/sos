defmodule SosWeb.PatientLive.PatientComponent do
  use SosWeb, :live_component

  def render(assigns) do
    ~L"""
      <tr id="patient-<%= @patient.id %>">
        <td><%= @patient.first_name %></td>
        <td><%= @patient.last_name %></td>

        <td>
          <span><%= live_redirect "Show", to: Routes.patient_show_path(@socket, :show, @patient) %></span>
          <span><%= live_patch "Edit", to: Routes.patient_index_path(@socket, :edit, @patient) %></span>
          <span><%= link "Delete", to: "#", phx_click: "delete", phx_value_id: @patient.id, data: [confirm: "Are you sure?"] %></span>
        </td>
      </tr>
    """
  end
end
