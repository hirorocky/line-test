class ChangeCompanyCode < ActiveRecord::Migration[5.2]
  def change
    rename_column :companies, :compnay_code, :company_code
  end
end
