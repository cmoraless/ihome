require 'test_helper'

class CamerasControllerTest < ActionController::TestCase
  setup do
    @camera = cameras(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cameras)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create camera" do
    assert_difference('Camera.count') do
      post :create, camera: { ip: @camera.ip, name: @camera.name, password: @camera.password, port: @camera.port, user: @camera.user }
    end

    assert_redirected_to camera_path(assigns(:camera))
  end

  test "should show camera" do
    get :show, id: @camera
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @camera
    assert_response :success
  end

  test "should update camera" do
    put :update, id: @camera, camera: { ip: @camera.ip, name: @camera.name, password: @camera.password, port: @camera.port, user: @camera.user }
    assert_redirected_to camera_path(assigns(:camera))
  end

  test "should destroy camera" do
    assert_difference('Camera.count', -1) do
      delete :destroy, id: @camera
    end

    assert_redirected_to cameras_path
  end
end
