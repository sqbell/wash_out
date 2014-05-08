xml.instruct!
xml.tag! 'soap:Envelope', 'xmlns:soap' => 'http://schemas.xmlsoap.org/soap/envelope/' do
  xml.tag! 'soap:Body' do
    xml.tag!('soap:Fault',
             'xmlns:soap' => 'http://schemas.xmlsoap.org/soap/envelope/',
             'xmlns:xml'  => 'http://www.w3.org/XML/1998/namespace') do
      xml.faultcode error_code
      xml.faultstring error_message
      xml.tag! "detail" do
        xml.tag! "#{@operation}Fault", 'xmlns' => 'http://types.walletserver.casinomodule.com/3_0/' do
          wsdl_data xml, detail
        end
      end unless detail.nil?
    end
  end
end
