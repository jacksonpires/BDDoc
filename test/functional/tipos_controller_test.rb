require File.dirname(__FILE__) + '/../test_helper'
require 'tipos_controller'

# Re-raise errors caught by the controller.
class TiposController; def rescue_action(e) raise e end; end

class TiposControllerTest < Test::Unit::TestCase
  fixtures :tipos

  def setup
    @controller = TiposController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = tipos(:first).id
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:tipos)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:tipo)
    assert assigns(:tipo).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:tipo)
  end

  def test_create
    num_tipos = Tipo.count

    post :create, :tipo => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_tipos + 1, Tipo.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:tipo)
    assert assigns(:tipo).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Tipo.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Tipo.find(@first_id)
    }
  end
end
