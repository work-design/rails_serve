class RailsRoleInit < ActiveRecord::Migration[5.0]

  def change

    create_table :govern_taxons do |t|
      t.string :name
      t.string :code
      t.integer :position, default: 1
      t.integer :governs_count, default: 0
      t.timestamps
    end

    create_table :governs do |t|
      t.string :type
      t.string :name
      t.string :code
      t.integer :position, default: 1
      t.references :govern_taxon
      t.timestamps
    end

    create_table :rules do |t|
      t.string :name
      t.string :code
      t.string :params
      t.references :govern
      t.integer :position, default: 1
      t.timestamps
    end

    create_table :roles do |t|
      t.string :name, null: false
      t.string :description, limit: 1024
      t.string :code
      t.boolean :visible
      t.string :who_types, array: true
      t.timestamps
    end
    
    create_table :role_types do |t|
      t.references :role
      t.string :who_type
      t.timestamps
    end

    create_table :role_rules do |t|
      t.references :role
      t.references :rule
      t.references :govern
      t.references :govern_taxon
      t.string :status
      t.timestamps
    end

    create_table :who_roles do |t|
      t.references :who, polymorphic: true
      t.references :role
      t.timestamps
    end

  end

end
