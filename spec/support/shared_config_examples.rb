shared_examples "table configuration" do
  it 'tables have a class attached' do
    doc.at_xpath('//table')[:class].should include 'table2'
  end

  it 'thead has a class attached' do
    doc.at_xpath('//thead')[:class].should include 'thead2'
  end

  it 'th has a class attached' do
    doc.at_xpath('//th')[:class].should include 'th2'
  end

  it 'tbody has a class attached' do
    doc.at_xpath('//tbody')[:class].should include 'tbody2'
  end

  it 'tr has a class attached' do
    doc.at_xpath('//tr')[:class].should include 'tr2'
  end

  it 'td has a class attached' do
    doc.at_xpath('//td')[:class].should include 'td2'
  end
end