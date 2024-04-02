# frozen_string_literal: true

require_relative 'breadcrumb_helper/version'

raise LoadError, 'The project is not a Rails project!' unless defined?(Rails)

require_relative 'breadcrumb_helper/main'

require_relative 'breadcrumb_helper/railtie'
