class McReasonsModel < ActiveRecord::Base
	establish_connection :mysql_prod
	self.table_name = "reasons"

	def grab_table_data
		query = "SELECT * FROM manual_charges.reasons"

		info = McReasonsModel.connection.select_rows(query)

		return info
	end

end
