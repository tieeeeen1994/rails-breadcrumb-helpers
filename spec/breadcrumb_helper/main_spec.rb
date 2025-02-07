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
    context 'when the action breadcrumbs method exists and has valid code' do
      before do
        instance.add_breadcrumb(name: 'Your Life', path: '/kidney/stones')
        allow(instance).to receive_messages(action_name: 'show', show_breadcrumbs: nil,
                                            controller_path: 'kidney/stones',
                                            render: '<a href="/kidney/stones">Your Life</a>')
      end

      it 'renders the breadcrumb items' do
        expect(instance.render_breadcrumb_items).to match(%r{/kidney/stones.*Your Life})
      end
    end

    context 'when the action breadcrumbs method does not exist' do
      before do
        allow(instance).to receive(:action_name).and_return('show')
        allow(instance).to receive_messages(action_name: 'show', controller_path: 'kidney/stones',
                                            render: '<a href="/lungs">Your Death</a>')
      end

      it 'still renders the template' do
        expect(instance.render_breadcrumb_items).to eq('<a href="/lungs">Your Death</a>')
      end
    end

    context 'when the action breadcrumbs method exists but raises an exception' do
      let(:logger_klass) do
        Class.new do
          def self.warn(*args); end
        end
      end

      before do
        instance.add_breadcrumb(name: 'Your Life', path: '/kidney/stones')
        allow(instance).to receive_messages(action_name: 'show', controller_path: 'kidney/stones',
                                            render: '<a href="/failures/dreams">Ash in the Wind</a>')
        allow(instance).to receive(:show_breadcrumbs).and_raise(NoMethodError)
        allow(Rails).to receive(:logger).and_return(logger_klass)
      end

      it 'renders the template without fail' do
        expect(instance.render_breadcrumb_items).to eq('<a href="/failures/dreams">Ash in the Wind</a>')
      end
    end
  end

  describe '#_breadcrumb_items' do
    it 'is a private method' do
      expect { instance._breadcrumb_items }.to raise_error(NoMethodError, /private method.*called/)
    end
  end
end
