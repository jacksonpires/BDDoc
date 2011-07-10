require File.dirname(__FILE__) + '/../test_helper'
require 'documentos_controller'

# Re-raise errors caught by the controller.
class DocumentosController; def rescue_action(e) raise e end; end

class DocumentosControllerTest < Test::Unit::TestCase
  fixtures :documentos

  def setup
    @controller = DocumentosController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = documentos(:first).id
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

    assert_not_nil assigns(:documentos)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:documento)
    assert assigns(:documento).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:documento)
  end

  def test_create
    num_documentos = Documento.count

    post :create, :documento => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_documentos + 1, Documento.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:documento)
    assert assigns(:documento).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Documento.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Documento.find(@first_id)
    }
  end
end
