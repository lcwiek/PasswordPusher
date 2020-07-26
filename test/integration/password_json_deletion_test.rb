require 'test_helper'

class PasswordJsonCreationTest < ActionDispatch::IntegrationTest
  def test_deletion
    post "/p.json", params: { :password => { payload: "testpw" } }
    assert_response :success

    res = JSON.parse(@response.body)
    assert res.key?("id")
    assert res.key?("payload")
    assert res.key?("url_token")
    assert res.key?("expired")
    assert_equal false, res["expired"]
    assert res.key?("deleted")
    assert_equal false, res["deleted"]
    assert res.key?("deletable_by_viewer")
    assert_equal false, res["deletable_by_viewer"]

    # Get the new password via json e.g. /p/<url_token>.json
    delete "/p/" + res["url_token"] + ".json"
    assert_response :success

    res = JSON.parse(@response.body)
    assert res.key?("id")
    assert res.key?("payload")
    assert_nil res["payload"]
    assert res.key?("url_token")
    assert res.key?("expired")
    assert_equal true, res["expired"]
    assert res.key?("deleted")
    assert_equal true, res["deleted"]
    assert res.key?("deletable_by_viewer")
    assert_equal false, res["deletable_by_viewer"]

    # Now try to retrieve the password again
    get "/p/" + res["url_token"] + ".json"
    assert_response :success

    res = JSON.parse(@response.body)
    assert res.key?("id")
    assert res.key?("payload")
    assert_nil res["payload"]
    assert res.key?("url_token")
    assert res.key?("expired")
    assert_equal true, res["expired"]
    assert res.key?("deleted")
    assert_equal true, res["deleted"]
    assert res.key?("deletable_by_viewer")
    assert_equal false, res["deletable_by_viewer"]
  end
end