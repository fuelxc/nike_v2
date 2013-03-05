class String
  def underscore
    self.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end

  def camelize(first_letter_in_uppercase = false)
    word = self.to_s
    if !!first_letter_in_uppercase
      word.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
    else
      word[0].downcase + word.camelize(true)[1..-1]
    end
  end
end

class Symbol
  def camelize(first_letter_in_uppercase = false)
    if !!first_letter_in_uppercase
      self.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
    else
      (self[0].to_s.downcase + self.camelize(true)[1..-1]).to_sym
    end
  end
end