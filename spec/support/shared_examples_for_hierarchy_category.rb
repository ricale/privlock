shared_examples_for 'hierarchy category' do |children_count|
  it 'is count ' do
    categories = child_categories
    child_categories = [] 
    categories.each do |category|
      child_categories = child_categories.concat category[:children] if category[:children]
    end

    child_categories.count.should == 3
  end
end