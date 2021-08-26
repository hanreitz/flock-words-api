class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :email
      t.password_digest :password

      t.timestamps
    end
  end
end
