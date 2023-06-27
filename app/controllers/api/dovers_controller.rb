require 'net/http'
require 'uri'
require 'json'
require 'cgi'

module Api
    class DoversController < ApplicationController
        @@hostname = "localhost:3000"

        def searchByNotarius
            uri = URI("https://www.reestr-dover.ru/api/search")
            data = '{"token":"%{token}", "date":"%{date}", "regnum":"%{regnum}", "notary":"%{notary}"}' % 
                    {token: params[:token], date: params[:date], regnum: params[:regnum], notary: params[:notary]}
            headers = {'content-type': 'application/json', 
                       'content-length': '%{l}' % {l: data.length},
                       'referer': 'https://www.reestr-dover.ru',
                       'Cookie': 'JSESSIONID=4C72509B22721202330268DC653A854D; Path=/; HttpOnly'}

            https = Net::HTTP.new(uri.host, uri.port)
            https.use_ssl = true

            response = https.post(uri.path, data, headers)

            if response.code == "200"
                render json: JSON.parse(response.body), status: 200
            else
                render json: { message: "Server error."}, status: 500
            end
            
            puts "  [SYSTEM] FNP Server responce code - %{uri}" % {uri: response.code}
        end

        def searchByConsul
            uri = URI("https://www.reestr-dover.ru/api/search")
            data = '{"token":"%{token}", "date":"%{date}", "regnum":"%{regnum}", "consul":"%{consul}", 
                    "country":"%{country}"}' % 
                    {token: params[:token], date: params[:date], regnum: params[:regnum], consul: params[:consul],
                     country: params[:country]}
            headers = {'content-type': 'application/json', 
                       'content-length': '%{l}' % {l: data.length},
                       'referer': 'https://www.reestr-dover.ru',
                       'Cookie': 'JSESSIONID=4C72509B22721202330268DC653A854D; Path=/; HttpOnly'}

            https = Net::HTTP.new(uri.host, uri.port)
            https.use_ssl = true

            response = https.post(uri.path, data, headers)

            if response.code == "200"
                render json: JSON.parse(response.body), status: 200
            else
                render json: { message: "Server error."}, status: 500
            end
            
            puts "  [SYSTEM] FNP Server responce code - %{uri}" % {uri: response.code}
        end

        def searchByOfficial
            uri = URI("https://www.reestr-dover.ru/api/search")
            data = '{"token":"%{token}", "date":"%{date}", "regnum":"%{regnum}", "official":"%{official}", 
                    "region":"%{region}"}' % 
                    {token: params[:token], date: params[:date], regnum: params[:regnum], 
                     official: params[:official], region: params[:region]}
            headers = {'content-type': 'application/json', 
                       'content-length': '%{l}' % {l: data.length},
                       'referer': 'https://www.reestr-dover.ru',
                       'Cookie': 'JSESSIONID=4C72509B22721202330268DC653A854D; Path=/; HttpOnly'}

            https = Net::HTTP.new(uri.host, uri.port)
            https.use_ssl = true

            response = https.post(uri.path, data, headers)

            if response.code == "200"
                render json: JSON.parse(response.body), status: 200
            else
                render json: { message: "Server error."}, status: 500
            end
            
            puts "  [SYSTEM] FNP Server responce code - %{uri}" % {uri: response.code}
        end

        def getCaptcha
            uri = URI("https://www.reestr-dover.ru/api/captcha/captcha.jpg")
            headers = {'Cookie': 'JSESSIONID=4C72509B22721202330268DC653A854D; Path=/; HttpOnly'}

            response = Net::HTTP.get_response(uri, headers)

            if response.code == "200" 
                open("public/captcha.jpg", "wb") do |file|
                    file.write(response.body)
                end
                render json: { message: @@hostname + '/captcha.jpg'}, status: 200
            else
                render json: { message: "Server error."}, status: 500
            end

            puts "  [SYSTEM] FNP Server responce code - %{uri}" % {uri: response.code}
        end

        def getCountries
            uri = URI("https://www.reestr-dover.ru/api/countries")
            headers = {'Cookie': 'JSESSIONID=4C72509B22721202330268DC653A854D; Path=/; HttpOnly'}

            response = Net::HTTP.get_response(uri, headers)

            if response.code == "200"
                render json: JSON.parse(response.body), status: 200
            else
                render json: { message: "Server error."}, status: 500
            end
            
            puts "  [SYSTEM] FNP Server responce code - %{uri}" % {uri: response.code}
        end

        def getRegions
            uri = URI("https://www.reestr-dover.ru/api/districts")
            headers = {'Cookie': 'JSESSIONID=4C72509B22721202330268DC653A854D; Path=/; HttpOnly'}

            response = Net::HTTP.get_response(uri, headers)

            if response.code == "200"
                render json: JSON.parse(response.body), status: 200
            else
                render json: { message: "Server error."}, status: 500
            end
            
            puts "  [SYSTEM] FNP Server responce code - %{uri}" % {uri: response.code}
        end

        def getNotarys
            query = CGI.escape(params['query'])
            uri = URI("https://www.reestr-dover.ru/api/notaries?query=%{q}" % {q: query})
            headers = {'Cookie': 'JSESSIONID=4C72509B22721202330268DC653A854D; Path=/; HttpOnly'}

            response = Net::HTTP.get_response(uri, headers)

            if response.code == "200"
                render json: JSON.parse(response.body), status: 200
            else
                render json: { message: "Server error."}, status: 500
            end
            
            puts "  [SYSTEM] FNP Server responce code - %{uri}" % {uri: response.code}
        end

        def getRevocations
            uri = URI("https://www.reestr-dover.ru/api/revocations")
            data = '{"regnum":"%{regnum}", "date":"%{date}", "actcertifier":"%{actcertifier}", 
                    "person":"%{person}", "organization":"%{organization}", "oldnum":"%{oldnum}",
                    "olddate":"%{olddate}", "oldcertifier":"%{oldcertifier}", 
                    "withKartotekaSearch":"%{withKartotekaSearch}", "size":"%{size}", "page":"%{page}"}' % 
                    {regnum: params[:regnum], date: params[:date], actcertifier: params[:actcertifier], 
                     person: params[:person], organization: params[:organization], oldnum: params[:oldnum],
                     olddate: params[:olddate], oldcertifier: params[:oldcertifier], size: params[:size], 
                     withKartotekaSearch: params[:withKartotekaSearch], page: params[:page]}
            headers = {'content-type': 'application/json', 
                       'content-length': '%{l}' % {l: data.length},
                       'referer': 'https://www.reestr-dover.ru',
                       'Cookie': 'JSESSIONID=4C72509B22721202330268DC653A854D; Path=/; HttpOnly'}

            https = Net::HTTP.new(uri.host, uri.port)
            https.use_ssl = true

            response = https.post(uri.path, data, headers)

            if response.code == "200"
                render json: JSON.parse(response.body), status: 200
            else
                render json: { message: "Server error."}, status: 500
            end
            
            puts "  [SYSTEM] FNP Server responce code - %{uri}" % {uri: response.code}
        end
    end
end