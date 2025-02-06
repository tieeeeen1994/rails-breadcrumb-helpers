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

## Gotchas

### Railtie Configuration

This gem's Railtie sets the Rails application's `config.action_controller.include_all_helpers` to `false`. This is a non-negotiable setup as the way breadcrumbs are defined in each helper *will have unavoidably similar method names*.

By default, Rails includes **all helper files** into a controller. This will result to some method names getting replaced when there are similar ones across all helpers. In order to avoid this, the mentioned config needs to be disabled so that **it only loads the related helper associated with the controller**.

### Crumb Stoppers

As of `0.2.0`, this gem now supports a feature called Crumb Stoppers. Suppose we have the given code:

```ruby
module Some::Namespace
  module MyHelper
    prepend BreadcrumbHelper::Some::Namespace

    def show_breadcrumbs
      add_breadcrumb name: 'Home', path: root_path
      add_breadcrumb name: @product.name # Assume this does not exist because of an unauthorized error that was rendered earlier.
    end
  end
end
```

The devloper will then need to add support for code *in each breadcrumb action*. To avoid this problem, the current default code of the gem is changed so that it stops the breadcrumb trail when it encounters a `NoMethodError` exception. Do note that it will still display the breadcrumbs that has no errors prior for a more beautiful display. However, the implementation is only integrated mostly in the view template, so for those who are updating the gem from `0.1.*`, I would advise to copy the code style found in the template to avail the Crumb Stoppers feature.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tieeeeen1994/breadcrumb_helper. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/tieeeeen1994/breadcrumb_helper/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the BreadcrumbHelper project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/tieeeeen1994/breadcrumb_helper/blob/master/CODE_OF_CONDUCT.md).
