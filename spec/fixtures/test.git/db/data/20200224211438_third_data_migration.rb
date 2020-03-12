class ThirdDataMigration < ActiveRecord::Migration
  def up
    # Work it!
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
