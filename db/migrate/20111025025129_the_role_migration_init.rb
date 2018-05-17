class TheRoleMigrationInit < ActiveRecord::Migration[5.0]

  def change

    create_table :govern_taxons, force: true do |t|
      t.string :name
      t.string :code
      t.integer :position, default: 0
      t.integer :governs_count, default: 0
      t.timestamps
    end

    create_table :governs, force: true do |t|
      t.string :type
      t.string :name
      t.string :code
      t.integer :position, default: 0
      t.references :govern_taxon
      t.timestamps
    end

    create_table :rules, force: true do |t|
      t.string :name
      t.string :code
      t.string :params
      t.references :govern
      t.integer :position, default: 0
      t.timestamps
    end

    create_table :roles, force: true do |t|
      t.string :name, null: false
      t.string :description, limit: 1024
      t.timestamps
    end

    create_table :role_rules, force: true do |t|
      t.references :role
      t.references :rule
      t.references :govern
      t.timestamps
    end

    create_table :who_roles, force: true do |t|
      t.references :who, polymorphic: true
      t.references :role
      t.timestamps
    end

  end

end
