require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @base_title = "2King"
  end

  # test "should get home" do
  #   get root_path
  #   assert_response :success
  #   assert_select "title", "Home | #{@base_title}"
  # end
end
