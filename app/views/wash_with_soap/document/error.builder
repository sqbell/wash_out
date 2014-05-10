xml.instruct!
xml.tag!('soap:Envelope', 'xmlns:soap' => 'http://schemas.xmlsoap.org/soap/envelope/') do
  xml.tag! 'soap:Body' do
    xml.tag!('soap:Fault', 'xmlns:soap' => 'http://schemas.xmlsoap.org/soap/envelope/') do
      xml.faultcode error_code
      xml.faultstring error_message, 'xml:lang' => 'en-GB'
      xml.tag! "detail" do
        xml.tag! "#{@operation}Fault", 'xmlns' => 'http://types.walletserver.casinomodule.com/3_0/' do
          detail.each do |key, value|
            xml.tag! key, value, 'xmlns' => ''
          end
        end
      end unless detail.nil?
    end
  end
end
