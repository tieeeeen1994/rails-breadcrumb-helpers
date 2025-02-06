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

  describe '#render_breadcrumb_item_path' do
    let(:item) { { name: 'You Feel', path: '/like/dying' } }

    it 'returns the path value of the item' do
      expect(instance.render_breadcrumb_item_path(item)).to eq('/like/dying')
    end
  end

  describe '#render_breadcrumb_item_name' do
    context 'when the item name is valid' do
      let(:item) { { name: 'I feel very terrible', path: '/my/dreams/feel/real' } }

      it 'returns the name value of the item' do
        expect(instance.render_breadcrumb_item_name(item)).to eq('I feel very terrible')
      end
    end

    context 'when the item name is invalid' do
      let(:item_klass) do
        Class.new do
          def to_s
            raise NoMethodError
          end
        end
      end
      let(:item_klass_instance) { item_klass.new }
      let(:item) { { name: item_klass_instance, path: '/my/dreams/feel/real' } }

      it 'returns a falsey value' do
        expect(instance.render_breadcrumb_item_name(item)).to be_falsey
      end
    end
  end
end
