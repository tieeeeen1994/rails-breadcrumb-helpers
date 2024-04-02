# frozen_string_literal: true

RSpec.describe BreadcrumbHelper::Main do
  let(:klass) { Class.new { include BreadcrumbHelper::Main } }
  let(:instance) { klass.new }

  describe '#add_breadcrumb' do
    it 'adds a breadcrumb item' do
      instance.add_breadcrumb(name: 'Home', path: '/home/along/the/riles')
      expect(instance.send(:_breadcrumb_items)).to contain_exactly(name: 'Home', path: '/home/along/the/riles')
    end
  end

  describe '#breadcrumb_items' do
    before { instance.add_breadcrumb(name: 'Your Life', path: '/kidney/stones') }

    it 'returns the list of breadcrumb items' do
      expect(instance.breadcrumb_items).to contain_exactly(name: 'Your Life', path: '/kidney/stones')
    end

    it 'cannot be modified directly through insertion' do
      process = -> { instance.breadcrumb_items << { name: 'Goodbye', path: '/delicious/foods' } }
      expect { process.call }.to raise_error(FrozenError)
    end

    it 'cannot be modified directly through update' do
      process = -> { instance.breadcrumb_items[0] = :bad_data }
      expect { process.call }.to raise_error(FrozenError)
    end
  end

  describe '#render_breadcrumb_items' do
    before do
      instance.add_breadcrumb(name: 'Your Life', path: '/kidney/stones')
      allow(instance).to receive(:action_name).and_return('show')
      allow(instance).to receive_messages(action_name: 'show', show_breadcrumbs: nil, controller_path: 'kidney/stones',
                                          render: '<a href="/kidney/stones">Your Life</a>')
    end

    it 'renders the breadcrumb items' do
      expect(instance.render_breadcrumb_items).to match(%r{/kidney/stones.*Your Life})
    end
  end

  describe '#_breadcrumb_items' do
    it 'is a private method' do
      expect { instance._breadcrumb_items }.to raise_error(NoMethodError, /private method.*called/)
    end
  end
end
