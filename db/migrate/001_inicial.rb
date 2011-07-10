class Inicial < ActiveRecord::Migration
  def self.up
    create_table :documentos do |t|
      t.column :docdescricao, :string, :limit => 60, :null => false
      t.column :docautor, :string, :limit => 60, :null => true
      t.column :docpalavras_chave, :string, :limit => 254, :null => false
      t.column :docsinopse, :text, :null => true
      t.column :docarquivo, :string, :limit =>60, :null => false
      t.column :area_id, :integer, :null =>false
      t.column :tipo_id, :integer, :null =>false
      t.column :created_at, :datetime
      t.column :updated_at, :datetime, :null => true
    end  
  
    create_table :areas do |t|
      t.column :areadescricao, :string, :limit => 60, :null => false
      t.column :created_at, :datetime
      t.column :updated_at, :datetime, :null => true
    end  

    create_table :tipos do |t|
      t.column :tipodescricao, :string, :limit => 60, :null => false
      t.column :created_at, :datetime
      t.column :updated_at, :datetime, :null => true
    end  
  
  end

  def self.down
    drop_table :documentos
    drop_table :areas
    drop_table :tipos
  end
end
