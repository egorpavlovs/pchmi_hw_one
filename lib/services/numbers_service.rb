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
      not_right_answers = answers - right
      right_answers = answers - not_right_answers

      resp = right.count == answers.count ? right_answers.count.to_f/right.count*100 : "Count answers not right - 0"

      statistic = [right.join(" "), answers.join(" "), resp].join(";")
      File.open('files/statistic.csv', 'a'){ |file| file.puts  statistic }
      [resp, not_right_answers]
    end


    def create_statistic()
      statistic_records = File.open('files/statistic.csv'){ |file| file.read }.split("\n").drop(1)

      # create statistic hashs
      answers_hash = {}
      generate_all_elements().each{ |element| answers_hash.merge!({element=>[]}) }

      colors_hash = {}
      generate_color(true).each{ |color| colors_hash.merge!({color=>[]}) }
      numbers_hash = {}
      generate_number(true).each{ |number| numbers_hash.merge!({number=>[]}) }
      elements_hash = {}
      generate_element(true).each{ |element| elements_hash.merge!({element=>[]}) }

      statistic_records.each do |statistic_record|
        statistic_elements = statistic_record.split(";")
        right_variants = statistic_elements.first.split(" ")
        user_answers = statistic_elements.second.split(" ")

        not_right_answers = user_answers - right_variants
        right_answers = user_answers - not_right_answers

        right_variants.each{ |right_variant|
          answers_hash[right_variant] << (right_answers.include?(right_variant) ? 1 : 0)
        }
      end

      # average percent of correct answer for element
      percent_correct_answer = answers_hash.map { |key, value| [key, value.sum.to_f/value.count*100] if value.present? }.compact

      percent_correct_answer.each do |key_with_percent|
        key = key_with_percent.first
        percent = key_with_percent.last

        color = key.split("_").first
        element = key.split("_").second
        number = key.split("_").last

        colors_hash[color] << percent
        elements_hash[element] << percent
        numbers_hash[number.to_i] << percent
      end

      percent_correct_color = colors_hash.map { |key, value| [key, value.sum.to_f/value.count] if value.present? }.compact
      percent_correct_element = elements_hash.map { |key, value| [key, value.sum.to_f/value.count] if value.present? }.compact
      percent_correct_number = numbers_hash.map { |key, value| [key, value.sum.to_f/value.count] if value.present? }.compact

      {
        "percent_correct_answer"=>percent_correct_answer,
        "percent_correct_color"=>percent_correct_color,
        "percent_correct_element"=>percent_correct_element,
        "percent_correct_number"=>percent_correct_number
      }
    end
  end
end