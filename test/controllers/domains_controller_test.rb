require 'test_helper'

class DomainsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get domains_index_url
    assert_response :success
  end

  test "should get new" do
    get domains_new_url
    assert_response :success
  end

  test "should get edit" do
    get domains_edit_url
    assert_response :success
  end

  test "should get show" do
    get domains_show_url
    assert_response :success
  end

  test "should get destroy" do
    get domains_destroy_url
    assert_response :success
  end

end
