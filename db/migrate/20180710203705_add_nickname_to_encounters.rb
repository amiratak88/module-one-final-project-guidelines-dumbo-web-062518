class AddNicknameToEncounters < ActiveRecord::Migration[5.0]
  def change
    add_column :encounters, :nickname, :string
  end
end
