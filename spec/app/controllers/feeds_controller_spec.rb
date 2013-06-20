require 'spec_helper'

describe Reeder::Application do
  describe 'GET /api/feeds' do
    context 'when no feeds exist' do
      it 'returns an empty collection' do
        get '/api/feeds'

        expect(last_response.status).to eq 200
        expect(json_response).to be_empty
      end
    end

    context 'when feeds exist' do
      before { Fabricate(:feed) }

      it 'returns a collection of feeds' do
        get '/api/feeds'

        expect(last_response.status).to eq 200
        expect(json_response).not_to be_empty
        expect(json_response[0]['title']).to eq 'Blog'
      end
    end
  end

  describe 'GET /api/feeds/:id' do
    it 'returns error if feed does not exist' do
      get '/api/feeds/12345'

      expect(last_response.status).to eq 404
      expect(json_error).to eq 'Feed does not exist'
    end

    context 'for existing feed' do
      let!(:feed) { Fabricate(:feed) }

      it 'returns feed details' do
        get "/api/feeds/#{feed.id}"

        expect(last_response.status).to eq 200
        expect(json_response['id']).to eq feed.id
      end
    end
  end

  describe 'POST /feeds' do
    it 'returns error if feed attributes are missing' do
      post '/api/feeds'

      expect(last_response.status).to eq 400
      expect(json_error).to eq 'Feed attributes required'
    end

    it 'returns feed validation errors' do
      post '/api/feeds', feed: {title: "Foo"}

      expect(last_response.status).to eq 422
      expect(json_error).to eq "Url can't be blank"
    end

    it 'returns feed instance' do
      post '/api/feeds', feed: {title: "Foo", url: 'http:/foo.com'}

      expect(last_response.status).to eq 200
      expect(json_response).to include 'id', 'title', 'url'
    end
  end

  describe 'POST /api/feeds/import' do
    it 'requires feed url parameter' do
      post '/api/feeds/import'

      expect(last_response.status).to eq 400
      expect(json_error).to eq 'Feed URL required'
    end

    it 'returns error on invalid feed url' do
      post '/api/feeds/import', url: 'http://foo.bar'

      expect(last_response.status).to eq 400
      expect(json_error).to eq 'Invalid feed URL'
    end

    it 'returns a new feed details' do
      post '/api/feeds/import', url: 'https://news.ycombinator.com/rss'

      expect(last_response.status).to eq 200
      expect(json_response).to be_a Hash
    end
  end

  describe 'POST /api/feeds/import/opml' do
    it 'requires opml data' do
      post '/api/feeds/import/opml'

      expect(last_response.status).to eq 400
      expect(json_error).to eq 'OPML data required'
    end

    it 'returns a collection of imported feeds' do
      post '/api/feeds/import/opml', opml: fixture('opml.xml')

      expect(last_response.status).to eq 200
      expect(json_response).to be_an Array
      expect(json_response[0]['title']).to eq 'A Fresh Cup'
    end
  end

  describe 'DELETE /api/feeds/:id' do
    it 'returns error if feed does not exist' do
      delete '/api/feeds/12345'

      expect(last_response.status).to eq 404
      expect(json_error).to eq 'Feed does not exist'
    end

    it 'deletes an existing feed' do
      delete "/api/feeds/#{Fabricate(:feed).id}"

      expect(last_response.status).to eq 200
      expect(json_response['deleted']).to eq true
    end
  end
end