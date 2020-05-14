defmodule SosWeb.PatientLive.PatientComponent do
  use SosWeb, :live_component

  def render(assigns) do
    ~L"""
      <tr class="<%= if new_item?(@new_patient_ids, @patient.id) do "new-item" end %>" id="patient-<%= @patient.id %>">
        <td class="px-6 py-4 whitespace-no-wrap border-b border-gray-200 text-sm leading-5 text-gray-900"><%= @patient.first_name %></td>
        <td class="px-6 py-4 whitespace-no-wrap border-b border-gray-200 text-sm leading-5 text-gray-900"><%= @patient.last_name %></td>

        <td class="px-6 py-4 whitespace-no-wrap border-b border-gray-200 text-sm leading-5 text-gray-500">
          <span><%= live_redirect "Show", to: Routes.patient_show_path(@socket, :show, @patient), class: "text-blue-600 hover:text-blue-900" %></span>
          <span><%= live_patch "Edit", to: Routes.patient_index_path(@socket, :edit, @patient) %></span>
          <span><%= link "Delete", to: "#", phx_click: "delete", phx_value_id: @patient.id, data: [confirm: "Are you sure?"] %></span>
        </td>
      </tr>
    """
  end

  defp new_item?(ids, id) do
    Enum.count(ids, fn x -> x == id end) > 0
  end

end
