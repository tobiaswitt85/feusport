# frozen_string_literal: true

Ui::CardBuilder = Struct.new(:title, :options, :view, :block) do
  attr_reader :body, :save_button_label, :cancel_button_url

  def initialize(*args)
    super
    view.capture_haml(self, &block)
  end

  def title(title = nil)
    @title = title if title
    @title
  end

  def body(&block)
    if block.present?
      @body = view.capture_haml(&block)
    else
      @body
    end
  end

  def direct(&block)
    if block.present?
      @direct = view.capture_haml(&block)
    else
      @direct
    end
  end

  def footer(&block)
    if block.present?
      @footer = view.capture_haml(&block)
    else
      @footer
    end
  end

  def primary_actions(options = {}, &block)
    @primary_actions = Ui::NavBuilder.new(options, view, block) if block
    @primary_actions || []
  end

  def actions(options = {}, &block)
    @actions = Ui::NavBuilder.new(options, view, block) if block
    @actions || []
  end
end
