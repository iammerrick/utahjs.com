def pages
  @items.select { |item| item.page? }.sort_by{ |item| item[:order] }
end

def articles
  @items.select { |item| item.article? }.sort_by{ |item| item[:date] }.reverse
end