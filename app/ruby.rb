# frozen_string_literal: true

case entry
when Score::List
  render('list_entry', list: entry)
when 'page'
  render('page_entry')
when 'column'
  render('column_entry')
end
