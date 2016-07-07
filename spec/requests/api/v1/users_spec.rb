require 'rails_helper'

RSpec.describe 'api/v1/users', type: :request do
  describe '#index' do
    let!(:user) { User.create!(name: 'John Doe', age: 22, active: true ) }
    let!(:user_two) { User.create!(name: 'John Doe 2', age: 23, active: false ) }

    context 'filter integer attribute' do
      before do
        get '/api/v1/users?q[age]=22'
      end

      it do
        expect(json).to eq([{
          "id"=>user.id,
          "name"=>"John Doe",
          "age"=>22,
          "active"=>true,
          "created_at"=> response_date(user.created_at),
          "updated_at"=> response_date(user.updated_at)
        }])
      end
    end

    context ' filter boolean attribute' do
      before do
        get '/api/v1/users?q[active]=false'
      end

      it do
        expect(json).to eq([{
          "id"=>user_two.id,
          "name"=>"John Doe 2",
          "age"=>23,
          "active"=>false,
          "created_at"=> response_date(user_two.created_at),
          "updated_at"=> response_date(user_two.updated_at)
        }])
      end
    end

    context ' filter string attribute' do
      before do
        get '/api/v1/users?q[name]=John Doe'
      end

      it do
        expect(json).to eq([{
          "id"=>user.id,
          "name"=>"John Doe",
          "age"=>22,
          "active"=>true,
          "created_at"=> response_date(user.created_at),
          "updated_at"=> response_date(user.updated_at)
        }])
      end
    end

    context 'pagination' do
      before do
        get '/api/v1/users?page=2&page_size=1'
      end

      it do
        expect(json).to eq([{
          "id"=>user_two.id,
          "name"=>"John Doe 2",
          "age"=>23,
          "active"=>false,
          "created_at"=> response_date(user_two.created_at),
          "updated_at"=> response_date(user_two.updated_at)
        }])
      end
    end
  end

  describe '#show' do
    let!(:user) { User.create(name: 'John Doe', age: 22, active: true ) }

    before do
      get "/api/v1/users/#{user.id}"
    end

    it do
      expect(json).to eq({
        "id"=> user.id,
        "name"=>"John Doe",
        "age"=>22,
        "active"=>true,
        "created_at"=> response_date(user.created_at),
        "updated_at"=> response_date(user.updated_at)
      })
    end
  end

  describe '#create' do
    context 'success' do
      before do
        post '/api/v1/users/', user: { name: 'John Doe', age: 22, active: true }
      end

      it do
        expect(response.status).to eq(201)
      end

      it do
        expect(User.count).to eq(1)
      end
    end

    context 'failure' do
      before do
        post '/api/v1/users/', user: { name: 'John Doe', active: true }
      end

      it do
        expect(response.status).to eq(422)
      end

      it do
        expect(User.count).to eq(0)
      end
    end
  end

  describe '#update' do
    context 'success' do
      let!(:user) { User.create(name: 'John Doe', age: 22, active: true ) }

      before do
        put "/api/v1/users/#{user.id}", user: { age: 23 }
      end

      it do
        expect(json).to eq({
          "id"=> user.id,
          "name"=>"John Doe",
          "age"=>23,
          "active"=>true,
          "created_at"=> response_date(user.created_at),
          "updated_at"=> response_date(user.reload.updated_at)
        })
      end

      it 'touches database' do
        expect(user.updated_at).to_not eq(user.reload.updated_at)
      end
    end

    context 'failure' do
      let!(:user) { User.create(name: 'John Doe', age: 22, active: false ) }

      before do
        put "/api/v1/users/#{user.id}", user: { age: 24 }
      end

      it do
        expect(json).to eq({
          "age" => ["cannot change age when inactive"]
        })
      end

      it 'touches database' do
        expect(user.updated_at).to_not eq(user.reload.updated_at)
      end
    end
  end

  describe '#delete' do
    context 'success' do
      let!(:user) { User.create(name: 'John Doe', age: 22, active: false ) }

      before do
        delete "/api/v1/users/#{user.reload.id}"
      end

      it do
        expect(response.status).to eq(204)
      end

      it 'touches database' do
        expect(User.count).to eq(0)
      end
    end

    context 'failure' do
      let!(:user) { User.create(name: 'John Doe', age: 22, active: true ) }

      before do
        delete "/api/v1/users/#{user.reload.id}"
      end

      it do
        expect(response.status).to eq(422)
      end

      it do
        expect(json).to eq({
          "active" => ["cannot remove active user"]
        })
      end
    end
  end
end
