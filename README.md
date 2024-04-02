# Breadcrumb Helper for Rails

## Installation

Add this to your Gemfile:

```bash
gem 'breadcrumb_helper', '~> 0.1'
```

## Usage

### Generate the files

To start, use the provided generator for a simplified and streamlined workflow:

```bash
rails generate breadcrumbs namespace
```

For example:

```bash
rails generate breadcrumbs test/namespace
```
will generate the following files in `test/namespace` folder structure respectively.
1. `app/helpers/concerns/breadcrumb_helper/test/namespace.rb`
2. `app/views/test/namespace/_breadcrumbs.html.erb`
3. `app/views/test/namespace/_breadcrumb_items.html.erb`

### Structuring the breadcrumbs

The generator will provide a file inside `concerns` folder of `helpers`. This should be included (`include`) or prepended (`prepend`) to your helper files. Assume that we have a `Test::Namespace::SomeController` with `show` and `index` actions. There should exist a `Test::Namespace::SomeHelper` file that includes or prepends the `BreadcrumbHelper::Test::Namespace` module.

```ruby
module Test::Namespace
  module SomeHelper
    include BreadcrumbHelper::Test::Namespace
    # or prepend BreadcrumbHelper::Test::Namespace

    # ...
  end
end
```

Since `SomeController` have `show` and `index` actions, our helper can define breadcrumbs for each action as such:

```ruby
module Test::Namespace
  module SomeHelper
    include BreadcrumbHelper::Test::Namespace

    def index_breadcrumbs
      add_breadcrumb name: 'Home'
    end

    def show_breadcrumbs
      add_breadcrumb name: 'Home', path: root_path
      add_breadcrumb name: 'Specific Data'
    end
  end
end
```

With this setup, the controller's `index` and `show` actions will have their respective breadcrumbs rendered as defined in your helper.

### Render the breadcrumbs

Somewhere in your `layouts` (anywhere, really), simply call `render 'breadcrumbs'` to render them.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tieeeeen1994/breadcrumb_helper. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/tieeeeen1994/breadcrumb_helper/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the BreadcrumbHelper project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/tieeeeen1994/breadcrumb_helper/blob/master/CODE_OF_CONDUCT.md).
