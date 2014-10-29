class McSqlModel < ActiveRecord::Base
	establish_connection :mysql_prod
	self.table_name = "vp_manual_charges"

	def grab_table_data(vendor)
		if vendor == "all" || vendor == nil
			query = "SELECT order_id, description, amount, printer, comments FROM manual_charges.vp_charges WHERE dt_paid IS NULL"
		else
			query = "SELECT order_id, description, amount, comments FROM manual_charges.vp_charges WHERE printer = '#{vendor}' AND dt_paid IS NULL"
		end

		info = McSqlModel.connection.select_rows(query)

		return info
	end

	def insert_data(vendor, printer_id, orderid, reason_insert, amount, other_val)
		
		select_query = "SELECT * FROM manual_charges.vp_manual_charges"
		info = McSqlModel.connection.select_rows(select_query)

		@bool = false

		info.each do |x|
			if x[1] == orderid
				@bool = true
			end
		end

		if @bool == false
			#if reason == ""
			#	insert_query = "INSERT into manual_charges.test_info(order_id,reason,amount, charge_type) VALUES(#{orderid}, NULL, #{amount}, manual_charges)"
			#else
			@date = Date.today
			insert_query = "INSERT into manual_charges.vp_charges(order_id, printer, description, amount, type, dt_paid, printer_id, created_at, comments) VALUES(#{orderid}, '#{vendor}', '#{reason_insert}', #{amount}, 'manual_charges', NULL, #{printer_id}, '#{@date}', '#{other_val}')"
			#end

			McSqlModel.connection.execute(insert_query)
		end
	end

	def delete_data(orderid)
		@query = "DELETE from manual_charges.vp_charges WHERE order_id = #{orderid}"
		McSqlModel.connection.execute(@query)
	end

	def insert_date_paid(date, vendor)
		@query
    if (vendor == "all")
      @query = "UPDATE manual_charges.vp_charges SET dt_paid='#{date}' WHERE dt_paid IS NULL"
    else
      @query = "UPDATE manual_charges.vp_charges SET dt_paid='#{date}' WHERE dt_paid IS NULL AND printer = '#{vendor}'"
    end

		McSqlModel.connection.execute(@query)
	end

	def update_data(orderid, reason_insert, amount, other_insert)
		@query = "UPDATE manual_charges.vp_charges SET description='#{reason_insert}', amount=#{amount}, comments='#{other_insert}' WHERE order_id=#{orderid}"
		McSqlModel.connection.execute(@query)
	end

	def insert_new_reason(new_reason)
		insert_query = "INSERT into manual_charges.vp_manual_charges(other) VALUES('#{new_reason}')"

		McSqlModel.connection.execute(insert_query)
	end

end
