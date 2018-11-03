module ApplicationHelper
  def flash_helper
    flash.map do |key, value|
      # is-success
      # is-danger

      notification_class =
        case key
        when :notice
          'is-info'
        when :alert
          'is-warning'
        end

      content_tag :div, class: "notification #{notification_class}" do
        content_tag(:button, '', class: 'delete') + content_tag(:span, value)
      end
    end.join(',').html_safe
  end

  def breadcrumb(organization = nil)
    content_tag :nav, class: 'breadcrumb', 'aria-label': 'breadcrumbs' do
      content_tag :ul do
        concat(
          content_tag(
            :li,
            link_to(content_tag(:span, t(:account)), account_path)
          )
        )
        concat(
          content_tag(
            :li,
            link_to(content_tag(:span, organization.name), organization_path(@organization))
          )
        ) if organization

        concat(yield) if block_given?
      end
    end
  end
end
