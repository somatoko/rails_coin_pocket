class CreateCryptos < ActiveRecord::Migration[7.1]
  def change
    create_table :cryptos do |t|
      t.string :symbol
      t.references :user, null: false, foreign_key: true
      t.decimal :cost_per
      t.decimal :amount_owned

      t.timestamps
    end
  end
end
