module Api
  module V1
    module Serializers
      class FilmMakerSerializer < ActiveModel::Serializer
        attributes :id, :name, :location, :avatar, :role, :description
        self.root=:film_makers
        embed :ids, include: true

        def role
          object.expertise
        end

        def description
          object.about
        end

        def avatar
          if object.photos.first.nil?
            ActionController::Base.helpers.image_url "actor.png"
          else
            object.photos.first
          end
        end

        #has_one :customer,:serializer=>Api::V1::Serializers::CustomerSerializer, :key => :customer, :root => :customer
        #has_many :credit_cards, :serializer=>Api::V1::Serializers::CreditCardSerializer, :key => :creditCards, :root => :creditCards
        #has_many :bank_accounts, :serializer=>Api::V1::Serializers::BankAccountsSerializer, :key => :bankAccounts, :root=>:bankAccounts

      end
    end
  end
end