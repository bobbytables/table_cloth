module ElementHelpers
  def to_element(string, type)
    Nokogiri::HTML(string).at_xpath(".//#{type}")
  end
end