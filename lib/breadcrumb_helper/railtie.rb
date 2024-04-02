# frozen_string_literal: true

module BreadcrumbHelper
  # Railtie for Breadcrumb Helper for Rails integration.
  class Railtie < Rails::Railtie
    generators do
      require_relative '../generators/breadcrumbs_generator'
    end

    # Do not include helpers in controllers by default.
    # This will still include helpers associated with the controller.
    # E.g. Namespace::SomeController will still by default include Namespace::SomeHelper.
    config.action_controller.include_all_helpers = false
  end
end
