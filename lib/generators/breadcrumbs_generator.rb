# frozen_string_literal: true

# Generates a breadcrumb view templates to be used in your Rails application.
# Doing so adds more freedom with styling and customizing the breadcrumb view.
class BreadcrumbsGenerator < Rails::Generators::Base
  source_root File.expand_path('templates', __dir__)
  desc 'Generates breadcrumb view templates based on given namespace.'
  argument :name, type: :string, default: ''

  def create_namespaced_breadcrumb_views
    return if processed_name.blank?

    copy_file 'breadcrumb_items.html.erb', "app/views/layouts/#{processed_name}/_breadcrumb_items.html.erb"
    copy_file 'breadcrumbs.html.erb', "app/views/layouts/#{processed_name}/_breadcrumbs.html.erb"
  end

  def create_shared_breadcrumb_views
    return if processed_name.present?

    copy_file 'breadcrumb_items.html.erb', 'app/views/shared/_breadcrumb_items.html.erb'
    copy_file 'breadcrumbs.html.erb', 'app/views/shared/_breadcrumbs.html.erb'
  end

  def create_breadcrumb_concern
    return if processed_name.blank?

    template 'name.rb', "app/helpers/concerns/breadcrumb_helper/#{processed_name}.rb"
  end

  private

  def processed_name
    @processed_name ||= name.strip.delete_prefix('/').delete_suffix('/')
  end
end
