class NumbersService
  class << self
    def generate_three_elements()
      elements = []
      3.times do |element|
        elements << [generate_color(), generate_element(), generate_number()].join("_")
      end
      pp elements
      elements
    end

    def generate_all_elements()
      ["a", "b", "c"]
    end

    def generate_color()
      colors = ["red", "green", "blue"]
      colors.sample
    end

    def generate_element()
      elements = ["word", "symbol"]
      elements.sample
    end

    def generate_number()
      numbers = [1,2,3,4,5,6,7,8,9]
      numbers.sample
    end
  end
end