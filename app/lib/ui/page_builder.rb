# frozen_string_literal: true

Ui::PageBuilder = Struct.new(:options, :view, :block) do
  attr_reader :body

  def initialize(*args)
    super
    view.capture_haml(self, &block)
  end

  def title(title = nil)
    @title = title if title
    @title
  end

  def sub_title(sub_title = nil)
    @sub_title = sub_title if sub_title
    @sub_title
  end

  def tabs(options = {}, &block)
    @tabs = Ui::NavBuilder.new(options, view, block) if block_given?
    @tabs
  end

  def head_title
    parts = []
    parts << tabs.detect(&:active)&.label
    parts << title
    parts.join(' - ')
  end

  private

  def to_string(something)
    if something.is_a?(Class) && something.respond_to?(:model_name)
      return something.model_name.human(count: :many)
    end
    something
  end
end
