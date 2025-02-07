# frozen_string_literal: true

module BreadcrumbHelper
  # Contains the core code driver for breadcrumbs.
  module Main
    # The method to add a breadcrumb item.
    # Add more methods to the helper to modify breadcrumb items.
    def add_breadcrumb(name:, path: nil)
      _breadcrumb_items << { name: name, path: path }
    end

    # Copy of breadcrumb items to prevent modification.
    def breadcrumb_items
      _breadcrumb_items.dup.freeze
    end

    # Render the items to view as a string and html_safe on.
    # Expected to find the partial in various locations thanks to Rails rendering.
    def render_breadcrumb_items
      begin
        try("#{action_name}_breadcrumbs")
      rescue NoMethodError
        Rails.logger.warn("An error occurred in #{action_name}_breadcrumbs in #{controller_namespace}.")
      end
      render('breadcrumb_items', items: breadcrumb_items)
    end

    private

    # Absolute source of truth for breadcrumb items, only modifiable through add_breadcrumb method.
    def _breadcrumb_items
      @_breadcrumb_items ||= []
    end

    # The namespace of the controller.
    def controller_namespace
      @controller_namespace ||= controller_path.split('/')[0...-1].join('/')
    end
  end
end
