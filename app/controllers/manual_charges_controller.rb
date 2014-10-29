class ManualChargesController < ApplicationController
  $vendor
  def main

  	@load_date = Time.now.strftime("%Y-%m-%d %H:%M:%S")
  	@vendors = ManualChargesModel.grab_manual_charges

    @hash_table = ManualChargesModel.make_hash
    
    @insert_confirm = false
    @delete_confirm = false
    @update_confirm = false
  	
	  @orderid = params[:orderid]
  	@reason = params[:reason]

  	@amount = params[:amount]

    @vendor = params[:vendors]
    $vendor = @vendor

    @sorts = ["Vendor", "Order ID", "Reason", "Amount"]
    @sort = params[:sort]
  	
  	@model = McSqlModel.new
    @reasons_model = McReasonsModel.new

    @reasons = @reasons_model.grab_table_data

    @r_val = nil
    @a_val = nil

    @other = params[:other]

    if @orderid != nil

        if @orderid["0"] != ""
          insert_new_data(@orderid, @reason, @amount, @other, @vendor)
        else
          update_old_data(@orderid, @reason, @amount, @other)
        end
      
    end
  
    @delete = params[:delete]

    if @delete != nil
      #delete_info(@delete, @model)
      @delete_confirm = true
    end

  	@info = @model.grab_table_data(@vendor)
    sort_info(@sort, @info)

  end

  def delete_info(delete)
      @model = McSqlModel.new
      @model.delete_data(delete)
      redirect_to '/manual_charges/main'
  end

  def sort_info(sort_value, info)
    case (sort_value)
      when 'Order ID' then
        info.sort_by! do |x|		# sorts in numerical order by order id
          x[0].to_i
        end
      when 'Reason' then
        info.sort_by! do |x|		# sorts in alphabetical order by reason
          x[1]
        end
      when 'Amount' then
        info.sort_by! do |x|		# sorts in numerical order by amount
          x[2].to_i
        end
      else
        info.sort_by! do |x|		# sorts in alphabetical order by vendor
          x[3]
        end
    end
  end

  def mark_paid
    @dt_paid = Date.today
    @model = McSqlModel.new
    @model.insert_date_paid(@dt_paid, $vendor)
    redirect_to '/manual_charges/main'
  end

  def insert_new_data(order_id, reason, amount, other, vendor)
    for i in 0..order_id.length

      @str = i.to_s

      if order_id[@str] != nil && order_id[@str] != ""
        if reason != nil && reason != ""
          @r_val = reason[@str]
        end
        if amount != nil && amount != ""
          @a_val = @amount[@str]
        end
        if other != nil && other != ""
          @o_val = other[@str]
        end

        if vendor == "all"
          @vend = params[:vend]
          @vend = @vend[@str]

          @model.insert_data(@vend, @hash_table[@vend], order_id[@str], @r_val, @a_val, @o_val)
        else
          @model.insert_data(vendor, @hash_table[vendor], order_id[@str], @r_val, @a_val, @o_val)
        end

        @insert_confirm = true

      end
    end

  end

  def update_old_data(orderid, reason, amount, other)
    orderid.each do |x|

      @str = x[0]

      if orderid[@str] != nil && orderid[@str] != ""
        if reason != nil && reason != ""
          @r_val = reason[@str]
        end
        if amount != nil && amount != ""
          @a_val = amount[@str]
        end
        if other != nil && other != ""
          @o_val = other[@str]
        end
        @model.update_data(orderid[@str], @r_val, @a_val, @o_val)
        @update_confirm = true
      end
    end
  end

end
