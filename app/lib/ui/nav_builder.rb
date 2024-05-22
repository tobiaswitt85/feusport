# frozen_string_literal: true

Ui::NavBuilder = Struct.new(:options, :view, :block) do
  attr_reader :items
  delegate :each, :map, :filter, :detect, to: :items

  def initialize(*args)
    super
    @items = []
    view.capture_haml(self, &block)
  end

  def link_to(label, url, options = {})
    @items << Ui::NavBuilderItem.new(to_string(label), url, options)
  end

  def dropdown(label, options = {}, &block)
    if block_given?
      dropdown = Ui::NavBuilder.new(options, view, block)
      @items << Ui::NavBuilderItem.new(to_string(label), nil, { type: :dropdown, dropdown: dropdown })
    end
  end

  private

  def to_string(something)
    if something.is_a?(Class) && something.respond_to?(:model_name)
      return something.model_name.human(count: :many)
    end
    something
  end
end

Ui::NavBuilderItem = Struct.new(:label, :url, :options) do
  def active
    options[:active]
  end

  def dropdown?
    options[:type] == :dropdown
  end

  def dropdown
    options[:dropdown]
  end
end