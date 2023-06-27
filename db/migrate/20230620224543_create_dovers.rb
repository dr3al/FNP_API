class CreateDovers < ActiveRecord::Migration[7.0]
  def change
    create_table :dovers do |t|
      t.string :token
      t.string :date
      t.string :regnum
      t.string :notary
      t.string :consul
      t.string :country
      t.string :official
      t.string :region

      t.timestamps
    end
  end
end
