# frozen_string_literal: true

require_relative 'breadcrumb_helper/version'

raise LoadError, 'The project is not a Rails project!' unless defined?(Rails)

# The main namespace module for the gem.
module BreadcrumbHelper; end

require_relative 'breadcrumb_helper/main'

require_relative 'breadcrumb_helper/railtie'
