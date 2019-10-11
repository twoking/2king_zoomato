module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    page_title.empty? ? "2King" : "#{page_title} | 2King"
  end
end
