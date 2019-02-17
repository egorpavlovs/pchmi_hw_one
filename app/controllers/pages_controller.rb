class PagesController < ApplicationController
  before_action :get_elements
  before_action :get_all_elements

  def show
    render template: "pages/#{params[:page]}"
  end

  private

    def get_elements
      @elements =  NumbersService.generate_three_elements()
    end

    def get_all_elements
      @all_elements =  NumbersService.generate_all_elements()
    end
end
