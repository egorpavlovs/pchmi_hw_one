class NumbersService
  class << self
    def generate_elements(elements_count)
      result_elements = []

      colors = []
      elements = []
      numbers = []

      elements_count.times do
        colors = generate_uniq_components("color", colors)
        element = generate_uniq_components("element", elements)
        number = generate_uniq_components("number", numbers)
      end

      for i in 0..elements_count-1
        result_elements << [colors[i], elements[i], numbers[i]].join("_")
      end
      p colors
      p elements
      p numbers
      # result_elements = result_elements.uniq.count == elements_count ? result_elements : generate_elements(elements_count)
      result_elements
    end

    def generate_uniq_components(type, components)
      remaining = nil
      case type
      when "color"
        remaining = generate_color(true) - components
        remaining = generate_color(true) unless remaining.present?
      when "element"
        remaining = generate_element(true) - components
        remaining = generate_element(true) unless remaining.present?
      when "number"
        remaining = generate_number(true) - components
        remaining = generate_number(true) unless remaining.present?
      end
      components << remaining.sample
    end

    def generate_all_elements()
      colors = generate_color(true)
      elements = generate_element(true)
      numbers = generate_number(true)

      all_elements = []
      colors.each do |color|
        elements.each do |element|
          numbers.each do |number|
            all_elements << [color, element, number].join("_")
          end
        end
      end
      all_elements
    end

    def generate_color(all = nil)
      colors = ["red", "green", "blue"]
      all ? colors : colors.sample
    end

    def generate_element(all = nil)
      elements = ["word", "symbol"]
      all ? elements : elements.sample
    end

    def generate_number(all = nil)
      numbers = [1,2,3,4,5,6,7,8,9]
      all ? numbers : numbers.sample
    end

    def check_answers(right, answers)
      not_right_answers = nil
      resp = if right.count == answers.count
        not_right_answers = answers - right
        case not_right_answers.count
        when 0
          100
        when 1
          66
        when 2
          33
        when 3
          0
        end
      else
        "Count answers not right - 0"
      end
      statistic = [right.join(" "), answers.join(" "), resp].join(";")
      File.open('files/statistic.csv', 'a'){ |file| file.puts  statistic }
      [resp, not_right_answers]
    end
  end
end