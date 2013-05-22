require "locomotive_currency/version"

module Locomotive
  module Liquid
    module Tags
      class Currency < ::Liquid::Tag

        Syntax = /(#{::Liquid::Expression}+)?/

        def initialize(tag_name, markup, tokens, context)
          if markup =~ Syntax
            @exchange_string = $1.gsub('\'', '')
          else
            raise ::Liquid::SyntaxError.new("Syntax Error in 'currency' - Valid syntax: currency <from_currency><to_currency>. Example: currency 'EURUSD'")
          end

          super
        end

        def render(context)
          begin
            Rails.cache.fetch("currency_#{@exchange_string}",:expires=>3600) do
              get_exchangerate(@exchange_string)
            end
          rescue NameError
            # ==========================================================================
            # = in case we are using locomotive editor, the RAILS cache doesn’t exist! =
            # ==========================================================================
            get_exchangerate(@exchange_string)
          end
        end

        def get_exchangerate(exchange_string)
          begin
            currency=Net::HTTP.get_response(URI.parse("http://download.finance.yahoo.com/d/quotes.csv?e=.csv&f=sl1d1t1&s=#{exchange_string}=X"))
            currency.body.split(',')[1]
          rescue Exception => e
            "Error getting exchangerate"
          end
        end
      end

      class CurrencyDate < ::Liquid::Tag

        Syntax = /(#{::Liquid::Expression}+)?/

        def initialize(tag_name, markup, tokens, context)
          if markup =~ Syntax
            @exchange_string = $1.gsub('\'', '')
          else
            raise ::Liquid::SyntaxError.new("Syntax Error in 'currency_date' - Valid syntax: currency_date <from_currency><to_currency>. Example: currency_date 'EURUSD'")
          end

          super
        end

        def render(context)
          begin
            Rails.cache.fetch("currency_date_#{@exchange_string}",:expires=>3600) do
              get_exchangerate(@exchange_string)
            end
          rescue NameError
            # ==========================================================================
            # = in case we are using locomotive editor, the RAILS cache doesn’t exist! =
            # ==========================================================================
            get_exchangerate(@exchange_string)
          end
        end

        def get_exchangerate(exchange_string)
          begin
            currency=Net::HTTP.get_response(URI.parse("http://download.finance.yahoo.com/d/quotes.csv?e=.csv&f=sl1d1t1&s=#{exchange_string}=X"))
            currency_date=currency.body.gsub("\"","").split(',')[2]
            currency_time=currency.body.gsub("\"","").split(',')[3]
            date=Date.strptime(currency_date,'%m/%d/%Y')
            Time.parse("#{date.to_s} #{currency_time} EDT").strftime("%d.%m.%Y %H:%M")
          rescue Exception => e
            "Error getting exchangerate"
          end
        end
      end

      ::Liquid::Template.register_tag('currency', Currency)
      ::Liquid::Template.register_tag('currency_date', CurrencyDate)
    end
  end
end
