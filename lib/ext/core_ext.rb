class String
  def underscore
    self.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end
  def camelize(first_letter_in_uppercase = false)
    lower_case_and_underscored_word = self.to_s
    if first_letter_in_uppercase
      lower_case_and_underscored_word.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
    else
      lower_case_and_underscored_word[0].downcase + lower_case_and_underscored_word.camelize[1..-1]
    end
  end
end

class Symbol
  def camelize(first_letter_in_uppercase = false)
    lower_case_and_underscored_word = self.to_s
    if first_letter_in_uppercase
      lower_case_and_underscored_word.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }.to_sym
    else
      (lower_case_and_underscored_word[0].downcase + lower_case_and_underscored_word.camelize[1..-1]).to_sym
    end
  end
end