module Spree
  class PaymentMethod::DotpayPl < PaymentMethod

    preference :merchant_id, :string
    preference :merchant_pin, :string
    preference :store_host, :string
    preference :currency_code, :string, :default => "PLN"
    preference :dotpay_host, :string, :default => 'https://ssl.dotpay.pl'


    def payment_profiles_supported?
      false
    end

    def source_required?
      false
    end

    def auto_capture?
      false
    end

    def capture(*)
      simulated_successful_billing_response
    end

    def self.validate_dotpay_notification(params)

      order = Spree::Order.find_by_number(params['control'])

      if order
          puts "==== order find: #{order.inspect}"
          merchant_pin = order.get_dotpay_payment.payment_method.preferences[:merchant_pin]

          txt_hash = merchant_pin+
              params['id'].to_s+
              params['operation_number'].to_s+
              params['operation_type'].to_s+
              params['operation_status'].to_s+
              params['operation_amount'].to_s+
              params['operation_currency'].to_s+
              params['operation_withdrawal_amount'].to_s+
              params['operation_commission_amount'].to_s+
              params['operation_original_amount'].to_s+
              params['operation_original_currency'].to_s+
              params['operation_datetime'].to_s+
              params['operation_related_number'].to_s+
              params['control'].to_s+
              params['description'].to_s+
              params['email'].to_s+
              params['p_info'].to_s+
              params['p_email'].to_s+
              params['credit_card_issuer_identification_number'].to_s+
              params['credit_card_masked_number'].to_s+
              params['credit_card_brand_codename'].to_s+
              params['credit_card_brand_code'].to_s+
              params['credit_card_id'].to_s+
              params['channel'].to_s+
              params['channel_country'].to_s+
              params['geoip_country'].to_s

              calculated = Digest::SHA256.hexdigest txt_hash
              puts "==== caculated chk: #{calculated}"
              puts "==== from hash chk: #{params['signature']}"
              puts "==== comparsion: #{calculated == params['signature'] }"
          if calculated != params['signature']
            return nil
          else
            return order
          end
      else
        return nil
      end

    end


    private

    def simulated_successful_billing_response
      ActiveMerchant::Billing::Response.new(true, "", {}, {})
    end

  end
end
