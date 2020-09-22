require 'spec_helper'

describe "granules/descriptor_document" do
  it "is possible to create a granule open search descriptor document with a valid client id" do
    stub_client_id = stub_model(ClientId)
    stub_client_id.clientId = 'foo'
    assign(:client_id_model, stub_client_id)

    assign(:short_name, 'MOD02QKM')
    assign(:version_id, '005')
    assign(:data_center, 'LAADS')

    render
    expect(rendered).to include("template=\"#{ENV['opensearch_url']}/granules.atom?datasetId={echo:datasetId?}&amp;shortName=MOD02QKM&amp;versionId=005&amp;dataCenter=LAADS&amp;boundingBox={geo:box?}&amp;geometry={geo:geometry?}&amp;placeName={geo:name?}&amp;startTime={time:start?}&amp;endTime={time:end?}&amp;cursor={os:startPage?}&amp;numberOfResults={os:count?}&amp;offset={os:startIndex?}&amp;uid={geo:uid?}&amp;parentIdentifier={eo:parentIdentifier?}&amp;clientId=foo\">")
    expect(rendered).to include("template=\"#{ENV['opensearch_url']}/granules.html?datasetId={echo:datasetId?}&amp;shortName=MOD02QKM&amp;versionId=005&amp;dataCenter=LAADS&amp;boundingBox={geo:box?}&amp;geometry={geo:geometry?}&amp;placeName={geo:name?}&amp;startTime={time:start?}&amp;endTime={time:end?}&amp;cursor={os:startPage?}&amp;numberOfResults={os:count?}&amp;offset={os:startIndex?}&amp;uid={geo:uid?}&amp;parentIdentifier={eo:parentIdentifier?}&amp;clientId=foo\">")

  end

  it "is comformant with draft 2 of the open search parameter extension" do
      osdd_response_str = <<-eos
                  <os:OpenSearchDescription xmlns:os="http://a9.com/-/spec/opensearch/1.1/"
                  	xmlns:echo="https://cmr.earthdata.nasa.gov/search/site/docs/search/api.html#atom"
                  	xmlns:geo="http://a9.com/-/opensearch/extensions/geo/1.0/"
                  	xmlns:time="http://a9.com/-/opensearch/extensions/time/1.0/"
                  	xmlns:esipdiscovery="http://commons.esipfed.org/ns/discovery/1.2/" esipdiscovery:version="1.2"
                    xmlns:params="http://a9.com/-/spec/opensearch/extensions/parameters/1.0/"
                    xmlns:referrer="http://www.opensearch.org/Specifications/OpenSearch/Extensions/Referrer/1.0"
                    xmlns:eo="http://a9.com/-/opensearch/extensions/eo/1.0/"
                    xmlns:atom="http://www.w3.org/2005/Atom" >
                  	<os:ShortName>CMR Granules</os:ShortName>
                  	<os:Description>NASA CMR Granule search using geo, time and parameter extensions</os:Description>
                  	<os:Tags>CMR NASA CWIC CEOS-OS-BP-V1.1/L3 ESIP OGC granule pageOffset=1 indexOffset=0</os:Tags>
                  	<os:Contact>#{ENV['contact']}</os:Contact>
                  	<os:Url type="application/atom+xml" rel="results"
                  	  params:method="GET"
                  		template=\"#{ENV['opensearch_url']}/granules.atom?datasetId={echo:datasetId?}&amp;shortName=MOD02QKM&amp;versionId=005&amp;dataCenter=LAADS&amp;boundingBox={geo:box?}&amp;geometry={geo:geometry?}&amp;placeName={geo:name?}&amp;startTime={time:start?}&amp;endTime={time:end?}&amp;cursor={os:startPage?}&amp;numberOfResults={os:count?}&amp;offset={os:startIndex?}&amp;uid={geo:uid?}&amp;parentIdentifier={eo:parentIdentifier?}&amp;clientId=foo\">
	                    <params:Parameter name="datasetId" uiDisplay="Collection identifier" value="{echo:datasetId}" title="Inventory associated with a dataset expressed as an ID" minimum="0"/>
	                    <params:Parameter name="boundingBox" uiDisplay="Bounding box" value="{geo:box}" title="Inventory with a spatial extent overlapping this bounding box" minimum="0"/>
	                    <params:Parameter name="lat" uiDisplay="Latitude" value="{geo:lat}" title="Inventory with latitude in decimal degrees, must be used together with lon and radius" minimum="0" minInclusive="-90.0" maxInclusive="90.0"/>
	                    <params:Parameter name="lon" uiDisplay="Longitude" value="{geo:lon}" title="Inventory with longitude in decimal degrees, must be used together with lat and radius" minimum="0" minInclusive="-180.0" maxInclusive="180.0"/>
	                    <params:Parameter name="radius" uiDisplay="Radius" value="{geo:radius}" title="Inventory with the search radius in meters, must be used together with lat and lon" minimum="0" minInclusive="10" maxInclusive="6000000"/>
	  	                <params:Parameter name="geometry" uiDisplay="Geometry" value="{geo:geometry}" title="Inventory with a spatial extent overlapping this geometry" minimum="0">
	  	                  <atom:link rel="profile" href="http://www.opengis.net/wkt/LINESTRING" title="This service accepts WKT LineStrings"/>
	  	                  <atom:link rel="profile" href="http://www.opengis.net/wkt/POINT" title="This service accepts WKT Points"/>
	  	                  <atom:link rel="profile" href="http://www.opengis.net/wkt/POLYGON" title="This service accepts WKT Polygons"/>
	  	                </params:Parameter>
	  	                <params:Parameter name="placeName" uiDisplay="Place name" value="{geo:name}" title="Inventory with a spatial location described by this name" minimum="0"/>
	  	                <params:Parameter name="startTime" uiDisplay="Start time" value="{time:start}" title="Inventory with a temporal extent containing this start time" minimum="0"/>
	  	                <params:Parameter name="endTime" uiDisplay="End time" value="{time:end}" title="Inventory with a temporal extent containing this end time" minimum="0"/>
                      <params:Parameter name="cursor" uiDisplay="Start page" value="{os:startPage}" title="Start page for the search result" minimum="0" />
                      <params:Parameter name="numberOfResults" uiDisplay="Number of results" value="{os:count}" title="Maximum number of records in the search result" minimum="0" maxInclusive="2000"/>
	  	                <params:Parameter name="offset" uiDisplay="Start index" value="{os:startIndex}" title="0-based offset used to skip the specified number of results in the search result set" minimum="0"/>
	  	                <params:Parameter name="uid" uiDisplay="Unique identifier identifier" value="{geo:uid}" title="Inventory associated with this unique ID" minimum="0"/>
	  	                <params:Parameter name="parentIdentifier" uiDisplay="CMR Collection concept identifier" value="{eo:parentIdentifier}" title="Inventory associated with a dataset expressed as a CMR concept ID" minimum="0"/>
                      <params:Parameter name="clientId" uiDisplay="Client identifier" value="{referrer:source}" title="Client identifier to be used for metrics" minimum="0"/>
                    </os:Url>
                  	<os:Url type="text/html" rel="results"
                  	  params:method="GET"
                  		template=\"#{ENV['opensearch_url']}/granules.html?datasetId={echo:datasetId?}&amp;shortName=MOD02QKM&amp;versionId=005&amp;dataCenter=LAADS&amp;boundingBox={geo:box?}&amp;geometry={geo:geometry?}&amp;placeName={geo:name?}&amp;startTime={time:start?}&amp;endTime={time:end?}&amp;cursor={os:startPage?}&amp;numberOfResults={os:count?}&amp;offset={os:startIndex?}&amp;uid={geo:uid?}&amp;parentIdentifier={eo:parentIdentifier?}&amp;clientId=foo\">
	                    <params:Parameter name="datasetId" uiDisplay="Collection identifier" value="{echo:datasetId}" title="Inventory associated with a dataset expressed as an ID" minimum="0"/>
	                    <params:Parameter name="boundingBox" uiDisplay="Bounding box" value="{geo:box}" title="Inventory with a spatial extent overlapping this bounding box" minimum="0"/>
	                    <params:Parameter name="lat" uiDisplay="Latitude" value="{geo:lat}" title="Inventory with latitude in decimal degrees, must be used together with lon and radius" minimum="0" minInclusive="-90.0" maxInclusive="90.0"/>
	                    <params:Parameter name="lon" uiDisplay="Longitude" value="{geo:lon}" title="Inventory with longitude in decimal degrees, must be used together with lat and radius" minimum="0" minInclusive="-180.0" maxInclusive="180.0"/>
	                    <params:Parameter name="radius" uiDisplay="Radius" value="{geo:radius}" title="Inventory with the search radius in meters, must be used together with lat and lon" minimum="0" minInclusive="10" maxInclusive="6000000"/>
	                    <params:Parameter name="geometry" uiDisplay="Geometry" value="{geo:geometry}" title="Inventory with a spatial extent overlapping this geometry" minimum="0">
	  	                  <atom:link rel="profile" href="http://www.opengis.net/wkt/LINESTRING" title="This service accepts WKT LineStrings"/>
	  	                  <atom:link rel="profile" href="http://www.opengis.net/wkt/POINT" title="This service accepts WKT Points"/>
	  	                  <atom:link rel="profile" href="http://www.opengis.net/wkt/POLYGON" title="This service accepts WKT Polygons"/>
	  	                </params:Parameter>
	  	                <params:Parameter name="placeName" uiDisplay="Place name" value="{geo:name}" title="Inventory with a spatial location described by this name" minimum="0"/>
	  	                <params:Parameter name="startTime" uiDisplay="Start time" value="{time:start}" title="Inventory with a temporal extent containing this start time" minimum="0"/>
	  	                <params:Parameter name="endTime" uiDisplay="End time" value="{time:end}" title="Inventory with a temporal extent containing this end time" minimum="0"/>
                      <params:Parameter name="cursor" uiDisplay="Start page" value="{os:startPage}" title="Start page for the search result" minimum="0" />
                      <params:Parameter name="numberOfResults" uiDisplay="Number of results" value="{os:count}" title="Maximum number of records in the search result" minimum="0" maxInclusive="2000"/>
	  	                <params:Parameter name="offset" uiDisplay="Start index" value="{os:startIndex}" title="0-based offset used to skip the specified number of results in the search result set" minimum="0"/>
	  	                <params:Parameter name="uid" uiDisplay="Unique identifier identifier" value="{geo:uid}" title="Inventory associated with this unique ID" minimum="0"/>
                      <params:Parameter name="parentIdentifier" uiDisplay="CMR Collection concept identifier" value="{eo:parentIdentifier}" title="Inventory associated with a dataset expressed as a CMR concept ID" minimum="0"/>
	  	                <params:Parameter name="clientId" uiDisplay="Client identifier" value="{referrer:source}" title="Client identifier to be used for metrics" minimum="0"/>
                    </os:Url>
                  	<os:Query role="example"
                  			echo:shortName="MOD02QKM"
                  			echo:versionId="005"
                  			echo:dataCenter="LAADS"
                  			geo:box="-180.0,-90.0,180.0,90.0"
                  			time:start="2002-05-04T00:00:00Z"
                  			time:end="2009-05-04T00:00:00Z"
                  			title="Sample search" />
                  	<os:Attribution>NASA CMR</os:Attribution>
                  	<os:SyndicationRight>open</os:SyndicationRight>
                  </os:OpenSearchDescription>
      eos

      stub_client_id = stub_model(ClientId)
      stub_client_id.clientId = 'foo'
      assign(:client_id_model, stub_client_id)

      assign(:short_name, 'MOD02QKM')
      assign(:version_id, '005')
      assign(:data_center, 'LAADS')

      render
        expected_doc = Nokogiri::XML(osdd_response_str) do |config|
          config.default_xml.noblanks
        end
        actual_doc = Nokogiri::XML(rendered) do |config|
          config.default_xml.noblanks
        end

        expect(actual_doc.to_xml(:indent => 2)).to eq(expected_doc.to_xml(:indent => 2))
    end
end
