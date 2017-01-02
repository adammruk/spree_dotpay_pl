module SpreeDotpayPl
  class Engine < Rails::Engine
    engine_name 'spree_dotpay_pl'

    config.autoload_paths += %W(#{config.root}/lib)

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../../app/**/*_decorator*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    initializer "spree_dotpay_pl.assets.precompile" do |app|
      app.config.assets.precompile += %w( chanel_logos.jpg dotpay_b3_160x83.gif dotpay_b9_145x252 )
    end

    initializer "spree.gateway.payment_methods", :after => "spree.register.payment_methods" do |app|
      app.config.spree.payment_methods << Spree::PaymentMethod::DotpayPl

    end

    config.to_prepare &method(:activate).to_proc

  end
end
