class PageDecorator < Draper::Decorator
  delegate_all

  def meta_title
    object.meta_title.blank? ? object.name : object.meta_title
  end

  def page
    object.page
  end

end
