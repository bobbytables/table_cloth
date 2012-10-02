class TableGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("../templates", __FILE__)

  def create_uploader_file
    template "table.rb", "app/tables/#{file_name}_table.rb"
  end
end