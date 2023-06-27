require 'net/http'
require 'uri'
require 'json'
require 'cgi'
require 'nokogiri'

module Api
    class ProbatesController < ApplicationController
        def search
            uri = URI("https://notariat.ru/api/probate-cases/eis-proxy")
            data = '{"name":"%{name}", "birth_date":"%{birth_date}", "death_date":"%{death_date}"}' % 
                    {name: params[:name], birth_date: params[:birth_date], death_date: params[:death_date]}
            headers = {'content-type': 'application/json', 
                       'content-length': '%{l}' % {l: data.length},
                       'referer': 'https://notariat.ru/ru-ru/help/probate-cases/',
                       'x-csrftoken': 'IXe5Rdsc73zZmFJx3gyCKdUJCKxT8NpyuteUDbfj1B1FfCCQgBLmAGG0Jt68PcSa',
                       'Cookie': 'fnc_csrftoken=IXe5Rdsc73zZmFJx3gyCKdUJCKxT8NpyuteUDbfj1B1FfCCQgBLmAGG0Jt68PcSa; Path=/; Expires=Fri, 21 Jun 2024 07:43:54 GMT;'}

            https = Net::HTTP.new(uri.host, uri.port)
            https.use_ssl = true

            response = https.post(uri.path, data, headers)

            if response.code == "200"
                render json: JSON.parse(response.body), status: 200
            else
                render json: { message: response.body}, status: 500
            end
            
            puts "  [SYSTEM] FNP Server responce code - %{uri}" % {uri: response.code}
        end

        def wanted
          uri = URI('https://data.notariat.ru/directory/succession/search/')
          uri.query = URI.encode_www_form(wanted_params.to_h)
          response = Net::HTTP.get_response(uri)

          r = parse_wanted(response.body)

          if response.code == "200"
              render json: r, status: 200
          else
              render json: { message: "Server error.", info: response}, status: 500
          end

          puts "  [SYSTEM] FNP Server responce code - %{uri}" % {uri: response.code}
        end

        def wanted_params
          @wanted_params ||= params.permit(:last_name, :first_name, :middle_name)
        end

        def parse_wanted(html)
            doc = Nokogiri::HTML(html)
            result = []
            doc.css('.search__result-item').each do |item|
                region = item.css('.header').text.strip
                people = []
                item.css('.people-list__item-inside').each do |people_item|
                    item_name = people_item.css('.people-list__item-name').text.strip
                    death_year = people_item.css('.people-list__item-info-i span').text.strip
                    notary = people_item.css('a').text.strip
                    people.push(
                        name: item_name,
                        death_year: death_year,
                        notary: notary, 
                    )
                end
                result.push(
                    region: region,
                    items: people
                )
            end
            
            return result
        end
    end
end