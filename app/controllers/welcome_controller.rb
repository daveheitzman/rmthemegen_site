class WelcomeController < ApplicationController
  def index
  
    @dir_list = Dir.glob("*")

  end

end
