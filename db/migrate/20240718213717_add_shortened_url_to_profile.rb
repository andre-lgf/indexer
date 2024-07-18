class AddShortenedUrlToProfile < ActiveRecord::Migration[7.1]
  def change
    add_column :profiles, :shortened_url, :string
    add_index :profiles, :shortened_url, where: 'shortened_url is not null'
  end
end
