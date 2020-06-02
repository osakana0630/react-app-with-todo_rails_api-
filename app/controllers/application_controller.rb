class ApplicationController < ActionController::API
  #全コントローラーでこのモジュールを使えるようにする
  include Response
  include Authenticate
end
