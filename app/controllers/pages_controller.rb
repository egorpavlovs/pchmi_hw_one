class PagesController < ApplicationController
  before_action :init_array, :get_elements, :get_all_elements
# get_elementsвызывается несколько раз(((
  def show
    render template: "pages/#{params[:page]}"
  end

  def complete
    @answers = params[:elements]
    @elements = File.open('files/log_elements.txt'){ |file| file.read }.split('delimiter').first.split("\n")

    File.open('files/log_elements.txt', 'w'){ |file| file.write "" }

    result = NumbersService.check_answers(@elements, @answers)
    procent = result.first
    not_right_answers = result.last

    pp ['procent', procent]

    render template: "pages/result", :locals => { :procent => procent, :not_right_answers => not_right_answers }
  end

  private

    def init_array
      @hui = ["start"] unless @hui.present?
    end

    def get_elements
      @elements = NumbersService.generate_three_elements()
      File.open('files/log_elements.txt', 'a'){ |file| file.puts  @elements }
      File.open('files/log_elements.txt', 'a'){ |file| file.puts  "delimiter"}
      @elements
    end

    def get_all_elements
      @all_elements =  NumbersService.generate_all_elements()
    end
end
