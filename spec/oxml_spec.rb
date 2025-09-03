# frozen_string_literal: true

require 'oxml'

RSpec.describe OXML do
  let(:xml) do
    %(
      <nodes xmlns:ns4="http://Model/Status/Protocol/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="ns4:ServiceProtocol">
        <services>
          <serviceId>
            <id>100</id>
            <statusId>400</statusId>
          </serviceId>
          <updateId>500</updateId>
        </services>
        <services>
          <serviceId>
            <id>200</id>
            <statusId>400</statusId>
          </serviceId>
          <updateId>500</updateId>
        </services>
        <services>
          <serviceId>
            <id>300</id>
            <statusId>400</statusId>
          </serviceId>
          <updateId>500</updateId>
        </services>
        <id>82383838383838</id>
        <nodes>
          <id>8888888</id>
        </nodes>
        <quantities>
          <size>122</size>
          <id>
            <code>900</code>
            <node>5</node>
          </id>
        </quantities>
        <quantities>
          <size>103</size>
          <id>
            <code>900</code>
            <node>10</node>
          </id>
        </quantities>
        <quantities>
          <size>92</size>
          <id>
            <code>900</code>
            <node>20</node>
          </id>
        </quantities>
        <time>2023-10-20T05:05:00.000+01:00</time>
        <type>
          <id>9000</id>
          <mode>
            <id>2828288</id>
            <protocol>7000</protocol>
          </mode>
        </type>
        <informations>2</informations>
        <informations>17</informations>
        <informations>64</informations>
        <informations>1157</informations>
        <informations>1604</informations>
        <informations>100008</informations>
      </nodes>
      <nodes xmlns:ns4="http://Model/Status/Protocol/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="ns4:ServiceShop">
        <services>
          <serviceId>
            <id>400</id>
            <statusId>500</statusId>
          </serviceId>
          <updateId>600</updateId>
        </services>
        <services>
          <serviceId>
            <id>500</id>
            <statusId>500</statusId>
          </serviceId>
          <updateId>700</updateId>
        </services>
        <services>
          <serviceId>
            <id>600</id>
            <statusId>500</statusId>
          </serviceId>
          <updateId>700</updateId>
        </services>
        <note>Text  with extra  spaces     </note>
        <tag>Special character biały</tag>
      </nodes>
    )
  end

  let(:output) do
    {
      nodes: [
        {
          "@xmlns:ns4": 'http://Model/Status/Protocol/',
          "@xmlns:xsi": 'http://www.w3.org/2001/XMLSchema-instance',
          "@xsi:type": 'ns4:ServiceProtocol',
          services: [
            { service_id: { id: '100', status_id: '400' }, update_id: '500' },
            { service_id: { id: '200', status_id: '400' }, update_id: '500' },
            { service_id: { id: '300', status_id: '400' }, update_id: '500' }
          ],
          id: '82383838383838',
          nodes: { id: '8888888' },
          quantities: [
            { size: '122', id: { code: '900', node: '5' } },
            { size: '103', id: { code: '900', node: '10' } },
            { size: '92', id: { code: '900', node: '20' } }
          ],
          time: '2023-10-20T05:05:00.000+01:00',
          type: {
            id: '9000', mode: { id: '2828288', protocol: '7000' }
          },
          informations: %w[2 17 64 1157 1604 100008]
        },
        {
          "@xmlns:ns4": 'http://Model/Status/Protocol/',
          "@xmlns:xsi": 'http://www.w3.org/2001/XMLSchema-instance',
          "@xsi:type": 'ns4:ServiceShop',
          services: [
            { service_id: { id: '400', status_id: '500' }, update_id: '600' },
            { service_id: { id: '500', status_id: '500' }, update_id: '700' },
            { service_id: { id: '600', status_id: '500' }, update_id: '700' }
          ],
          note: 'Text  with extra  spaces     ',
          tag: 'Special character biały'
        }
      ]
    }
  end

  describe '.parse' do
    it { expect(OXML.parse(xml, {})).to eq(output) }

    describe 'when nil attribute' do
      let(:options) { { delete_namespace_attributes: true } }

      let(:xml) do
        '<wd5:offerDetails xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true" />
        <wd5:offerPercentage>0.0</wd5:offerPercentage>'
      end

      it { expect(OXML.parse(xml, options)).to eq('wd5:offer_details': nil, 'wd5:offer_percentage': '0.0') }
    end

    describe 'options[strip_namespaces]' do
      let(:xml) do
        '<wd-dir5:queryResponse xmlns:wd5="attr"><queryResponse></queryResponse></wd-dir5:queryResponse>'
      end

      context 'when false' do
        let(:options) { { strip_namespaces: false } }
        let(:parsed_response) do
          { 'wd_dir5:query_response': { '@xmlns:wd5': 'attr', query_response: nil } }
        end

        it { expect(OXML.parse(xml, options)).to eq(parsed_response) }
      end

      context 'when true' do
        let(:options) { { strip_namespaces: true } }
        let(:parsed_response) do
          { 'query_response': { '@xmlns:wd5': 'attr', query_response: nil } }
        end

        it { expect(OXML.parse(xml, options)).to eq(parsed_response) }
      end
    end

    describe 'options[delete_namespace_attributes]' do
      context 'when false' do
        let(:options) { { delete_namespace_attributes: false } }
        let(:xml) do
          '<wd5:queryResponse xmlns:wd5="attr"><queryResponse></queryResponse></wd5:queryResponse>'
        end
        let(:parsed_response) do
          { 'wd5:query_response': { '@xmlns:wd5': 'attr', query_response: nil } }
        end

        it { expect(OXML.parse(xml, options)).to eq(parsed_response) }
      end

      context 'when true' do
        let(:options) { { delete_namespace_attributes: true } }
        let(:xml) do
          '<wd5:queryResponse xmlns:wd5="attr"><queryResponse></queryResponse></wd5:queryResponse>'
        end
        let(:parsed_response) do
          { 'wd5:query_response': { query_response: nil } }
        end

        it { expect(OXML.parse(xml, options)).to eq(parsed_response) }
      end
    end

    describe 'options[advanced_typecasting]' do
      context 'when Null value' do
        let(:xml) { '<available></available>' }

        context 'when enabled' do
          let(:options) { { advanced_typecasting: true } }

          it { expect(OXML.parse(xml, options)).to eq(available: nil) }
        end

        context 'when disabled' do
          let(:options) { { advanced_typecasting: false } }

          it { expect(OXML.parse(xml, options)).to eq(available: nil) }
        end
      end

      context 'when True value' do
        let(:xml) { '<available>true</available>' }

        context 'when enabled' do
          let(:options) { { advanced_typecasting: true } }

          it { expect(OXML.parse(xml, options)).to eq(available: true) }
        end

        context 'when disabled' do
          let(:options) { { advanced_typecasting: false } }

          it { expect(OXML.parse(xml, options)).to eq(available: 'true') }
        end
      end

      context 'when False value' do
        let(:xml) { '<available>false</available>' }

        context 'when enabled' do
          let(:options) { { advanced_typecasting: true } }

          it { expect(OXML.parse(xml, options)).to eq(available: false) }
        end

        context 'when disabled' do
          let(:options) { { advanced_typecasting: false } }

          it { expect(OXML.parse(xml, options)).to eq(available: 'false') }
        end
      end

      context 'when DateTime value' do
        let(:xml) { '<startTime>2023-08-30T00:00:00</startTime>' }

        context 'when enabled' do
          let(:options) { { advanced_typecasting: true } }

          it { expect(OXML.parse(xml, options)).to eq(start_time: DateTime.parse('2023-08-30T00:00:00')) }
        end

        context 'when disabled' do
          let(:options) { { advanced_typecasting: false } }

          it { expect(OXML.parse(xml, options)).to eq(start_time: '2023-08-30T00:00:00') }
        end
      end

      context 'when Date value' do
        let(:xml) do
          '<date>2023-04-13+02:00</date>'
        end

        context 'when option enabled' do
          let(:options) { { advanced_typecasting: true } }

          it { expect(OXML.parse(xml, options)).to eq('date': Date.parse('2023-04-13+02:00')) }
        end

        context 'when option disabled' do
          let(:options) { { advanced_typecasting: false } }

          it { expect(OXML.parse(xml, options)).to eq('date': '2023-04-13+02:00') }
        end
      end

      context 'when Time value' do
        let(:xml) do
          '<time>05:05:00</time>'
        end

        context 'when option enabled' do
          let(:options) { { advanced_typecasting: true } }

          it { expect(OXML.parse(xml, options)).to eq('time': Time.parse('05:05:00')) }
        end

        context 'when option disabled' do
          let(:options) { { advanced_typecasting: false } }

          it { expect(OXML.parse(xml, options)).to eq('time': '05:05:00') }
        end
      end
    end

    describe 'options[skip_soap_elements]' do
      let(:xml) do
        '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><queryResponse></queryResponse></soapenv:Body></soapenv:Envelope>'
      end

      context 'when false' do
        let(:options) { { skip_soap_elements: false } }
        let(:parsed_response) do
          { 'soapenv:envelope': { '@xmlns:soapenv': 'http://schemas.xmlsoap.org/soap/envelope/', 'soapenv:body': { query_response: nil } } }
        end

        it { expect(OXML.parse(xml, options)).to eq(parsed_response) }
      end

      context 'when true' do
        let(:options) { { skip_soap_elements: true } }
        let(:parsed_response) { { query_response: nil } }

        it { expect(OXML.parse(xml, options)).to eq(parsed_response) }
      end
    end
  end

  describe '.build' do
    it { expect(OXML.build(output)).to eq(xml.gsub(/>\s*</, '><').strip) }

    let(:hash) do
      {
        'service' => {
          "@xmlns:ns4": 'http://Model/Status/Protocol/',
          "@xmlns:xsi": 'http://www.w3.org/2001/XMLSchema-instance',
          "@xsi:type": 'ns4:ServiceProtocol',
          'salePoint' => 578_920,
          'status' => {
            'noTransaction' => '2829999',
            'codeState' => '1'
          },
          'nodes' => {
            'node' => [1, 2, 3].map do |carrier|
              {
                'noCarrier' => carrier,
                'typePlace' => '100'
              }
            end
          }
        }
      }
    end
    let(:result) do
      %(
        <service xmlns:ns4="http://Model/Status/Protocol/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="ns4:ServiceProtocol">
          <salePoint>578920</salePoint>
          <status>
            <noTransaction>2829999</noTransaction>
            <codeState>1</codeState>
          </status>
          <nodes>
            <node>
              <noCarrier>1</noCarrier>
              <typePlace>100</typePlace>
            </node>
            <node>
              <noCarrier>2</noCarrier>
              <typePlace>100</typePlace>
            </node>
            <node>
              <noCarrier>3</noCarrier>
              <typePlace>100</typePlace>
            </node>
          </nodes>
        </service>
       )
    end
    it { expect(OXML.build(hash)).to eq(result.gsub(/>\s*</, '><').strip) }

    it 'preserves the state of an original input' do
      OXML.build(hash)
      expect(OXML.build(hash)).to eq(result.gsub(/>\s*</, '><').strip)
    end
  end
end
