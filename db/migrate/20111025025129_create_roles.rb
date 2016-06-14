class CreateRoles < ActiveRecord::Migration

  def change
    create_table :roles do |t|
      t.string :name, null: false
      t.text   :description, null: false
      t.timestamps
    end

    create_table :role_rules do |t|
      t.references :role
      t.references :rule
      t.timestamps
    end

    create_table :sections do |t|
      t.string :name
      t.string :code
      t.timestamps
    end

    create_table :rules do |t|
      t.string :name
      t.string :code
      t.references :section
      t.timestamps
    end

  end

end
