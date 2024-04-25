# frozen_string_literal: true

Ui::CardBuilder = Struct.new(:title, :options, :view, :block) do
  attr_reader :body

  def initialize(*args)
    super
    view.capture_haml(self, &block)
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

  def actions(&block)
    if block.present?
      @actions = view.capture_haml(&block)
    else
      @actions
    end
  end

  def header(&block)
    if block.present?
      @header = view.capture_haml(&block)
    else
      @header
    end
  end
end
